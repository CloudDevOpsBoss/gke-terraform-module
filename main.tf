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

module "dev" {
  source       = "./modules/gke"
  project_id   = var.project_id
  region       = var.region
  cluster_name = var.cluster_name
}

# module "qa" {
#   source       = "./modules/gke"
#   project_id   = var.project_id
#   region       = var.region
#   cluster_name = var.cluster_name_qa
# }
# module "prod" {
#   source       = "./modules/gke"
#   project_id   = var.project_id
#   region       = var.region
#   cluster_name = var.cluster_name_prod
# }

  