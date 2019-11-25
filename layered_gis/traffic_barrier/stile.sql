SELECT
  5214 AS layer_code, 'barrier' AS layer_class, 'stile' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-dev.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key IN ('barrier','highway') AND tags.value='stile')
