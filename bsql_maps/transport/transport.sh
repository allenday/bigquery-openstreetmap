#!/bin/sh

echo "SELECT
    'transport-highway' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.lines\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'highway')" > "transport-highway.sql"

echo "SELECT
    'transport-waterway' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.lines\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'waterway')" > "transport-waterway.sql"