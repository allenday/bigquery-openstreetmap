"""
Creates OSM layers in BigQuery based on SQL scripts
"""

import os
import time
import logging
from typing import List

from google.cloud import bigquery
from google.cloud import storage
from google.api_core.exceptions import NotFound

from copy_public_tables import copy_tables_to_public_dataset

GCP_PROJECT = os.environ['GCP_PROJECT']
GCS_BUCKET = os.environ['GCS_BUCKET'].replace('gs://', '')
BQ_LAYERS_TABLE = os.environ['BQ_LAYERS_TABLE']
BQ_TARGET_DATASET = os.environ['BQ_TARGET_DATASET']
BQ_TEMP_DATASET = os.environ['BQ_TEMP_DATASET']

bq = bigquery.Client(project=GCP_PROJECT)

temp_dataset_ref = bigquery.DatasetReference(GCP_PROJECT, BQ_TEMP_DATASET)
temp_table_ref = bigquery.TableReference(temp_dataset_ref, BQ_LAYERS_TABLE)


def create_temp_dataset():
    """Creates temporary dataset"""

    bq.create_dataset(temp_dataset_ref, exists_ok=True)


def delete_temp_dataset():
    """Deletes temporary BigQuery dataset and table"""

    bq.delete_dataset(temp_dataset_ref, delete_contents=True, not_found_ok=True)


def get_queries() -> List[str]:
    """gets SQL query files from Cloud Storage bucket. It expects them to be in "folder" layered_gis

    :returns list of SQL queries
    """

    logging.info("getting query files")
    gcs = storage.Client(project=GCP_PROJECT)
    bucket = gcs.bucket(GCS_BUCKET)
    blobs = bucket.list_blobs(prefix='layered_gis')
    queries = {}
    for blob in blobs:
        blob_name = blob.name
        if '.sh' in blob_name:
            continue
        filename = blob_name.replace('layered_gis/', '')
        layer, _ = filename.split('/')
        sql_query = blob.download_as_string().decode('utf-8')
        full_query = queries.get(layer, '')
        if full_query:
            full_query += 'UNION ALL \n'
        full_query += sql_query + '\n'
        queries[layer] = full_query
    return queries.values()


def create_query_jobs(queries: List[str]):
    """Runs queries for concrete layers and save results in temporary file"""

    logging.info("creating BQ query jobs")
    for sql_query in queries:
        job_config = bigquery.QueryJobConfig()
        job_config.create_disposition = bigquery.CreateDisposition.CREATE_IF_NEEDED
        job_config.write_disposition = bigquery.WriteDisposition.WRITE_APPEND
        job_config.destination = temp_table_ref
        job_config.allow_large_results = True
        query_job = bq.query(sql_query, job_config=job_config, location='US')


def wait_jobs_completed():
    """Checks if all BigQuery jobs are completed so it can copy temp table"""

    logging.info("checking jobs")
    time.sleep(30)
    while True:
        running_jobs = []
        for job in bq.list_jobs(state_filter='RUNNING', all_users=True):
            running_jobs.append(job)
        logging.info("running jobs {}".format(len(running_jobs)))
        if not running_jobs:
            break
        time.sleep(30)


def copy_table():
    """Copy temporary table to final destination"""

    logging.info("copy table")
    dataset_ref = bigquery.DatasetReference(GCP_PROJECT, BQ_TARGET_DATASET)
    table_ref = bigquery.TableReference(dataset_ref, BQ_LAYERS_TABLE)
    copyjob_config = bigquery.CopyJobConfig()
    copyjob_config.create_disposition = bigquery.CreateDisposition.CREATE_IF_NEEDED
    copyjob_config.write_disposition = bigquery.WriteDisposition.WRITE_TRUNCATE
    bq.copy_table(temp_table_ref, table_ref, job_config=copyjob_config)


def create_layer_partitioned_table():
    """Creates layer partitioned table"""

    table_name = f"{BQ_LAYERS_TABLE}"
    sql_query = f"""CREATE OR REPLACE TABLE `{GCP_PROJECT}.{BQ_TARGET_DATASET}.{table_name}`
    PARTITION BY layer_partition
    AS
    SELECT
    *,
    `{GCP_PROJECT}.{BQ_TARGET_DATASET}`.layer_partition(name) as layer_partition
    FROM `{GCP_PROJECT}.{BQ_TARGET_DATASET}.{BQ_LAYERS_TABLE}`"""

    job_config = bigquery.QueryJobConfig()
    query_job = bq.query(sql_query, job_config=job_config)


def create_features_table():
    """creates 'features' table which is union of all 5 tables"""

    table_name = 'features'
    sql_query = f"""CREATE OR REPLACE TABLE `{GCP_PROJECT}.{BQ_TARGET_DATASET}.{table_name}`
    AS
    SELECT COALESCE(osm_id, osm_way_id) AS osm_id, osm_version, osm_timestamp, 'point' AS feature_type, all_tags, geometry FROM `{GCP_PROJECT}.{BQ_TARGET_DATASET}.points` 
    UNION ALL
    SELECT COALESCE(osm_id, osm_way_id) AS osm_id, osm_version, osm_timestamp, 'line' AS feature_type, all_tags, geometry FROM `{GCP_PROJECT}.{BQ_TARGET_DATASET}.lines`
    UNION ALL
    SELECT COALESCE(osm_id, osm_way_id) AS osm_id, osm_version, osm_timestamp, 'multilinestring' AS feature_type, all_tags, geometry FROM `{GCP_PROJECT}.{BQ_TARGET_DATASET}.multilinestrings`
    UNION ALL
    SELECT COALESCE(osm_id, osm_way_id) AS osm_id, osm_version, osm_timestamp, 'multipolygon' AS feature_type, all_tags, geometry FROM `{GCP_PROJECT}.{BQ_TARGET_DATASET}.multipolygons`
    UNION ALL
    SELECT COALESCE(osm_id, osm_way_id) AS osm_id, osm_version, osm_timestamp, 'other_relation' AS feature_type, all_tags, geometry FROM `{GCP_PROJECT}.{BQ_TARGET_DATASET}.other_relations` 
    """
    query_job = bq.query(sql_query)


def process():
    """Complete flow"""

    create_temp_dataset()
    queries = get_queries()
    create_query_jobs(queries)
    wait_jobs_completed()
    copy_table()
    #create_layer_partitioned_table()
    create_features_table()
    delete_temp_dataset()
    #copy_tables_to_public_dataset()


def main(data, context):
    process()


if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    # process()
