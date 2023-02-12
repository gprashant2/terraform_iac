# allow http traffic
resource "google_compute_firewall" "allow-http" {
  name = "${var.app_name}-fw-allow-http"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
 source_ranges = ["0.0.0.0/0","35.191.0.0/16","130.211.0.0/22"]
  target_tags = ["http"]
}

