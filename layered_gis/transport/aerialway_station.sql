SELECT
  5621 AS layer_code, 'transport' AS layer_class, 'aerialway_station' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'aerialway' AND tags.value='station'))
