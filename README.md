# DevOps-DevSecOps-Tools-Library
A library for the installation of various tools for the DevOps and DevSecOps Work



# Kubernetes Setup on EC2 Server

## aws eks update-kubeconfig --name <CLUSTER NAME> --region <CLUSTER REGION> 
# aws eks update-kubeconfig --name EKS_CLOUD --region ap-south-1

# kubectl get nodes

# cat /root/.kube/config
or
ls -la
cd .kube/
cat config

# Then, Copy the config file to Jenkins master or the local file manager and save it
# Then, goto manage Jenkins –> manage credentials –> Click on Jenkins global –> add credentials
