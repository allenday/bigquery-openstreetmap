import os

from googleapiclient.discovery import build
import google.auth
from pprint import pprint

GCP_PROJECT = os.environ['GCP_PROJECT']
GCE_ZONE = os.environ['GCE_ZONE']
SCRIPT_URL = os.environ['SCRIPT_URL']


def get_info():
    credentials, _project = google.auth.default()
    service = build('compute', 'v1', credentials=credentials, cache_discovery=False)

    request = service.instances().get(project=GCP_PROJECT, zone=GCE_ZONE, instance='inst1')
    response = request.execute()
    pprint(response)


def main(request):
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
            'email': '164168395917-compute@developer.gserviceaccount.com',
            'scopes': ['https://www.googleapis.com/auth/cloud-platform']
        }
    }
    request = service.instances().insert(project=GCP_PROJECT, zone=GCE_ZONE, body=body)
    response = request.execute()
    print(response)


if __name__ == '__main__':
    # get_info()
    main()
