#!/bin/bash

i=0
mode=""
for SQL in `find . -type f -name '*.sql' | sort`; do
  if (($i > 0)); then
    mode="--append_table"
  else
    mode="--replace"
  fi

  cmd="cat $SQL | bq query\
  --project ${GCP_PROJECT}\
  --nouse_legacy_sql\
  $mode\
  --range_partitioning 'layer_code,0,9999,1'\
  --clustering_fields 'layer_code,geometry'\
  --display_name $SQL\
  --destination_table '${GCP_PROJECT}:${BQ_SOURCE_DATASET}.layers'\
  --destination_schema ../schema/geofabrik_layers.json >/dev/null"

  if (($i > 0)); then
    echo $cmd
  else
    echo "$cmd" | bash
  fi

  ((i=i+1))
done
