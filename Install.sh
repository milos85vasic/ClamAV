#!/bin/sh

sh Build.sh && sh sh StartService.sh && sudo docker exec clamav which msmtp && \
    sudo docker exec clamav sh -c 'echo "Test email" | mailx -s "Test" ${ALERT_EMAIL}'
