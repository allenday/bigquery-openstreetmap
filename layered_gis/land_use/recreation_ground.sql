SELECT
COALESCE(osm_id,osm_way_id) AS osm_id, osm_version, osm_timestamp, all_tags, geometry, 'land_use-recreation_ground' AS layer, 7211 AS layer_code, 'land_use' AS layer_class, 'recreation_ground' AS layer_name, feature_type AS gdal_type, `openstreetmap-public-data-prod.osm_planet.layer_partition`('land_use-recreation_ground') AS layer_partition
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'leisure' AND tags.value='recreation_ground') OR (tags.key = 'landuse' AND tags.value='recreation_ground'))
