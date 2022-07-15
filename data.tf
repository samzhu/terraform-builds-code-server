# Ubuntu
data "google_compute_image" "ubuntu_20" {
  project = "ubuntu-os-cloud"
  family  = "ubuntu-2004-lts"
}
