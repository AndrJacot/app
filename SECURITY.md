# Security & Hardening Notes

## Threat Model
- Assume external actors may attempt to compromise CI/CD, cluster, or app.
- Mitigations: Least-privilege IAM, OIDC auth, image scanning, secrets encryption.

## Hardening
- Docker: Non-root, multi-stage builds.
- K8s: Private cluster, RBAC, HPA limits.
- CI: OIDC for GCP (no long-lived keys), Trivy scans fail on critical/high.
- Secrets: Use GCP Secret Manager (encrypted at rest). Trade-offs vs. ExternalSecrets: Native Secrets are simpler but less dynamic; ExternalSecrets allow syncing from external stores like Vault but add complexity. Here, we use native Secrets mounted as env vars for SYS_ENV.
- IaC Scan: Checkov in CI fails on high issues.
- Observability: Structured logs to GCP Logging; Prometheus metrics exposed.

## Recommendations
- Enable GCP audit logging.
- Use mTLS for ingress if production.
- Rotate secrets regularly.

