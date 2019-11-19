SELECT 
  COALESCE(osm_id,osm_way_id) AS osm_id, osm_version, osm_timestamp, all_tags, geometry, 'land_use-commercial' AS layer, 7209 AS layer_code, 'land_use' AS layer_class, 'commercial' AS layer_name, feature_type AS gdal_type, `openstreetmap-public-data-prod.osm_planet.layer_partition`('land_use-commercial') AS layer_partition
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'landuse' AND tags.value='commercial')
