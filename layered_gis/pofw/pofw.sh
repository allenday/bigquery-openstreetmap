#!/bin/sh

CLASS=pofw
LAYER=( 
        "3100:religion=christian"
        "3200:religion=jewish"
        "3300:religion=muslim"
        "3400:religion=buddhist"
        "3500:religion=hindu"
        "3600:religion=taoist"
        "3700:religion=shinto"
        "3800:religion=sikh"
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
WHERE EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')
  AND COALESCE(osm.id,osm.way_id) = COALESCE(f.osm_id,f.osm_way_id)
" > "$F.sql"
done

LAYER=(
        "3101:denomination=anglican>christian_anglican"
        "3102:denomination=catholic>christian_catholic"
        "3103:denomination=evangelical>christian_evangelical"
        "3104:denomination=lutheran>christian_lutheran"
        "3105:denomination=methodist>christian_methodist"
        "3106:denomination=orthodox>christian_orthodox"
        "3107:denomination=protestant>christian_protestant"
        "3108:denomination=baptist>christian_baptist"
        "3109:denomination=mormon>christian_mormon"
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
WHERE EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V') AND osm.id = f.osm_id
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'religion' AND tags.value='christian')
  AND COALESCE(osm.id,osm.way_id) = COALESCE(f.osm_id,f.osm_way_id)
" > "$F.sql"
done

LAYER=(
        "3301:denomination=sunni>muslim_sunni"
        "3302:denomination=shia>muslim_shia"
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
WHERE EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V') AND osm.id = f.osm_id
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'religion' AND tags.value='muslim')
  AND COALESCE(osm.id,osm.way_id) = COALESCE(f.osm_id,f.osm_way_id)
" > "$F.sql"
done
