#!/usr/bin/env bash

gcloud functions deploy check-df \
--project openstreetmap-public-data-dev \
--entry-point main \
--runtime python37 \
--timeout 540 \
--trigger-topic check_df_job \
--env-vars-file env.yaml