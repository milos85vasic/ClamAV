#!/bin/bash

if [ -z "$1" ]; then

  TAG="DEFAULT"

else

  TAG="$1"
fi

sudo echo "Anti-Virus scan started from '$TAG'" | /Scripts/Log.sh && \
  sudo clamscan -r --remove /scandir | grep --line-buffered "FOUND" | /Scripts/Log.sh
