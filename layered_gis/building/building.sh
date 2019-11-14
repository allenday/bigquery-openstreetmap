#!/bin/sh

echo "SELECT
    1500 AS layer_code, 'building' AS layer_class, 'building' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'building')" > "building.sql"
