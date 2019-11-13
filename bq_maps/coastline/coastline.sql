# unclear how to select these features.
# "Only the code 8300 is used. Coastlines don't have a name attribute."

SELECT
  8300 AS layer_code, 'coastline' AS layer_class, 'coastline' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'coastline' OR tags.value='coastline')
