
# terraform state backend bucket
module "backend" {
  source        = "./modules/backend"
  project       = var.project
  service_name  = var.cluster_name
}

# iam service account module
module "service_account" {
  source                    = "./modules/iam"
  service_name              = var.cluster_name
  project                   = var.project
  display_name              = "Kube Cluster Service Account"
  description               = "Kube Cluster Service Account"
  service_account_iam_roles = [
                              "roles/secretmanager.secretAccessor",
                              "roles/logging.logWriter",
                              "roles/monitoring.metricWriter",
                              "roles/iam.serviceAccountUser",
                              "roles/compute.instanceAdmin.v1",
                              "roles/compute.admin",
                              "roles/storage.admin"
                            ]
}

module "network" {
  source              = "./modules/network"
  project             = var.project
  region              = var.region
  service_name        = var.cluster_name
  source_ip_address   = var.source_ip_address
  target_firewall_tag = format("%s-firewall", var.cluster_name)
  project_services    = [
                        "cloudresourcemanager.googleapis.com",
                        "servicenetworking.googleapis.com",
                        "container.googleapis.com",
                        "compute.googleapis.com",
                        "iam.googleapis.com",
                        "logging.googleapis.com",
                        "monitoring.googleapis.com",
                        "securetoken.googleapis.com",
                      ]
}

# module "gitlab-runner" {
#   source              = "./modules/compute-vm"
#   machine_type        = "e2-medium"
#   project             = var.project
#   zone                = var.zone
#   environment         = var.environment
#   service_name        = format("%s-gitlab-runner", var.cluster_name)
#   network             = module.network.network_link
#   subnetwork          = module.network.subnetwork_link
#   service_account     = module.service_account.service_account_email
#   target_firewall_tag = format("%s-firewall", var.cluster_name)
#   # ssh_keys            = "ubuntu:${file("<PATH-TO-YOUR-PUBLIC-SSH-KEY>.pub")}"
# }

module "master-node" {
  source              = "./modules/compute-vm"
  machine_type        = "e2-medium"
  project             = var.project
  zone                = var.zone
  environment         = var.environment
  service_name        = format("%s-master", var.cluster_name)
  network             = module.network.network_link
  subnetwork          = module.network.subnetwork_link
  service_account     = module.service_account.service_account_email
  target_firewall_tag = format("%s-firewall", var.cluster_name)
  # ssh_keys            = "ubuntu:${file("<PATH-TO-YOUR-PUBLIC-SSH-KEY>.pub")}"
}

module "worker-node-1" {
  source              = "./modules/compute-vm"
  machine_type        = "e2-standard-4"
  project             = var.project
  zone                = var.zone
  environment         = var.environment
  service_name        = format("%s-worker-1", var.cluster_name)
  network             = module.network.network_link
  subnetwork          = module.network.subnetwork_link
  service_account     = module.service_account.service_account_email
  target_firewall_tag = format("%s-firewall", var.cluster_name)
  # ssh_keys            = "ubuntu:${file("<PATH-TO-YOUR-PUBLIC-SSH-KEY>.pub")}"
}

module "worker-node-2" {
  source              = "./modules/compute-vm"
  machine_type        = "e2-standard-4"
  project             = var.project
  zone                = var.zone
  environment         = var.environment
  service_name        = format("%s-worker-2", var.cluster_name)
  network             = module.network.network_link
  subnetwork          = module.network.subnetwork_link
  service_account     = module.service_account.service_account_email
  target_firewall_tag = format("%s-firewall", var.cluster_name)
  # ssh_keys            = "ubuntu:${file("<PATH-TO-YOUR-PUBLIC-SSH-KEY>.pub")}"
}
