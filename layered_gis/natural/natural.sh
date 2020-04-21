#!/bin/sh

CLASS=natural
LAYER=( 
        "4101:natural=spring"
        "4102:natural=glacier"
        "4111:natural=peak"
        "4112:natural=cliff"
        "4113:natural=volcano"
        "4121:natural=tree"
        "4131:natural=mine>mine-natural"
        "4131:historic=mine>mine-historic"
        "4131:landuse=mine>mine-landuse"
        "4131:survey_point=mine>mine-survey_point"
        "4131:industrial=mine>mine-industrial"
        "4132:natural=cave_entrance"
        "4141:natural=beach"
        "8300:natural=coastline"
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
