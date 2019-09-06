python main.py \
--runner DataflowRunner \
--project openstreetmap-public-data-dev \
--temp_location gs://openstreetmap-public-data-dev/df_temp \
--staging_location gs://openstreetmap-public-data-dev/df_staging \
--network dataflow \
--no_use_public_ips true \
--template_location gs://openstreetmap-public-data-dev/df_template/process_geojson
