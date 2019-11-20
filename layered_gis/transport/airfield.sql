SELECT
  5652 AS layer_code, 'transport' AS layer_class, 'airfield' AS layer_name, feature_type AS gdal_type, osm_id, osm_version, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'aeroway' AND tags.value='airfield'))
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'military' AND tags.value='airfield'))
   OR (
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'aeroway' AND tags.value='aeroway')
      AND
      EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'type' AND tags.value='airstrip')
      )
