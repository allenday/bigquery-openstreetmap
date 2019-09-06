#!/usr/bin/env bash

gcloud beta functions deploy init-gce \
--project openstreetmap-public-data-dev \
--entry-point main \
--runtime python37 \
--trigger-http \
--env-vars-file env.yaml