// Terraform plugin for creating random IDs
resource "random_id" "instance_id" {
  byte_length = 8
}

# google_storage_bucket.terraform-default
resource "google_storage_bucket" "storage_bucket" {
  name          = "${var.service_name}-tfstate-${random_id.instance_id.hex}"
  project       = var.project
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  labels = {
    "data-server" = "storage-bucket"
  }
  versioning {
    enabled = true
  }
}
