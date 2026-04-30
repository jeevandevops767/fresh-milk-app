resource "google_compute_network" "vpc" {
    name                    = var.vpc_name 
    auto_create_subnetworks = false
}

# Subnet creation 

resource "google_compute_subnetwork" "subnet" {
   name              = var.subnet_name
   ip_cidr_range     = "10.0.0.0/24"
   region            = var.region
   network           = google_compute_network.vpc.id

   secondary_ip_range {
    range_name     = "pods-range"
    ip_cidr_range  = "10.1.0.0/16"

   }

   secondary_ip_range {
    range_name     = "service-range"
    ip_cidr_range  = "10.2.0.0/20"
   }
}
   