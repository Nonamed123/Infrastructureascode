resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "${var.type_machine}"
  zone         = "${var.zones}"

  # определение загрузочного диска
  tags = ["reddit-db"]

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  # определение сетевого интерфейса
  tags = ["reddit-db"]
  
 network_interface{
  network_ip = "10.132.15.222"
  subnetwork = "default"

    access_config = {}
  }

  metadata {
    ssh-keys = "${var.user_key}:${file(var.public_key_path)}"
  }
}

resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  # правило применимо к инстансам с тегом ...
  target_tags = ["reddit-db"]

  # порт будет доступен только для инстансов с тегом ...
  source_tags = ["reddit-app"]
}
