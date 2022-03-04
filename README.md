1. create creds/gcp.json and fill it out from web service account - keys
2. terraform.tfvars  - project_id can be find from 'gcloud config get-value project'
3. following  API are required for terraform apply to work on this configuration.
* Cloud Resource Manager API
* Compute Engine API
* Kubernetes Engine API
* Service Networking API
* Cloud SQL Admin API
