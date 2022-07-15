
# cloudsql instance
# resource "google_sql_database_instance" "cloudsql" {
#   name             = "${var.sid}-db-${random_id.name_suffix.hex}"
#   region           = var.region
#   database_version = var.database_version
#   settings {
#     tier = var.database_instance_type
#     availability_type = "REGIONAL"
#     ip_configuration {
#       ipv4_enabled    = false
#       private_network = google_compute_network.vpc.id
#     }
#   }
#   deletion_protection = false
#   depends_on = [google_service_networking_connection.private_vpc_connection]
# }

# cloudsql db 
# resource "google_sql_database" "database" {
#   name     = var.cloud_sql_database
#   instance = google_sql_database_instance.cloudsql.name
# }

# resource "google_sql_user" "users" {
#   name     = var.cloud_sql_user
#   instance = google_sql_database_instance.cloudsql.name
#   password = random_password.password.result
# }