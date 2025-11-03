resource "google_project_service" "api" {
  for_each = toset(local.apis)
  service  = each.key

  disable_on_destroy = false
}

resource "google_compute_network" "vpc" {
  name                    = "k8s-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = "10.0.1.0/24"
  region        = local.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2"
  ip_cidr_range = "10.0.2.0/24"
  region        = local.region
  network       = google_compute_network.vpc.id
}

resource "google_container_cluster" "cluster" {
  name     = "app-cluster"
  location = local.region

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.subnet1.id

  enable_autopilot = true
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
}

resource "google_artifact_registry_repository" "registry" {
  location      = local.region
  repository_id = "app-repo"
  format        = "DOCKER"
}

resource "google_service_account" "ci_sa" {
  account_id   = "github-ci-sa"
  display_name = "CI Service Account"
}

resource "google_project_iam_member" "ci_artifact_writer" {
  project = local.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.ci_sa.email}"
}

resource "google_project_iam_member" "ci_gke_developer" {
  project = local.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.ci_sa.email}"
}

// For OIDC with GitHub
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "github-pool"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  attribute_mapping                  = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }
  attribute_condition                = "assertion.repository == 'AndrJacot/app'"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "ci_wif" {
  service_account_id = google_service_account.ci_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/AndrJacot/app"
}

resource "google_secret_manager_secret" "sys_env" {
  secret_id = "sys-env"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "sys_env_version" {
  secret = google_secret_manager_secret.sys_env.id

  secret_data = "helloworld"
}
