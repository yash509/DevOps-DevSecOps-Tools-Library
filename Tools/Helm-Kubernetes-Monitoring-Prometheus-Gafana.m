curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh


helm version --client


helm repo add stable https://charts.helm.sh/stable


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts


kubectl create namespace prometheus


helm install stable prometheus-community/kube-prometheus-stack -n prometheus


kubectl get pods -n prometheus


kubectl get svc -n prometheus



--- To make Prometheus and grafana available outside the cluster, use LoadBalancer or NodePort instead of ClusterIP.
--- change ClusterIP to LoadBalancer in the below 2 files

kubectl edit svc stable-kube-prometheus-sta-prometheus -n prometheus
kubectl edit svc stable-grafana -n prometheus


kubectl get svc -n prometheus




login to grafana:- (Creds)
UserName: admin 
Password: prom-operator


For creating a dashboard to monitor the cluster: 15661, 3119, 6417
