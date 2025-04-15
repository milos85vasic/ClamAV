#!/bin/bash

while inotifywait -r -e create,modify /mnt/DATA; do

  docker exec -w / clamav /Scripts/ScanAndAlert.sh
done