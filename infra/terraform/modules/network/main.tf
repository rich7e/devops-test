resource "docker_network" "app" {
  name = var.app_net_name
}

resource "docker_network" "frontend" {
  name = var.frontend_net_name
}

output "app_net_id"      { value = docker_network.app.id }
output "frontend_net_id" { value = docker_network.frontend.id }
