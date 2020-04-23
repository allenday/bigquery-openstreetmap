
WITH osm AS (
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.nodes`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, CAST(id AS STRING) AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.ways`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.relations`
)
SELECT 1102 AS layer_code, 'boundary' AS layer_class, 'national' AS layer_name, f.feature_type AS gdal_type, f.osm_id, f.osm_way_id, f.osm_timestamp, osm.all_tags, f.geometry
FROM `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE osm.id = f.osm_id
AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'admin_level' AND tags.value='2')
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'boundary' AND tags.value='administrative')

UNION ALL

SELECT 1102 AS layer_code, 'boundary' AS layer_class, 'national' AS layer_name, f.feature_type AS gdal_type, f.osm_id, f.osm_way_id, f.osm_timestamp, osm.all_tags, f.geometry
FROM `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE osm.way_id = f.osm_way_id
AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'admin_level' AND tags.value='2')
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'boundary' AND tags.value='administrative')

