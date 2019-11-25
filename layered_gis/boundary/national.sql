SELECT
  1102 AS layer_code, 'boundary' AS layer_class, 'national' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-dev.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'boundary' AND tags.value='administrative')
AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'admin_level' AND tags.value='2')
