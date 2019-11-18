SELECT
  9102 AS layer_code, 'cycle_route_segment' AS layer_class, 'regional_cycle_network' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'rcn' AND tags.value='yes')
