#!/bin/sh

LAYER=(
        "1101:admin_level1:admin_level=1"
        "1102:national:admin_level=2"
        "1103:admin_level3:admin_level=3"
        "1104:admin_level4:admin_level=4"
        "1105:admin_level5:admin_level=5"
        "1106:admin_level6:admin_level=6"
        "1107:admin_level7:admin_level=7"
        "1108:admin_level8:admin_level=8"
        "1109:admin_level9:admin_level=9"
        "1110:admin_level10:admin_level=10"
        "1111:admin_level11:admin_level=11"
)


for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  T="${layer#*:}"
  C="${T%%:*}"
  KV="${T##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"

  echo "SELECT
  $CODE AS layer_code, 'boundary' AS layer_class, '$C' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'boundary' AND tags.value='administrative')
AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$C.sql"
done
