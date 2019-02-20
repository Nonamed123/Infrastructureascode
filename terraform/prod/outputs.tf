output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}

output "db_external_ip" {
  value = "${module.db.db_external_ip}"
}
output "db_unternel_ip" {
  value = "${module.db.db_unternel_ip}"
}
output "app_unternel_ip" {
  value = "${module.app.app_unternel_ip}"
}