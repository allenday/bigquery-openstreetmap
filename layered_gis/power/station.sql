SELECT
  6410 AS layer_code, 'power' AS layer_class, 'station' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM `openstreetmap-public-data-prod.osm_planet.features`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'power' AND tags.value='generator')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE
       (  tags.key = 'generator:source' AND tags.value = 'nuclear' ) --6411
    OR ( (tags.key = 'generator:source' AND tags.value = 'solar') OR (tags.key = 'power_source' AND tags.value = 'photovoltaic') ) --6412
    OR (  tags.key = 'generator:source' AND tags.value IN ('gas','coal')  ) -- 6413
    OR ( (tags.key = 'generator:source' AND tags.value = 'hydro') OR (tags.key = 'power_source' AND tags.value = 'hydro') ) --6414
    OR ( (tags.key = 'generator:source' AND tags.value = 'wind') OR (tags.key = 'power_source' AND tags.value = 'wind') ) --6415
    OR ( (tags.key = 'power' AND tags.value = 'station') OR (tags.key = 'power' AND tags.value = 'sub_station') ) --6422
    OR (  tags.key = 'power' AND tags.value = 'transformer' ) --6423
  )
