#!/usr/bin/env bash

gcloud functions deploy create-bq-layers-$STAGE \
--project $GCP_PROJECT \
--no-allow-unauthenticated \
--entry-point main \
--runtime python37 \
--timeout 540 \
--trigger-topic $PS_TOPIC_LAYERS \
--source=$SOURCE_ROOT/pipeline/cf_create_bq_layers \
--set-env-vars=STAGE=$STAGE,GCS_BUCKET=$GCS_BUCKET,BQ_LAYERS_TABLE=$BQ_LAYERS_TABLE,BQ_DATASET=$BQ_DATASET,BQ_TEMP_DATASET=$BQ_TEMP_DATASET,BQ_SERVICE_ACCOUNT_FILENAME=$BQ_SERVICE_ACCOUNT_FILENAME,BQ_PUBLIC_DATASET=$BQ_PUBLIC_DATASET,BQ_PUBLIC_PROJECT=$BQ_PUBLIC_PROJECT
