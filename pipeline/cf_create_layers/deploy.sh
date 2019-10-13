#!/usr/bin/env bash

gcloud functions deploy bq-create-layers \
--project $GCP_PROJECT \
--entry-point main \
--runtime python37 \
--timeout 540 \
--trigger-topic $PS_LAYERS_TOPIC \
--set-env-vars=BUCKET=$GCS_BUCKET,TABLE_NAME=$BQ_LAYERS_TABLE,DATASET_NAME=$BQ_DATASET,TEMP_DATASET_NAME=$BQ_TEMP_DATASET