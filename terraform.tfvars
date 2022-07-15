project_id  = "das-ct-lab"
credentials = "~/.config/gcloud/application_default_credentials.json"
region      = "asia-east1"
zone        = "asia-east1-c"
sid         = "coder"

worker_instance_type = "e2-standard-2"
worker_disk_size     = "100"

//Network
public_cidr  = "10.1.0.0/20"
private_cidr = "10.2.0.0/20"

// database
database_instance_type = "db-f1-micro"
database_version       = "POSTGRES_13"
cloud_sql_database     = "dev"
cloud_sql_user         = "sqladmin"

openvscode_server_version = "1.66.0"