SELECT
  5651 AS layer_code, 'transport' AS layer_class, 'airport' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'type' AND tags.value='airstrip'))
   AND (
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='airport')
      OR
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'aeroway' AND tags.value='aerodrome')
      )
