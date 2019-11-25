#!/bin/sh
# https://cloud.google.com/bigquery/docs/partitioned-tables#comparing_partitioning_options

LAYER_CLASSES=`find . -type d -depth 1 | xargs basename | sort`

echo "CREATE OR REPLACE FUNCTION \`${GCP_PROJECT}.${BQ_DATASET}.get_partitions\` (name STRING)
  RETURNS ARRAY<DATE>
  AS (CASE"
N=1
for LAYER_CLASS in $LAYER_CLASSES
do
  K0=$N
  K1=$N
  LAYER_NAMES=`find $LAYER_CLASS -type f -name '*.sql' -exec basename '{}' .sql \; | sort`
  for LAYER_NAME in $LAYER_NAMES
  do
    #echo "$LAYER_CLASS/$LAYER_NAME"
    echo "WHEN name = '$LAYER_CLASS-$LAYER_NAME' THEN [DATE_ADD('1970-01-01', INTERVAL $N DAY)]"
    K1=$N
    N=$((N+1))
  done
  echo "WHEN name = '$LAYER_CLASS' THEN GENERATE_DATE_ARRAY(DATE_ADD('1970-01-01', INTERVAL $K0 DAY),
  DATE_ADD('1970-01-01', INTERVAL $K1 DAY))"
done
echo "  ELSE ARRAY<DATE>[] END);"
