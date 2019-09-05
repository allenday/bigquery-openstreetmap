#!/usr/bin/env bash

gcloud --project openstreetmap-public-data-dev functions deploy init-df \
--entry-point main \
--runtime python37 \
--trigger-resource openstreetmap-public-data-dev-geojson	\
--trigger-event google.storage.object.finalize \
--env-vars-file env.yaml