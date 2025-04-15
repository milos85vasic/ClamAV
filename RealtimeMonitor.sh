#!/bin/bash

while inotifywait -r -e create,modify /mnt/DATA; do

  docker exec clamav /Scripts/ScanAndAlert.sh "Realtime-Monitor"
done