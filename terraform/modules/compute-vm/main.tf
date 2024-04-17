resource "google_compute_instance" "compute_vm" {
  name         = var.service_name
  machine_type = var.machine_type
  project      = var.project
  zone         = var.zone

  boot_disk {
    device_name = "${var.service_name}_disk"
    initialize_params {
      # image = "debian-cloud/debian-11"
      image = "ubuntu-2004-focal-v20230817"
      size = "24"
      type = "pd-balanced"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {
      // Ephemeral IP
    }
  }

  # metadata = {
  #   ssh-keys = var.ssh_keys
  # }

  service_account {
    email   = var.service_account
    scopes  = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = [var.environment, "kube-cluster", var.target_firewall_tag]
}
