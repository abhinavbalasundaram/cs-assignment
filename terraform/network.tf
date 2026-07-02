resource "google_compute_network" "main" {
  name                    = "vpc"
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.required_apis
  ]
}

resource "google_compute_subnetwork" "primary_gke" {
  name                     = "primary-gke-subnet"
  ip_cidr_range            = "10.10.0.0/24"
  region                   = var.primary_region
  network                  = google_compute_network.main.id
  private_ip_google_access = true

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
  name                     = "secondary-gke-subnet"
  ip_cidr_range            = "10.11.0.0/24"
  region                   = var.secondary_region
  network                  = google_compute_network.main.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "secondary-pods"
    ip_cidr_range = "10.21.0.0/16"
  }

  secondary_ip_range {
    range_name    = "secondary-services"
    ip_cidr_range = "10.31.0.0/20"
  }
}

resource "google_compute_router" "primary" {
  name    = "primary-router"
  region  = var.primary_region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "primary" {
  name                               = "primary-nat"
  router                             = google_compute_router.primary.name
  region                             = var.primary_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.primary_gke.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_router" "secondary" {
  name    = "secondary-router"
  region  = var.secondary_region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "secondary" {
  name                               = "secondary-nat"
  router                             = google_compute_router.secondary.name
  region                             = var.secondary_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.secondary_gke.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_global_address" "app" {
  name = "app-global-ip"

  depends_on = [
    google_project_service.required_apis
  ]
}