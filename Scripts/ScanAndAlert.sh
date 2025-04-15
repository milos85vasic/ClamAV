#!/bin/bash

if [ -z "$1" ]; then

    echo "Usage: $0 <message>"
    exit 1
fi

echo "Scan started from '$1'" && \
  clamscan -r --move=/quarantine /scandir | grep --line-buffered "FOUND" | /Scripts/Log.sh
