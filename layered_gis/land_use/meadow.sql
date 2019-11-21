SELECT
  7208 AS layer_code, 'land_use' AS layer_class, 'meadow' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry 
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'landuse' AND tags.value='meadow')
