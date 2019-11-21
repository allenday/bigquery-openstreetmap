SELECT
  7211 AS layer_code, 'land_use' AS layer_class, 'recreation_ground' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry 
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'leisure' AND tags.value='recreation_ground') OR (tags.key = 'landuse' AND tags.value='recreation_ground'))
