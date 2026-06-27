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