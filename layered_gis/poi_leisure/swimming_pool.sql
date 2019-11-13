SELECT
  2253 AS layer_code, 'poi_leisure' AS layer_class, 'swimming_pool' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='swimming_pool')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='swimming_pool')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'sport' AND tags.value='swimming')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='water_park')
