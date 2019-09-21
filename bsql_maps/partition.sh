#!/bin/sh
# https://cloud.google.com/bigquery/docs/partitioned-tables#comparing_partitioning_options

LAYERS=$(find . -name '*.sql' -exec basename '{}' .sql \; | sort)

echo "CREATE OR REPLACE FUNCTION \`openstreetmap-public-data-dev.osm_planet.name2partnum\`(name STRING)
  RETURNS DATE
  AS (CAST(TIMESTAMP_ADD(TIMESTAMP \"1970-01-01\", INTERVAL (CASE"
N=1
for LAYER in $LAYERS
do
    echo "WHEN name = '$LAYER' THEN $N"
    N=$((N+1))
done
echo "ELSE -1 END) DAY) AS DATE));"
