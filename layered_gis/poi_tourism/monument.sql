
WITH osm AS (
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.nodes`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, CAST(id AS STRING) AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.ways`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.relations`
)
SELECT 2723 AS layer_code, 'poi_tourism' AS layer_class, 'monument' AS layer_name, f.feature_type AS gdal_type, f.osm_id, f.osm_way_id, f.osm_timestamp, osm.all_tags, f.geometry
FROM `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE osm.id = f.osm_id
AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'historic' AND tags.value='monument')

UNION ALL

SELECT 2723 AS layer_code, 'poi_tourism' AS layer_class, 'monument' AS layer_name, f.feature_type AS gdal_type, f.osm_id, f.osm_way_id, f.osm_timestamp, osm.all_tags, f.geometry
FROM `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE osm.way_id = f.osm_way_id
AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'historic' AND tags.value='monument')

