#!/bin/bash

if [ -z "$1" ]; then

  TAG="DEFAULT"

else

  TAG="$1"
fi

if ps -A | grep clamscan; then

  sudo echo "Anti-Virus scan is already running. Requested from '$ATG'" | sudo /Scripts/Log.sh

else

  sudo echo "Anti-Virus scan started from '$TAG'" | sudo /Scripts/Log.sh && \
    sudo clamscan -r --remove /scandir | grep --line-buffered "FOUND" | sudo /Scripts/Log.sh
fi
