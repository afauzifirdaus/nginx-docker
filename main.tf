terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

variable "host_port" {
  type    = number
  default = 8081
}

variable "pesan" {
  type    = string
  default = "Halo dari Terraform + Jenkins"
}

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_container" "web" {
  name    = "web-terraform"
  image   = docker_image.nginx.image_id
  restart = "unless-stopped"

  ports {
    internal = 80
    external = var.host_port
  }

  # Isi halaman dikirim langsung ke container (tidak bergantung path di Jenkins)
  upload {
    file    = "/usr/share/nginx/html/index.html"
    content = "<h1>${var.pesan}</h1>\n"
  }
}

output "url" {
  value = "http://localhost:${var.host_port}"
}

