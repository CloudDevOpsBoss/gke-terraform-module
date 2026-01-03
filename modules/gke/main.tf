resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  
deletion_protection = false 
  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name

  node_count = 2

node_config {
     machine_type = "n1-standard-2"
    disk_type    = "pd-standard"
    disk_size_gb = 30
  }
}
