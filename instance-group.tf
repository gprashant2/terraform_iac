resource "google_compute_instance_group_manager" "web_private_group"{
  name = "${var.app_name}-healthcheck"
  project = "${var.gcp_project}"
  base_instance_name = "web"
  zone = "${var.gcp_zone}"
  version {
    instance_template  = "${google_compute_instance_template.web_server.self_link}"
  }
  named_port {
    name = "http"
    port = 8080
  }
}

# automatically scale virtual machine instances in managed instance groups according to an autoscaling policy
resource "google_compute_autoscaler" "autoscaler" {
  name = "${var.app_name}-autoscaler"
  project = var.gcp_project
  zone = var.gcp_zone
  target  = "${google_compute_instance_group_manager.web_private_group.self_link}"
  autoscaling_policy {
    max_replicas = 2
    min_replicas = 1
    cooldown_period = 300
    
    cpu_utilization {
      target = 0.8
    }
  }
}
