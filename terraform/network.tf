resource "google_compute_network" "main" {
  name                    = "vpc"
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.required_apis
  ]
}

resource "google_compute_subnetwork" "primary_gke" {
  name          = "primary-gke-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.primary_region
  network       = google_compute_network.main.id

  secondary_ip_range {
    range_name    = "primary-pods"
    ip_cidr_range = "10.20.0.0/16"
  }

  secondary_ip_range {
    range_name    = "primary-services"
    ip_cidr_range = "10.30.0.0/20"
  }
}

resource "google_compute_subnetwork" "secondary_gke" {
  name          = "secondary-gke-subnet"
  ip_cidr_range = "10.11.0.0/24"
  region        = var.secondary_region
  network       = google_compute_network.main.id

  secondary_ip_range {
    range_name    = "secondary-pods"
    ip_cidr_range = "10.21.0.0/16"
  }

  secondary_ip_range {
    range_name    = "secondary-services"
    ip_cidr_range = "10.31.0.0/20"
  }
}