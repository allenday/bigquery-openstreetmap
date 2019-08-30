SELECT
    *
FROM `openstreetmap-public-data-dev.osm_planet.multilinestrings`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'route' AND tags.value='aerialway')
