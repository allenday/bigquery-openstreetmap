SELECT
  2403 AS layer_code, 'poi_accommodation' AS layer_class, 'bed_and_breakfast' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='bed_and_breakfast')
