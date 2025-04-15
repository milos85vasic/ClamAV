#!/bin/bash

docker exec -w / -it clamav bash -c "echo '0 */6 * * * /Scripts/ScanAndAlert.sh' | crontab -"