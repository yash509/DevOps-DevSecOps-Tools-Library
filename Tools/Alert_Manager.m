#### Firstly Open the Custom Port 587 on AWS or any other cloud

# Alert Manager Download Steps
wget https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-amd64.tar.gz

tar -xvf alertmanager-0.27.0.linux-amd64.tar.gz

rm alertmanager-0.27.0.linux-amd64.tar.gz

mv alertmanager-0.27.0.linux-amd64/ alertmanager
------------------------------------------------------------------------------------------------------------------

###### For setting up the alert rules on prometheus we have to create the alert_rules.yaml file inside the prometheus folder by using command:

vi alert_rules.yaml

# paste this below content in the above mentioned file:
groups:
  - name: alert_rules # Name of the alert rules group
    rules:
      - alert: InstanceDown
        expr: up == 0 # Expression to detect instance down
        for: 1m
        labels:
          severity: "critical"
        annotations:
          summary: "Endpoint {{ $labels.instance }} down"
          description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 1 minute."
 
      - alert: WebsiteDown
        expr: probe_success == 0 # Expression to detect website down
        for: 1m
        labels:
          severity: critical
        annotations:
          description: The website at {{ $labels.instance }} is down.
          summary: Website Down
 
      - alert: HostOutOfMemory
        expr: node_memory_MemAvailable / node_memory_MemTotal * 100 < 25 #Expression to detect low memory
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Host out of memory (instance {{ $labels.instance }})"
          description: "Node memory is filling up (< 25% left)\n VALUE = {{$value }}\n LABELS: {{ $labels }}"
 
      - alert: HostOutOfDiskSpace
        expr: (node_filesystem_avail{mountpoint="/"} * 100) / node_filesystem_size{mountpoint="/"} < 50 # Expression to detect low disk space
        for: 1s
        labels:
          severity: warning
        annotations:
          summary: "Host out of disk space (instance {{ $labels.instance }})"
          description: "Disk is almost full (< 50% left)\n VALUE = {{ $value }}\n LABELS: {{ $labels }}"
 
      - alert: HostHighCpuLoad
        expr: (sum by (instance)(irate(node_cpu{job="node_exporter_metrics",mode="idle"}[5m]))) > 80 #Expression to detect high CPU load
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Host high CPU load (instance {{ $labels.instance }})"
          description: "CPU load is > 80%\n VALUE = {{ $value }}\n LABELS:{{ $labels }}"
 
      - alert: ServiceUnavailable
        expr: up{job="node_exporter"} == 0 # Expression to detect service unavailability
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Service Unavailable (instance {{ $labels.instance }})"
          description: "The service {{ $labels.job }} is not available\n VALUE = {{ $value }}\n LABELS: {{ $labels }}"
 
      - alert: HighMemoryUsage
        expr: (node_memory_Active / node_memory_MemTotal) * 100 > 90 #Expression to detect high memory usage
        for: 10m
        labels:
          severity: critical
        annotations:
          summary: "High Memory Usage (instance {{ $labels.instance }})"
          description: "Memory usage is > 90%\n VALUE = {{ $value }}\n LABELS: {{ $labels }}"
 
      - alert: FileSystemFull
        expr: (node_filesystem_avail / node_filesystem_size) * 100 < 10 #Expression to detect file system almost full
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "File System Almost Full (instance {{ $labels.instance}})"
          description: "File system has < 10% free space\n VALUE = {{ $value }}\n LABELS: {{ $labels }}"


-------------------------------------------------------------------------------------------------------------------------------------------

# Then edit the prometheus.yml file

vi prometheus.yml -> 1. In this file, under the "rules_file" section edit the content written below the "rules_file" section with "alert_rules.yaml"
                     2. Uncomment the thing written under the "alerting -> targets" as " - <monitoring-IP>:9093 "
                     3. Add the "Job" under the scrape_configs 

alerting:
 alertmanagers:
  - static_configs:
    - targets: ['localhost:9093']

-------------------------------------------------------------------------------------------------------------------------------------------

# Go to Alert Manager Folder on server edit the "alertmanager.yml" file:

1. vi alertmanger.yml -> remove the pre-existing content and add the below new content  

route:
  group_by:
    - alertname
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 1h
  receiver: email-notifications

receivers:
  - name: email-notifications
    email_configs:
      - to: clouddevopshunter@gmail.com
        from: monitoring@ccd.com
        smarthost: smtp.gmail.com:587
        auth_username: clouddevopshunter@gmail.com
        auth_identity: clouddevopshunter@gmail.com
        auth_password: bdmq omqh vvkk zoqx   #The auth_password we can get from google app passwords
        send_resolved: true

inhibit_rules:
  - source_match: null
    severity: critical
    target_match:
      severity: warning
      equal:
        - alertname
        - dev
        - instance


# Then go to Alert Manager folder and start the Alert Manager using the command:

./alertmanager &
OR
./alertmanager --config.file=alertmanager.yml &

-- now we can access the alert manager on port 9093 followed by monitoring server's IP "monitoring-IP:9093"

-- For checking that whether the Alert Manager is working or not 
1. Go to Alert Manager on port 9093 
2. Click on "Status"
3. If status "ready" that means the alert manager is working otherwise not

--------------------------------------------------------------------------------------------------------------------------------------------

1. Then restart the Prometheus
2. Once restarted under the "status > rules" we can view the rules we defined earlier

--------------------------------------------------------------------------------------------------------------------------------------------