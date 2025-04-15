#!/bin/bash

TARGET_SCRIPT="/Custom/Scripts/Log.sh"

if [ ! -t 0 ]; then
    if [ -e "$TARGET_SCRIPT" ]; then
        while IFS= read -r line; do
            echo "$line" | "$TARGET_SCRIPT"
        done
    else
        cat  # Just output the piped data
    fi
fi

# If arguments are provided, forward them
if [ $# -gt 0 ]; then
    if [ -e "$TARGET_SCRIPT" ]; then
        "$TARGET_SCRIPT" "$1"
    else
        echo "$1"
    fi
fi