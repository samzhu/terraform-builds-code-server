//------------------------------------------------------------
// Service Account for Worker process.
resource "google_service_account" "worker_service_account" {
  project      = var.project_id
  account_id   = "${var.sid}-worker-sa-${random_id.name_suffix.hex}"
  display_name = "Worker Service Account"
}