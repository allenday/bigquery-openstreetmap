#!/bin/sh

echo "SELECT
  9102 AS layer_code, 'cycle_route_segment' AS layer_class, 'regional_cycle_network' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'rcn' AND tags.value='yes')" > "regional_cycle_network.sql"

echo "SELECT
  9102 AS layer_code, 'cycle_route_segment' AS layer_class, 'local_cycle_network' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'lcn' AND tags.value='yes')" > "local_cycle_network.sql"
