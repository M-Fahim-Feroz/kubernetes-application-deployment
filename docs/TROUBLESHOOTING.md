# Troubleshooting Guide — Kubernetes Application Deployment

## Docker Issues

### Build fails

```bash
docker build -t node-app:local .
# Check for Node version issues in Dockerfile
```

### `make docker-build` command not found on Windows

Make is not installed by default on Windows. Use Git Bash or WSL:

```bash
# In Git Bash or WSL:
make docker-build IMAGE_TAG=v1.0.0
```

Or run the equivalent command directly:

```bash
docker build -t node-app:v1.0.0 .
```

## Kubernetes Issues

### Pods stuck in `ImagePullBackOff`

The deployment uses `IMAGE_TAG` as a placeholder. Ensure you are using the rendering workflow:

```bash
make k8s-deploy-rendered IMAGE_TAG=v1.0.0
# NOT: kubectl apply -f k8s/  (this leaves IMAGE_TAG unresolved)
```

### HPA shows `<unknown>` targets

Metrics Server must be installed in your cluster:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### Ingress not routing traffic

Verify an Ingress controller is installed:

```bash
kubectl get pods -n ingress-nginx
# Install if missing:
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace
```

### `kubectl apply` fails with namespace not found

Apply the namespace manifest first:

```bash
kubectl apply -f k8s/namespace.yaml
```

## Helm Issues

### `helm install` fails with existing release

```bash
helm upgrade --install node-app helm/node-app/ -n node-app-namespace
```

### Values not applying

```bash
helm template node-app helm/node-app/ -f helm/node-app/values.yaml  # preview rendered YAML
```

## CI Failures

### Trivy scan fails

```bash
docker build -t node-app:local .
docker run --rm aquasec/trivy image --ignore-unfixed --severity HIGH,CRITICAL node-app:local
```

### kubeconform fails

```bash
kubeconform -strict -ignore-missing-schemas k8s/*.yaml
```
