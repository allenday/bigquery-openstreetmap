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


GCP_PROJECT = os.environ['GCP_PROJECT']
BUCKET = os.environ['BUCKET']
TABLE_NAME = os.environ['TABLE_NAME']
DATASET_NAME = os.environ['DATASET_NAME']
TEMP_DATASET_NAME = os.environ['TEMP_DATASET_NAME']

bq = bigquery.Client(project=GCP_PROJECT)

temp_dataset_ref = bigquery.DatasetReference(GCP_PROJECT, TEMP_DATASET_NAME)
temp_table_ref = bigquery.TableReference(temp_dataset_ref, TABLE_NAME)


def delete_temp_table():
    """Deletes temporary BigQuery table"""

    try:
        bq.get_table(temp_table_ref)
        bq.delete_table(temp_table_ref)
        logging.info("deleted temp table")
    except NotFound:
        pass


def get_queries() -> List[str]:
    """gets SQL query files from Cloud Storage bucket. It expects them to be in "folder" bsql_maps

    :returns list of SQL queries
    """

    logging.info("getting query files")
    gcs = storage.Client(project=GCP_PROJECT)
    bucket = gcs.bucket(BUCKET)
    blobs = bucket.list_blobs(prefix='bsql_maps')
    queries = {}
    for blob in blobs:
        blob_name = blob.name
        if '.sh' in blob_name:
            continue
        filename = blob_name.replace('bsql_maps/', '')
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


def copy_table():
    """Copy temporary table to final destination"""

    logging.info("copy table")
    dataset_ref = bigquery.DatasetReference(GCP_PROJECT, DATASET_NAME)
    table_ref = bigquery.TableReference(dataset_ref, TABLE_NAME)
    copyjob_config = bigquery.CopyJobConfig()
    copyjob_config.create_disposition = bigquery.CreateDisposition.CREATE_IF_NEEDED
    copyjob_config.write_disposition = bigquery.WriteDisposition.WRITE_TRUNCATE
    bq.copy_table(temp_table_ref, table_ref, job_config=copyjob_config)


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


def process():
    """Complete flow"""
    delete_temp_table()
    queries = get_queries()
    create_query_jobs(queries)
    wait_jobs_completed()
    copy_table()


def main(data, context):
    process()
