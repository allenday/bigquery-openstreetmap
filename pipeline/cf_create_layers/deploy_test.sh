#!/usr/bin/env bash

gcloud functions deploy bq-create-layers-test \
--project openstreetmap-public-data-dev \
--entry-point main \
--runtime python37 \
--timeout 540 \
--trigger-topic create-layers-test \
--env-vars-file env_test.yaml