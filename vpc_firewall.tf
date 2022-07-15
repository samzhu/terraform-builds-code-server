// Firewall Rules

// Allow All Http
resource "google_compute_firewall" "http-allow-all" {
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  name          = "${var.sid}-http-allow-all-${random_id.name_suffix.hex}"
  network       = google_compute_network.vpc.self_link
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-allow-all"]
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  depends_on = [google_compute_network.vpc]
}

// Allow All Https
resource "google_compute_firewall" "https-allow-all" {
  allow {
    ports    = ["443"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  name          = "${var.sid}-https-allow-all"
  network       = google_compute_network.vpc.self_link
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-allow-all"]
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  depends_on = [google_compute_network.vpc]
}

// Allow Google IAP
resource "google_compute_firewall" "ssh-allow-google-iap" {
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  name          = "${var.sid}-ssh-allow-google-iap"
  network       = google_compute_network.vpc.self_link
  project       = var.project_id
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["ssh-allow-google-iap"]
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  depends_on = [google_compute_network.vpc]
}

resource "google_compute_firewall" "webserver" {
  name    = "${var.sid}-backend-http-server-${random_id.name_suffix.hex}"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    # ports    = ["80"]
  }

  source_ranges = [
    "130.211.0.0/22", # Google LB
    "35.191.0.0/16",  # Google LB
  ]

  target_tags = [
    "allow-google-lb"
  ]
}
