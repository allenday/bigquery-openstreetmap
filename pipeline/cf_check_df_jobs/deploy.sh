#!/usr/bin/env bash

gcloud functions deploy check-df-jobs \
--project $GCP_PROJECT \
--entry-point main \
--runtime python37 \
--timeout 540 \
--trigger-topic $PS_TOPIC_DF_JOBS \
--set-env-vars=PUBSUB_DF_TOPIC=$PS_TOPIC_DF_JOBS,PUBSUB_BQ_TOPIC=$PS_TOPIC_LAYERS
