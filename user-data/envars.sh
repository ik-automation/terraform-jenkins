#!/bin/bash

set -euo

PASSWORD=$(aws ssm get-parameter --name "${secret}" --region ${region} --with-decryption | jq -r '.Parameter' | jq -r '.Value')
echo "export ADMIN_PASSWORD=$$PASSWORD" >> /etc/environment
source /etc/environment
