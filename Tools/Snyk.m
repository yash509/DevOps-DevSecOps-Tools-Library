# Synk Installation using Ansible Playbook

Install Anisble Firstly
Make Directory Ansible
Then create a "yaml" file ansible-playbook in the above directory

vi synk.yaml

---
- name: Install DevOps Security Tool
  hosts: localhost
  become: yes
  tasks:
    - name: Download and install Snyk
      ansible.builtin.get_url:
        url: https://static.snyk.io/cli/latest/snyk-linux
        dest: /usr/local/bin/snyk
        mode: '0755'
---

after saving the above "yaml" file run the command for Intallation of Synk: 
ansible-playbook -i localhost synk.yaml
