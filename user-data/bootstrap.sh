#!/bin/bash

echo "Bootsrap"
/usr/local/bin/envars.sh

set -a
source /etc/environment
set +a

/usr/local/bin/cloudwatch.sh
/usr/local/bin/entrypoint.sh

systemctl status awslogs.service