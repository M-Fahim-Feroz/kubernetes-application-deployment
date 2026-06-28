# Runbook — Kubernetes Application Deployment

## Build and Deploy

```bash
# 1. Build image
make docker-build IMAGE_TAG=v1.0.0

# 2. Render manifests and deploy
make k8s-deploy-rendered IMAGE_TAG=v1.0.0

# 3. Verify
kubectl get pods -n node-app-namespace
```

## Helm Install

```bash
helm install node-app helm/node-app/ --namespace node-app-namespace --create-namespace
helm list -n node-app-namespace
```

## Helm Upgrade

```bash
helm upgrade node-app helm/node-app/ -n node-app-namespace
```

## Scale Deployment

```bash
kubectl scale deployment node-app -n node-app-namespace --replicas=3
```

## View Logs

```bash
kubectl logs -f deployment/node-app -n node-app-namespace
```

## Port Forward (local access)

```bash
kubectl port-forward svc/node-app-service 8080:80 -n node-app-namespace
# Access: http://localhost:8080
```

## Cleanup

```bash
# Remove resources (keep namespace)
make k8s-delete

# Remove everything including namespace
make k8s-delete-all

# Remove Helm release
make helm-uninstall
```
