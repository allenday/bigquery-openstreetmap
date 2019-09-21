#!/usr/bin/env bash

gcloud functions deploy check-df-jobs \
--project openstreetmap-public-data-dev \
--entry-point main \
--runtime python37 \
--timeout 540 \
--trigger-topic check-df-jobs \
--env-vars-file env.yaml
