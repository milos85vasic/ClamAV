#!/bin/bash
set -e

echo "Starting database repair..."
rm -f /var/lib/clamav/*.cvd
sudo -u clamav freshclam --stdout --no-warnings
clamscan --debug --infected --no-summary /var/lib/clamav/*.cvd
echo "Verification complete"