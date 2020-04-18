#!/bin/sh

CLASS=boundary
LAYER=(
        "1101:admin_level=1>admin_level1"
        "1102:admin_level=2>national"
        "1103:admin_level=3>admin_level3"
        "1104:admin_level=4>admin_level4"
        "1105:admin_level=5>admin_level5"
        "1106:admin_level=6>admin_level6"
        "1107:admin_level=7>admin_level7"
        "1108:admin_level=8>admin_level8"
        "1109:admin_level=9>admin_level9"
        "1110:admin_level=10>admin_level10"
        "1111:admin_level=11>admin_level11"
)


for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KVF="${layer##*:}"
  K="${KVF%%=*}"
  VF="${KVF##*=}"
  V="${VF%%>*}"
  F="${VF##*>}"
  N="${F%%-*}"

#  CODE="${layer%%:*}"
#  KV="${layer##*:}"
#  T="${layer#*:}"
#  C="${T%%:*}"
#  KV="${T##*:}"
#  K="${KV%%=*}"
#  V="${KV##*=}"

  echo "
WITH osm AS (
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.nodes\`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, CAST(id AS STRING) AS way_id, all_tags FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.ways\`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.relations\`
)
SELECT
  $CODE AS layer_code, '$CLASS' AS layer_class, '$N' AS layer_name, f.feature_type AS gdal_type, f.osm_id, f.osm_way_id, f.osm_timestamp, osm.all_tags, f.geometry
FROM
  \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.features\` AS f, osm
WHERE EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V') AND osm.id = f.osm_id
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'boundary' AND tags.value='administrative')
UNION ALL
SELECT
  $CODE AS layer_code, '$CLASS' AS layer_class, '$N' AS layer_name, f.feature_type AS gdal_type, f.osm_id, f.osm_way_id, f.osm_timestamp, osm.all_tags, f.geometry
FROM
  \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.features\` AS f, osm
WHERE EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V') AND osm.way_id = f.osm_way_id
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'boundary' AND tags.value='administrative')
" > "$F.sql"
done
