terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.14.1"
    }
  }
}

# -----------------------------
# Google Provider
# -----------------------------
provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = "./keys.json"
}

# -----------------------------
# Service Account
# -----------------------------
resource "google_service_account" "ubuntu-vm-sa" {
  account_id   = var.service_account_name
  
}
resource "google_compute_instance" "ubuntu_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["ssh", "http-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  # 🔧 Linux Configuration via Startup Script

 metadata_startup_script = "echo hi > /test.txt"
  service_account {
    email  = google_service_account.ubuntu-vm-sa.email
    scopes = ["cloud-platform"]
  }
}




