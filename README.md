# Project Overview & Quickstart

This repository sets up a minimal production-sensible Kubernetes application on GKE with CI/CD using GitHub Actions.

## Components
- **app/**: Python Flask HTTP service with /healthz endpoint.
- **charts/**: Helm chart for deploying the app.
- **infra/terraform/**: Terraform for GKE, VPC, Artifact Registry, IAM.
- **infra/ansible/**: Ansible to provision local containerized GitHub runner with Docker support.
- **.github/workflows/**: CI/CD pipelines.
- **SECURITY.md**: Security notes.
- **OPERATIONS.md**: Runbooks.

## Quickstart
1. **Prerequisites**:
   - GCP account with billing enabled.
   - GitHub repo with Actions enabled.
   - Terraform, Ansible, Docker, Python installed locally.
   - For macOS M1: Install Docker Desktop[](https://www.docker.com/products/docker-desktop/).
   - GCP credentials: `gcloud auth application-default login`.
   - GitHub PAT or repo access for runner registration.

2. **Provision Infrastructure**:
   - cd infra/terraform
   - terraform init
   - terraform apply -var="project_id=<your-gcp-project-id>"

3. **Setup Local DinD Runner**:
   - cd infra/ansible
   - ansible-playbook -i inventories/local.ini playbooks/runner.yml --extra-vars "github_repo=<owner/repo> github_token=<registration-token>"

4. **Run Locally**:
   - See app/README.md

5. **CI/CD**:
   - Push to main or open PR to trigger workflows.

6. **Destroy**:
   - terraform destroy
   - Unregister runner from GitHub settings.

