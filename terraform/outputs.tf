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

output "primary_cluster_name" {
  description = "Name of the primary GKE cluster."
  value       = google_container_cluster.primary.name
}

output "secondary_cluster_name" {
  description = "Name of the secondary GKE cluster."
  value       = google_container_cluster.secondary.name
}

output "primary_cluster_region" {
  description = "Region of the primary GKE cluster."
  value       = google_container_cluster.primary.location
}

output "secondary_cluster_region" {
  description = "Region of the secondary GKE cluster."
  value       = google_container_cluster.secondary.location
}

output "primary_get_credentials_command" {
  description = "Command to configure kubectl for the primary cluster."
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${google_container_cluster.primary.location} --project ${var.project_id}"
}

output "secondary_get_credentials_command" {
  description = "Command to configure kubectl for the secondary cluster."
  value       = "gcloud container clusters get-credentials ${google_container_cluster.secondary.name} --region ${google_container_cluster.secondary.location} --project ${var.project_id}"
}

output "app_global_ip" {
  description = "Global static IP for the external application endpoint."
  value       = google_compute_global_address.app.address
}