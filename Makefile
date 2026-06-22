.PHONY: docker-build k8s-apply k8s-delete helm-lint helm-template helm-install helm-uninstall

docker-build:
	docker build -t node-app:latest .

k8s-apply:
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/

k8s-delete:
	kubectl delete -f k8s/

helm-lint:
	helm lint helm/node-app/

helm-template:
	helm template node-app helm/node-app/

helm-install:
	helm upgrade --install node-app helm/node-app/ --namespace node-app-namespace --create-namespace

helm-uninstall:
	helm uninstall node-app --namespace node-app-namespace
