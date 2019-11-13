#!/bin/sh

LAYER=( 
        "5622:amenity=bus_station"
        "5641:amenity=taxi"
        "5655:aeroway=helipad"
        "5656:aeroway=apron"
        "5661:amenity=ferry_terminal"
)



for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'landuse' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#5621
#highway=bus_stop, or public_transport=stop_position + bus=yes
echo "SELECT
  5621 AS layer_code, 'transport' AS layer_class, 'bus_stop' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'highway' AND tags.value='bus_stop'))
   OR (
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'public_transport' AND tags.value='stop_position')
      AND
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'bus' AND tags.value='yes')
      )" > "bus_stop.sql"

#5651
#amenity=airport or aeroway=aerodrome unless type=airstrip
echo "SELECT
  5621 AS layer_code, 'transport' AS layer_class, 'airport' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'type' AND tags.value='airstrip'))
   AND (
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='airport')
      OR
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'aeroway' AND tags.value='aerodrome')
      )" > "airport.sql"

#5652
#aeroway=airfield, military=airfield, aeroway=aeroway with type=airstrip
echo "SELECT
  5621 AS layer_code, 'transport' AS layer_class, 'airfield' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'aeroway' AND tags.value='airfield'))
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'military' AND tags.value='airfield'))
   OR (
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'aeroway' AND tags.value='aeroway')
      AND
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'type' AND tags.value='airstrip')
      )" > "airfield.sql"

#5671
echo "SELECT
  5621 AS layer_code, 'transport' AS layer_class, 'aerialway_station' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'aerialway' AND tags.value='station'))" > "aerialway_station.sql"
