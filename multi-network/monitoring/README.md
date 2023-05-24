# Tools for monitoring celestia node deployments 

Example Practical application, with some more detail: https://mirror.xyz/0xf3bF9DDbA413825E5DdF92D15b09C2AbD8d190dd/yPwxf_Zmv7hvtD6jzfvJusIB3Fovce-NcXTjdU9W9hE

## Monitoring with Prometheus and Grafana

This setup uses Prometheus to scrape data from an externally hosted celestia node and export the data to Grafana for viewing metrics in a useful GUI. With celestia DA nodes (light and full storage) using the celestia node stack, Otel collector is used as a bridge to export metrics to Prometheus. (which is exporting metrics in the OpenTelemetry Protocol (OTLP)) and Prometheus (which can only scrape metrics in the Prometheus Exposition Format).

See `Prometheus` 

`prometheus-metrics-server.sh` install script for installing and setup of tools needed for setup of Grafana dashboard

## Monitoring with SNMP 

This setup uses SNMP installed on Linux devices for monitoring and sending information to PRTG monitoring software on a separate dedicated device.

See `snmp`

`service-monitor.sh` install script for monitoring celestia node service with PRTG

## DAS sampling

`das-sampling.sh` script to log sampling stats for DA node performance recording

