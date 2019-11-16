#!/bin/bash
echo $DATAFLOW_TEMPLATE_LOCATION
python main.py \
--runner DataflowRunner \
--project $GCP_PROJECT \
--temp_location $DATAFLOW_TEMP_LOCATION \
--staging_location $DATAFLOW_STAGING_LOCATION \
--network dataflow \
--no_use_public_ips true \
--template_location $DATAFLOW_TEMPLATE_LOCATION
