Write-Host "Running Kubernetes Preflight Checks..."
helm lint helm/node-app
helm template node-app helm/node-app
kubectl apply --dry-run=client -f k8s/
if (Get-Command kubeconform -ErrorAction SilentlyContinue) {
    kubeconform -summary -verbose -strict -ignore-missing-schemas k8s/
} else {
    Write-Host "kubeconform not installed locally. To install: winget install kubeconform"
}

