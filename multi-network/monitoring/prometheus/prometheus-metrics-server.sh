#!/bin/bash

#CREATE NODE IP VARIABLE 
echo "What is the IP address of the Celestia node server? Enter server IP:"
read CELESTIA_SERVER_IP

# Print the IP address entered by the user for confirmation
echo "You entered $CELESTIA_SERVER_IP as the IP address of the Celestia node server."
echo "ensure the node is active and ports (4318,8889) are open"
echo ""
echo "celestia node service must include the following args to connect to this metrics server"
echo "--metrics --metrics.tls=false --metrics.endpoint otel.celestia.tools:4318 --metrics.endpoint <METRICS-SERVER-IP>:4318"
echo ""
echo "Press Enter to continue..."
read -r


###########################################################################################
#################  SETUP PROMETHEUS #######################################################
###########################################################################################
#install prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.33.0/prometheus-2.33.0.linux-amd64.tar.gz
tar xvf prometheus-2.33.0.linux-amd64.tar.gz
sudo cp prometheus-2.33.0.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.33.0.linux-amd64/promtool /usr/local/bin/
sudo chown ubuntu:ubuntu /usr/local/bin/prometheus
sudo chown ubuntu:ubuntu /usr/local/bin/promtool
#configure prometheus
sudo mkdir /etc/prometheus
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<EOF
global:
  scrape_interval: 10s
  scrape_timeout: 3s
  evaluation_interval: 5s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9090']

  - job_name: otel-collector
    static_configs:
      - targets: ['127.0.0.1:8888']

  - job_name: da-node-metrics
    metrics_path: /metrics
    static_configs:
      - targets: ['127.0.0.1:8889']
EOF
#setup prom service
sudo tee /etc/systemd/system/prometheus.service << EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=root
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

###########################################################################################
#################  SETUP GRAFANA ##########################################################
###########################################################################################
curl https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt update
sudo apt install grafana

###########################################################################################
#################  SETUP OTEL COLLECTOR ###################################################
###########################################################################################
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.75.0/otelcol_0.75.0_linux_amd64.tar.gz
tar xvf otelcol_0.75.0_linux_amd64.tar.gz
sudo cp ~/otelcol /usr/local/bin/
sudo chown ubuntu:ubuntu /usr/local/bin/otelcol
#configure otelcol
sudo mkdir /etc/otelcol/
sudo tee /etc/otelcol/otelcol.yml << EOF
receivers:
  otlp:
    protocols:
      grpc:
      http:
  prometheus:
    config:
      scrape_configs:
      - job_name: 'otel-collector'
        scrape_interval: 10s
        static_configs:
        - targets: ['$CELESTIA-SERVER-IP:8888']
exporters:
  otlphttp:
    endpoint: http://otel.celestia.tools:4318
  prometheus:
    endpoint: "127.0.0.1:8889"
    namespace: celestia
    send_timestamps: true
    metric_expiration: 180m
    enable_open_metrics: true
    resource_to_telemetry_conversion:
      enabled: true
processors:
  batch:
  memory_limiter:
    # 80% of maximum memory up to 2G
    limit_mib: 1500
    # 25% of limit up to 2G
    spike_limit_mib: 512
    check_interval: 5s
service:
  pipelines:
    metrics:
      receivers: [otlp, prometheus]
      exporters: [otlphttp, prometheus]
EOF
#setup otelcol service
sudo tee /etc/systemd/system/otelcol.service << EOF
[Unit]
Description=OpenTelemetry Collector
Wants=network-online.target
After=network-online.target

[Service]
User=ubuntu
Type=simple
ExecStart=/usr/local/bin/otelcol --config /etc/otelcol/otelcol.yml

[Install]
WantedBy=multi-user.target
EOF
###########################################################################################
#START SERVICES
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start Prometheus
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl enable otelcol.service
sudo systemctl start otelcol.service
