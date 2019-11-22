#!/bin/bash

python dataflow/main.py \
--runner DataflowRunner \
--project $GCP_PROJECT \
--temp_location $DF_TEMP_LOCATION \
--staging_location $DF_STAGING_LOCATION \
--network dataflow \
--no_use_public_ips true \
--template_location $DF_TEMPLATE_LOCATION

gcloud functions deploy init-df-$STAGE \
--project $GCP_PROJECT \
--no-allow-unauthenticated \
--entry-point main \
--runtime python37 \
--trigger-resource $GCS_GEOJSON_BUCKET	\
--trigger-event google.storage.object.finalize \
--source=$SOURCE_ROOT/pipeline/cf_init_df \
--set-env-vars=STAGE=$STAGE,DF_TEMPLATE=$DF_TEMPLATE_LOCATION,GCS_BUCKET=$GCS_BUCKET,BQ_TARGET_DATASET=$BQ_TARGET_DATASET
