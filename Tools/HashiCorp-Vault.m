sudo apt install -y apt-utils

wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault
vault --version
vault



# Temporarily disable TLS to check if Vault starts correctly. Modify the listener in vault.hcl
//
sudo vi /etc/vault.d/vault.hcl
//

#add this below as script
//
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1 //this portion only
}
//

//
sudo systemctl enable vault
sudo systemctl start vault
sudo systemctl status vault
//

//
sudo ss -tuln | grep 8200
export VAULT_ADDR="http://<ec2-ip>:8200"
vault status
//

# Open a terminal and create the Vault service file using a text editor like vi or nano.
sudo vi /etc/systemd/system/vault.service

# Paste the following content into the file
//
[Unit]
Description=HashiCorp Vault - A tool for managing secrets
Documentation=https://developer.hashicorp.com/vault/docs
Requires=network-online.target
After=network-online.target

[Service]
User=root
Group=root
ExecStart=/usr/bin/vault server -config=/etc/vault.d/vault.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
//

sudo systemctl daemon-reload

sudo systemctl enable vault
sudo systemctl start vault
sudo systemctl status vault




echo 'export VAULT_ADDR="http://<vault-server-ip>:8200"' >> ~/.bashrc 
source ~/.bashrc


# This below command will output:
	# 5 unseal keys (used to unseal Vault).	
	# Root token (used to log in and manage Vault)
//	
vault operator init
//



Important:
Save these keys securely (e.g., password manager, encrypted storage). Losing them can lock you out of Vault.
You’ll need at least 3 unseal keys to unseal Vault.

# Use the vault operator unseal command with three of the unseal keys generated during initialization:
vault operator unseal <UNSEAL_KEY_1>
vault operator unseal <UNSEAL_KEY_2>
vault operator unseal <UNSEAL_KEY_3>


# For login into the vault use the below command
vault login <root_token>




# Now, storing the AWS Credentials in Vault follow the below steps
1. Use the below command to Enable the KV Secrets Engine in Vault:
//
vault secrets enable -path=aws kv
//

2. Use the below command to Verify that the secrets engine is enabled:
//
vault secrets list
//

3. Use the below command to Add your AWS credentials (Access Key ID and Secret Access Key) to Vault:
//
vault kv put aws/terraform-project aws_access_key_id=<your-access-key-id> aws_secret_access_key=<your-secret-access-key>
//
//aws: Represents a namespace or folder for AWS-related secrets in Vault.
//terraform-project: Represents a specific Terraform project using AWS credentials.

4. Use the below command to Verify that the secret is stored:
//
vault kv get aws/terraform-project
//

5. Use the below commands to Configure Vault Authentication:
5.1. Use the below command to Enable AppRole Authentication:
//
vault auth enable approle
//

5.2. Create a Policy for Access: Create a policy file, e.g., aws-policy.hcl:
//
path "aws/terraform-project" {
    capabilities = ["read"]
}
//
Apply the policy by using the below command:
//
vault policy write aws-policy aws-policy.hcl
vault write auth/approle/role/cicd-role token_policies="aws-policy"
//

5.3. Create an AppRole using the below command:
//
vault write auth/approle/role/cicd-role token_policies="aws-policy" secret_id_ttl=24h \
    token_ttl=1h \
    token_max_ttl=4h
//
	
5.4. Retrieve Role ID and Secret ID using the below command:
//
vault read auth/approle/role/cicd-role/role-id
vault write -f auth/approle/role/cicd-role/secret-id
//


Install the 3 new Plugins on Jenkins:
HashiCorp Vault
HashiCorp Vault Pipeline
Amazon EC2










