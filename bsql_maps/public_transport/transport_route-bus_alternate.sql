SELECT
    'route-bus-alternate' AS name, *
FROM `openstreetmap-public-data-dev.osm_planet.multilinestrings`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'route' AND tags.value='bus')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'state' AND tags.value='alternate')
