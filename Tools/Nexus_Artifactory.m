# Steps for installing the Nexus Artifactory for publishing the Artifacts it can only be use in Java based Projects build by using Maven 

Install Docker Firstly

# Then run the below command for installing Nexus Artifactory using Docker 
docker run -d --name nexus -p 8081:8081 sonatype/nexus3:latest


# By default username is "admin"
# To get password go to the loacation "/nexus-data/admin.password"


# command to access the running docker conatiner
dokcer exec -it <container-id> /bin/bash
cd sonatype-work/
ls
cd nexus3/
ls
cat admin.password # here you can find the login password for nexus repository

# For configuring the anonymous access
Select the option "Enable Anonymous Access" 


# install the plugin "Nexus Artifact Uploader & Config File Provider" on Jenkins.

1. Go-To Jenkins and Click on Manage Jenkins 
2. Then, Click on Managed files
3. Click on "Add a new config"
4. Select "Global Maven Settings.xml"
5. Add the ID of the config file as "global-maven"
6. Click Next
7. Copy the thing in the Content from line number 119-123
8. Then paste below on line number 125 
9. and rename the id as "maven-snapshots"
10. Done

# then go-to the pom.xml file
Edit the "pom.xml" file and edit the server IP in the below file piece of code:-

<distributionManagement>
	<repository>
		<id>maven-releases</id>
		<url>http://<nexus-server-ip-here>:8081/repository/maven-releases/</url> 
	</repository>
	<snapshotRepository>
		<id>maven-snaphots</id>
		<url>http://<nexus-server-ip-here>:8081/repository/maven-snapshots/</url> 
	</snapshotRepository>
	</distributionManagement>

 ## The END
