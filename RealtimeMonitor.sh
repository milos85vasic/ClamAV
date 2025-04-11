#!/bin/bash

# Install the dependencies before using it:
#
# sudo apt install inotify-tools
#

while inotifywait -r -e create,modify /mnt/DATA; do

  docker exec clamav /scripts/ScanAndAlert.sh
done