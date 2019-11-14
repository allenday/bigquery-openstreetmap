SELECT
  1031 AS layer_code, 'place' AS layer_class, 'dwelling' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='isolated_dwelling')
