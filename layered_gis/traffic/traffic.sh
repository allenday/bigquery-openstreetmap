#!/bin/sh

LAYER=( 
        "5201:highway=traffic_signals"
        "5202:highway=mini_roundabout"
        "5203:highway=stop"
        "5205:highway=ford"
        "5206:highway=motorway_junction"
        "5207:highway=turning_circle"
        "5208:highway=speed_camera"
        "5209:highway=street_lamp"
        "5250:amenity=fuel"
        "5270:amenity=bicycle_parking"
)



for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'traffic' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#5204
#highway=crossing, railway=level_crossing
echo "SELECT
  5204 AS layer_code, 'traffic' AS layer_class, 'crossing' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'highway' AND tags.value='crossing') OR (tags.key = 'railway' AND tags.value='level_crossing'))" > "crossing.sql"
#5251
echo "SELECT
  5251 AS layer_code, 'traffic' AS layer_class, 'service' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'highway' AND tags.value='services')" > "service.sql"
#5260
echo "SELECT
  5260 AS layer_code, 'traffic' AS layer_class, 'parking' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='parking')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'parking' AND tags.value='surface')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'parking' AND tags.value='multi-storey')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'parking' AND tags.value='underground')" > "parking.sql"
#5261
echo "SELECT
  5261 AS layer_code, 'traffic' AS layer_class, 'parking_site' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='parking')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'parking' AND tags.value='surface')" > "parking_site.sql"
#5262
echo "SELECT
  5262 AS layer_code, 'traffic' AS layer_class, 'parking_multistorey' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='parking')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'parking' AND tags.value='multi-storey')" > "parking_multistorey.sql"
#5263
echo "SELECT
  5263 AS layer_code, 'traffic' AS layer_class, 'parking_underground' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='parking')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'parking' AND tags.value='underground')" > "parking_underground.sql"
