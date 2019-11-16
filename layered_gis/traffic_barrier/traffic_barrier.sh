#!/bin/sh

LAYER=( 
        "5211:barrier=gate"
        "5212:barrier=bollard"
        "5213:barrier=lift_gate"
        "5216:barrier=fence"
        "5218:barrier=block"
        "5219:barrier=kissing_gate"
        "5220:barrier=cattle_grid"
)

for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'traffic' AS layer_class, 'barrier_$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "barrier_$V.sql"
done

#5210
echo "SELECT
  5210 AS layer_code, 'traffic' AS layer_class, 'barrier' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='gate')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='bollard')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='lift_gate')
    AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='stile')
    AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'highway' AND tags.value='stile')
    AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='cycle_barrier')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='fence')
    AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='toll_booth')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='block')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='kissing_gate')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='cattle_grid')" > "barrier.sql"

#5214
echo "SELECT
  5214 AS layer_code, 'barrier' AS layer_class, 'stile' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key IN ('barrier','highway') AND tags.value='stile')" > "stile.sql"
#5215
echo "SELECT
  5217 AS layer_code, 'barrier' AS layer_class, 'cycle' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='cycle_barrier')" > "cycle.sql"
#5217
echo "SELECT
  5217 AS layer_code, 'barrier' AS layer_class, 'toll' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='toll_booth')" > "toll.sql"
