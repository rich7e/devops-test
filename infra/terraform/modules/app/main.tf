resource "docker_container" "app" {
  count    = var.replicas
  name     = "${var.container_name}${count.index + 1}"
  image    = var.image
  restart  = "unless-stopped"

  env = [
    "DB_HOST=${var.db_host}",
    "DB_PORT=${var.db_port}",
    "DB_NAME=${var.db_name}",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
  ]

  mounts {
    type   = "bind"
    source = var.mtls_host_dir
    target = "/etc/app-tls"
    read_only = true
  }

  networks_advanced { name = var.networks[0] }
}
