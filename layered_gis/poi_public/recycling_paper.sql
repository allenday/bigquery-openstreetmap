SELECT
  2032 AS layer_code, 'poi_public' AS layer_class, 'recycling_paper' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:paper' AND tags.value='yes')
