SELECT
  5204 AS layer_code, 'traffic' AS layer_class, 'crossing' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'highway' AND tags.value='crossing') OR (tags.key = 'railway' AND tags.value='level_crossing'))
