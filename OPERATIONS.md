# Operations Runbook

## Deploy
- Manual: helm upgrade --install app charts/app -f charts/app/values.<env>.yaml --namespace default
- CI: Triggered on merge/promotion.

## Rollback
- If health checks fail post-deploy: helm rollback app
- CI automates: If smoke test fails, run `helm rollback`.

## Debugging
- App health: kubectl get pods; curl <service>/healthz
- Metrics: kubectl port-forward svc/prometheus 9090; query in browser.
- Logs: gcloud logging read "resource.type=k8s_container"
- HPA: kubectl describe hpa app

## Cleanup
- Destroy infra: cd infra/terraform; terraform destroy
- Unregister runner: GitHub Settings > Actions > Runners > Remove

