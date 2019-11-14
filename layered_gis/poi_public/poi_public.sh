#!/bin/sh

LAYER=(
        "2001:amenity=police"
        "2002:amenity=fire_station"
        "2004:amenity=post_box"
        "2005:amenity=post_office"
        "2006:amenity=telephone"
        "2007:amenity=library"
        "2009:amenity=courthouse"
        "2010:amenity=prison"
        "2011:amenity=embassy"
        "2012:amenity=community_centre"
        "2013:amenity=nursing_home"
        "2014:amenity=arts_centre"
        "2016:amenity=marketplace"
        "2081:amenity=university"
        "2082:amenity=school"
        "2083:amenity=kindergarten"
        "2084:amenity=college"
        "2099:amenity=public_building"
)


for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"

  echo "SELECT
  $CODE AS layer_code, 'poi_public' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

echo "SELECT
  2015 AS layer_code, 'poi_public' AS layer_class, 'graveyard' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'amenity' AND tags.value='grave_yard') OR
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'landuse' AND tags.value='cemetery')" > "graveyard.sql"

#2008
echo "SELECT
  2008 AS layer_code, 'poi_public' AS layer_class, 'town_hall' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'amenity' AND tags.value='townhall')" > "town_hall.sql"

#2030
echo "SELECT
  2030 AS layer_code, 'poi_public' AS layer_class, 'recycling' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'amenity' AND tags.value='recycling')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:glass' AND tags.value='yes')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:paper' AND tags.value='yes')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:clothes' AND tags.value='yes')
AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:scrap_metal' AND tags.value='yes')" > "recycling.sql"

#2031
echo "SELECT
  2031 AS layer_code, 'poi_public' AS layer_class, 'recycling_glass' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:glass' AND tags.value='yes')" > "recycling_glass.sql"

#2032
echo "SELECT
  2032 AS layer_code, 'poi_public' AS layer_class, 'recycling_paper' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:paper' AND tags.value='yes')" > "recycling_paper.sql"

#2033
echo "SELECT
  2033 AS layer_code, 'poi_public' AS layer_class, 'recycling_clothes' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:clothes' AND tags.value='yes') " > "recycling_clothes.sql"

#2034
echo "SELECT
  2034 AS layer_code, 'poi_public' AS layer_class, 'recycling_metal' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'recycling:metal' AND tags.value='yes') " > "recycling_metal.sql"
