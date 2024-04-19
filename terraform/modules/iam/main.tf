// Create the service account
resource "google_service_account" "service_account" {
  account_id   = format("%s-sa", var.service_name)
  description  = var.description
  display_name = var.display_name
  project      = var.project
}

// Add the service account to the project
resource "google_project_iam_member" "service_account" {
  count   = length(var.service_account_iam_roles)
  project = var.project
  role    = element(var.service_account_iam_roles, count.index)
  member  = format("serviceAccount:%s", google_service_account.service_account.email)
}
