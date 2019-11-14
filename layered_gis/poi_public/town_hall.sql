SELECT
  2008 AS layer_code, 'poi_public' AS layer_class, 'town_hall' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE
EXISTS(SELECT 1 FROM UNNEST(all_tags) AS tags WHERE tags.key = 'amenity' AND tags.value='townhall')
