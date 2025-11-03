output "cluster_name" {
  value = google_container_cluster.cluster.name
}

output "registry_url" {
  value = "${local.region}-docker.pkg.dev/${local.project_id}/${google_artifact_registry_repository.registry.repository_id}"
}

output "ci_sa_email" {
  value = google_service_account.ci_sa.email
}

output "workload_identity_pool" {
  value = google_iam_workload_identity_pool.github_pool.name
}
