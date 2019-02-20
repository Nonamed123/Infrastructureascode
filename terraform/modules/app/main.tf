resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "${var.type_machine}"
  zone         = "${var.zones}"

  # определение загрузочного диска
  tags = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  # определение сетевого интерфейса
  tags = ["reddit-app"]
  
   network_interface {
    network       = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "${var.user_key}:${file(var.public_key_path)}"
  }
}
resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}
resource "google_compute_firewall" "firewall_nginx" {
  name    = "allow-nginx-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}