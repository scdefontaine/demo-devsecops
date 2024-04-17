
// Enable required services on the project
resource "google_project_service" "service" {
  count   = length(var.project_services)
  project = var.project
  service = element(var.project_services, count.index)

  // Do not disable the service on destroy. On destroy, we are going to
  // destroy the project, but we need the APIs available to destroy the
  // underlying resources.
  disable_on_destroy = false
}

// Create a network for GKE
resource "google_compute_network" "network" {
  name                    = format("%s-network", var.service_name)
  project                 = var.project
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.service,
  ]
}

// Create subnets
resource "google_compute_subnetwork" "subnetwork" {
  name          = format("%s-subnet", var.service_name)
  project       = var.project
  network       = google_compute_network.network.self_link
  region        = var.region
  ip_cidr_range = "10.0.0.0/24"

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = format("%s-pod-range", var.service_name)
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = format("%s-svc-range", var.service_name)
    ip_cidr_range = "10.2.0.0/20"
  }
}

// Create an external NAT IP
resource "google_compute_address" "nat" {
  name    = format("%s-nat-ip-address", var.service_name)
  project = var.project
  region  = var.region

  depends_on = [
    google_project_service.service,
  ]
}

// Create a cloud router for use by the Cloud NAT
resource "google_compute_router" "router" {
  name    = format("%s-cloud-router", var.service_name)
  project = var.project
  region  = var.region
  network = google_compute_network.network.self_link

  bgp {
    asn = 64514
  }
}

// Create a NAT router so the nodes can reach DockerHub, etc
resource "google_compute_router_nat" "nat" {
  name    = format("%s-cloud-nat", var.service_name)
  project = var.project
  router  = google_compute_router.router.name
  region  = var.region

  nat_ip_allocate_option = "MANUAL_ONLY"

  nat_ips = [google_compute_address.nat.self_link]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnetwork.self_link
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]

    secondary_ip_range_names = [
      google_compute_subnetwork.subnetwork.secondary_ip_range.0.range_name,
      google_compute_subnetwork.subnetwork.secondary_ip_range.1.range_name,
    ]
  }
}

resource "google_compute_firewall" "allow_ip" {
  name    = format("%s-allow-ip", var.service_name)
  project = var.project
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.source_ip_address]  // Replace this with the actual IP you want to allow.

  target_tags = [var.target_firewall_tag]  // Ensure the VM instance has this tag.
}