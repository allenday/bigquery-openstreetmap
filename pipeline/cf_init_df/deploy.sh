#!/usr/bin/env bash

gcloud functions deploy init-df \
--project $GCP_PROJECT \
--entry-point main \
--runtime python37 \
--trigger-resource $GCS_GEOJSON_BUCKET	\
--trigger-event google.storage.object.finalize \
--set-env-vars=DF_TEMPLATE=$DATAFLOW_TEMPLATE_LOCATION,DF_WORKING_BUCKET=$GCS_BUCKET,BQ_TARGET_DATASET=$BQ_TARGET_DATASET
