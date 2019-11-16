#!/bin/sh

LAYER=(
        "2721:tourism=attraction"
        "2722:tourism=museum"
        "2723:historic=monument"
        "2724:historic=memorial"
        "2725:tourism=artwork"
        "2731:historic=castle"
        "2732:historic=ruins"
        "2733:historic=archaeological_site"
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
  $CODE AS layer_code, 'poi_destination' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

