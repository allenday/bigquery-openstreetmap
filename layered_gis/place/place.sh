#!/bin/sh

LAYER=(
        "1001:place=city"
        "1002:place=town"
        "1003:place=village"
        "1004:place=hamlet"
        "1010:place=suburb"
        "1020:place=island"
        "1030:place=farm"
        "1040:place=region"
        "1041:place=county"
        "1050:place=locality"
)


for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'place' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#1005
echo "SELECT
  1005 AS layer_code, 'place' AS layer_class, 'national_capital' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE (
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'is_capital' AND tags.value='country')
   )
   OR
   (
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'admin_level' AND tags.value = '2')
   )
   OR (
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'capital' AND tags.value='yes') AND
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'admin_level')
   )" > "national_capital.sql"

#1031
echo "SELECT
  1031 AS layer_code, 'place' AS layer_class, 'dwelling' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='isolated_dwelling')" > "dwelling.sql"


#1099
echo "SELECT
  1099 AS layer_code, 'place' AS layer_class, 'named_place' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'area' AND tags.value='yes')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='town')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='village')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='hamlet')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='suburb')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='island')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='farm')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='isolated_dwelling')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='region')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='county')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='locality')
AND (
  (
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'is_capital' AND tags.value='country')
   )
   OR
   (
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'admin_level' AND tags.value = '2')
   )
   OR (
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'capital' AND tags.value='yes') AND
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'admin_level')
   )
)" > "named_place.sql"
