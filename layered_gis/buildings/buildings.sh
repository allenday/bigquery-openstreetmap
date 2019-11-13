#!/bin/sh

#TODO is it correct to use layer_name as 'buildings'? in the spec it specifies blank (null?)
echo "SELECT
    1500 AS layer_code, 'buildings' AS layer_class, 'buildings' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'building')" > "buildings.sql"
