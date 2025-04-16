#!/bin/bash

MONITOR_DIR="/scandir"

inotifywait -m -r -e modify,create,delete --format '%w%f %e' "$MONITOR_DIR" | while read -r file event; do
    
    if [[ -f "$file" ]]; then
    
        echo "Processing file: $file (Event: $event)"
        
        clamscan "$file"

                

    else
        
        echo "Skipping non-file item: $file (Event: $event)"
    fi
done