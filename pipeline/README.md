
#Data pipeline
data pipeline consists of several steps:  
1. Cloud Function which starts Compute Engine instance which downloads OSM file, parses and uploads to Cloud
Storage
2. Cloud Function which is triggered after file is uplodaed to Storage and starts Dataflow jobs
3. Cloud Functions which checks status of Dataflow jobs and after completed triggers BigQuery jobs to create layers table
4. TODO

folders represents concrete steps:  
`dataflow` - code for Beam / Dataflow transformations
`cf_check_df` - cloud function which checks Dataflow job status