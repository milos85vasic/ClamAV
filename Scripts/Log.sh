#!/bin/bash
set -e

if [ -z "$1" ]; then

    echo "Usage: $0 <message>"
    exit 1
fi

echo ">> $1"

