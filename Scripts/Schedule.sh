#!/bin/sh

docker exec -it clamav bash -c "echo '0 */6 * * * /Scripts/ScanAndAlert.sh' | crontab -"