#!/bin/sh

CLASS=poi_destination
LAYER=(
        "2721:tourism=attraction"
        "2722:tourism=museum"
        "2723:historic=monument"
        "2724:historic=memorial"
        "2725:tourism=artwork"
        "2731:historic=castle"
        "2732:historic=ruins"
        "2733:historic=archaeological_site"
        "2734:historic=wayside_cross"
        "2735:historic=wayside_shrine"
        "2736:historic=battlefield"
        "2737:historic=fort"
        "2741:tourism=picnic_site"
        "2742:tourism=viewpoint"
        "2743:tourism=zoo"
        "2744:tourism=theme_park"
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
