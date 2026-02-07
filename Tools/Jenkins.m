# Commands for Jenkins Installation


sudo apt update
sudo apt install openjdk-17-jre -y
wget https://pkg.jenkins.io/debian-stable/binary/jenkins_2.541.1_all.deb
sudo apt install ./jenkins_2.541.1_all.deb -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins


steps to change the default port  ->
sudo mkdir -p /etc/systemd/system/jenkins.service.d
sudo nano /etc/systemd/system/jenkins.service.d/override.conf

Paste this below content:
[Service]
ExecStart=
ExecStart=/usr/bin/java -Djava.awt.headless=true -jar /usr/share/java/jenkins.war --httpPort=9099

The blank ExecStart= clears the original command.
The second ExecStart forces Jenkins to run on port 9099.
Save and exit (CTRL+O, Enter, CTRL+X).

then restart again using below cmds:
sudo systemctl daemon-reload
sudo systemctl restart jenkins


