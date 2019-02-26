provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}
terraform {
  backend "gcs" {
    bucket  = "reddit-apper"
    prefix  = "prod"
  }
}
module "app" {
  source          = "../modules/app"
  public_key_path = "${var.public_key_path}"
  app_disk_image  = "${var.app_disk_image}"
 }

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  db_disk_image   = "${var.db_disk_image}"
  
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["86.57.179.30/32"]
}

module "ip" {
  source = "../modules/ip"
}
