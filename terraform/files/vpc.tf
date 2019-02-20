resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"
  description = "Allow SSH my rule"
  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
}