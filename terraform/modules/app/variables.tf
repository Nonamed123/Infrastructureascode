variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
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
default = "Buldozer"
}
variable host_db {
  description = "Host database"
  default     = "127.0.0.1"
}
