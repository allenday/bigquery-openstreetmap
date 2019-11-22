#!/usr/bin/env bash

gcloud beta functions deploy init-gce-$STAGE \
--project $GCP_PROJECT \
--no-allow-unauthenticated \
--entry-point main \
--runtime python37 \
--trigger-http \
--source=$SOURCE_ROOT/pipeline/cf_init_gce \
--set-env-vars=STAGE=$STAGE,GCE_ZONE=$GCE_ZONE,GCE_SCRIPT_URL=$GCE_SCRIPT_URL,GCE_SERVICE_ACCOUNT_EMAIL=$GCE_SERVICE_ACCOUNT_EMAIL
