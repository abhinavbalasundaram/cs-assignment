resource "google_bigquery_dataset" "logs" {
  dataset_id  = "gke_logs"
  description = "Dataset for GKE and load balancer logs exported from Cloud Logging"
  location    = "US"

  delete_contents_on_destroy = true

  depends_on = [
    google_project_service.required_apis
  ]
}

resource "google_logging_project_sink" "gke_logs_to_bigquery" {
  name        = "gke-logs-to-bigquery"
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.logs.dataset_id}"

  filter = <<-EOT
    resource.type="k8s_container"
    OR resource.type="http_load_balancer"
  EOT

  unique_writer_identity = true

  depends_on = [
    google_bigquery_dataset.logs
  ]
}

resource "google_bigquery_dataset_iam_member" "log_sink_writer" {
  dataset_id = google_bigquery_dataset.logs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.gke_logs_to_bigquery.writer_identity
}

resource "google_service_account" "grafana_bigquery" {
  account_id   = "grafana-bigquery"
  display_name = "Grafana BigQuery data source service account"
}

resource "google_project_iam_member" "grafana_bigquery_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.grafana_bigquery.email}"
}

resource "google_bigquery_dataset_iam_member" "grafana_bigquery_data_viewer" {
  dataset_id = google_bigquery_dataset.logs.dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:${google_service_account.grafana_bigquery.email}"
}