resource "google_compute_disk" "coder_server" {
  name  = "${var.sid}-disk-${random_id.name_suffix.hex}"
  image = data.google_compute_image.ubuntu_20.self_link
  size  = var.worker_disk_size
  type  = "pd-balanced"
  zone  = var.zone
}


resource "google_compute_instance" "code-server" {
  project      = var.project_id
  zone         = var.zone
  count        = 1
  name         = "${var.sid}-server-${random_id.name_suffix.hex}"
  machine_type = var.worker_instance_type
  tags         = ["http", "http-allow-all", "ssh-allow-google-iap", "allow-google-lb"]
  # metadata_startup_script = file("./gce_init_script/ubuntu_init.sh")
  metadata_startup_script = templatefile("./gce_init_script/ubuntu_init.sh",
    {
      token                     = random_password.coder-token.result
      openvscode_server_version = var.openvscode_server_version
    }
  )

  metadata = {
    enable_os_logging = true
  }

  boot_disk {
    source      = google_compute_disk.coder_server.name
    auto_delete = false
  }

  network_interface {
    subnetwork_project = var.project_id
    network            = google_compute_network.vpc.name
    subnetwork         = google_compute_subnetwork.subnet-pv.name
    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  service_account {
    email  = google_service_account.worker_service_account.email
    scopes = ["cloud-platform"]
  }
  // scopes ref:https://cloud.google.com/monitoring/access-control#scopes

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  scheduling {
    preemptible         = false // if is true vm will be terminated in 24h or even earlier
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
}
