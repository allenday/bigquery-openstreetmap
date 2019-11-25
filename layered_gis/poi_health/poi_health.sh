#!/bin/sh

LAYER=( 
        "2101:amenity=pharmacy"
        "2110:amenity=hospital"
        "2120:amenity=doctors"
        "2121:amenity=dentist"
        "2129:amenity=veterinary"
)



for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'poi_health' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done
