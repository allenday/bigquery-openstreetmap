#!/bin/sh

for LAYER in supermarket bakery kiosk mall department_store convenience clothes florist chemist \
    books butcher shoes alcohol beverages optician jewelry gift sports stationery outdoor \
    mobile_phone toys newsagent greengrocer beauty video car bicycle doityourself hardware \
    furniture computer garden_centre hairdresser car_repair travel_agency laundry dry_cleaning
do
    echo "SELECT
  osm_id,NULL AS osm_way_id,osm_version,osm_timestamp,all_tags,geometry
FROM \`openstreetmap-public-data-dev.osm_planet.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'shop' AND tags.value='${LAYER}')
UNION ALL
SELECT
  osm_id,osm_way_id,osm_version,osm_timestamp,all_tags,geometry
FROM \`openstreetmap-public-data-dev.osm_planet.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'shop' AND tags.value='${LAYER}')
UNION ALL
SELECT
  osm_id,NULL AS osm_way_id,osm_version,osm_timestamp,all_tags,geometry
FROM \`openstreetmap-public-data-dev.osm_planet.other_relations\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'shop' AND tags.value='${LAYER}');
" > "layer-shops-${LAYER}.sql"
done
