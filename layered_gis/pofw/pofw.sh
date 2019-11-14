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
  $CODE AS layer_code, 'pofw' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#3101
echo "SELECT
  3101 AS layer_code, 'pofw' AS layer_class, 'christian_anglican' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='christian')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='anglican')" > "christian_anglican.sql"
#3102
echo "SELECT
  3102 AS layer_code, 'pofw' AS layer_class, 'christian_catholic' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='christian')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='catholic')" > "christian_catholic.sql"
#3103
echo "SELECT
  3103 AS layer_code, 'pofw' AS layer_class, 'christian_evangelical' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='christian')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='evangelical')" > "christian_evangelical.sql"
#3104
echo "SELECT
  3104 AS layer_code, 'pofw' AS layer_class, 'christian_lutheran' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='christian')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='lutheran')" > "christian_lutheran.sql"
#3105
echo "SELECT
  3105 AS layer_code, 'pofw' AS layer_class, 'christian_methodist' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='christian')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='methodist')" > "christian_methodist.sql"
#3106
echo "SELECT
  3106 AS layer_code, 'pofw' AS layer_class, 'christian_orthodox' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='christian')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='orthodox')" > "christian_orthodox.sql"
#3107
echo "SELECT
  3107 AS layer_code, 'pofw' AS layer_class, 'christian_protestant' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='christian')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='protestant')" > "christian_protestant.sql"
#3108
echo "SELECT
  3108 AS layer_code, 'pofw' AS layer_class, 'christian_baptist' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='christian')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='baptist')" > "christian_baptist.sql"
#3109
echo "SELECT
  3109 AS layer_code, 'pofw' AS layer_class, 'christian_mormon' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='christian')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='mormon')" > "christian_mormon.sql"

#3301
echo "SELECT
  3301 AS layer_code, 'pofw' AS layer_class, 'muslim_sunni' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='muslim')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='sunni')" > "muslim_sunni.sql"
#3302
echo "SELECT
  3302 AS layer_code, 'pofw' AS layer_class, 'muslim_shia' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='muslim')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'denomination' AND tags.value='shia')" > "muslim_shia.sql"
