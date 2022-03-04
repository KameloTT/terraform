1. create creds/gcp.json and fill it out from web service account - keys
2. terraform.tfvars  - project_id can be find from 'gcloud config get-value project'
3.  Compute Engine API and Kubernetes Engine API are required for terraform apply to work on this configuration. Enable both APIs for your Google Cloud project before continuing
