#!/bin/sh

echo "SELECT
    'natural-beach' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'natural' AND tags.value='beach')" > "natural-beach.sql"

echo "SELECT
    'natural-coastline' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.lines\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'natural' AND tags.value='coastline')" > "natural-coastline.sql"

echo "SELECT
    'natural-geyser' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'natural' AND tags.value='geyser')" > "natural-geyser.sql"

echo "SELECT
    'natural-grassland' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'natural' AND tags.value='grassland')" > "natural-grassland.sql"

echo "SELECT
    'natural-scrub' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'natural' AND tags.value='scrub')" > "natural-scrub.sql"

echo "SELECT
    'natural-volcano' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'natural' AND tags.value='volcano')" > "natural-volcano.sql"

echo "SELECT
    'natural-wood' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'natural' AND tags.value='wood')" > "natural-wood.sql"