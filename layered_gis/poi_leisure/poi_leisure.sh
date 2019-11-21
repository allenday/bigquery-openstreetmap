#!/bin/sh

LAYER=( 
        "2201:amenity=theatre"
        "2202:amenity=nightclub"
        "2203:amenity=cinema"
        "2204:leisure=park"
        "2205:leisure=playground"
        "2206:leisure=dog_park"
        "2251:leisure=sports_centre"
        "2252:leisure=pitch"
        "2255:leisure=golf_course"
        "2256:leisure=stadium"
        "2257:leisure=ice_rink"
)



for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'poi_leisure' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#2253
echo "SELECT
  2253 AS layer_code, 'poi_leisure' AS layer_class, 'swimming_pool' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='swimming_pool')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='swimming_pool')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'sport' AND tags.value='swimming')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='water_park')" > "swimming_pool.sql"

#2254
echo "SELECT
  2254 AS layer_code, 'poi_leisure' AS layer_class, 'tennis_court' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'sport' AND tags.value='tennis')" > "tennis.sql"
