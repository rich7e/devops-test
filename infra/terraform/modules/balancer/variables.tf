variable "image"           { type = string }
variable "domain"          { type = string }
variable "le_volume_name"  { type = string }
variable "mtls_host_dir"   { type = string }
variable "networks"        { type = list(string) }
variable "publish_http"    { type = number }
variable "publish_https"   { type = number }
