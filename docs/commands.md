# Useful Kubernetes Commands

This document provides a cheat sheet for verifying, troubleshooting, and managing the Kubernetes deployment.

## Cluster Info
```bash
# Get cluster info
kubectl cluster-info

# List all nodes
kubectl get nodes
```

## Pod & Deployment Management
```bash
# Get all resources
kubectl get all -n node-app-namespace

# Get HorizontalPodAutoscaler
kubectl get hpa -n node-app-namespace

# Watch pods spin up
kubectl get pods -n node-app-namespace -w

# Check deployment status
kubectl rollout status deployment/node-app -n node-app-namespace

# View logs for the deployment
kubectl logs -n node-app-namespace deployment/node-app

# Port forward to the service for local testing without Ingress
kubectl port-forward -n node-app-namespace service/node-app 8080:80
```

## Networking & Security
```bash
# View Ingress resources
kubectl get ingress -n node-app-namespace

# View NetworkPolicy
kubectl get networkpolicy -n node-app-namespace

# List services
kubectl get svc -n node-app-namespace
```

## ConfigMaps and Secrets
```bash
# View the ConfigMap
kubectl get configmap node-app-config -n node-app-namespace -o yaml

# View the Secret (encoded)
kubectl get secret node-app-secret -n node-app-namespace -o yaml
```

## Helm Specific Commands
```bash
# Lint the chart
helm lint ./helm/node-app

# Generate template from the chart
helm template node-app ./helm/node-app

# Install the chart
helm install node-app ./helm/node-app -n node-app-namespace --create-namespace

# Uninstall the chart
helm uninstall node-app -n node-app-namespace
```

## Safe Cleanup & Reset
```bash
# Delete raw resources without deleting namespace
kubectl delete -f k8s/networkpolicy.yaml,k8s/hpa.yaml,k8s/ingress.yaml,k8s/service.yaml,k8s/deployment.yaml,k8s/secret.yaml,k8s/configmap.yaml

# Delete namespace only when intentionally resetting the environment
kubectl delete -f k8s/namespace.yaml

# Check namespace status (Useful if it gets stuck in Terminating)
kubectl get ns node-app-namespace

# Wait until namespace is fully deleted before reinstalling Helm
kubectl get ns
```
