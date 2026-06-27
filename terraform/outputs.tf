output "project_id" {
  description = "The GCP project ID used by this environment."
  value       = var.project_id
}

output "primary_region" {
  description = "Primary GCP region."
  value       = var.primary_region
}

output "secondary_region" {
  description = "Secondary GCP region."
  value       = var.secondary_region
}

output "enabled_apis" {
  description = "APIs enabled for this project."
  value       = sort(keys(google_project_service.required_apis))
}

output "vpc_name" {
  description = "Name of the VPC created."
  value       = google_compute_network.main.name
}

output "primary_gke_subnet" {
  description = "Primary GKE subnet name."
  value       = google_compute_subnetwork.primary_gke.name
}

output "secondary_gke_subnet" {
  description = "Secondary GKE subnet name."
  value       = google_compute_subnetwork.secondary_gke.name
}

output "primary_gke_pod_range" {
  description = "Secondary range used for primary cluster Pods."
  value       = "primary-pods"
}

output "primary_gke_service_range" {
  description = "Secondary range used for primary cluster Services."
  value       = "primary-services"
}

output "secondary_gke_pod_range" {
  description = "Secondary range used for secondary cluster Pods."
  value       = "secondary-pods"
}

output "secondary_gke_service_range" {
  description = "Secondary range used for secondary cluster Services."
  value       = "secondary-services"
}