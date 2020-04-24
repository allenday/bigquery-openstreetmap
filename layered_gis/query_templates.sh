common_query() {
echo "
WITH osm AS (
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.nodes\`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, CAST(id AS STRING) AS way_id, all_tags FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.ways\`
  UNION ALL
  SELECT CAST(id AS STRING) AS id, null AS way_id, all_tags FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.relations\`
)
SELECT $CODE AS layer_code, '$CLASS' AS layer_class, '$NAME_PREFIX$N' AS layer_name, f.feature_type AS gdal_type,
CASE WHEN f.osm_id="" THEN NULL ELSE f.osm_id END AS osm_id,
CASE WHEN f.osm_way_id="" THEN NULL ELSE f.osm_way_id END AS osm_way_id,
f.osm_timestamp, osm.all_tags, f.geometry
FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.features\` AS f, osm
WHERE osm.id = f.osm_id
$EXTRA_CONSTRAINTS

UNION ALL

SELECT $CODE AS layer_code, '$CLASS' AS layer_class, '$NAME_PREFIX$N' AS layer_name, f.feature_type AS gdal_type,
CASE WHEN f.osm_id="" THEN NULL ELSE f.osm_id END AS osm_id,
CASE WHEN f.osm_way_id="" THEN NULL ELSE f.osm_way_id END AS osm_way_id,
f.osm_timestamp, osm.all_tags, f.geometry
FROM \`${GCP_PROJECT}.${BQ_SOURCE_DATASET}.features\` AS f, osm
WHERE osm.way_id = f.osm_way_id
$EXTRA_CONSTRAINTS
"
}
