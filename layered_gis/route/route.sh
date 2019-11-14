#!/bin/sh

LAYER=( "9001:bicycle"
        "9002:mtb"
        "9003:hiking"
        "9004:horse"
        "9005:nordic_walking"
        "9006:running")

for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  NAME="${layer##*:}"
  echo "SELECT
  $CODE AS layer_code, 'route' AS layer_class, '$NAME' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'route' AND tags.value='$NAME')" > "routes_$NAME.sql"
done
