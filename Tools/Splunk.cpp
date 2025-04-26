# commands to install Splunk on both Ubuntu and Linux

1. wget -O splunk-9.1.1-64e843ea36b1-linux-2.6-amd64.deb "https://download.splunk.com/products/splunk/releases/9.1.1/linux/splunk-9.1.1-64e843ea36b1-linux-2.6-amd64.deb"

2. sudo dpkg -i splunk-9.1.1-64e843ea36b1-linux-2.6-amd64.deb
  
3. sudo /opt/splunk/bin/splunk enable boot-start

4. sudo ufw allow openSSH --> The command sudo ufw allow OpenSSH is used to allow incoming SSH traffic through the UFW (Uncomplicated Firewall) on your Ubuntu system. It’s essential for enabling SSH access to your server.
-- By running the above 4th command, you ensure that SSH access is permitted through your firewall, which is crucial for remote server management and administration.

5. sudo ufw allow 8000 --> The command sudo ufw allow 8000 is used to allow incoming network traffic on port 8000 through the UFW (Uncomplicated Firewall) on your Ubuntu system. It permits access to a specific port for network services or applications.
-- Port 8000 is the default port for the Splunk Frontend

6. sudo ufw status --> This command allows you to check the status of your UFW firewall. It will display information about whether the firewall is active, which rules are enabled, and whether it’s set to allow or deny specific types of traffic.

7. sudo ufw enable --> This command is used to enable the UFW firewall if it’s not already active. Enabling the firewall ensures that the rules you’ve configured or will configure are enforced.
-- By running the 6th & 7th commands, you can both check the current status of your firewall and activate it to apply the defined rules and settings.

8. sudo /opt/splunk/bin/splunk start --> The command is used to start the Splunk Enterprise application on your system. When you run this command with superuser privileges (using sudo), it initiates the Splunk service, allowing you to begin using the Splunk platform for data analysis, monitoring, and other data-related tasks.

9. sudo ufw allow 8088 --> The command sudo ufw allow 8088 is used to allow incoming network traffic on port 8088 through the UFW (Uncomplicated Firewall) on your Ubuntu system. It permits access to a specific port for network services or applications.

10. sudo ufw status --> This command allows you to check the status of your UFW firewall. It will display information about whether the firewall is active, which rules are enabled, and whether it’s set to allow or deny specific types of traffic.

11.   

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
-- Once the Splunk is active and its Frontend is running on the port 8000 on browser then follow the below steps to configure it on Jenkins and for Jenkins

----> Splunk Configuration for Jenkins
In Splunk Dashboard/Frontend
1. Click on Apps –> Find more apps
2. Search for Jenkins in the Search bar
3. You will get the Splunk app for Jenkins and click on install
4. You will be prompted to provide your Splunk credentials. That’s why we have to create a personal Splunk account firstly before getting started with Splunk installation on ubuntu/linux
5. Click on Agree and install
6. Now click on Go home
7. On the homepage of Splunk, you will see Jenkins has been added
8. In the Splunk web interface/Frontend, go to Settings > Data Inputs.
9. Click on HTTP Event Collector.
10. Click on Global Settings
11. Set All tokens to enabled
12. Uncheck SSL enable --> If doesn't have SSL
13. Use 8088 port and click on save
14. Now click on New token --> For generating Splunk Token for its use in Jenkins
15. Provide a Name and click on the next
16. Click Review
17. Click Submit
18. Click Start searching
19. Now let’s copy our token again In the Splunk web interface, go to Settings > Data Inputs

----> Jenkins Configuration for Splunk usage 
Go to Jenkins dashboard
1. Click on Manage Jenkins –> Plugins –> Available plugins
2. Search for Splunk and install it.
3. Again Click on Manage Jenkins –> System
4. Search for Splunk
5. Check to enable checkbox
6. HTTP input host as SPLUNK PUBLIC IP
7. HTTP token that you generated in Splunk
8. Jenkins IP and apply.
9. Now in the Jenkins dashboard Under Splunk click on Test connection

