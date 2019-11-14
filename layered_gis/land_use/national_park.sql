SELECT
  7220 AS layer_code, 'land_use' AS layer_class, 'national_park' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry 
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'boundary' AND tags.value='national_park')
