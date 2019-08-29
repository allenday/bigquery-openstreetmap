SELECT
  osm_id,NULL AS osm_way_id,osm_version,osm_timestamp,all_tags,geometry
FROM `openstreetmap-public-data-dev.osm_planet.points`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='wayside_shrine')
UNION ALL
SELECT
  osm_id,osm_way_id,osm_version,osm_timestamp,all_tags,geometry
FROM `openstreetmap-public-data-dev.osm_planet.multipolygons`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='wayside_shrine')
UNION ALL
SELECT
  osm_id,NULL AS osm_way_id,osm_version,osm_timestamp,all_tags,geometry
FROM `openstreetmap-public-data-dev.osm_planet.other_relations`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='wayside_shrine');

