SELECT
  4131 AS layer_code, 'natural' AS layer_class, 'mine' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'natural' AND tags.value='mine')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='mine')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'landuse' AND tags.value='mine')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'survey_point' AND tags.value='mine')
   OR EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'industrial' AND tags.value='mine')
