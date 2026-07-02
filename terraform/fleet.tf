resource "google_gke_hub_feature" "mcs" {
  name     = "multiclusterservicediscovery"
  location = "global"
  project  = var.project_id

  depends_on = [
    google_container_cluster.primary,
    google_container_cluster.secondary
  ]
}

resource "google_gke_hub_feature" "mci" {
  name     = "multiclusteringress"
  location = "global"
  project  = var.project_id

  spec {
    multiclusteringress {
      config_membership = "projects/${var.project_id}/locations/${var.primary_region}/memberships/primary-cluster"
    }
  }

  depends_on = [
    google_gke_hub_feature.mcs,
    google_container_cluster.primary,
    google_container_cluster.secondary
  ]
}