#!/usr/bin/env bash

gcloud --project openstreetmap-public-data-dev functions deploy bq-create-layers \
--entry-point main \
--runtime python37 \
--timeout 540 \
--trigger-topic create-layers \
--env-vars-file env.yaml