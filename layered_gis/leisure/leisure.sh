#!/bin/sh

for LAYER in park playground dog_park sports_centre pitch swimming_pool water_park golf_course \
    stadium ice_rink
do
    echo "SELECT
  'leisure-${LAYER}' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.points\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='${LAYER}')
UNION ALL
SELECT
  'leisure-${LAYER}' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.multipolygons\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='${LAYER}')
UNION ALL
SELECT
  'leisure-${LAYER}' AS name, *
FROM \`${GCP_PROJECT}.${BQ_DATASET}.other_relations\`
WHERE EXISTS(SELECT 1 FROM UNNEST(all_tags) as tags WHERE tags.key = 'leisure' AND tags.value='${LAYER}')
" > "leisure-${LAYER}.sql"
done
