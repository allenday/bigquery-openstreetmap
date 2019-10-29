SELECT
  'tourism-hostel' AS name, *
FROM `openstreetmap-public-data-dev.osm_planet.points`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='hostel')
UNION ALL
SELECT
  'tourism-hostel' AS name, *
FROM `openstreetmap-public-data-dev.osm_planet.multipolygons`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='hostel')
UNION ALL
SELECT
  'tourism-hostel' AS name, *
FROM `openstreetmap-public-data-dev.osm_planet.other_relations`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='hostel')

