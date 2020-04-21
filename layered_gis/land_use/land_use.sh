#!/bin/sh

CLASS=land_use
LAYER=( 
        "7201:landuse=forest>forest-landuse"
        "7201:natural=wood>forest-natural"
        "7202:leisure=park>park-park"
        "7202:leisure=common>park-common"
        "7203:landuse=residential"
        "7204:landuse=industrial"
        "7206:landuse=cemetery"
        "7207:landuse=allotments"
        "7208:landuse=meadow"
        "7209:landuse=commercial"
        "7210:leisure=nature_reserve"
        "7211:leisure=recreation_ground>recreation_ground-leisure"
        "7211:landuse=recreation_ground>recreation_ground-landuse"
        "7212:landuse=retail"
        "7213:landuse=military"
        "7214:landuse=quarry"
        "7215:landuse=orchard"
        "7216:landuse=vineyard"
        "7217:landuse=scrub"
        "7218:landuse=grass"
        "7219:landuse=heath"
        "7220:boundary=national_park"
        "7221:landuse=basin"
        "7222:landuse=village_green"
        "7223:landuse=plant_nursery"
        "7224:landuse=brownfield"
        "7225:landuse=greenfield"
        "7226:landuse=construction"
        "7227:landuse=railway"
        "7228:landuse=farmland"
        "7229:landuse=farmyard"

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
