.PHONY: docker-build k8s-apply k8s-delete helm-lint helm-template helm-install helm-uninstall

docker-build:
	docker build -t node-app:latest .

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
