# 🚀 Provision Ubuntu VM on Google Cloud using Terraform

This project demonstrates how to **provision an Ubuntu 22.04 virtual machine on Google Cloud Platform (GCP)** using **Terraform**, including:
- Google provider configuration
- Service Account creation
- Compute Engine VM provisioning
- Startup script execution

---

## 📌 Architecture Overview

**Resources created:**
- Google Service Account
- Google Compute Engine (Ubuntu VM)
- Default VPC network
- External IP (via `access_config`)
- Startup script to configure VM at boot

---

## 🛠️ Prerequisites

Before you begin, ensure you have:

- Google Cloud account
- GCP project created
- Terraform installed (v1.x recommended)
- Google Cloud service account key (`keys.json`)
- Enabled APIs:
  - Compute Engine API
  - IAM API

---

## 📂 Project Structure

```
.
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── README.md
└── keys.json   (DO NOT COMMIT)
```

---

## ⚙️ Provider Configuration

Terraform uses the **Google provider** to authenticate and manage GCP resources.

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.14.1"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = "./keys.json"
}
```

⚠️ **Security Note:**  
Never commit `keys.json` to GitHub. Always add it to `.gitignore`.

---

## 🔐 Service Account

A dedicated service account is created and attached to the VM.

```hcl
resource "google_service_account" "ubuntu-vm-sa" {
  account_id = var.service_account_name
}
```

---

## 🖥️ Compute Engine – Ubuntu VM

The VM uses **Ubuntu 22.04 LTS** and runs a startup script at boot.

```hcl
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

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    email  = google_service_account.ubuntu-vm-sa.email
    scopes = ["cloud-platform"]
  }
}
```

✔ Creates a file `/test.txt` on VM startup  
✔ Attaches service account with cloud-platform access  

---

## 📥 Input Variables

Define variables in `variables.tf`:

| Variable | Description |
|--------|------------|
| `project_id` | GCP project ID |
| `region` | GCP region |
| `zone` | GCP zone |
| `vm_name` | Name of VM |
| `machine_type` | VM size |
| `service_account_name` | Service account ID |

### Example `terraform.tfvars`

```hcl
project_id           = "my-gcp-project"
region               = "us-central1"
zone                 = "us-central1-a"
vm_name              = "ubuntu-vm"
machine_type         = "e2-medium"
service_account_name = "ubuntu-vm-sa"
```

---

## ▶️ How to Run

### Initialize Terraform
```bash
terraform init
```

### Preview Changes
```bash
terraform plan
```

### Apply Configuration
```bash
terraform apply
```

### Destroy Resources
```bash
terraform destroy
```

---

## 🔒 Security Best Practices

- ❌ Do not commit `keys.json`
- ✔ Use `.gitignore`
- ✔ Prefer Workload Identity / CI secrets for production
- ✔ Use least-privilege IAM roles

---

## 📄 .gitignore Example

```
*.tfstate
*.tfstate.backup
.terraform/
terraform.tfvars
keys.json
```

---

## 📌 Use Cases

- Learning Terraform with GCP
- Dev/Test VM provisioning
- CI/CD pipeline testing
- Startup script automation

---


