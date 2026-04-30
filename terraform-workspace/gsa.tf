resource "google_service_account" "gsa" {
  account_id   = "gke-sa"
  display_name = "GKE Service Account"
 
}

resource "google_project_iam_member" "gsa-role" {
    project   = var.project_id
  role        = "roles/storage.objectViewer"
  member      = "serviceAccount:${google_service_account.gsa.email}"
}