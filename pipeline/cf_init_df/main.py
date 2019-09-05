"""
Cloud Function which triggers Dataflow job when file is uploaded to Cloud Storage bucket
"""
import os
import json
import datetime
import logging

from googleapiclient.discovery import build
import google.auth

GCP_PROJECT = os.environ['GCP_PROJECT']
DF_TEMPLATE = os.environ['DF_TEMPLATE']
DF_WORKING_BUCKET = os.environ['DF_WORKING_BUCKET']
PUBSUB_DF_TOPIC = os.environ['PUBSUB_DF_TOPIC']
BQ_DATASET = os.environ['BQ_DATASET']


def publish_pubsub(df_api_response):
    from google.cloud import pubsub

    ps_topic = f'projects/{GCP_PROJECT}/topics/{PUBSUB_DF_TOPIC}'
    publisher = pubsub.PublisherClient()
    r = publisher.publish(ps_topic, json.dumps(df_api_response).encode())
    r.result()


def init_df(bucket, input_filename):
    input_path = f'gs://{bucket}/{input_filename}'

    bq_table = input_filename.split('.')[0].split('-')[-1]
    job_name = '{}_processing_{}'.format(bq_table, datetime.datetime.now().strftime("%Y%m%d-%H%M%S"))
    bq_path = f"{GCP_PROJECT}:{BQ_DATASET}.{bq_table}"

    body = {
        "jobName": f"{job_name}",
        "parameters": {
            "input": f"{input_path}",
            "bq_destination": bq_path,

        },
        "environment": {
            "tempLocation": f"{DF_WORKING_BUCKET}/df_temp",
            # "network": "dataflow",
            # "no_use_public_ips": True
            # "usePublicIps": False
        },

    }
    credentials, _project = google.auth.default()
    service = build('dataflow', 'v1b3', credentials=credentials, cache_discovery=False)

    request = service.projects().templates().launch(projectId=GCP_PROJECT, gcsPath=DF_TEMPLATE, body=body)
    response = request.execute()

    publish_pubsub(response)

    logging.info(response)


def main(data, context):
    bucket = data['bucket']
    filename = data['name']
    full_path = "gs://{}/{}".format(bucket, filename)
    logging.info("triggered by file: {}".format(full_path))
    init_df(bucket, filename)
