
import os
import json
import logging
from io import BytesIO
from google.cloud import storage
from google.cloud import bigquery
from google.oauth2 import service_account

GCP_PROJECT = os.environ['GCP_PROJECT']
GCS_BUCKET = os.environ['GCS_BUCKET'].replace('gs://', '')
BQ_SERVICE_ACCOUNT_FILENAME = os.environ['BQ_SERVICE_ACCOUNT_FILENAME']
BQ_SOURCE_DATASET = os.environ['BQ_SOURCE_DATASET']
BQ_TARGET_DATASET = os.environ['BQ_TARGET_DATASET']
BQ_TARGET_PROJECT = os.environ['BQ_TARGET_PROJECT']

def copy_tables_to_public_dataset():
    """copies all tables from internal dataset to BigQuery public dataset

    Service account which is used for access to public dataset project is stored in GCS.

    """

    gcs = storage.Client(project=GCP_PROJECT)

    bucket = gcs.bucket(GCS_BUCKET)
    sa_blob = bucket.blob(SERVICE_ACCOUNT_FILENAME)
    sa_blob.reload()
    f = BytesIO()
    sa_blob.download_to_file(f)
    sa_content = f.getvalue().decode('utf8')
    f.close()
    sa_content = json.loads(sa_content)
    credentials = service_account.Credentials.from_service_account_info(sa_content)

    bq = bigquery.Client(project=GCP_PROJECT, credentials=credentials)

    job_config = bigquery.CopyJobConfig()
    job_config.write_disposition = bigquery.WriteDisposition.WRITE_TRUNCATE
    job_config.create_disposition = bigquery.CreateDisposition.CREATE_IF_NEEDED

    source_dataset = bigquery.DatasetReference(GCP_PROJECT, BQ_DATASET)
    destination_dataset = bigquery.DatasetReference(BQ_TARGET_PROJECT, BQ_TARGET_DATASET)
    table_refs = []
    tables_res = bq.list_tables(source_dataset)
    for table_ref in tables_res:
        table_refs.append(table_ref)

    for table_ref in table_refs:
        table_name = table_ref.table_id
        source_table = bigquery.TableReference(source_dataset, table_name)
        destination_table = bigquery.TableReference(destination_dataset, table_name)
        bq.copy_table([source_table], destination_table, job_config=job_config)
        logging.info(f"copying table {table_name} to target dataset")


