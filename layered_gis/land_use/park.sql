SELECT
  7202 AS layer_code, 'land_use' AS layer_class, 'park' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry 
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'leisure' AND tags.value='park') OR (tags.key = 'leisure' AND tags.value='common'))
