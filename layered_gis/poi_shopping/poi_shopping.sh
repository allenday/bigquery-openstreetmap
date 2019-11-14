#!/bin/sh

LAYER=( 
        "2501:shop=supermarket"
        "2502:shop=bakery"
        "2503:shop=kiosk"
        "2504:shop=mall"
        "2505:shop=department_store"
        "2511:shop=convenience"
        "2512:shop=clothes"
        "2513:shop=florist"
        "2514:shop=chemist"
        "2515:shop=books"
        "2516:shop=butcher"
        "2517:shop=shoes"
        "2519:shop=optician"
        "2520:shop=jewelry"
        "2521:shop=gift"
        "2522:shop=sports"
        "2523:shop=stationery"
        "2524:shop=outdoor"
        "2525:shop=mobile_phone"
        "2526:shop=toys"
        "2527:shop=newsagent"
        "2528:shop=greengrocer"
        "2529:shop=beauty"
        "2530:shop=video"
        "2541:shop=car"
        "2542:shop=bicycle"
        "2544:shop=furniture"
        "2546:shop=computer"
        "2547:shop=garden_centre"
        "2561:shop=hairdresser"
        "2562:shop=car_repair"
        "2563:amenity=car_rental"
        "2564:amenity=car_wash"
        "2565:amenity=car_sharing"
        "2566:amenity=bicycle_rental"
        "2567:shop=travel_agency"
)

for layer in "${LAYER[@]}"
do
  CODE="${layer%%:*}"
  KV="${layer##*:}"
  K="${KV%%=*}"
  V="${KV##*=}"
  echo "SELECT
  $CODE AS layer_code, 'poi_shopping' AS layer_class, '$V' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = '$K' AND tags.value='$V')" > "$V.sql"
done

#2518
echo "SELECT
  2518 AS layer_code, 'poi_shopping' AS layer_class, 'beverages' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'shop' AND tags.value='alcohol') OR (tags.key = 'shop' AND tags.value='beverages'))" > "shop_beverages.sql"

#2543
#TODO request upstream mod, currently shows "shop=doityourself and shop=hardware" but following usual doc conventions should instead be "shop=doityourself, shop=hardware"
echo "SELECT
  2543 AS layer_code, 'poi_shopping' AS layer_class, 'doityourself' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'shop' AND tags.value IN ('doityourself','hardware')))" > "shop_doityourself.sql"

#2568
echo "SELECT
  2568 AS layer_code, 'poi_shopping' AS layer_class, 'laundry' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE (tags.key = 'shop' AND tags.value='laundry') OR (tags.key = 'shop' AND tags.value='dry_cleaning'))" > "shop_laundry.sql"

#2590
echo "SELECT
  2590 AS layer_code, 'poi_shopping' AS layer_class, 'vending_cigarette' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='vending_machine')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'vending' AND tags.value='cigarettes')
  AND NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'vending' AND tags.value='parking_tickets')" > "vending_machine.sql"

#2591
echo "SELECT
  2591 AS layer_code, 'poi_shopping' AS layer_class, 'vending_cigarette' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'vending' AND tags.value='cigarettes')" > "vending_cigarette.sql"

#2592
echo "SELECT
  2592 AS layer_code, 'poi_shopping' AS layer_class, 'vending_parking' AS layer_name, feature_type AS gdal_type, osm_id, osm_way_id, osm_timestamp, all_tags, geometry
FROM \`${GCP_PROJECT}.${BQ_DATASET}.features\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'vending' AND tags.value='parking_tickets')" > "vending_parking.sql"
