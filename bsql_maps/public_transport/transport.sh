#!/bin/sh

echo "SELECT
    'transport-aerialway_station' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'aerialway' AND tags.value='station')" > "transport-aerialway_station.sql"

echo "SELECT
    'transport-bus_station' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'amenity' AND tags.value='bus_station')" > "transport-bus_station.sql"

echo "SELECT
    'transport-bus_stop' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'highway' AND tags.value='bus_stop')" > "transport-bus_stop.sql"

echo "SELECT
    'transport-railway_platform' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.other_relations\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'public_transport' AND tags.value='stop_area')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'train' AND tags.value='yes')" > "transport-railway_platform.sql"

echo "SELECT
    'transport-railway_smallstation' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'railway' AND tags.value='halt')" > "transport-railway_smallstation.sql"

echo "SELECT
    'transport-railway_station' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'railway' AND tags.value='station')" > "transport-railway_station.sql"

echo "SELECT
    'transport-tram_stop' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'railway' AND tags.value='tram_stop')" > "transport-tram_stop.sql"

echo "SELECT
    'transport_route-aerialway' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multilinestrings\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'route' AND tags.value='aerialway')" > "transport_route-aerialway.sql"

echo "SELECT
    'transport_route-bus' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multilinestrings\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'route' AND tags.value='bus')
  AND (NOT EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'state') OR
    EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'state' AND tags.value='alternate'))" > "transport_route-bus.sql"

echo "SELECT
    'transport_route-bus_alternate' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multilinestrings\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'route' AND tags.value='bus')
  AND EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'state' AND tags.value='alternate')" > "transport_route-bus_alternate.sql"

echo "SELECT
    'transport_route-ferry' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multilinestrings\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'route' AND tags.value='ferry')" > "transport_route-ferry.sql"

echo "SELECT
    'transport_route-funicular' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multilinestrings\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'route' AND tags.value='funicular')" > "transport_route-funicular.sql"

echo "SELECT
    'transport_route-monorail' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multilinestrings\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'route' AND tags.value='monorail')" > "transport_route-monorail.sql"