
WITH osm AS (
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.nodes`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, CAST(id AS STRING) AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.ways`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.relations`
)
SELECT 5621 AS layer_code, 'transport' AS layer_class, 'bus_stop' AS layer_name, f.feature_type AS gdal_type,
CASE WHEN f.osm_id= THEN NULL ELSE f.osm_id END AS osm_id,
CASE WHEN f.osm_way_id= THEN NULL ELSE f.osm_way_id END AS osm_way_id,
f.osm_timestamp, osm.all_tags, f.geometry
FROM `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE osm.id = f.osm_id

  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'public_transport' AND tags.value='stop_position')
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'bus' AND tags.value='yes')
  AND COALESCE(osm.id,osm.way_id) = COALESCE(f.osm_id,f.osm_way_id)

UNION ALL

SELECT 5621 AS layer_code, 'transport' AS layer_class, 'bus_stop' AS layer_name, f.feature_type AS gdal_type,
CASE WHEN f.osm_id= THEN NULL ELSE f.osm_id END AS osm_id,
CASE WHEN f.osm_way_id= THEN NULL ELSE f.osm_way_id END AS osm_way_id,
f.osm_timestamp, osm.all_tags, f.geometry
FROM `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE osm.way_id = f.osm_way_id

  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'public_transport' AND tags.value='stop_position')
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'bus' AND tags.value='yes')
  AND COALESCE(osm.id,osm.way_id) = COALESCE(f.osm_id,f.osm_way_id)

