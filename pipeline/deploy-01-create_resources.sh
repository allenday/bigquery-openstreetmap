#!/bin/bash
gcloud pubsub topics create $PS_TOPIC_DF --project $GCP_PROJECT
gcloud pubsub topics create $PS_TOPIC_LAYERS  --project $GCP_PROJECT
gsutil mb $GCS_BUCKET
gsutil mb $GCS_GEOJSON_BUCKET

bq mk --project_id $GCP_PROJECT $BQ_SOURCE_DATASET
bq mk --project_id $GCP_PROJECT $BQ_TEMP_DATASET
bq mk --project_id $GCP_PROJECT $BQ_TARGET_DATASET

gsutil -m cp -r cf_init_df/df_template $GCS_BUCKET/
gsutil -m cp -r ../layered_gis $GCS_BUCKET/


LAYER_CLASSES=`find ../layered_gis -type d -depth 1 | xargs basename | sort`

(echo "CREATE OR REPLACE FUNCTION \`${GCP_PROJECT}.${BQ_TARGET_DATASET}.get_partitions\` (name STRING) RETURNS ARRAY<DATE> AS (CASE"
N=1
for LAYER_CLASS in $LAYER_CLASSES
do
  K0=$N
  K1=$N
  LAYER_NAMES=`find ../layered_gis/$LAYER_CLASS -type f -name '*.sql' -exec basename '{}' .sql \; | sort`
  for LAYER_NAME in $LAYER_NAMES
  do
    echo "WHEN name = '$LAYER_CLASS-$LAYER_NAME' THEN [DATE_ADD('1970-01-01', INTERVAL $N DAY)]"
    K1=$N
    N=$((N+1))
  done
  echo "WHEN name = '$LAYER_CLASS' THEN GENERATE_DATE_ARRAY(DATE_ADD('1970-01-01', INTERVAL $K0 DAY),
  DATE_ADD('1970-01-01', INTERVAL $K1 DAY))"
done
echo "  ELSE ARRAY<DATE>[] END);") | bq query --nouse_legacy_sql
