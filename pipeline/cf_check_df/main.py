"""
Cloud Functions which checks if Dataflow job is completed
"""

import os
import re
import json
import time
import base64
import logging

from googleapiclient.discovery import build
import google.auth

GCP_PROJECT = os.environ['GCP_PROJECT']
PUBSUB_DF_TOPIC = os.environ['PUBSUB_DF_TOPIC']


def publish_pubsub(df_api_response):
    from google.cloud import pubsub

    ps_topic = f'projects/{GCP_PROJECT}/topics/{PUBSUB_DF_TOPIC}'
    publisher = pubsub.PublisherClient()
    r = publisher.publish(ps_topic, json.dumps(df_api_response).encode())
    r.result()


def upload_bq(df_api_response):
    job_name = df_api_response['name']
    regex_match = re.search('lines|multilinestrings|multipolygons|other_relations|points', job_name)
    if regex_match:
        table_name = regex_match.group()
    else:
        table_name = job_name.split('_processing')[0]


def check_df_job_status(df_api_response):
    job = df_api_response['job']
    job_id = job['id']
    credentials, _project = google.auth.default()
    service = build('dataflow', 'v1b3', credentials=credentials, cache_discovery=False)

    request = service.projects().jobs().get(projectId=GCP_PROJECT, jobId=job_id, view='JOB_VIEW_ALL')
    response = request.execute()
    print(response)
    current_state = response['currentState']
    logging.info(f'job state {job_id}: {current_state}')
    if current_state in ('JOB_STATE_DONE', 'JOB_STATE_CANCELLED', 'JOB_STATE_FAILED'):
        return
    else:
        time.sleep(60 * 2)
        ps_data = {
            'job': {
                'id': job_id
            }
        }
        publish_pubsub(ps_data)
        return


def main(data, context):
    message_data = data['data']
    json_data_str = base64.b64decode(message_data)
    try:
        json_data = json.loads(json_data_str)
    except Exception as e:
        logging.error(f"couldn't decode json data: {json_data_str}")
        return 500
    check_df_job_status(json_data)
    return

