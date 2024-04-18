terraform {
  required_providers {
    google = {
      version = "~> 4.21.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
  # backend gcs bucket is configured and set in the deployment pipeline
  backend "gcs" {}

  # uncomment for local development
  # backend "gcs" {
  #   bucket = "<gcp-bucket-name>"
  #   prefix = "terraform/state"
  # }
}

provider "google" {
  alias = "gcp"
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}