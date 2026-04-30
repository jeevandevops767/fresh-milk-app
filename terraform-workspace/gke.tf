resource "google_container_cluster" "gke" {
    name             = var.cluster_name
    location         = var.region 

    remove_default_node_pool = true
    initial_node_count = 1

    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id

    ip_allocation_policy {
        cluster_secondary_range_name = "pods-range"
        services_secondary_range_name = "service-range"
    }
    private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}
