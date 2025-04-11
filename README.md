# ClamAV

The very basic configuration of ClamAV anti-virus running inside the Docker container.

## Project structure

```
~
├── docker-compose.yml
├── Dockerfile
├── clamav-monitor.service
├── Install.sh
├── LICENSE
├── README.md
├── README.pdf
├── RealtimeMonitor.sh
├── RunInBackground.sh
├── StartService.sh
├── Update.sh
└── Scripts/
    ├── GenerateMsmtp.sh
    ├── ScanAndAlert.sh
    └── Schedule.sh
```

## Setup

Set the environment variables to set on host machine:

```shell
SMTP_HOST=""          # e.g., smtp.gmail.com
SMTP_PORT=""          # e.g., 587
SMTP_USER=""          # your@email.com
SMTP_PASSWORD=""      # App password
ALERT_EMAIL=""        # Recipient
```

Install everything by running the script `Install.sh`
