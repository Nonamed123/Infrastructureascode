variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable private_key_path {
  description = "Path to the private keys used for ssh connect"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-db-base"
}
variable zones {
description = "Zone for start vm"
default = "europe-west1-b"
}
variable type_machine{
description = "Type of machine"
default = "g1-small"
}
variable user_key{
description = "User for ssh key"
}