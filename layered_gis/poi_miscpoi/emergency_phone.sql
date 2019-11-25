SELECT
  2921 AS layer_code, 'poi_miscpoi' AS layer_class, 'emergency_phone' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-dev.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE ((tags.key = 'amenity' AND tags.value='emergency_phone') OR (tags.key='emergency' AND tags.value='phone')))
