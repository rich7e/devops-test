variable "db_image"    { type = string }
variable "db_name"     { type = string }
variable "db_user"     { type = string }
variable "db_password" { type = string, sensitive = true }
variable "volume_name" { type = string }
variable "networks"    { type = list(string) }
