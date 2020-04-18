
WITH osm AS (
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.nodes`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, CAST(id AS STRING) AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.ways`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.relations`
)
SELECT
  5501 AS layer_code, 'fence' AS layer_class, 'dyke' AS layer_name, f.feature_type AS gdal_type, f.osm_id, f.osm_way_id, f.osm_timestamp, osm.all_tags, f.geometry
FROM
  `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE (tags.key = 'fence' AND tags.value='fence') OR (tags.key = 'fence' AND tags.value='wood_fence') OR (tags.key = 'fence' AND tags.value='wire_fence')) AND osm.id = f.osm_id
UNION ALL
SELECT
  5501 AS layer_code, 'fence' AS layer_class, 'dyke' AS layer_name, f.feature_type AS gdal_type, f.osm_id, f.osm_way_id, f.osm_timestamp, osm.all_tags, f.geometry
FROM
  `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE (tags.key = 'fence' AND tags.value='fence') OR (tags.key = 'fence' AND tags.value='wood_fence') OR (tags.key = 'fence' AND tags.value='wire_fence')) AND osm.way_id = f.osm_way_id

