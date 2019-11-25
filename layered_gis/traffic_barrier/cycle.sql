SELECT
  5217 AS layer_code, 'barrier' AS layer_class, 'cycle' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-dev.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='cycle_barrier')
