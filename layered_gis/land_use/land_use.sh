#!/bin/sh

LAYER=( 
        "7203:landuse=residential"
        "7204:landuse=industrial"
        "7206:landuse=cemetery"
        "7207:landuse=allotments"
        "7208:landuse=meadow"
        "7209:landuse=commercial"
        "7210:leisure=nature_reserve"
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
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'land_use' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry 
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#7201
echo "SELECT
  7201 AS layer_code, 'land_use' AS layer_class, 'forest' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry 
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'landuse' AND tags.value='forest') OR (tags.key = 'natural' AND tags.value='wood'))" > "forest.sql"

#7202
echo "SELECT
  7202 AS layer_code, 'land_use' AS layer_class, 'park' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry 
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'leisure' AND tags.value='park') OR (tags.key = 'leisure' AND tags.value='common'))" > "park.sql"

#7211
echo "SELECT
  7211 AS layer_code, 'land_use' AS layer_class, 'recreation_ground' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry 
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'leisure' AND tags.value='recreation_ground') OR (tags.key = 'landuse' AND tags.value='recreation_ground'))" > "recreation_ground.sql"
