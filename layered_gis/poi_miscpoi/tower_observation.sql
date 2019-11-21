SELECT
  2953 AS layer_code, 'poi_miscpoi' AS layer_class, 'tower_observation' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='tower')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tower:type' AND tags.value='observation')
