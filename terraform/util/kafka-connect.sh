#!/bin/bash

########### Update and Install ###########

yum update -y
yum install wget -y
yum install unzip -y
yum install java-1.8.0-openjdk-devel.x86_64 -y

########### Initial Bootstrap ###########

cd /tmp
wget ${confluent_platform_location}
unzip confluent-5.2.1-2.12.zip
mkdir /etc/confluent
mv confluent-5.2.1 /etc/confluent
mkdir ${confluent_home_value}/etc/kafka-connect

########### Generating Props File ###########

cd ${confluent_home_value}/etc/kafka-connect

cat > kafka-connect-ccloud.properties <<- "EOF"
${kafka_connect_properties}
EOF

############## HTTP Connector ###############

${confluent_home_value}/bin/confluent-hub install thomaskwscott/kafka-connect-http:1.0.0 --component-dir ${confluent_home_value}/share/java --no-prompt

########### Creating the Service ############

cat > /lib/systemd/system/kafka-connect.service <<- "EOF"
[Unit]
Description=Kafka Connect

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=${confluent_home_value}/bin/connect-distributed ${confluent_home_value}/etc/kafka-connect/kafka-connect-ccloud.properties

[Install]
WantedBy=multi-user.target
EOF

########### Enable and Start ###########

systemctl enable kafka-connect
systemctl start kafka-connect
