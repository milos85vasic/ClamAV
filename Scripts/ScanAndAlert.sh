#!/bin/bash

if [ -z "$1" ]; then

  TAG="DEFAULT"

else

  TAG="$1"
fi

echo "Anti-Virus scan started from '$TAG'" | /Scripts/Log.sh && \
  clamscan -r --move=/quarantine /scandir | grep --line-buffered "FOUND" | /Scripts/Log.sh
