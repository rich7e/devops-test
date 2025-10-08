variable "domain"           { type = string  default = "example.local" }

variable "app_net_name"     { type = string  default = "app-net" }
variable "db_net_name"      { type = string  default = "db-net" }
variable "frontend_net_name"{ type = string  default = "frontend-net" }

variable "pg_volume_name"   { type = string  default = "pgdata" }
variable "le_volume_name"   { type = string  default = "certs-le" }

variable "db_image"         { type = string  default = "postgres:16" }
variable "db_name"          { type = string  default = "postgres" }
variable "db_user"          { type = string  default = "postgres" }
variable "db_password"      { type = string  sensitive = true }

variable "app_image"        { type = string  default = "devops-test-app:local" }
variable "app_replicas"     { type = number  default = 2 }

variable "balancer_image"   { type = string  default = "devops-test-balancer:local" }
