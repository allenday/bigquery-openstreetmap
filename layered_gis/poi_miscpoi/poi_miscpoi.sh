#!/bin/sh

LAYER=( 
        "2902:amenity=bench"
        "2903:amenity=drinking_water"
        "2904:amenity=fountain"
        "2905:amenity=hunting_stand"
        "2906:amenity=waste_basket"
        "2952:man_made=water_tower"
        "2954:man_made=windmill"
        "2955:man_made=lighthouse"
        "2961:man_made=wastewater_plant"
        "2962:man_made=water_well"
        "2964:man_made=water_works"
)




for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'poi_miscpoi' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#2901
echo "SELECT
  2901 AS layer_code, 'poi_miscpoi' AS layer_class, 'toilet' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='toilets')" > "toilet.sql"

#2907
echo "SELECT
  2907 AS layer_code, 'poi_miscpoi' AS layer_class, 'camera_surveillance' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='surveillance')" > "camera_surveillance.sql"

#2921
echo "SELECT
  2921 AS layer_code, 'poi_miscpoi' AS layer_class, 'emergency_phone' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE ((tags.key = 'amenity' AND tags.value='emergency_phone') OR (tags.key='emergency' AND tags.value='phone')))" > "emergency_phone.sql"

#2922
echo "SELECT
  2922 AS layer_code, 'poi_miscpoi' AS layer_class, 'fire_hydrant' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE ((tags.key = 'amenity' AND tags.value='fire_hydrant') OR (tags.key='emergency' AND tags.value='fire_hydrant')))" > "fire_hydrant.sql"

#2923
echo "SELECT
  2923 AS layer_code, 'poi_miscpoi' AS layer_class, 'emergency_access' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'highway' AND tags.value='emergency_access_point')" > "emergency_access.sql"

#2950
echo "SELECT
  2950 AS layer_code, 'poi_miscpoi' AS layer_class, 'tower' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='tower')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tower:type' AND tags.value='communication') --2951
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='water_tower')     --2952
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tower:type' AND tags.value='observation')   --2953" > "tower.sql"

#2951
echo "SELECT
  2951 AS layer_code, 'poi_miscpoi' AS layer_class, 'tower_comms' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='tower')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tower:type' AND tags.value='communication')" > "tower_comms.sql"

#2953
echo "SELECT
  2953 AS layer_code, 'poi_miscpoi' AS layer_class, 'tower_observation' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='tower')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tower:type' AND tags.value='observation')" > "tower_observation.sql"

#2963
echo "SELECT
  2963 AS layer_code, 'poi_miscpoi' AS layer_class, 'water_mill' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='watermill')" > "water_mill.sql"
