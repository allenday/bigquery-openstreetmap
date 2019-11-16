#!/bin/bash

# Project IDs
export GCP_PROJECT=openstreetmap-public-data-prod
export BQ_PUBLIC_PROJECT=bigquery-public-data

# OSM
export OSM_URL=https://planet.openstreetmap.org/pbf/planet-latest.osm.pbf

# GCS
export GCS_BUCKET=gs://openstreetmap-public-data-prod
export GCS_GEOJSON_BUCKET=gs://openstreetmap-public-data-geojson-prod

# GCE
export GCE_INSTANCE_NAME=inst1
export SCRIPT_URL=$GCS_BUCKET/startup.sh
export GCE_ZONE=us-central1-a
export GCE_SERVICE_ACCOUNT_EMAIL=65356283268-compute@developer.gserviceaccount.com


# DATAFLOW
export DATAFLOW_TEMP_LOCATION=$GCS_BUCKET/df_temp
export DATAFLOW_STAGING_LOCATION=$GCS_BUCKET/df_staging
export DATAFLOW_TEMPLATE_LOCATION=$GCS_BUCKET/df_template/process_geojson

# BigQuery
export BQ_DATASET=osm_planet
export BQ_LAYERS_TABLE=layers
export BQ_TEMP_DATASET=osm_temp
export BQ_PUBLIC_DATASET=geo_openstreetmap

# PubSub topics
export DF_JOBS_PS_TOPIC=check-df-jobs
export PS_TOPIC_DF_JOBS=check-df-jobs
export PS_LAYERS_TOPIC=create-layers

# BQ public dataset
export SERVICE_ACCOUNT_FILENAME=bq_osm_service_account.json
