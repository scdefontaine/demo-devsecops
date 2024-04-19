// Required values to be set in terraform.tfvars
variable "project" {
  description = "The project"
}

variable "zone" {
  description = "The zone for the vm"
}

variable "service_name" {
  description = "The name to give the new vm"
}

# variable "ssh_keys" {
#   description = "ssh keys to the vm"
# }

variable "environment" {
  description = "environment"
}

variable "network" {
  description = "network"
}

variable "subnetwork" {
  description = "subnetwork"
}

variable "machine_type" {
  description = "machine type for the vm"
}

variable "service_account" {
  description = "service account for the vm"
}

variable "target_firewall_tag" {
  description = "target_firewall_tag."
}