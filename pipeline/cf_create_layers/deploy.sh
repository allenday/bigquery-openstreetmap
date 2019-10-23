#!/usr/bin/env bash

gcloud functions deploy bq-create-layers \
--project $GCP_PROJECT \
--entry-point main \
--runtime python37 \
--timeout 540 \
--trigger-topic $PS_LAYERS_TOPIC \
--set-env-vars=GCS_BUCKET=$GCS_BUCKET,BQ_LAYERS_TABLE=$BQ_LAYERS_TABLE,BQ_DATASET=$BQ_DATASET,BQ_TEMP_DATASET=$BQ_TEMP_DATASET