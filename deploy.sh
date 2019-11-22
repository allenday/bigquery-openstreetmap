#!/bin/bash


PROJECT=openstreetmap-public-data-dev
SCRIPT_BUCKET=gs://$PROJECT-deploy

gsutil mb -p $PROJECT $SCRIPT_BUCKET

gsutil cp ./osm2bigquery/osm2geojsoncsv			$SCRIPT_BUCKET/
gsutil cp ./osm2bigquery/osmconf.ini			$SCRIPT_BUCKET/
gsutil cp ./pipeline/gce_download_parse/process.sh	$SCRIPT_BUCKET/

#https://source.developers.google.com/projects/openstreetmap-public-data-dev/repos/github_allenday_bigquery-openstreetmap/moveable-aliases/deploy/startup.sh


