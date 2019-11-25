#!/bin/sh

LAYER=( 
        "2301:amenity=restaurant"
        "2302:amenity=fast_food"
        "2303:amenity=cafe"
        "2304:amenity=pub"
        "2305:amenity=bar"
        "2306:amenity=food_court"
        "2307:amenity=biergarten"
)



for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'poi_catering' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done
