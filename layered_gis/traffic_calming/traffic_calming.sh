#!/bin/sh

CLASS=traffic
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
  KVF="${layer##*:}"
  K="${KVF%%=*}"
  VF="${KVF##*=}"
  V="${VF%%>*}"
  F="${VF##*>}"
  N="${F%%-*}"
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
WHERE COALESCE(osm.id,osm.way_id) = COALESCE(f.osm_id,f.osm_way_id)
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')
" > "$F.sql"
done

#5230
CODE=5230
N=calming
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
WHERE COALESCE(osm.id,osm.way_id) = COALESCE(f.osm_id,f.osm_way_id)
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'traffic_calming')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'traffic_calming' AND tags.value='hump')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'traffic_calming' AND tags.value='bump')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'traffic_calming' AND tags.value='table')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'traffic_calming' AND tags.value='chicane')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'traffic_calming' AND tags.value='cushion')
" > "$N.sql"
