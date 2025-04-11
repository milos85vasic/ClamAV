#!/bin/bash

# Install the dependencies before using it:
#
# sudo apt install inotify-tools
#

while inotifywait -r -e create,modify /mnt/smb_share; do

  docker exec clamav /scripts/ScanAndAlert.sh
done