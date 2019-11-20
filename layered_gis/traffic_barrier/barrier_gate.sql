SELECT
  5211 AS layer_code, 'traffic' AS layer_class, 'barrier_gate' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='gate')
