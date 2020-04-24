
WITH osm AS (
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.nodes`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, CAST(id AS STRING) AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.ways`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.relations`
)
SELECT 5210 AS layer_code, 'traffic' AS layer_class, 'barrier' AS layer_name, f.feature_type AS gdal_type,
CASE WHEN f.osm_id= THEN NULL ELSE f.osm_id END AS osm_id,
CASE WHEN f.osm_way_id= THEN NULL ELSE f.osm_way_id END AS osm_way_id,
f.osm_timestamp, osm.all_tags, f.geometry
FROM `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE osm.id = f.osm_id

  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='gate')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='bollard')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='lift_gate')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='stile')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'highway' AND tags.value='stile')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='cycle_barrier')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='fence')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='toll_booth')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='block')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='kissing_gate')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='cattle_grid')

UNION ALL

SELECT 5210 AS layer_code, 'traffic' AS layer_class, 'barrier' AS layer_name, f.feature_type AS gdal_type,
CASE WHEN f.osm_id= THEN NULL ELSE f.osm_id END AS osm_id,
CASE WHEN f.osm_way_id= THEN NULL ELSE f.osm_way_id END AS osm_way_id,
f.osm_timestamp, osm.all_tags, f.geometry
FROM `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE osm.way_id = f.osm_way_id

  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='gate')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='bollard')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='lift_gate')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='stile')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'highway' AND tags.value='stile')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='cycle_barrier')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='fence')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='toll_booth')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='block')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='kissing_gate')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'barrier' AND tags.value='cattle_grid')

