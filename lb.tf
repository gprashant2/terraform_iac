# used to forward traffic to the correct load balancer for HTTP load balancing
resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name = "${var.app_name}-global-forwarding-rule"
  project = var.gcp_project
  target =  google_compute_target_http_proxy.target_http_proxy.self_link
  port_range = "8080"
}
# used by one or more global forwarding rule to route incoming HTTP requests to a URL map
resource "google_compute_target_http_proxy" "target_http_proxy" {
  name = "${var.app_name}-proxy"
  project = var.gcp_project
  url_map = google_compute_url_map.url_map.self_link
}

# used to route requests to a backend service based on rules that you define for the host and path of an incoming URL
resource "google_compute_url_map" "url_map" {
  name = "${var.app_name}-load-balancer"
  project = var.gcp_project
  default_service = google_compute_backend_service. backend_service.self_link
}
# defines a group of virtual machines that will serve traffic for load balancing
resource "google_compute_backend_service" "backend_service" {
  name = "${var.app_name}-backend-service"
  project = "${var.gcp_project}"
  port_name = "http"
  protocol = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_checks = ["${google_compute_health_check.healthcheck.self_link}"]
  backend {
    group = "${google_compute_instance_group_manager.web_private_group.instance_group}"
    balancing_mode = "RATE"
    max_rate_per_instance = 100
  }
}
# determine whether instances are responsive and able to do work
resource "google_compute_health_check" "healthcheck" {
   name = "${var.app_name}-healthcheck"
   timeout_sec = 5
   check_interval_sec = 5
   
   http_health_check {
     port = 8080
   }
}
# show external ip address of load balancer
output "load-balancer-ip-address" {
  value = google_compute_global_forwarding_rule. global_forwarding_rule.ip_address
}
