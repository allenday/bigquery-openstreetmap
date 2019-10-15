#!/bin/sh

for LAYER in surveillance tower water_tower windmill lighthouse wastewater_plant water_well watermill \
    water_works
do
    echo "SELECT
  'man_made-${LAYER}' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='${LAYER}')
UNION ALL
SELECT
  'man_made-${LAYER}' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='${LAYER}')
UNION ALL
SELECT
  'man_made-${LAYER}' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.other_relations\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'man_made' AND tags.value='${LAYER}')
" > "man_made-${LAYER}.sql"
done
