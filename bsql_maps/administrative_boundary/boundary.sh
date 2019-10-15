#!/bin/sh

echo "SELECT
    'boundary' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'boundary')" > "boundary.sql"

echo "SELECT
    'boundary-administrative' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'boundary' AND tags.value='administrative')" > boundary-administrative.sql

echo "SELECT
    'boundary-census' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'boundary' AND tags.value='census')" > boundary-census.sql
