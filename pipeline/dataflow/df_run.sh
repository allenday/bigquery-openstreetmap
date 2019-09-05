python main.py \
--project openstreetmap-public-data-dev \
--runner DataflowRunner \
--network dataflow \
--no_use_public_ips true \
--staging_location gs://openstreetmap-public-data-dev/df_staging \
--temp_location gs://openstreetmap-public-data-dev/df_temp \
--input gs://openstreetmap-public-data-dev/planet-latest-other_relations.geojson.csv \
--bq_destination openstreetmap-public-data-dev:osm_planet.test_load_job_2
