// Create customer VPC
resource "google_compute_network" "vpc" {
  name                            = "${var.sid}-vpc-${random_id.name_suffix.hex}"
  project                         = var.project_id
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
}

// Create customer Public-Subnet
resource "google_compute_subnetwork" "subnet-pb" {
  ip_cidr_range            = var.public_cidr
  name                     = "${var.sid}-public-subnet-${random_id.name_suffix.hex}"
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = "true"
  project                  = var.project_id
  region                   = var.region
  depends_on               = [google_compute_network.vpc]
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

// Create customer Private-Subnet
resource "google_compute_subnetwork" "subnet-pv" {
  ip_cidr_range            = var.private_cidr
  name                     = "${var.sid}-private-subnet-${random_id.name_suffix.hex}"
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = "true"
  project                  = var.project_id
  region                   = var.region
  depends_on               = [google_compute_network.vpc]
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

// Route to the Internet for VPC
resource "google_compute_route" "route-to-internet-for-vpc" {
  name             = "${var.sid}-vpc-route-to-internet-${random_id.name_suffix.hex}"
  description      = "route to the Internet."
  dest_range       = "0.0.0.0/0"
  project          = var.project_id
  network          = google_compute_network.vpc.self_link
  next_hop_gateway = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/gateways/default-internet-gateway"
  priority         = "1000"
}

// Cloud Router for Nat-gateway
resource "google_compute_router" "router" {
  name    = "${var.sid}-private-router-${random_id.name_suffix.hex}"
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.self_link
  bgp {
    asn = 64514
  }
}

// NAT Gateway
// https://www.terraform.io/docs/providers/google/r/compute_router_nat.html
resource "google_compute_router_nat" "natgateway" {
  name                               = "${var.sid}-natgateway-${random_id.name_suffix.hex}"
  project                            = var.project_id
  region                             = var.region
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.subnet-pv.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}