variable "project_id" {
  type        = string
  description = "ID of your GCP project. Make sure you set this up before running this terraform code. REQUIRED."
}

variable "region" {
  type        = string
  description = "The region where the resources are created."
  default     = "asia-east1"
}

variable "zone" {
  type        = string
  description = "The zone where the resources are created."
  default     = "asia-east1-c"
}

variable "credentials" {
  type        = string
  description = "Credentials file path. REQUIRED."
  default     = "~/.config/gcloud/application_default_credentials.json"
}

variable "sid" {
  description = "resources name assign in the head line"
  type        = string
}

variable "public_cidr" {
  type        = string
  description = "public subnet cidr"
}

variable "private_cidr" {
  type        = string
  description = "private subnet cidr"
}

variable "worker_instance_type" {
  type        = string
  description = "instance type for gitlab vm machine."
  default     = "e2-standard-2"
}

variable "worker_disk_size" {
  type        = string
  description = "disk size for gitlab vm"
  default     = "100"
}

variable "database_instance_type" {
  type        = string
  description = "instance type for cloudsql database"
}

variable "cloud_sql_database" {
  type        = string
  description = "database for cloudsql"
}

variable "cloud_sql_user" {
  type        = string
  description = "username for cloudsql"
}

variable "database_version" {
  type        = string
  description = "version for cloudsql"
}

variable "openvscode_server_version" {
  type        = string
  description = "version for openvscode"
  default     = "1.65.2"
}
