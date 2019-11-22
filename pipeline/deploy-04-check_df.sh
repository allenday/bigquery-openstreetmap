#!/bin/bash

gcloud functions deploy check-df-$STAGE \
--project $GCP_PROJECT \
--no-allow-unauthenticated \
--entry-point main \
--runtime python37 \
--timeout 540 \
--trigger-topic $PS_TOPIC_DF \
--source=$SOURCE_ROOT/pipeline/cf_check_df \
--set-env-vars=STAGE=$STAGE,PS_TOPIC_DF=$PS_TOPIC_DF,PS_TOPIC_LAYERS=$PS_TOPIC_LAYERS
