#!/bin/bash

export BASE=openstreetmap-public-data
export STAGE=dev
#export STAGE=prod

# Project IDs
export GCP_PROJECT=$BASE-$STAGE
export BQ_TARGET_PROJECT=$BASE-$STAGE

# Source OSM data settings
export DEV_OSM_URL=https://download.geofabrik.de/europe/luxembourg-latest.osm.pbf
export PROD_OSM_URL=https://planet.openstreetmap.org/pbf/planet-latest.osm.pbf

# Source git settings
export DEV_BRANCH=deploy
export PROD_BRANCH=master

# BQ settings
export DEV_BQ_TARGET_PROJECT=$BASE-$STAGE
export PROD_BQ_TARGET_PROJECT=bigquery-public-data

export DEV_BQ_SOURCE_DATASET=osm_planet
export DEV_BQ_LAYERS_TABLE=layers
export DEV_BQ_TEMP_DATASET=osm_temp_$STAGE
export DEV_BQ_TARGET_DATASET=geo_openstreetmap_$STAGE

export PROD_BQ_SOURCE_DATASET=osm_planet
export PROD_BQ_LAYERS_TABLE=layers
export PROD_BQ_TEMP_DATASET=osm_temp_$STAGE
export PROD_BQ_TARGET_DATASET=geo_openstreetmap

#GCE settings
export DEV_GCE_SERVICE_ACCOUNT_EMAIL=164168395917-compute@developer.gserviceaccount.com
export PROD_GCE_SERVICE_ACCOUNT_EMAIL=65356283268-compute@developer.gserviceaccount.com

###
### use STAGE to normalize variables for uniform referencing
###

TTT=$(echo "${STAGE}_BRANCH"                    | tr '[:lower:]' '[:upper:]'); export BRANCH=${!TTT}
export SOURCE_ROOT=https://source.developers.google.com/projects/$BASE-$STAGE/repos/github_allenday_bigquery-openstreetmap/moveable-aliases/$BRANCH/paths

export BQ_SERVICE_ACCOUNT_FILENAME=${STAGE}_bq_osm_service_account.json
TTT=$(echo "${STAGE}_BQ_TARGET_PROJECT"         | tr '[:lower:]' '[:upper:]'); export BQ_TARGET_PROJECT=${!TTT}
TTT=$(echo "${STAGE}_GCE_SERVICE_ACCOUNT_EMAIL" | tr '[:lower:]' '[:upper:]'); export GCE_SERVICE_ACCOUNT_EMAIL=${!TTT}
TTT=$(echo "${STAGE}_OSM_URL"                   | tr '[:lower:]' '[:upper:]'); export OSM_URL=${!TTT}

# GCS
export GCS_BUCKET=gs://$BASE-$STAGE
export GCS_GEOJSON_BUCKET=$GCS_BUCKET-geojson

# GCE
export GCE_INSTANCE_NAME=inst1-${STAGE}
export GCE_SCRIPT_URL=$GCS_BUCKET/startup.sh
export GCE_ZONE=us-central1-a

# DF
export DF_TEMP_LOCATION=$GCS_BUCKET/df_temp
export DF_STAGING_LOCATION=$GCS_BUCKET/df_staging
export DF_TEMPLATE_LOCATION=$GCS_BUCKET/df_template/process_geojson

# BigQuery
TTT=$(echo "${STAGE}_BQ_SOURCE_DATASET" | tr '[:lower:]' '[:upper:]'); export BQ_SOURCE_DATASET=${!TTT}
TTT=$(echo "${STAGE}_BQ_LAYERS_TABLE"   | tr '[:lower:]' '[:upper:]'); export BQ_LAYERS_TABLE=${!TTT}
TTT=$(echo "${STAGE}_BQ_TEMP_DATASET"   | tr '[:lower:]' '[:upper:]'); export BQ_TEMP_DATASET=${!TTT}
TTT=$(echo "${STAGE}_BQ_TARGET_DATASET" | tr '[:lower:]' '[:upper:]'); export BQ_TARGET_DATASET=${!TTT}

# PubSub topics
export PS_TOPIC_DF=check-df-$STAGE
export PS_TOPIC_LAYERS=create-layers-$STAGE
