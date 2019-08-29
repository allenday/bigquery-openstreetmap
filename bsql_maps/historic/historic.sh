#!/bin/sh

for LAYER in monument memorial castle ruins archaeological_site wayside_criss wayside_shrine \
    battlefield fort
do
    echo "SELECT
  *
FROM \`openstreetmap-public-data-dev.osm_planet.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='${LAYER}')
UNION ALL
SELECT
  *
FROM \`openstreetmap-public-data-dev.osm_planet.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='${LAYER}')
UNION ALL
SELECT
  *
FROM \`openstreetmap-public-data-dev.osm_planet.other_relations\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='${LAYER}')
" > "historic-${LAYER}.sql"
done
