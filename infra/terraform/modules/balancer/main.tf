resource "docker_volume" "le" {
  name = var.le_volume_name
}

resource "docker_container" "balancer" {
  name   = "balancer"
  image  = var.image
  restart = "unless-stopped"

  env = ["DOMAIN=${var.domain}"]

  ports {
    internal = 80
    external = var.publish_http
    protocol = "tcp"
  }
  ports {
    internal = 443
    external = var.publish_https
    protocol = "tcp"
  }

  mounts {
    type   = "volume"
    source = docker_volume.le.name
    target = "/etc/letsencrypt"
    read_only = true
  }
  mounts {
    type   = "bind"
    source = var.mtls_host_dir
    target = "/etc/nginx/mtls"
    read_only = true
  }

  networks_advanced { name = var.networks[0] }
  networks_advanced { name = var.networks[1] }
}
