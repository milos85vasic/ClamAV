#!/bin/bash
set -e

if [ -z "$1" ]; then

    echo "Usage: $0 <message>"
    exit 1
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "LOG :: $TIMESTAMP :: $1"

