#!/bin/bash
set -e

if [ -z "$1" ]; then

    echo "Usage: $0 <message>"
    exit 1
fi

if test -e /Custom/Scripts/Log.sh;

    sh /Custom/Scripts/Log.sh "$1"

else

    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    echo "LOG :: $TIMESTAMP :: $1"
fi


