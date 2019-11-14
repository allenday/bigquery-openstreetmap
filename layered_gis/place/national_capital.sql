SELECT
  1005 AS layer_code, 'place' AS layer_class, 'national_capital' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE (
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'is_capital' AND tags.value='country')
   )
   OR
   (
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'admin_level' AND tags.value = '2')
   )
   OR (
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'capital' AND tags.value='yes') AND
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'admin_level')
   )
