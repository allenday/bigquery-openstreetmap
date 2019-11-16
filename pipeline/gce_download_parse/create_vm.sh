#!/bin/bash

NAME=inst1
SCRIPT_URL=gs://openstreetmap-public-data-prod/startup.sh

gcloud compute instances create $NAME \
--project $GCP_PROJECT \
--machine-type n1-standard-32 \
--boot-disk-size 1TB \
--boot-disk-type pd-ssd \
--metadata=startup-script-url=$SCRIPT_URL \
--image debian-10-buster-v20190813 \
--image-project debian-cloud \
--scopes cloud-platform