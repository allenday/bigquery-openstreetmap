#!/usr/bin/env bash

gcloud beta functions deploy init-gce \
--project $GCP_PROJECT \
--entry-point main \
--runtime python37 \
--trigger-http \
--set-env-vars=GCE_ZONE=$GCE_ZONE,SCRIPT_URL=$SCRIPT_URL,SERVICE_ACCOUNT_EMAIL=$GCE_SERVICE_ACCOUNT_EMAIL
