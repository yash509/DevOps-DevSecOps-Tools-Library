# Anisble installation commands

exec > >(tee -i /var/log/user-data.log)
exec 2>&1
sudo apt update -y
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo apt install git -y 
mkdir Ansible && cd Ansible
vi synk.yml
- name: Install DevOps Tools
  hosts: localhost
  become: yes
  tasks:
    - name: Download and install Snyk
      ansible.builtin.get_url:
        url: https://static.snyk.io/cli/latest/snyk-linux
        dest: /usr/local/bin/snyk
        mode: '0755'
ansible-playbook -i localhost synk.yml
