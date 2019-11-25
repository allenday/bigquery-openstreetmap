SELECT
  5621 AS layer_code, 'transport' AS layer_class, 'bus_stop' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-dev.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'highway' AND tags.value='bus_stop'))
   OR (
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'public_transport' AND tags.value='stop_position')
      AND
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'bus' AND tags.value='yes')
      )
