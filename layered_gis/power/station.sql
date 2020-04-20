
WITH osm AS (
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.nodes`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, CAST(id AS STRING) AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.ways`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM `openstreetmap-public-data-dev.osm_planet.relations`
)
SELECT
  6410 AS layer_code, 'power' AS layer_class, 'station' AS layer_name, f.feature_type AS gdal_type, f.osm_id, f.osm_way_id, f.osm_timestamp, osm.all_tags, f.geometry
FROM
  `openstreetmap-public-data-dev.osm_planet.features` AS f, osm
WHERE EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'power' AND tags.value='generator')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE
       (  tags.key = 'generator:source' AND tags.value = 'nuclear' ) 
    OR ( (tags.key = 'generator:source' AND tags.value = 'solar') OR (tags.key = 'power_source' AND tags.value = 'photovoltaic') ) 
    OR (  tags.key = 'generator:source' AND tags.value IN ('gas','coal','oil','diesel')  ) 
    OR ( (tags.key = 'generator:source' AND tags.value = 'hydro') OR (tags.key = 'power_source' AND tags.value = 'hydro') ) 
    OR ( (tags.key = 'generator:source' AND tags.value = 'wind') OR (tags.key = 'power_source' AND tags.value = 'wind') ) 
    OR ( (tags.key = 'power' AND tags.value = 'station') OR (tags.key = 'power' AND tags.value = 'sub_station') ) 
    OR (  tags.key = 'power' AND tags.value = 'transformer' ) 
  )
  AND COALESCE(osm.id,osm.way_id) = COALESCE(f.osm_id,f.osm_way_id)

