#!/bin/sh

for LAYER in hotel motel bed_and_breakfast guest_house hostel chalet camp_site alpine_hut \
    caravan_site information attraction museum artwork picnic_site viewpoint zoo theme_park
do
    echo "SELECT
  osm_id,NULL AS osm_way_id,osm_version,osm_timestamp,all_tags,geometry
FROM \`openstreetmap-public-data-dev.osm_planet.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='${LAYER}')
UNION ALL
SELECT
  osm_id,osm_way_id,osm_version,osm_timestamp,all_tags,geometry
FROM \`openstreetmap-public-data-dev.osm_planet.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='${LAYER}')
UNION ALL
SELECT
  osm_id,NULL AS osm_way_id,osm_version,osm_timestamp,all_tags,geometry
FROM \`openstreetmap-public-data-dev.osm_planet.other_relations\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'tourism' AND tags.value='${LAYER}');
" > "tourism-${LAYER}.sql"
done
