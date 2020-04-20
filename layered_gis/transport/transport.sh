#!/bin/sh

CLASS=transport
LAYER=( 
        "5621:highway=bus_stop>bus_stop-highway"
        "5622:amenity=bus_station"
        "5641:amenity=taxi"
        "5652:aeroway=airfield>airfield-aeroway"
        "5652:militaryy=airfield>airfield-military"
        "5655:aeroway=helipad"
        "5656:aeroway=apron"
        "5661:amenity=ferry_terminal"
        "5671:aerialway=station>aerialway_station"
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

CODE=5621
N=bus_stop
#highway=bus_stop, or public_transport=stop_position + bus=yes
echo "SELECT
  $CODE AS layer_code, '$CLASS' AS layer_class, '$N' AS layer_name, f.feature_type AS gdal_type, f.osm_id, f.osm_way_id, f.osm_timestamp, osm.all_tags, f.geometry
FROM
  \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.features\` AS f, osm
WHERE EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'public_transport' AND tags.value='stop_position')
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'bus' AND tags.value='yes')
  AND COALESCE(osm.id,osm.way_id) = COALESCE(f.osm_id,f.osm_way_id)
" > "bus_stop.sql"

CODE=5651
N=airport
#amenity=airport or aeroway=aerodrome unless type=airstrip
echo "SELECT
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
WHERE NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE (tags.key = 'type' AND tags.value='airstrip'))
  AND (
      EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='airport')
      OR
      EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'aeroway' AND tags.value='aerodrome')
      )
  AND COALESCE(osm.id,osm.way_id) = COALESCE(f.osm_id,f.osm_way_id)
" > "airport.sql"

CODE=5652
N=airfield
#aeroway=airfield, military=airfield, aeroway=aeroway with type=airstrip
echo "SELECT
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
WHERE EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'aeroway' AND tags.value='aeroway')
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'type' AND tags.value='airstrip')
  AND COALESCE(osm.id,osm.way_id) = COALESCE(f.osm_id,f.osm_way_id)
" > "airfield.sql"
