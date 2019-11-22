#!/bin/bash

# OSM_FILENAME=$(basename $OSM_URL)
# CSV_FILENAME=${OSM_FILENAME//.osm.pbf/.csv}

#Runner=DataflowRunner
RUNNER=DirectRunner

echo "
python main.py \
--project $GCP_PROJECT \
--runner $RUNNER \
--network dataflow \
--no_use_public_ips true \
--staging_location $DF_STAGING_LOCATION \
--temp_location $DF_TEMP_LOCATION \
--input $GCS_GEOJSON_BUCKET/ \
--bq_destination $GCP_PROJECT:$BQ_TARGET_DATASET.test_table
"
