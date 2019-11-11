SELECT
  3400 AS layer_code, 'pofw' AS layer_class, 'buddhist' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'religion' AND tags.value='buddhist')
