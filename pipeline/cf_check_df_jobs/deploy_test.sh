#!/usr/bin/env bash

gcloud functions deploy check-df-jobs-test \
--project openstreetmap-public-data-dev \
--entry-point main \
--runtime python37 \
--timeout 540 \
--trigger-topic check-df-jobs-test \
--env-vars-file env_test.yaml