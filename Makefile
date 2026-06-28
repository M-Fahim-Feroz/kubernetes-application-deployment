.PHONY: docker-build k8s-apply k8s-delete helm-lint helm-template helm-install helm-uninstall k8s-render k8s-deploy-rendered

IMAGE_TAG ?= latest

docker-build:
	docker build -t node-app:$(IMAGE_TAG) .

k8s-render:
	@echo "Rendering manifests with IMAGE_TAG=$(IMAGE_TAG)"
	@mkdir -p .rendered
	@cp -r k8s/* .rendered/
	@sed -i.bak "s/IMAGE_TAG/$(IMAGE_TAG)/g" .rendered/deployment.yaml && rm -f .rendered/deployment.yaml.bak

k8s-deploy-rendered: k8s-render
	kubectl apply -f .rendered/namespace.yaml
	kubectl apply -f .rendered/configmap.yaml
	kubectl apply -f .rendered/secret.yaml
	kubectl apply -f .rendered/deployment.yaml
	kubectl apply -f .rendered/service.yaml
	kubectl apply -f .rendered/ingress.yaml
	kubectl apply -f .rendered/hpa.yaml
	kubectl apply -f .rendered/networkpolicy.yaml

k8s-apply:
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/configmap.yaml
	kubectl apply -f k8s/secret.yaml
	kubectl apply -f k8s/deployment.yaml
	kubectl apply -f k8s/service.yaml
	kubectl apply -f k8s/ingress.yaml
	kubectl apply -f k8s/hpa.yaml
	kubectl apply -f k8s/networkpolicy.yaml

k8s-delete:
	kubectl delete -f k8s/networkpolicy.yaml --ignore-not-found
	kubectl delete -f k8s/hpa.yaml --ignore-not-found
	kubectl delete -f k8s/ingress.yaml --ignore-not-found
	kubectl delete -f k8s/service.yaml --ignore-not-found
	kubectl delete -f k8s/deployment.yaml --ignore-not-found
	kubectl delete -f k8s/secret.yaml --ignore-not-found
	kubectl delete -f k8s/configmap.yaml --ignore-not-found

k8s-delete-all: k8s-delete
	kubectl delete -f k8s/namespace.yaml --ignore-not-found

helm-lint:
	helm lint helm/node-app/

helm-template:
	helm template node-app helm/node-app/

helm-install:
	helm install node-app helm/node-app/ --namespace node-app-namespace --create-namespace

helm-uninstall:
	helm uninstall node-app --namespace node-app-namespace --ignore-not-found

helm-reset: helm-uninstall
