# File for Helm Installation

sudo snap install helm --classic


### for making connectivity between the Prometheus and KUberenetes Cluster to view the metrics of Cluster follow below steps

kubectl create namespace prometheus-node-exporter

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm install prometheus-node-exporter prometheus-community/prometheus-node-exporter --namespace prometheus-node-exporter
