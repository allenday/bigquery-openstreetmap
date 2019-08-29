SELECT *
FROM `openstreetmap-public-data-dev.osm_planet.lines`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'natural' AND tags.value='coastline');
