resource "docker_volume" "pgdata" {
  name = var.volume_name
}

resource "docker_container" "db" {
  name  = "db"
  image = var.db_image
  restart = "unless-stopped"

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
  ]

  mounts {
    target = "/var/lib/postgresql/data"
    source = docker_volume.pgdata.name
    type   = "volume"
  }

  networks_advanced {
    name = var.networks[0]
  }
}
