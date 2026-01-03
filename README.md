# 🚀 GKE Cluster Provisioning Using Terraform (Learning Project)

This project demonstrates **how to provision, connect, and destroy a Google Kubernetes Engine (GKE) cluster using Terraform**, authenticated via a **Service Account**.

---

## 📌 Project Overview

**What this project covers:**

* GKE cluster creation using Terraform
* Service Account–based authentication
* Zonal GKE cluster (quota-safe)
* Custom node pool (learning-friendly machine size)
* Connecting to the cluster using `kubectl`
* Clean destroy with deletion protection disabled

---

## 🏗️ Architecture (High Level)

```
Terraform
   │
   ├── Google Provider (Service Account Auth)
   │
   └── GKE Cluster (Zonal)
        └── Custom Node Pool (e2-small)
```

---

## 📂 Project Structure

```
.
├── main.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
└── modules/
    └── gke/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## ✅ Prerequisites

* Google Cloud Project
* Terraform >= 1.3
* gcloud CLI
* kubectl
* Service Account with following roles:

  * `roles/container.admin`
  * `roles/compute.admin`
  * `roles/iam.serviceAccountUser`

---

## 🔐 Authentication (Service Account)

Export service account credentials:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="./keys/.json"
```

Activate service account:

```bash
gcloud auth activate-service-account \
  --key-file=./keys.json
```

Set project:

```bash
gcloud config set project terraform-gcp-482804
```

---

## ⚙️ Terraform Configuration

### Terraform & Provider Configuration

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
  credentials = "./keys.json"  # Service Account key
}
```

---

### Environment-wise GKE Modules (Dev / QA / Prod)

This project provisions **multiple GKE clusters** using the **same reusable module**.

```hcl
module "dev" {
  source       = "./modules/gke"
  project_id   = var.project_id
  region       = var.region
  cluster_name = var.cluster_name
}

module "qa" {
  source       = "./modules/gke"
  project_id   = var.project_id
  region       = var.region
  cluster_name = var.cluster_name_qa
}

module "prod" {
  source       = "./modules/gke"
  project_id   = var.project_id
  region       = var.region
  cluster_name = var.cluster_name_prod
}
```

> 💡 **Tip:** For learning, deploy one environment at a time to avoid quota exhaustion.

---

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
}
```

---

## ☸️ GKE Cluster Configuration (Zonal & Quota-Safe)

```hcl
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = "us-central1-a"

  deletion_protection = false

  remove_default_node_pool = true
  initial_node_count       = 1
}
```

---

## 🧱 Node Pool Configuration (Learning Optimized)

```hcl
resource "google_container_node_pool" "primary_nodes" {
  name     = "learning-node-pool"
  cluster = google_container_cluster.primary.name
  location = "us-central1-a"

  node_count = 1

  node_config {
    machine_type = "e2-small"
    disk_type    = "pd-standard"
    disk_size_gb = 30
  }
}
```

---

## 🚀 Deploy the Cluster

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

---

## 🔗 Connect to the GKE Cluster

Fetch credentials:

```bash
gcloud container clusters get-credentials dev-gke-cluster \
  --zone us-central1-a \
  --project terraform-gcp-482804
```

Verify:

```bash
kubectl get nodes
```

---

## 🧪 Test Deployment

```bash
kubectl run nginx --image=nginx
kubectl get pods
```

---

## 🧹 Destroy the Cluster

```bash
terraform destroy
```

> ⚠️ `deletion_protection = false` is required to allow destroy.

---

