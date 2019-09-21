#!/bin/bash

NAME=inst-test1
SCRIPT_URL=gs://openstreetmap-public-data-dev-test/startup_test.sh

gcloud compute instances create $NAME \
--project openstreetmap-public-data-dev \
--machine-type n1-standard-4 \
--boot-disk-size 1TB \
--boot-disk-type pd-ssd \
--metadata=startup-script-url=$SCRIPT_URL \
--image debian-10-buster-v20190813 \
--image-project debian-cloud \
--scopes cloud-platform