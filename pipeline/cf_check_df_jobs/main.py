"""
Cloud Functions which checks if all Dataflow jobs is completed. If yes, then it publishes message to PubSub topic to
trigger next step in the pipeline
"""

import os

import time
import datetime
import logging
from typing import Dict

from googleapiclient.discovery import build
import google.auth

GCP_PROJECT = os.environ['GCP_PROJECT']
PUBSUB_DF_TOPIC = os.environ['PUBSUB_DF_TOPIC']
PUBSUB_BQ_TOPIC = os.environ['PUBSUB_BQ_TOPIC']


def publish_pubsub(pubsub_topic: str, message: str):
    """Publishes message to concrete PubSub topic

    :param pubsub_topic: name of pubsub topic
    :param message: pubsub message, string
    """

    from google.cloud import pubsub

    ps_topic = f'projects/{GCP_PROJECT}/topics/{pubsub_topic}'
    publisher = pubsub.PublisherClient()
    r = publisher.publish(ps_topic, message.encode())
    r.result()


def get_df_jobs() -> Dict:
    """Gets 5 latest Dataflow jobs (since 5 jobs should be always running) and evaluate their status

    :returns API response, json converted to dictionary
    """
    credentials, _project = google.auth.default()
    service = build('dataflow', 'v1b3', credentials=credentials, cache_discovery=False)

    request = service.projects().jobs().list(projectId=GCP_PROJECT, pageSize=5)
    response = request.execute()
    logging.info(response)
    return response


def check_df_job_status(current_dt: datetime.datetime, df_api_response: Dict):
    """Analyzes status of Dataflow jobs based on response from Dataflow API

    :param current_dt: datetime to check against, usually now
    :param df_api_response: Full response from Dataflow API, jobs status
    """

    jobs = df_api_response['jobs']
    time_check_seconds = 60 * 60 * 2

    relevant_jobs = []
    jobs_running_no = 0
    for job in jobs:
        job_name = job['name']
        current_state = job['currentState']
        current_state_time_str = job['currentStateTime']
        current_state_time = datetime.datetime.strptime(current_state_time_str, '%Y-%m-%dT%H:%M:%S.%fZ')
        time_diff = current_dt - current_state_time
        total_seconds_diff = time_diff.total_seconds()
        if total_seconds_diff > time_check_seconds:
            continue
        if current_state in ('JOB_STATE_QUEUED', 'JOB_STATE_PENDING', 'JOB_STATE_RUNNING'):
            jobs_running_no += 1
        relevant_jobs.append(job)

    if len(relevant_jobs) != 5:
        logging.error(f"{relevant_jobs}")
        raise Exception(f'There are less jobs than expected')

    elif jobs_running_no:  # jobs are still running
        logging.info(f"Still running {jobs_running_no} jobs")
        time.sleep(60 * 2)
        publish_pubsub(PUBSUB_DF_TOPIC, " ")
    else:
        job_states = []
        for job in relevant_jobs:
            job_states.append(job['currentState'])
        unique_job_states = list(set(job_states))
        if len(unique_job_states) != 1:
            logging.error(f"{relevant_jobs}")
            raise Exception(f'There are less jobs than expected')
        if unique_job_states[0] == 'JOB_STATE_DONE':  # kick of creating layers job
            logging.info("all jobs completed")
            publish_pubsub(PUBSUB_BQ_TOPIC, " ")
        else:
            logging.error(f"{relevant_jobs}")
            raise Exception(f'Unknown situation with jobs')


def main(data, context):
    current_dt = datetime.datetime.utcnow()
    response = get_df_jobs()
    check_df_job_status(current_dt, response)
