SELECT
  9102 AS layer_code, 'cycle_route_segment' AS layer_class, 'local_cycle_network' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-dev.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'lcn' AND tags.value='yes')
