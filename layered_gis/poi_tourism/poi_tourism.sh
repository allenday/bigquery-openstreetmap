#!/bin/sh

LAYER=( 
        "2721:tourism=attraction"
        "2722:tourism=museum"
        "2723:historic=monument"
        "2724:historic=memorial"
        "2725:tourism=artwork"
        "2731:historic=castle"
        "2732:historic=ruins"
        "2734:historic=wayside_cross"
        "2735:historic=wayside_shrine"
        "2736:historic=battlefield"
        "2737:historic=fort"
        "2741:tourism=picnic_site"
        "2742:tourism=viewpoint"
        "2743:tourism=zoo"
        "2744:tourism=theme_park"
)



for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'poi_money' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#2701
echo "SELECT
  2701 AS layer_code, 'poi_tourism' AS layer_class, 'tourist_info' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='information')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'information' AND tags.value='map')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'information' AND tags.value='board')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'information' AND tags.value='guidepost')" > "tourist_info.sql"

#2704
echo "SELECT
  2704 AS layer_code, 'poi_tourism' AS layer_class, 'tourist_map' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='information')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'information' AND tags.value='map')" > "tourist_map.sql"
#2705
echo "SELECT
  2705 AS layer_code, 'poi_tourism' AS layer_class, 'tourist_board' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='information')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'information' AND tags.value='board')" > "tourist_board.sql"
#2706
echo "SELECT
  2706 AS layer_code, 'poi_tourism' AS layer_class, 'tourist_guidepost' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='information')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'information' AND tags.value='guidepost')" > "tourist_guidepost.sql"

#2725
echo "SELECT
  2725 AS layer_code, 'poi_tourism' AS layer_class, 'art' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='artwork')" > "art.sql"
#2733
echo "SELECT
  2733 AS layer_code, 'poi_tourism' AS layer_class, 'archaeological' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='archaeological_site')" > "archaeological.sql"
