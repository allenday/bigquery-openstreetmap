
WITH osm AS (
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.nodes`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, CAST(id AS STRING) AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.ways`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.relations`
)
SELECT 2030 AS layer_code, 'poi_public' AS layer_class, 'recycling' AS layer_name, f.feature_type AS gdal_type,
CASE WHEN f.osm_id= THEN NULL ELSE f.osm_id END AS osm_id,
CASE WHEN f.osm_way_id= THEN NULL ELSE f.osm_way_id END AS osm_way_id,
f.osm_timestamp, osm.all_tags, f.geometry
FROM `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE osm.id = f.osm_id

  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'amenity' AND tags.value='recycling')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'recycling:glass' AND tags.value='yes')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'recycling:paper' AND tags.value='yes')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'recycling:clothes' AND tags.value='yes')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'recycling:scrap_metal' AND tags.value='yes')


UNION ALL

SELECT 2030 AS layer_code, 'poi_public' AS layer_class, 'recycling' AS layer_name, f.feature_type AS gdal_type,
CASE WHEN f.osm_id= THEN NULL ELSE f.osm_id END AS osm_id,
CASE WHEN f.osm_way_id= THEN NULL ELSE f.osm_way_id END AS osm_way_id,
f.osm_timestamp, osm.all_tags, f.geometry
FROM `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE osm.way_id = f.osm_way_id

  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'amenity' AND tags.value='recycling')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'recycling:glass' AND tags.value='yes')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'recycling:paper' AND tags.value='yes')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'recycling:clothes' AND tags.value='yes')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) AS tags WHERE tags.key = 'recycling:scrap_metal' AND tags.value='yes')


