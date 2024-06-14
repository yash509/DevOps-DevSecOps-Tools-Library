sudo useradd --system --no-create-home --shell /bin/false blackbox_exporter

wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz

tar -xvf blackbox_exporter-0.25.0.linux-amd64.tar.gz

// do manually
sudo cd blackbox_exporter-0.25.0.linux-amd64.tar.gz

./blackbox_exporter




//add this below lines of config in the "prometheus.yml" file 
---
scrape_configs:
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # Look for a HTTP 200 response.
    static_configs:
      - targets:
        - http://prometheus.io    # Target to probe with http.
        - http://app-running-ip-&-port-here # For Example:- 13.224.76.88:8080 or kubernetes port eg:- 30119 # Target to probe with http on port 8080. 
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: <change-monitoring-ip-here>:9115  # The blackbox exporter's real hostname:port.
---


# 7587 code for Grafana Dashboard
