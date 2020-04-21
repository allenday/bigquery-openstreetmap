#!/bin/sh
source ../query_templates.sh

CLASS=poi_miscpoi
LAYER=( 
        "2901:amenity=toilets>toilet"
        "2902:amenity=bench"
        "2903:amenity=drinking_water"
        "2904:amenity=fountain"
        "2905:amenity=hunting_stand"
        "2906:amenity=waste_basket"
        "2907:man_made=surveillance>camera_surveillance"
        "2921:amenity=emergency_phone>emergency_phone-amenity"
        "2921:emergency=phone>emergency_phone-emergency"
        "2922:amenity=fire_hydrant>fire_hydrant-amenity"
        "2922:emergency=fire_hydrant>fire_hydrant-emergency"
        "2923:highway=emergency_access_point>emergency_access"
        "2952:man_made=water_tower"
        "2954:man_made=windmill"
        "2955:man_made=lighthouse"
        "2961:man_made=wastewater_plant"
        "2962:man_made=water_well"
        "2963:man_made=watermill>water_mill"
        "2964:man_made=water_works"
)

for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KVF="${layer##*:}"
  K="${KVF%%=*}"
  VF="${KVF##*=}"
  V="${VF%%>*}"
  F="${VF##*>}"
  N="${F%%-*}"
  EXTRA_CONSTRAINTS="AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')"
  common_query > "$F.sql"
done

CODE=2950
N=tower
F=tower
EXTRA_CONSTRAINTS="
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='tower')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'tower:type' AND tags.value='communication')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='water_tower')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'tower:type' AND tags.value='observation')"
common_query > "$F.sql"

CODE=2951
N=tower_comms
F=tower_comms
EXTRA_CONSTRAINTS="
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='tower')
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'tower:type' AND tags.value='communication')"
common_query > "$F.sql"

CODE=2953
N=tower_observation
F=tower_observation
EXTRA_CONSTRAINTS="
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='tower')
  AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = 'tower:type' AND tags.value='observation')"
common_query > "$F.sql"
