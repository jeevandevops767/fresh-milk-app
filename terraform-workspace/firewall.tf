resource "google_compute_firewall" "allow-internal" {
    name                  = "allow-internal"
    network                = google_compute_network.vpc.id

# 10.0.0.0/8 is a private IP address range, meaning it is not publicly routable on the internet

    allow {
      protocol = "tcp"
      ports    = ["0-65535"]
    }

    source_ranges = ["10.0.0.0/8"]
}

resource "google_compute_firewall" "allow-http" {
    name              = "allow-http"
    network           = google_compute_network.vpc.id

    allow {
      protocol = "tcp"
      ports     = ["80", "443"]

    }

    source_ranges = ["0.0.0.0/0"]

}
