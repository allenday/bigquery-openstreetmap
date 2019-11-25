#!/usr/bin/env bash

echo "# Configuration file for OSM import

# put here the name of keys, or key=value, for ways that are assumed to be polygons if they are closed
# see http://wiki.openstreetmap.org/wiki/Map_Features
closed_ways_are_polygons=aeroway,amenity,boundary,building,craft,geological,historic,landuse,leisure,military,natural,office,place,shop,sport,tourism,highway=platform,public_transport=platform

# comment to avoid laundering of keys ( ':' turned into '_' )
attribute_name_laundering=yes

# keys that should NOT be reported in the 'other_tags' field
ignore=created_by,converted_by,source,time,ele,note,openGeoDB:,fixme,FIXME

[lines]
# common attributes
osm_id=yes
osm_version=yes
osm_timestamp=yes
other_tags=no
# create 'all_tags' field
all_tags=yes

[multilinestrings]
# common attributes
osm_id=yes
osm_version=yes
osm_timestamp=yes
other_tags=no
# create 'all_tags' field
all_tags=yes

[multipolygons]
# common attributes
osm_id=yes
osm_version=yes
osm_timestamp=yes
other_tags=no
# create 'all_tags' field
all_tags=yes

[other_relations]
# common attributes
osm_id=yes
osm_version=yes
osm_timestamp=yes
other_tags=no
# create 'all_tags' field
all_tags=yes

[points]
# common attributes
osm_id=yes
osm_version=yes
osm_timestamp=yes
other_tags=no
# create 'all_tags' field
all_tags=yes
" | gsutil cp - $GCS_BUCKET/osmconf.ini

echo "#!/bin/bash

OSM_FILENAME=\"\$(basename $OSM_URL)\"
FILENAME_BASE=\"\${OSM_FILENAME//.osm.pbf/}\"

# download file
echo 'downloading'

axel -n 10 $OSM_URL
echo 'downloading completed'
# parse

echo \"./osm2geojsoncsv \$OSM_FILENAME \$FILENAME_BASE\"
./osm2geojsoncsv \$OSM_FILENAME \$FILENAME_BASE

# upload
find . -name '*.csv' -exec gsutil -m cp {} $GCS_GEOJSON_BUCKET \;

# wait for Dataflow job to start
sleep 120s

# publish pubsub message so we can check when datflow jobs are done and
gcloud pubsub topics publish $PS_TOPIC_DF --message ' '

# shutdown
gcloud compute instances delete \$(hostname) --zone $GCE_ZONE -q
" | gsutil cp - $GCS_BUCKET/process.sh

echo "#!/bin/bash
# Build BQ GeoJSON dataset from OSM dump file
# The driver will categorize features into 5 layers :

# points : 'node' features that have significant tags attached.
# lines : 'way' features that are recognized as non-area.
# multilinestrings : 'relation' features that form a multilinestring
# (type = 'multilinestring' or type = 'route').
# multipolygons : 'relation' features that form a multipolygon
# (type = 'multipolygon' or type = 'boundary'), and 'way' features that
# are recognized as area.
# other_relations : 'relation' features that do not belong to the above 2 layers.
# Note: for recent GDAL option 'OGR_INTERLEAVED_READING=YES' is not required
# Use as
# time sh osm2geojsoncsv germany-latest.osm.pbf germany-latest
set -e

# use custom GDAL configuration
OGRCONFIG=osmconf.ini

