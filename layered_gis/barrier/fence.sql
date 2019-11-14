SELECT
  5501 AS layer_code, 'barrier' AS layer_class, 'fence' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'barrier' AND tags.value='fence') OR (tags.key = 'barrier' AND tags.value='wood_fence') OR (tags.key = 'barrier' AND tags.value='wire_fence'))
