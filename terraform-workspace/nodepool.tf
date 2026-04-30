resource "google_container_node_pool" "primary_nodes" {
    name       = "node-pool"
    cluster    = google_container_cluster.gke.name
    location   = var.region
      node_count = 2

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}