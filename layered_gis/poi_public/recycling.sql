SELECT
  2030 AS layer_code, 'poi_public' AS layer_class, 'recycling' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'amenity' AND tags.value='recycling')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:glass' AND tags.value='yes')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:paper' AND tags.value='yes')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:clothes' AND tags.value='yes')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:scrap_metal' AND tags.value='yes')
