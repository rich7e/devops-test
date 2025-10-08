variable "image"          { type = string }
variable "replicas"       { type = number }
variable "container_name" { type = string }
variable "db_host"        { type = string }
variable "db_port"        { type = number }
variable "db_name"        { type = string }
variable "db_user"        { type = string }
variable "db_password"    { type = string, sensitive = true }
variable "mtls_host_dir"  { type = string }
variable "networks"       { type = list(string) }
