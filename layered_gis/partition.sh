#!/bin/sh
# https://cloud.google.com/bigquery/docs/partitioned-tables#comparing_partitioning_options

LAYERS=`find . -type d -depth 1 | xargs basename | sort`

echo "CREATE OR REPLACE FUNCTION \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.gd\`(j INT64)
RETURNS ARRAY<DATE>
AS(ARRAY<DATE>[(CAST(TIMESTAMP_ADD(TIMESTAMP'1970-01-01',INTERVAL j DAY)AS DATE))]);"
echo "CREATE OR REPLACE FUNCTION \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.gda\`(j INT64,k INT64)
RETURNS ARRAY<DATE>
AS(GENERATE_DATE_ARRAY(CAST(TIMESTAMP_ADD(TIMESTAMP'1970-01-01',INTERVAL j DAY)AS DATE),CAST(TIMESTAMP_ADD(TIMESTAMP'1970-01-01',INTERVAL k DAY)AS DATE)));"

echo "CREATE OR REPLACE FUNCTION \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.layer_partition\`(c STRING)
RETURNS ARRAY<DATE>
AS(CASE"
N=1
for LAYER in $LAYERS
do
  K0=$N
  K1=$N
  LAYER_CLASSES=`find $LAYER -type f -name '*.sql' -exec basename '{}' .sql \; | sort`
  for LAYER_CLASS in $LAYER_CLASSES
  do
    #echo "$LAYER/$LAYER_CLASS"
    echo "WHEN c='$LAYER-$LAYER_CLASS' THEN \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.gd\`($N)"
    K1=$N
    N=$((N+1))
  done
  echo "WHEN c='$LAYER' THEN \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.gda\`($K0,$K1)"
done
echo "ELSE ARRAY<DATE>[] END);"
