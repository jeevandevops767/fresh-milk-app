resource "google_container_cluster" "gke_cluster" {
  name     = "jeeva-cluster"
  location = "us-central1"
  deletion_protection = false

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
  }
}