if [ \"\$#\" -ne 2 ]
then
    echo \"Use as:\\n\\t\$0 INPUT_FILENAME_OSM_PBF OUTPUT_BASENAME\"
    exit 1
fi

# input file name
OSMNAME=\"\$1\"
# output file basename (without extension)
NAME=\"\$2\"

# check input file
if [ ! -f \"\$OSMNAME\" ]
then
    echo \"Input file '\$1' doesn't exist\"
    exit 1
fi
# check input file
if [ ! -r \"\$OSMNAME\" ]
then
    echo \"Input file '\$1' is not readable\"
    exit 1
fi
if [ ! -s \"\$OSMNAME\" ]
then
    echo \"Input file '\$1' is empty\"
    exit 1
fi
BASENAME=\$(basename \"\$OSMNAME\")
if [ \$(basename \"\$BASENAME\" .pbf) = \"\$BASENAME\" ]
then
    echo \"Input file '\$1' is not PBF Format ('Protocolbuffer Binary Format') file\"
    exit 1
fi
# the option below can be helpful for some hardware configurations:
# --config OSM_COMPRESS_NODES YES
# GDAL_CACHEMAX and OSM_MAX_TMPFILE_SIZE defined in MB
# for GDAL_CACHEMAX=4000 and OSM_MAX_TMPFILE_SIZE=4000 recommended RAM=60GB
for ogrtype in points lines multilinestrings multipolygons other_relations
do
    if [ \"\$ogrtype\" = 'multipolygons' ]
    then
        osm_fields='osm_id,osm_way_id,osm_version,osm_timestamp'
    else
        osm_fields='osm_id,NULL AS osm_way_id,osm_version,osm_timestamp'
    fi
    echo \"Processing \${ogrtype} with OSM fields \${osm_fields}\"

    ogr2ogr --debug on -skipfailures \\
    -f CSV \\
    \"\${NAME}-\${ogrtype}.geojson.csv\" \"\${OSMNAME}\" \\
    --config OSM_CONFIG_FILE \"\${OGRCONFIG}\" \\
    --config OGR_INTERLEAVED_READING YES \\
    --config GDAL_CACHEMAX 4000 \\
    --config OSM_MAX_TMPFILE_SIZE 4000 \\
    -dialect sqlite \\
    -sql \"select AsGeoJSON(geometry) AS geometry, \${osm_fields}, replace(all_tags,X'0A','') as all_tags from \${ogrtype} where ST_IsValid(geometry) = 1\" \\
    2>\"\${NAME}-\${ogrtype}.debug.log\" \\
    &
done
wait
echo 'Complete'
" | gsutil cp - $GCS_BUCKET/osm2geojsoncsv

echo "#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export GCS_BUCKET=$GCS_BUCKET
export PS_TOPIC_DF=$PS_TOPIC_DF
export OSM_URL=$OSM_URL
export GCS_GEOJSON_BUCKET=$GCS_GEOJSON_BUCKET

echo 'deb http://ftp.us.debian.org/debian/ sid main contrib non-free' | sudo tee -a /etc/apt/sources.list
echo 'deb-src http://ftp.us.debian.org/debian/ sid main' | sudo tee -a /etc/apt/sources.list
echo 'deb http://ftp.us.debian.org/debian/ testing main contrib non-free' | sudo tee -a /etc/apt/sources.list
echo 'deb-src http://ftp.us.debian.org/debian/ testing main' | sudo tee -a /etc/apt/sources.list

echo 'Package: *' | sudo tee -a /etc/apt/preferences
echo 'Pin: release a=unstable' | sudo tee -a /etc/apt/preferences
echo 'Pin-Priority: 1000' | sudo tee -a /etc/apt/preferences
echo 'Package: *' | sudo tee -a /etc/apt/preferences
echo 'Pin: release a=testing' | sudo tee -a /etc/apt/preferences
echo 'Pin-Priority: 100' | sudo tee -a /etc/apt/preferences

sudo apt-get -y update
#&& apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install locales build-essential clang
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install gdal* wget axel

gsutil cp $GCS_BUCKET/osm2geojsoncsv ~/
gsutil cp $GCS_BUCKET/osmconf.ini ~/
gsutil cp $GCS_BUCKET/process.sh ~/

cd ~/ || exit
chmod +x osm2geojsoncsv
chmod +x process.sh

./process.sh" | gsutil cp - $GCS_BUCKET/startup.sh

gcloud beta functions deploy init-gce-$STAGE \
--project $GCP_PROJECT \
--no-allow-unauthenticated \
--entry-point main \
--runtime python37 \
--trigger-http \
--source=$SOURCE_ROOT/pipeline/cf_init_gce \
--set-env-vars=STAGE=$STAGE,GCE_ZONE=$GCE_ZONE,GCE_SCRIPT_URL=$GCE_SCRIPT_URL,GCE_SERVICE_ACCOUNT_EMAIL=$GCE_SERVICE_ACCOUNT_EMAIL
