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

variable "primary_zone" {
  description = "Primary GCP zone for the first GKE cluster."
  type        = string
  default     = "us-central1-a"
}

variable "secondary_zone" {
  description = "Secondary GCP zone for the second GKE cluster."
  type        = string
  default     = "us-east1-b"
}

variable "name_prefix" {
  description = "Prefix used for naming project resources."
  type        = string
  default     = "cs-assignment"
}