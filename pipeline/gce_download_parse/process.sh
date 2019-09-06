#!/usr/bin/env bash

# download file
echo "downloading"
OSM_URL=https://planet.openstreetmap.org/pbf/planet-latest.osm.pbf

OSM_FILENAME="$(basename $OSM_URL)"
FILENAME_BASE="${OSM_FILENAME//.osm.pbf/""}"

wget $OSM_URL
echo "downloading completed"
# parse

./osm2geojsoncsv.sh $OSM_FILENAME $FILENAME_BASE

# upload
find . -name '*.csv' -exec gsutil -m cp {} gs://planet-latest-multilinestrings.debug.log/ \;

# shutdown
gcloud compute instances delete $(hostname) --zone \
$(curl -H Metadata-Flavor:Google http://metadata.google.internal/computeMetadata/v1/instance/zone -s | cut -d/ -f4) -q