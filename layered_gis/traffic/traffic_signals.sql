SELECT
  5201 AS layer_code, 'traffic' AS layer_class, 'traffic_signals' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-dev.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'highway' AND tags.value='traffic_signals')
