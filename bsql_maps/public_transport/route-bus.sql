SELECT
    'route-bus' AS name, *
FROM `openstreetmap-public-data-dev.osm_planet.multilinestrings`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'route' AND tags.value='bus')
  AND (NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'state') OR 
    EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'state' AND tags.value='alternate'))
