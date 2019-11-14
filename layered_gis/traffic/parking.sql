SELECT
  5260 AS layer_code, 'traffic' AS layer_class, 'parking' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='parking')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'parking' AND tags.value='surface')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'parking' AND tags.value='multi-storey')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'parking' AND tags.value='underground')
