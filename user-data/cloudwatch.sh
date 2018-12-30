#!/bin/bash

curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
chmod +x ./awslogs-agent-setup.py
python ./awslogs-agent-setup.py -n -r us-west-2 -c /usr/local/bin/cwlog.cfg
systemctl start awslogs.service
systemctl enable awslogs.service