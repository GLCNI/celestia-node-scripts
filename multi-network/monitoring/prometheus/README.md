# Monitoring with Prometheus & Grafana (with Otel collector)

This setup uses Prometheus to scrape data from an externally hosted celestia node and export the data to Grafana for viewing metrics in a useful GUI.
With celestia DA nodes (light and full storage) using the celestia node stack, Otel collector is used as a bridge to export metrics to Prometheus. (which is exporting metrics in the OpenTelemetry Protocol (OTLP)) and Prometheus (which can only scrape metrics in the Prometheus Exposition Format).

Optional Node exporter: which is useful for viewing hardware-based metrics. can be installed on the target device.

## Setup monitoring server 

### 1. Setup Prometheus 

**Install Prometheus**
Steps to download and Extract (Promtol and Prometheus), unpacks the install file and copy binaries to `/usr/local/bin/`
```
wget https://github.com/prometheus/prometheus/releases/download/v2.33.0/prometheus-2.33.0.linux-amd64.tar.gz
tar xvf prometheus-2.33.0.linux-amd64.tar.gz
sudo cp prometheus-2.33.0.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.33.0.linux-amd64/promtool /usr/local/bin/
sudo chown ubuntu:ubuntu /usr/local/bin/prometheus
sudo chown ubuntu:ubuntu /usr/local/bin/promtool
```

**confirm installation**
 ```
prometheus --version
promtool --version
```
**Configure Prometheus** 
```
sudo mkdir /etc/prometheus/
sudo nano /etc/prometheus/prometheus.yml
```

Prometheus configuration
```
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

```

**Setup system service for Prometheus**
```
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
```

Enable and start service 
```
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start Prometheus
```

### 2. Setup Grafana

**Install Grafana**
```
curl https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt update
sudo apt install grafana
```

Enable Grafana service
```
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

### 3. Setup Otel collector 

**Install Otel collector**
```
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.75.0/otelcol_0.75.0_linux_amd64.tar.gz
tar xvf otelcol_0.75.0_linux_amd64.tar.gz
sudo cp ~/otelcol /usr/local/bin/
sudo chown ubuntu:ubuntu /usr/local/bin/otelcol
otelcol –version
```

**Configure Otelcol**
```
sudo mkdir /etc/otelcol/
sudo nano /etc/otelcol/otelcol.yml
```

paste in otelcol.yml configuration file
```
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
        - targets: ['<CELESTIA-SERVER-IP>:8888']
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
```

**Configure system service for otelcol**
```
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
```

Enable and start service
```
sudo systemctl daemon-reload
sudo systemctl enable otelcol.service
sudo systemctl start otelcol.service
```

### 4. Configure Celestia Node 

To configure the Celestia node to send metrics to the ‘metrics- server’ that is hosting grafana/prometheus & otelcol

Add the following args
```
ExecStart=/usr/local/bin/celestia light start --keyring.accname my_celes_key --p2p.network blockspacerace --core.ip https://rpc-blockspacerace.pops.one --gateway --gateway.addr localhost --metrics --metrics.tls=false --metrics.endpoint otel.celestia.tools:4318 --metrics.endpoint <METRICS-SERVER-IP>:4318
```

Ensure ports are open
```
ufw allow 4318, 8889
```

### 5. Accessing Metrics

**To access Grafana interface**

On a web browser `http://<metrics-server-ip>:3000`

Once opened, will need to change password (default login= admin: admin)

Add datasource – Prometheus URL - `http://< metrics-server-ip>:9090`

**Troubleshooting: Prometheus targets**

This will display which jobs are active or down via web browser
On a web browser `http://<metrics-server-ip>:9090/targets`

**Troubleshooting: Test metrics are being scrapped**

If the celesita node server is active and sending metrics to metrics server, metrics should be returned 
`curl -s localhost:8889/metrics | grep HELP`

## Use Metrics server install script 