// below is the sample Pipeline scriptn to implement the HashiCorp Vault in the Jenkins CI/CD Pipeline
pipeline {
    agent any

    environment {
        VAULT_URL = 'http://:8200/' // Vault server URL needs to be changed everytime manually
    }

    stages {
        
        stage("Debug Vault Credentials") {
            steps {
                script {
                    echo "Verifying Vault Credentials Configuration..."
                    withCredentials([
                        string(credentialsId: 'VAULT_URL', variable: 'VAULT_URL'),
                        string(credentialsId: 'vault-role-id', variable: 'VAULT_ROLE_ID'),
                        string(credentialsId: 'vault-secret-id', variable: 'VAULT_SECRET_ID')
                    ]) {
                        echo "Vault Role ID is available"
                        echo "Vault Secret ID is available"
                    }
                }
            }
        }

        stage("Test Vault Connectivity and Login") {
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'VAULT_URL', variable: 'VAULT_URL'),
                        string(credentialsId: 'vault-role-id', variable: 'VAULT_ROLE_ID'),
                        string(credentialsId: 'vault-secret-id', variable: 'VAULT_SECRET_ID')
                    ]) {
                        echo "Testing Vault Connectivity..."
                        sh '''
                        # Set Vault address
                        export VAULT_ADDR="${VAULT_URL}"

                        # Log into Vault using AppRole
                        echo "Logging into Vault using AppRole..."
                        VAULT_TOKEN=$(vault write -field=token auth/approle/login role_id=${VAULT_ROLE_ID} secret_id=${VAULT_SECRET_ID})
                        echo "Vault Login Successful"

                        # Verify connectivity
                        vault status
                        '''
                    }
                }
            }
        }
        
        stage("Fetch Credentials from Vault") {
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'VAULT_URL', variable: 'VAULT_URL'),
                        string(credentialsId: 'vault-role-id', variable: 'VAULT_ROLE_ID'),
                        string(credentialsId: 'vault-secret-id', variable: 'VAULT_SECRET_ID')
                        ]) 
                        {
                            echo "Fetching GitHub and AWS credentials from Vault..."
                            // Fetch secrets with error handling
                            sh '''
                            # Set Vault server URL
                            export VAULT_ADDR="${VAULT_URL}"
                            
                            # Log into Vault using AppRole
                            echo "Logging into Vault..."
                            VAULT_TOKEN=$(vault write -field=token auth/approle/login role_id=${VAULT_ROLE_ID} secret_id=${VAULT_SECRET_ID} || { echo "Vault login failed"; exit 1; })
                            export VAULT_TOKEN=$VAULT_TOKEN
                            
                            # Fetch GitHub token
                            # echo "Fetching GitHub Token..."
                            # GIT_TOKEN=$(vault kv get -field=pat secret/github || { echo "Failed to fetch GitHub token"; exit 1; })
                            
                            # Fetch AWS credentials
                            echo "Fetching AWS Credentials..."
                            AWS_ACCESS_KEY_ID=$(vault kv get -field=aws_access_key_id aws/terraform-project || { echo "Failed to fetch AWS Access Key ID"; exit 1; })
                            AWS_SECRET_ACCESS_KEY=$(vault kv get -field=aws_secret_access_key aws/terraform-project || { echo "Failed to fetch AWS Secret Access Key"; exit 1; })
                            
                            # Export credentials to environment variables
                            echo "Exporting credentials to environment..."
                            echo "export GIT_TOKEN=${GIT_TOKEN}" >> vault_env.sh
                            echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" >> vault_env.sh
                            echo "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" >> vault_env.sh
                            '''
                            // Load credentials into environment
                            sh '''
                            echo "Loading credentials into environment..."
                            . ${WORKSPACE}/vault_env.sh
                            echo "Credentials loaded successfully."
                            '''
                        }
                }
            }
        }
        
        stage('Checkout from Git') {                        
            steps {                                       
                git branch: 'main', url: 'https://github.com/yash509/DevSecOps-ChrmeLog-Wp-Deployment.git'
            }
        }
        
        stage("Docker Image Building"){
            steps{
                script{
                    //dir('Band Website') {
                        withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){   
                            sh "docker build -t vault-test ." 
                            
                        //}
                    }
                }
            }
        }
        
        stage("Docker Image Tagging"){
            steps{
                script{
                    //dir('Band Website') {
                        withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){
                            sh "docker tag vault-test yash5090/vault-test:latest " 
                        //}
                    }
                }
            }
        }
        
        stage("Image Push to DockerHub") {
            steps{
                script{
                    //dir('Band Website') {
                        withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                            sh "docker push yash5090/vault-test:latest "
                        //}
                    }
                }
            }
        }
        
        // stage('Deploy to Docker Container'){
        //     steps{
        //         //dir('BMI Calculator (JS)') {
        //             sh 'docker run -d --name vault-test -p 5000:80 yash5090/vault-test:latest' 
        //         //}
        //     }
        // }
        
    }
}


// For future references we can use the below links or notes or articles
https://blog.devops.dev/step-by-step-guide-using-hashicorp-vault-to-secure-aws-credentials-in-jenkins-ci-cd-pipelines-with-6a3971c63580
https://blog.devops.dev/end-to-end-aws-eks-provisioning-with-terraform-jenkins-ci-cd-and-hashicorp-vault-6caf11cb2d2c
