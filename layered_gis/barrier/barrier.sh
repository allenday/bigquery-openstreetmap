#!/bin/sh

LAYER=( 
        "5511:barrier=hedge"
        "5512:barrier=tree_row"
        "5521:barrier=wall"
        "5531:man_made=dyke"
)



for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'barrier' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#5501
#barrier=fence, wood_fence, wire_fence
echo "SELECT
  5501 AS layer_code, 'barrier' AS layer_class, 'fence' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'barrier' AND tags.value='fence') OR (tags.key = 'barrier' AND tags.value='wood_fence') OR (tags.key = 'barrier' AND tags.value='wire_fence'))" > "fence.sql"
