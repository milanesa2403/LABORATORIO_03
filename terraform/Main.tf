terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  # Conexión local al daemon de Docker
}

# --- DESCARGA DE IMÁGENES DESDE DOCKER HUB ---

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_image" "node" {
  name         = "node:18-alpine"
  keep_locally = true
}

resource "docker_image" "postgres" {
  name         = "postgres:15-alpine"
  keep_locally = true
}

# --- REDES ---
resource "docker_network" "dev_network" {
  name = "dev-network"
}

resource "docker_network" "qa_network" {
  name = "qa-network"
}

# --- VOLÚMENES PARA PERSISTENCIA ---
resource "docker_volume" "bd_dev_data" {
  name = "bd-dev-data"
}

resource "docker_volume" "bd_qa_data" {
  name = "bd-qa-data"
}

# ==========================================
# AMBIENTE DEV (12541)
# ==========================================

resource "docker_container" "bd_dev" {
  name    = "bd-dev"
  image   = docker_image.postgres.image_id
  restart = "always"
  networks_advanced {
    name = docker_network.dev_network.name
  }
  ports {
    internal = 5432
    external = var.dev_ports.database
  }
  env = [
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=secret",
    "POSTGRES_DB=dev_db"
  ]
  volumes {
    volume_name    = docker_volume.bd_dev_data.name
    container_path = "/var/lib/postgresql/data"
  }
}

resource "docker_container" "api_dev" {
  name    = "api-dev"
  image   = docker_image.node.image_id
  restart = "always"
  networks_advanced {
    name = docker_network.dev_network.name
  }
  ports {
    internal = 3000
    external = var.dev_ports.backend
  }
  depends_on = [docker_container.bd_dev]
}

resource "docker_container" "web_dev" {
  name    = "web-dev"
  image   = docker_image.nginx.image_id
  restart = "always"
  networks_advanced {
    name = docker_network.dev_network.name
  }
  ports {
    internal = 80
    external = var.dev_ports.frontend
  }
  depends_on = [docker_container.api_dev]
}

# ==========================================
# AMBIENTE QA
# ==========================================

resource "docker_container" "bd_qa" {
  name    = "bd-qa"
  image   = docker_image.postgres.image_id
  restart = "always"
  networks_advanced {
    name = docker_network.qa_network.name
  }
  ports {
    internal = 5432
    external = var.qa_ports.database
  }
  env = [
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=secret",
    "POSTGRES_DB=qa_db"
  ]
  volumes {
    volume_name    = docker_volume.bd_qa_data.name
    container_path = "/var/lib/postgresql/data"
  }
}

resource "docker_container" "api_qa" {
  name    = "api-qa"
  image   = docker_image.node.image_id
  restart = "always"
  networks_advanced {
    name = docker_network.qa_network.name
  }
  ports {
    internal = 3000
    external = var.qa_ports.backend
  }
  depends_on = [docker_container.bd_qa]
}

resource "docker_container" "web_qa" {
  name    = "web-qa"
  image   = docker_image.nginx.image_id
  restart = "always"
  networks_advanced {
    name = docker_network.qa_network.name
  }
  ports {
    internal = 80
    external = var.qa_ports.frontend
  }
  depends_on = [docker_container.api_qa]
}