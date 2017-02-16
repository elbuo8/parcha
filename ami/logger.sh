#!/bin/sh

mkdir -p /etc/fluentd/

cat >/etc/fluentd/fluentd.conf <<EOF
<source>
  @type debug_agent
  port 24230
  bind 127.0.0.1
</source>

<source>
  type forward
  port 24224
  bind 0.0.0.0
</source>

<match docker.*>
  @type kinesis_firehose
  region "#{ENV['AWS_REGION']}"
  delivery_stream_name "#{ENV['ENVIRONMENT']}-#{ENV['SERVICE']}-logs-#{ENV['AWS_REGION']}"
</match>

<match **>
  @type stdout
</match>
EOF

cat >/etc/systemd/system/logger.service <<EOF
[Unit]
Description=logger
After=docker.service
Requires=docker.service

[Service]
Environment=AWS_REGION=$AWS_REGION
Environment=SERVICE=$SERVICE
Environment=ENVIRONMENT=$ENVIRONMENT
ExecStartPre=-/usr/bin/docker kill logger
ExecStartPre=-/usr/bin/docker rm logger
ExecStartPre=/usr/bin/docker pull atlassianlabs/fluentd
ExecStart=/usr/bin/docker run --ulimit nofile=65536:65536 -p 24224:24224 -e AWS_REGION -e ENVIRONMENT -e SERVICE --name logger -v /etc/fluentd:/etc/fluent atlassianlabs/fluentd
ExecStop=/usr/bin/docker stop logger

[Install]
WantedBy=multi-user.target
EOF

docker pull atlassianlabs/fluentd

systemctl enable logger.service
