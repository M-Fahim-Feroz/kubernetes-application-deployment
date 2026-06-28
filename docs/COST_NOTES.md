# Cost Notes — Kubernetes Application Deployment

This project deploys to a Kubernetes cluster. Costs depend entirely on where the cluster is hosted.

## Cost by Cluster Type

| Cluster | Cost |
|---|---|
| minikube / kind (local) | Free |
| Docker Desktop Kubernetes (local) | Free |
| k3s on a local VM | Free |
| AWS EKS | ~$73/month (cluster) + node costs |
| Azure AKS | ~$70–90/month for a single-node demo |
| GKE Autopilot | Pay per pod (~$0.05/vCPU-hour) |

## Recommendations for Zero-Cost Testing

1. **minikube** — easiest local option:

   ```bash
   minikube start
   eval $(minikube docker-env)
   make docker-build IMAGE_TAG=v1.0.0
   make k8s-deploy-rendered IMAGE_TAG=v1.0.0
   ```

2. **Docker Desktop** — enable Kubernetes in settings, then use `make k8s-deploy-rendered`.

3. **kind (Kubernetes in Docker)** — for CI-like local testing.

## Notes

- All CI validation (Trivy, kubeconform, helm lint) runs for free on GitHub Actions (public repo).
- No cloud resources are provisioned by the CI pipeline in this repository.
