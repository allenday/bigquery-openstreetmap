#!/bin/sh

# in every subfolder in layered_gis folder, there is bash file which generates queries for that layer
# script goes through folders and executes those scripts to generate sql files

FOLDERS="$(find . -mindepth 1 -type d)"

for FOLDER in $FOLDERS; do
    cd $FOLDER || exit
    FILE="$(find *.sh)"
    echo "running " $FOLDER/$FILE
    bash $FILE
    cd ..
done
