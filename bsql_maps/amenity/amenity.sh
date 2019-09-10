#!/bin/sh

for LAYER in police fire_station post_box post_office telephone library townhall courthouse prison embassy \
    community_centre nursing_home arts_centre grave_yard market_place recycling university \
    school kindergarten college public_building pharmacy hospital doctors dentist veterinary theatre \
    nightclub cinema park playground swimming_pool restaurant fast_food cafe pub bar food_court \
    biergarten shelter car_rental car_wash car_sharing bicycle_rental vending_machine bank atm toilets \
    bench drinking_water fountain hunting_stand waste_basket emergency_phone fire_hydrant
do
    echo "SELECT
  'amenity-${LAYER}' AS name, *
FROM \`openstreetmap-public-data-dev.osm_planet.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='${LAYER}')
UNION ALL
SELECT
  'amenity-${LAYER}' AS name, *
FROM \`openstreetmap-public-data-dev.osm_planet.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='${LAYER}')
UNION ALL
SELECT
  'amenity-${LAYER}' AS name, *
FROM \`openstreetmap-public-data-dev.osm_planet.other_relations\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='${LAYER}')
" > "amenity-${LAYER}.sql"
done
