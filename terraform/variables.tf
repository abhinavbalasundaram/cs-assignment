variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "primary_region" {
  description = "Primary GCP region for the first GKE cluster."
  type        = string
  default     = "us-central1"
}

variable "secondary_region" {
  description = "Secondary GCP region for the second GKE cluster."
  type        = string
  default     = "us-east1"
}

variable "name_prefix" {
  description = "Prefix used for naming project resources."
  type        = string
  default     = "cs-assignment"
}