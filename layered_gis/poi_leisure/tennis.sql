SELECT
  2254 AS layer_code, 'poi_leisure' AS layer_class, 'tennis_court' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-dev.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'sport' AND tags.value='tennis')
