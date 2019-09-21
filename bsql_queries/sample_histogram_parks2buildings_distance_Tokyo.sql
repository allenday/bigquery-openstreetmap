WITH city AS (
	SELECT
		osm_layers.name as osm_name,
		osm_layers.all_tags AS osm_tags,
		(SELECT tags.value FROM UNNEST(all_tags) as tags WHERE tags.key = 'admin_level') as admin_level,
		osm_layers.geometry AS geometry
	FROM `openstreetmap-public-data-dev.osm_planet.osm_layers_partitions` AS osm_layers
	WHERE osm_layers.partnum = `openstreetmap-public-data-dev.osm_planet.name2partnum`('boundary-administrative')
		--https://en.m.wikipedia.org/wiki/Special_wards_of_Tokyo
		AND EXISTS(SELECT tags.value FROM UNNEST(all_tags) as tags WHERE tags.key = 'name' and tags.value in 
    ('千代田区','中央区','港区','新宿区','文京区','台東区','墨田区','江東区','品川区','目黒区','大田区','世田谷区','渋谷区','中野区','杉並区','豊島区','北区','荒川区','板橋区','練馬区','足立区','葛飾区','江戸川区'))
		AND EXISTS(SELECT tags.value FROM UNNEST(all_tags) as tags WHERE tags.key = 'place' and tags.value='city')
),
city_buildings AS (
	SELECT
		osm_layers.*
	FROM `openstreetmap-public-data-dev.osm_planet.osm_layers_partitions` AS osm_layers, city
	WHERE osm_layers.partnum = `openstreetmap-public-data-dev.osm_planet.name2partnum`('building')
		AND ST_DWITHIN(city.geometry, osm_layers.geometry, 0)
		-- ignore incorrect geometries with wrong orientation (see GeoJSON RFC 7946)
		AND ST_AREA(osm_layers.geometry) <= 1E10
),
city_parks AS (
	SELECT
		osm_layers.*
	FROM `openstreetmap-public-data-dev.osm_planet.osm_layers_partitions` AS osm_layers, city
	WHERE osm_layers.partnum = `openstreetmap-public-data-dev.osm_planet.name2partnum`('leisure-park')
		AND ST_DWITHIN(city.geometry, osm_layers.geometry, 0)
		-- ignore incorrect geometries with wrong orientation (see GeoJSON RFC 7946)
		AND ST_AREA(osm_layers.geometry) <= 1E10
),
city_buildings_parks AS (
	SELECT
		-- distance histogram bin size is equal to 30 meters
		30*round(min(ST_DISTANCE(city_buildings.geometry, city_parks.geometry))/30) as distance_park,
		ST_GEOHASH(ST_CENTROID(city_buildings.geometry)) AS building_geohash
	FROM city_buildings, city_parks
	GROUP BY 2
),
city_buildings_parks_agg AS (
	SELECT
		count(1) as count_buildings,
		distance_park,
		-- grid cell size is equal to 0.01 x 0.01 degree
		ST_GEOHASH(ST_SNAPTOGRID(ST_GEOGPOINTFROMGEOHASH(building_geohash), 0.01)) AS geohash
	FROM city_buildings_parks
	GROUP BY 2,3
),
city_buildings_parks_agg_points AS (
	SELECT
	  *,
	  ST_GEOGPOINTFROMGEOHASH(geohash) AS geometry
	FROM city_buildings_parks_agg
),
city_buildings_parks_agg_cells AS (
	SELECT
		geohash,
		count_buildings,
		distance_park,
		(SELECT
			ST_MAKEPOLYGON(ST_MAKELINE(ARRAY_AGG(geom)))
			FROM UNNEST(ARRAY[
				ST_GEOGPOINT(ST_X(geometry)-0.25/50, ST_Y(geometry)-0.25/50),
				ST_GEOGPOINT(ST_X(geometry)-0.25/50, ST_Y(geometry)+0.25/50),
				ST_GEOGPOINT(ST_X(geometry)+0.25/50, ST_Y(geometry)+0.25/50),
				ST_GEOGPOINT(ST_X(geometry)+0.25/50, ST_Y(geometry)-0.25/50)
			]) as geom
		) as geometry
	FROM city_buildings_parks_agg_points
)
select * from city_buildings_parks_agg_cells;
