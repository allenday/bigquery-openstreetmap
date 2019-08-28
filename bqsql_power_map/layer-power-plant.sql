SELECT
  osm_id,osm_way_id,osm_version,osm_timestamp,all_tags,geometry
FROM `openstreetmap-public-data-dev.osm_planet.multipolygons`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'power' AND tags.value='plant');
