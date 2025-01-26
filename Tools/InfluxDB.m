docker run -d -p 8086:8086 --name influxdb2 influxdb:1.8.6-alpine


docker exec -it influxdb2 bash
influx
CREATE DATABASE "jenkins" WITH DURATION 1825d REPLICATION 1 NAME "jenkins-retention"
SHOW DATABASES
USE database_name




-------For Grafana
1. Jenkins health –> use prometheus data source
up{instance="jenkins-ip:8080", job="jenkins"}



2. Jenkins executor | node | queue count –> use prometheus data source
jenkins_executor_count_value

jenkins_node_count_value

jenkins_queue_size_value



3. Jenkins over all –> influxDB
SELECT count(build_number) FROM "jenkins_data" WHERE ("build_result" = 'SUCCESS' OR "build_result" = 'CompletedSuccess')

SELECT count(build_number) FROM "jenkins_data" WHERE ("build_result" = 'FAILURE' OR "build_result" = 'CompletedError' )

SELECT count(build_number) FROM "jenkins_data" WHERE ("build_result" = 'ABORTED' OR "build_result" = 'Aborted' )

SELECT count(build_number) FROM "jenkins_data" WHERE ("build_result" = 'UNSTABLE' OR "build_result" = 'Unstable' )

SELECT count(build_number) FROM "jenkins_data" WHERE ("build_result" = 'NOT_BUILT' OR "build_result" = 'not_built' )



4. Pipelines ran in last 10 minutes –> influx DB
SELECT count(project_name) FROM jenkins_data WHERE time &gt;= now() - 10m



5. Total Build –> influx DB
SELECT count(build_number) FROM "jenkins_data"



6. Last Build status –> influx Db
SELECT build_result FROM "jenkins_data" WHERE $timeFilter  ORDER BY time DESC LIMIT 1



7. Average time –> Influx-DB
select build_time/1000 FROM jenkins_data WHERE $timeFilter



8. last 10 build details –> Influx-DB
SELECT "build_exec_time", "project_name", "build_number", "build_causer", "build_time", "build_result" FROM "jenkins_data" WHERE $timeFilter ORDER BY time DESC LIMIT 10




---slack pipeline stage
pipeline {
    agent any
    parameters {
        choice(name: 'action', choices: 'create\ndelete', description: 'Select create or delete.')
    }
    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }
        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/yash509/DevSecOps-CICal-Deployment.git'
            }
        }
    }
    post {
        always {
            slackSend(
                channel: '#cloud_devsecops_engineer',
                color: currentBuild.currentResult == 'SUCCESS' ? 'good' : 'danger',
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} \n build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
            )
        }
    }
}

