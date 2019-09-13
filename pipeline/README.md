
#Data pipeline
data pipeline consists of several steps:  
1. Cloud Function which starts Compute Engine instance. Cloud Function is triggered by Cloud Scheduler.  
2. GCE instance downloads OSM file, parses it and uploads to Cloud Storage. 
3. Cloud Function which is triggered after file is uploaded to Storage and starts Dataflow jobs
4. Cloud Function which checks status of Dataflow jobs and waits until all are completed
5. Cloud Function which runs BigQuery jobs to create 

folders represents concrete steps:  

`cf_init_gce` - Cloud Functions which creates GCE instance 
`cf_init_df` - Cloud Function which launches Dataflow template job   
`dataflow` - Code for Beam / Dataflow process   
`cf_check_df_jobs` - Cloud Function which checks Dataflow job status  
`cf_create_layers` - Cloud Function which creates layer table in BigQuery

`gce_download_parse` - bash scripts which are executed in GCE instance


#General info
All code that in `pipeline` folder was developed/runs on Python 3.7  
Settings for Cloud functions are stored via `env.yaml` files and set during deployment

Files ending with `_test` are for testing purposes

