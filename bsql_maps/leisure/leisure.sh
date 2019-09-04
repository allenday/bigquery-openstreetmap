#!/bin/sh

for LAYER in park playground dog_park sports_centre pitch swimming_pool water_park golf_course \
    stadium ice_rink
do
    echo "SELECT
  'leisure-${LAYER}' AS name, *
FROM \`openstreetmap-public-data-dev.osm_planet.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='${LAYER}')
UNION ALL
SELECT
  'leisure-${LAYER}' AS name, *
FROM \`openstreetmap-public-data-dev.osm_planet.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='${LAYER}')
UNION ALL
SELECT
  'leisure-${LAYER}' AS name, *
FROM \`openstreetmap-public-data-dev.osm_planet.other_relations\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='${LAYER}')
" > "leisure-${LAYER}.sql"
done
