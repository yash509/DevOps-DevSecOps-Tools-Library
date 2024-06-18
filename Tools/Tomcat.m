# Install Tomcat on Port 8083 and finally deploy on Apache Tomcat, Before we add Pipeline Script, we need to install and configure Tomcat on our server.


# Here are the steps to install Tomcat 9

cd /opt

sudo wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz (Another link)

sudo tar -xvf apache-tomcat-9.0.65.tar.gz

## Move to the conf directory and change the port in the Tomcat server to another port from the default port
cd /opt/apache-tomcat-9.0.65/conf
vi server.xml

## Update Tomcat users’ XML file for manager app login
cd /opt/apache-tomcat-9.0.65/conf
sudo vi tomcat-users.xml

## —add-below-line at the end (2nd-last line)—-
<user username="admin" password="admin1234" roles="admin-gui, manager-gui"/>

## Create a symbolic link for the direct start and stop of Tomcat
sudo ln -s /opt/apache-tomcat-9.0.65/bin/startup.sh /usr/bin/startTomcat
sudo ln -s /opt/apache-tomcat-9.0.65/bin/shutdown.sh /usr/bin/stopTomcat

## Go to this path and comment below lines in manager
sudo vi /opt/apache-tomcat-9.0.65/webapps/manager/META-INF/context.xml
## comment these below lines
<!-- Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->

## Go to this path and comment below lines in host-manager
sudo vi /opt/apache-tomcat-9.0.65/webapps/host-manager/META-INF/context.xml
## comment these below lines
<!-- Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->


sudo stopTomcat
sudo startTomcat


# Certainly! To allow both ubuntu and Jenkins users to copy the petclinic.war file to the /opt/apache-tomcat-9.0.65/webapps/ directory without entering passwords, you can add the appropriate entries to the /etc/sudoers file. Here’s how you can do it:
# Open the terminal.
# Use the sudo command to edit the sudoers file using a text editor like visudo:
sudo visudo

# Scroll down to an appropriate section (e.g., just below the line with %sudo ALL=(ALL:ALL) ALL) and add the following lines:
# after workspace change your job name 
ubuntu ALL=(ALL) NOPASSWD: /bin/cp /var/lib/jenkins/workspace/petclinic/target/petclinic.war /opt/apache-tomcat-9.0.65/webapps/
jenkins ALL=(ALL) NOPASSWD: /bin/cp /var/lib/jenkins/workspace/petclinic/target/petclinic.war /opt/apache-tomcat-9.0.65/webapps/


Save the file and exit the text editor.

By adding these lines, you’re allowing both the Ubuntu user and the Jenkins user to run the specified cp command without being prompted for a password.

After making these changes, both users should be able to run the Jenkins job that copies the petclinic.war file to the specified directory without encountering permission issues. Always ensure that you’re cautious when editing the sudoers file and that you verify the paths and syntax before saving any changes.

Since 8080 is being used by Jenkins, we have used Port 8083 to host the Tomcat Server


# Jenkinsfile Tomcat Server Deployment Stage
stage("Deploy To Tomcat"){
            steps{
                sh "cp  /var/lib/jenkins/workspace/Real-World-CI-CD/target/petclinic.war /opt/apache-tomcat-9.0.65/webapps/ "
            }
        }
