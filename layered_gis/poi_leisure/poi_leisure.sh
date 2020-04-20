#!/bin/sh

CLASS=poi_leisure
LAYER=( 
        "2201:amenity=theatre"
        "2202:amenity=nightclub"
        "2203:amenity=cinema"
        "2204:leisure=park"
        "2205:leisure=playground"
        "2206:leisure=dog_park"
        "2251:leisure=sports_centre"
        "2252:leisure=pitch"
        "2254:sport=tennis>tennis_court"
        "2255:leisure=golf_course"
        "2256:leisure=stadium"
        "2257:leisure=ice_rink"
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


#2253
echo "SELECT
  2253 AS layer_code, 'poi_leisure' AS layer_class, 'swimming_pool' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='swimming_pool')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='swimming_pool')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'sport' AND tags.value='swimming')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='water_park')" > "swimming_pool.sql"

