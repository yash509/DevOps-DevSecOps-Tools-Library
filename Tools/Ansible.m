# Anisble installation commands

exec > >(tee -i /var/log/user-data.log)
exec 2>&1
sudo apt update -y
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo apt install git -y 




---- New 2026

exec > >(tee -i /var/log/user-data.log)
exec 2>&1

# Update system
sudo apt update -y
sudo apt upgrade -y

# Install Ansible directly from Ubuntu repos (no PPA needed)
sudo apt install ansible -y
apt install ansible-core -y

# Install Git
sudo apt install git -y

