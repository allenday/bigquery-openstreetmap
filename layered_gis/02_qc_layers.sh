#!/bin/sh

# in every subfolder in layered_gis folder, there is bash file which generates queries for that layer
# script goes through folders and executes those scripts to generate sql files

FOLDERS="$(find . -mindepth 1 -type d | sort)"

for FOLDER in $FOLDERS; do
  FILES="$(find $FOLDER/*.sql | sort)"
  for FILE in $FILES; do
    CUT1="$(echo $FILE | cut -d. -f2)"
    CLASS="$(echo $CUT1 | cut -d/ -f2)"
    NAME="$(echo $CUT1 | cut -d/ -f3)"
    /bin/echo -n "$CLASS.$NAME	"

#    /bin/echo "SELECT COUNT(*) FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.layers\` WHERE layer_class='$CLASS' AND layer_name='$NAME'" | bq query --nouse_legacy_sql --format csv 2>/dev/null | grep -v f0
  done
#    echo "running " $FOLDER/$FILE
#    bash $FILE
#    cd ..
done
