#!/bin/sh

LAYER=( 
        "2401:tourism=hotel"
        "2402:tourism=motel"
        "2403:tourism=bed_and_breakfast"
        "2405:tourism=hostel"
        "2406:tourism=chalet"
        "2421:amenity=shelter"
        "2422:tourism=camp_site"
        "2423:tourism=alpine_hut"
        "2424:tourism=caravan_site"
)



for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'poi_accommodation' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#2404
echo "SELECT
  2404 AS layer_code, 'poi_accommodation' AS layer_class, 'guesthouse' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='guest_house')" > "guest_house.sql"
