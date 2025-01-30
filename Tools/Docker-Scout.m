# File for Docker-Scout Installation




docker login

curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s -- -b /usr/local/bin

sudo mkdir -p /tmp/docker-scout/sha256

sudo chmod -R 777 /tmp/docker-scout

sudo usermod -aG docker jenkins

sudo chown -R jenkins:jenkins /var/lib/jenkins/workspace

sudo chmod -R 775 /var/lib/jenkins/workspace
