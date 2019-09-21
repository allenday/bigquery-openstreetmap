#!/usr/bin/env bash


OSM_FILENAME="$(basename $OSM_URL)"
FILENAME_BASE="${OSM_FILENAME//.osm.pbf/""}"

# download file
echo "downloading"

wget $OSM_URL
echo "downloading completed"
# parse

./osm2geojsoncsv $OSM_FILENAME $FILENAME_BASE

# upload
find . -name '*.csv' -exec gsutil -m cp {} $GCS_GEOJSON_BUCKET \;

# wait for Dataflow job to start
sleep 120s

# publish pubsub message so we can check when datflow jobs are done
gcloud pubsub topics publish $DF_JOBS_PS_TOPIC --message " "

# shutdown
gcloud compute instances delete $(hostname) --zone \
$(curl -H Metadata-Flavor:Google http://metadata.google.internal/computeMetadata/v1/instance/zone -s | cut -d/ -f4) -q