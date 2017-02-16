#!/bin/sh

cat >/etc/systemd/system/api.service <<EOF
[Unit]
Description=logger
After=logger.service
Requires=logger.service

[Service]
ExecStartPre=-/usr/bin/docker kill api
ExecStartPre=-/usr/bin/docker rm api
ExecStartPre=/usr/bin/docker pull nginx
ExecStart=/usr/bin/docker run -p 3000:80 --log-driver=fluentd --log-opt fluentd-address=localhost:24224 --name api nginx
ExecStop=/usr/bin/docker stop api

[Install]
WantedBy=multi-user.target
EOF

docker pull nginx

systemctl enable api.service
