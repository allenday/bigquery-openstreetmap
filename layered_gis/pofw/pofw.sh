#!/bin/sh

LAYER=( 
        "3100:religion=christian"
        "3200:religion=jewish"
        "3300:religion=muslim"
        "3400:religion=buddhist"
        "3500:religion=hindu"
        "3600:religion=taoist"
        "3700:religion=shinto"
        "3800:religion=sikh"
)

for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'pofw' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

LAYER=( 
        "3101:denomination=anglican"
        "3102:denomination=catholic"
        "3103:denomination=evangelical"
        "3104:denomination=lutheran"
        "3105:denomination=methodist"
        "3106:denomination=orthodox"
        "3107:denomination=protestant"
        "3108:denomination=baptist"
        "3109:denomination=mormon"
)

for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'pofw' AS layer_class, 'christian_$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='christian')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "christian_$V.sql"
done

#3301
echo "SELECT
  3301 AS layer_code, 'pofw' AS layer_class, 'muslim_sunni' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='muslim')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='sunni')" > "muslim_sunni.sql"
#3302
echo "SELECT
  3302 AS layer_code, 'pofw' AS layer_class, 'muslim_shia' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='muslim')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='shia')" > "muslim_shia.sql"
