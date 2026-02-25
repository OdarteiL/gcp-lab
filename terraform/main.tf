terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "gcs" {
    bucket = "earnest-entropy-469620-q5-tfstate"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# VPC Network
resource "google_compute_network" "main" {
  name                    = "lab-network"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "main" {
  name          = "lab-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.main.self_link
  region        = var.region
}

# Firewall — allow HTTP
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-tf"
  network = google_compute_network.main.name
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}

# Compute Engine VM (free tier)
resource "google_compute_instance" "web" {
  name         = "tf-web-server"
  machine_type = "e2-micro"
  tags         = ["web-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main.self_link
    access_config {}  # Assigns ephemeral public IP
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    echo '<h1>Provisioned by Terraform via GitLab!</h1>' > /var/www/html/index.html
    systemctl enable nginx && systemctl start nginx
  EOF
}
