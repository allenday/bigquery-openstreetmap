SELECT
  2922 AS layer_code, 'poi_miscpoi' AS layer_class, 'fire_hydrant' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE ((tags.key = 'amenity' AND tags.value='fire_hydrant') OR (tags.key='emergency' AND tags.value='fire_hydrant')))
