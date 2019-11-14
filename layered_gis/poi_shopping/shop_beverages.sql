SELECT
  2518 AS layer_code, 'poi_shopping' AS layer_class, 'beverages' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'shop' AND tags.value='alcohol') OR (tags.key = 'shop' AND tags.value='beverages'))
