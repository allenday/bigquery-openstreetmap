SELECT
  5261 AS layer_code, 'traffic' AS layer_class, 'parking_site' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='parking')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'parking' AND tags.value='surface')
