#!/bin/sh
# https://cloud.google.com/bigquery/docs/partitioned-tables#comparing_partitioning_options

LAYERS=$(find . -name '*.sql' -exec basename '{}' .sql \; | sort)

echo "CREATE OR REPLACE FUNCTION \`${GCP_PROJECT}.${BQ_DATASET}.get_partitions\` (name STRING)
  RETURNS ARRAY<DATE>
  AS (CASE"
N=1
for LAYER in $LAYERS
do
    echo "WHEN name = '$LAYER' THEN ARRAY<DATE>[CAST(TIMESTAMP_ADD(TIMESTAMP '1970-01-01', INTERVAL $N DAY) AS DATE)]"
    N=$((N+1))
done
echo "ELSE ARRAY<DATE>[] END);"
