SELECT
  6702 AS layer_code, 'aeroway' AS layer_class, 'taxiway' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'aeroway' AND tags.value='taxiway')
