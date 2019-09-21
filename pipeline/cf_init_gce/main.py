"""
Creates Google Compute Engine instance
"""

import os
import logging

from googleapiclient.discovery import build
import google.auth

GCP_PROJECT = os.environ['GCP_PROJECT']
GCE_ZONE = os.environ['GCE_ZONE']
SCRIPT_URL = os.environ['SCRIPT_URL']
SERVICE_ACCOUNT_EMAIL = os.environ['SERVICE_ACCOUNT_EMAIL']


def get_info(instance_name: str):
    """Gets info about GCE instance, for dev/debugging purposes

    :param instance_name: name of GCE instance
    """

    credentials, _project = google.auth.default()
    service = build('compute', 'v1', credentials=credentials, cache_discovery=False)

    request = service.instances().get(project=GCP_PROJECT, zone=GCE_ZONE, instance=instance_name)
    response = request.execute()
    print(response)


def create_vm():
    """Creates GCE instance based on predefined parameters"""

    credentials, _project = google.auth.default()
    service = build('compute', 'v1', credentials=credentials, cache_discovery=False)
    body = {
        'name': 'osmprocess',
        'machineType': f'zones/{GCE_ZONE}/machineTypes/n1-standard-16',
        'disks': [
            {
                'boot': True,
                'autoDelete': True,
                'initializeParams': {
                    'sourceImage': 'projects/debian-cloud/global/images/debian-10-buster-v20190813',
                    'diskSizeGb': '1000',
                    'diskType': f'zones/{GCE_ZONE}/diskTypes/pd-ssd'
                }
            }
        ],
        'networkInterfaces': [{'accessConfigs': [{'name': 'external-nat',
                                                  'networkTier': 'PREMIUM',
                                                  'type': 'ONE_TO_ONE_NAT'}],
                               'network': 'global/networks/default',
                               }
                              ],
        'metadata': {'items': [
            {
                'key': 'startup-script-url',
                'value': SCRIPT_URL,
            }
        ]},
        'serviceAccounts': {
            'email': SERVICE_ACCOUNT_EMAIL,
            'scopes': ['https://www.googleapis.com/auth/cloud-platform']
        }
    }
    request = service.instances().insert(project=GCP_PROJECT, zone=GCE_ZONE, body=body)
    response = request.execute()
    logging.info(response)


def main(request=None):
    create_vm()
