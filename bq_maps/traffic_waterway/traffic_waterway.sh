#!/bin/sh

LAYER=( 
        "5301:leisure=slipway"
        "5302:leisure=marina"
        "5303:man_made=pier"
        "5311:waterway=dam"
        "5321:waterway=waterfall"
        "5331:waterway=lock_gate"
        "5332:waterway=weir"
)



for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'traffic' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done
