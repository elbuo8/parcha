#!/bin/sh

mkdir -p /etc/telegraf/

cat >/etc/telegraf/telegraf.conf <<EOF
[global_tags]
  region = "$AWS_REGION"
  service = "$SERVICE"
  environment = "$ENVIRONMENT"

[agent]
  interval = "10s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = ""
  debug = false
  quiet = false
  logfile = ""
  omit_hostname = true

[[outputs.datadog]]
  apikey = "$DATADOG_KEY"

[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false

[[inputs.disk]]

[[inputs.diskio]]

[[inputs.kernel]]

[[inputs.mem]]

[[inputs.processes]]

[[inputs.swap]]

[[inputs.system]]

[[inputs.docker]]

[[inputs.statsd]]
  service_address = "0.0.0.0:8125"
  percentiles = [75,8590,95,99]
  metric_separator = "_"
  parse_data_dog_tags = true
  allowed_pending_messages = 10000
  percentile_limit = 1000
EOF

cat >/etc/systemd/system/metrics.service <<EOF
[Unit]
Description=metrics
After=logger.service
Requires=docker.service

[Service]
ExecStartPre=-/usr/bin/docker kill metrics
ExecStartPre=-/usr/bin/docker rm metrics
ExecStartPre=/usr/bin/docker pull telegraf:alpine
ExecStart=/usr/bin/docker run -p 8125:8125/udp --name metrics -v /etc/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro telegraf
ExecStop=/usr/bin/docker stop metrics

[Install]
WantedBy=multi-user.target
EOF

docker pull telegraf:alpine

systemctl enable metrics.service
