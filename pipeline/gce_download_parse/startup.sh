#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
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
sudo DEBIAN_FRONTEND=noninteractive apt-get -y qq install locales build-essential clang

sudo apt-get -y install gdal* wget

gsutil cp gs://openstreetmap-public-data-dev/osm2geojsoncsv.sh ~/
gsutil cp gs://openstreetmap-public-data-dev/osmconf.ini ~/
gsutil cp gs://openstreetmap-public-data-dev/process.sh ~/

cd ~/
echo "current folder " && pwd
ls
chmod +x osm2geojsoncsv.sh
chmod +x process.sh

./process.sh
