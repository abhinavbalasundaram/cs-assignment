resource "google_service_account" "gke_nodes" {
  account_id   = "gke-nodes"
  display_name = "GKE node service account"

  depends_on = [
    google_project_service.required_apis
  ]
}

resource "google_project_iam_member" "gke_nodes_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_nodes_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_nodes_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_container_cluster" "primary" {
  name     = "primary-cluster"
  location = var.primary_zone

  network    = google_compute_network.main.id
  subnetwork = google_compute_subnetwork.primary_gke.id

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  ip_allocation_policy {
    cluster_secondary_range_name  = "primary-pods"
    services_secondary_range_name = "primary-services"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  fleet {
    project = var.project_id
  }

  depends_on = [
    google_compute_subnetwork.primary_gke
  ]
}

resource "google_container_node_pool" "primary_web" {
  name     = "web-pool"
  location = var.primary_zone
  cluster  = google_container_cluster.primary.name

  node_count = 1

  node_config {
    machine_type    = "e2-small"
    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      workload = "web"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

resource "google_container_cluster" "secondary" {
  name     = "secondary-cluster"
  location = var.secondary_zone

  network    = google_compute_network.main.id
  subnetwork = google_compute_subnetwork.secondary_gke.id

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  ip_allocation_policy {
    cluster_secondary_range_name  = "secondary-pods"
    services_secondary_range_name = "secondary-services"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.1.0/28"
  }

  fleet {
    project = var.project_id
  }

  depends_on = [
    google_compute_subnetwork.secondary_gke
  ]
}

resource "google_container_node_pool" "secondary_web" {
  name     = "web-pool"
  location = var.secondary_zone
  cluster  = google_container_cluster.secondary.name

  node_count = 1

  node_config {
    machine_type    = "e2-small"
    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      workload = "web"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}