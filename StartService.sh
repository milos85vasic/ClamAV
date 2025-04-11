#!/bin/bash

sudo cp clamav-monitor.service /etc/systemd/system/clamav-monitor.service && \
    sudo systemctl enable --now clamav-monitor