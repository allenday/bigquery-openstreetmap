SELECT
  5235 AS layer_code, 'traffic' AS layer_class, 'calming_cushion' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'traffic_calming' AND tags.value='cushion')
