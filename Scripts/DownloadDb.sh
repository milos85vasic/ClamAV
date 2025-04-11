#!/bin/bash
set -e

mirrors=(
    "http://db.cn.clamav.net"
    "http://db.local.clamav.net"
    "http://db.jp.clamav.net"
)

download_file() {
    for mirror in "${mirrors[@]}"; do
        if wget -q --tries=3 --timeout=15 "$mirror/$1" -O "/var/lib/clamav/$1"; then
            echo "Downloaded $1 from $mirror"
            return 0
        fi
    done
    return 1
}

files=("main.cvd" "daily.cvd" "bytecode.cvd")

for file in "${files[@]}"; do
    until download_file "$file"; do
        echo "Retrying $file in 30 seconds..."
        sleep 30
    done
done

chown clamav:clamav /var/lib/clamav/*.cvd