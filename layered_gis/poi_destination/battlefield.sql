SELECT
  2736 AS layer_code, 'poi_destination' AS layer_class, 'battlefield' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='battlefield')
