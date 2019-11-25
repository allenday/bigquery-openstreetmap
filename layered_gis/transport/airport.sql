SELECT
  5621 AS layer_code, 'transport' AS layer_class, 'airport' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-dev.osm_planet.features`
WHERE NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'type' AND tags.value='airstrip'))
   AND (
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='airport')
      OR
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'aeroway' AND tags.value='aerodrome')
      )
