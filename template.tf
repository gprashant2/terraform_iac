# Create web server template
resource "google_compute_instance_template" "web_server" {
  name = "web-server-template"
  description = "This template is used to create Apache web server"
  instance_description = "Web Server running Apache"
  can_ip_forward = false
  machine_type = "g1-small"
  tags = ["ssh","http"]
  scheduling {
    automatic_restart = true
    on_host_maintenance = "MIGRATE"
  }
  disk {
    source_image = "centos-7-v20200403"
    auto_delete = true
    boot = true
  }
  
  network_interface {
    network = "${google_compute_network.vpc.name}"
   subnetwork = "${google_compute_subnetwork.subnet.name}"
//   access_config {}
  }
  
  lifecycle {
    create_before_destroy = true
  }
  metadata_startup_script = "sudo yum -y update; sudo yum install -y httpd; sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf;sudo systemctl start httpd.service"
}
