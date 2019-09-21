#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export GCS_BUCKET=gs://openstreetmap-public-data-dev-test
export DF_JOBS_PS_TOPIC=check-df-jobs-test
export OSM_URL=https://download.geofabrik.de/europe/luxembourg-latest.osm.pbf
export GCS_GEOJSON_BUCKET=gs://openstreetmap-public-data-dev-geojson-test/

echo "deb http://ftp.us.debian.org/debian/ sid main contrib non-free" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://ftp.us.debian.org/debian/ sid main" | sudo tee -a /etc/apt/sources.list
echo "deb http://ftp.us.debian.org/debian/ testing main contrib non-free" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://ftp.us.debian.org/debian/ testing main" | sudo tee -a /etc/apt/sources.list

echo "Package: *" | sudo tee -a /etc/apt/preferences
echo "Pin: release a=unstable" | sudo tee -a /etc/apt/preferences
echo "Pin-Priority: 1000" | sudo tee -a /etc/apt/preferences
echo "Package: *" | sudo tee -a /etc/apt/preferences
echo "Pin: release a=testing" | sudo tee -a /etc/apt/preferences
echo "Pin-Priority: 100" | sudo tee -a /etc/apt/preferences

sudo apt-get -y update
#&& apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install locales build-essential clang
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install gdal* wget

gsutil cp $GCS_BUCKET/osm2geojsoncsv ~/
gsutil cp $GCS_BUCKET/osmconf.ini ~/
gsutil cp $GCS_BUCKET/process.sh ~/


cd ~/ || exit
chmod +x set_env_vars_test.sh
chmod +x osm2geojsoncsv
chmod +x process.sh

./process.sh
