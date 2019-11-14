SELECT
  1099 AS layer_code, 'place' AS layer_class, 'named_place' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'area' AND tags.value='yes')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='town')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='village')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='hamlet')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='suburb')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='island')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='farm')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='isolated_dwelling')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='region')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='county')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='locality')
AND (
  (
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'is_capital' AND tags.value='country')
   )
   OR
   (
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'admin_level' AND tags.value = '2')
   )
   OR (
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'place' AND tags.value='city') AND
   NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'capital' AND tags.value='yes') AND
   EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'admin_level')
   )
)
