provider "docker" {}

module "network" {
  source = "./modules/network"
  app_net_name      = var.app_net_name
  db_net_name       = var.db_net_name
  frontend_net_name = var.frontend_net_name
}

module "db" {
  source      = "./modules/db"
  db_image    = var.db_image
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
  volume_name = var.pg_volume_name
  networks    = [module.network.app_net_id]
}

module "app" {
  source         = "./modules/app"
  image          = var.app_image
  replicas       = var.app_replicas
  container_name = "app"
  db_host        = "db"
  db_port        = 5432
  db_name        = var.db_name
  db_user        = var.db_user
  db_password    = var.db_password
  mtls_host_dir  = abspath("${path.root}/../../certs/app")
  networks       = [module.network.app_net_id]
}

module "balancer" {
  source          = "./modules/balancer"
  image           = var.balancer_image
  domain          = var.domain
  le_volume_name  = var.le_volume_name
  mtls_host_dir   = abspath("${path.root}/../../certs/balancer")
  networks        = [module.network.frontend_net_id, module.network.app_net_id]
  publish_http    = 80
  publish_https   = 443
}
