docker run -d -p 8086:8086 --name influxdb2 influxdb:1.8.6-alpine




docker exec -it influxdb2 bash
influx
CREATE DATABASE "jenkins" WITH DURATION 1825d REPLICATION 1 NAME "jenkins-retention"
SHOW DATABASES
USE database_name




