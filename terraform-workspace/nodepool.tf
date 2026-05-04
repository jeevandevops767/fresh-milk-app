resource "google_container_node_pool" "primary_nodes" {
    name       = "node-pool"
    cluster    = google_container_cluster.gke.name
    location   = var.zone
      node_count = 1

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
} 