#!/bin/sh
source ../query_templates.sh

CLASS=aeroway
LAYER=( 
        "6701:aeroway=runway"
        "6702:aeroway=taxiway"
)

for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  EXTRA_CONSTRAINTS="AND EXISTS(SELECT 1 FROM UNNEST(osm.all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')"
  common_query > "$F.sql"
done
