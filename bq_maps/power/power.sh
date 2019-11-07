#!/bin/sh

echo "SELECT
  6204 AS layer_code, 'power' AS layer_class, 'pole' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'power' AND tags.value='pole')" > "power-pole.sql"

echo "SELECT
  6410 AS layer_code, 'power' AS layer_class, 'station' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'power' AND tags.value='generator')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE
       (  tags.key = 'generator:source' AND tags.value = 'nuclear' ) --6411
    OR ( (tags.key = 'generator:source' AND tags.value = 'solar') OR (tags.key = 'power_source' AND tags.value = 'photovoltaic') ) --6412
    OR (  tags.key = 'generator:source' AND tags.value IN ('gas','coal')  ) -- 6413
    OR ( (tags.key = 'generator:source' AND tags.value = 'hydro') OR (tags.key = 'power_source' AND tags.value = 'hydro') ) --6414
    OR ( (tags.key = 'generator:source' AND tags.value = 'wind') OR (tags.key = 'power_source' AND tags.value = 'wind') ) --6415
    OR ( (tags.key = 'power' AND tags.value = 'station') OR (tags.key = 'power' AND tags.value = 'sub_station') ) --6422
    OR (  tags.key = 'power' AND tags.value = 'transformer' ) --6423
  )" > "power-station.sql"

echo "SELECT
  6413 AS layer_code, 'power' AS layer_class, 'station_fossil' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'generator:source' AND tags.value IN ('gas','coal'))" > "power-station_fossil.sql"

echo "SELECT
  6411 AS layer_code, 'power' AS layer_class, 'station_nuclear' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'power' AND tags.value='generator')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'generator:source' AND tags.value='nuclear')" > "power-station_nuclear.sql"

echo "SELECT
  6412 AS layer_code, 'power' AS layer_class, 'station_solar' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'generator:source' AND tags.value = 'solar') OR (tags.key = 'power_source' AND tags.value = 'photovoltaic'))" > "power-station_solar.sql"

echo "SELECT
  6414 AS layer_code, 'power' AS layer_class, 'station_water' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'generator:source' AND tags.value = 'hydro') OR (tags.key = 'power_source' AND tags.value = 'hydro'))" > "power-station_water.sql"

echo "SELECT
  6415 AS layer_code, 'power' AS layer_class, 'station_wind' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'generator:source' AND tags.value = 'wind') OR (tags.key = 'power_source' AND tags.value = 'wind'))" > "power-station_wind.sql"

echo "SELECT
  6422 AS layer_code, 'power' AS layer_class, 'substation' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'power' AND tags.value='station')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'power' AND tags.value='sub_station')" > "power-substation.sql"

echo "SELECT
  6401 AS layer_code, 'power' AS layer_class, 'tower' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'power' AND tags.value='tower')" > "power-tower.sql"

echo "SELECT
  6423 AS layer_code, 'power' AS layer_class, 'transformer' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'power' AND tags.value='transformer')" > "power-transformer.sql"
