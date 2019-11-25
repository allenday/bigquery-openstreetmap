#!/bin/sh

LAYER=( 
        "5231:traffic_calming=hump"
        "5232:traffic_calming=bump"
        "5233:traffic_calming=table"
        "5234:traffic_calming=chicane"
        "5235:traffic_calming=cushion"
)

for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'traffic' AS layer_class, 'calming_$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "calming_$V.sql"
done

#5230
echo "SELECT
  5230 AS layer_code, 'traffic' AS layer_class, 'calming' AS layer_name, feature_type AS gdal_type, osm_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'traffic_calming')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'traffic_calming' AND tags.value='hump')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'traffic_calming' AND tags.value='bump')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'traffic_calming' AND tags.value='table')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'traffic_calming' AND tags.value='chicane')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'traffic_calming' AND tags.value='cushion')" > "calming.sql"
