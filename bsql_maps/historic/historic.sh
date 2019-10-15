#!/bin/sh

for LAYER in monument memorial castle ruins archaeological_site wayside_cross wayside_shrine \
    battlefield fort
do
    echo "SELECT
  'historic-${LAYER}' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='${LAYER}')
UNION ALL
SELECT
  'historic-${LAYER}' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='${LAYER}')
UNION ALL
SELECT
  'historic-${LAYER}' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.other_relations\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'historic' AND tags.value='${LAYER}')
" > "historic-${LAYER}.sql"
done
