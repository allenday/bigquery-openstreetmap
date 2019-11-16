#!/bin/sh

LAYER=( 
        "4101:natural=spring"
        "4102:natural=glacier"
        "4111:natural=peak"
        "4112:natural=cliff"
        "4113:natural=volcano"
        "4121:natural=tree"
        "4132:natural=cave_entrance"
        "4141:natural=beach"
        "8300:natural=coastline"
)



for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'natural' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#4131 
  echo "SELECT
  4131 AS layer_code, 'natural' AS layer_class, 'mine' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'natural' AND tags.value='mine')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='mine')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'landuse' AND tags.value='mine')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'survey_point' AND tags.value='mine')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'industrial' AND tags.value='mine')" > "mine.sql"
