#!/bin/bash

SCANWHAT="/scandir"

if [ -z "$1" ]; then

  TAG="DEFAULT"

else

  TAG="$1"
fi

if ps -A | grep clamscan; then

  sudo echo "Anti-Virus scan is already running. Requested from '$TAG'" | sudo /Scripts/Log.sh

else

  sudo echo "Anti-Virus scan started. Requested from '$TAG'" | sudo /Scripts/Log.sh && \
    sudo echo "The following directories will be scanned: " | sudo /Scripts/Log.sh && \
    sudo ls -lF /scandir | sudo /Scripts/Log.sh && \
    sudo clamscan -r --remove --follow-dir-symlinks=0 --follow-file-symlinks=0 "$SCANWHAT" | grep --line-buffered "FOUND" | sudo /Scripts/Log.sh && \
    sudo echo "Anti-Virus scan completed. Requested from '$TAG'" | sudo /Scripts/Log.sh
fi
