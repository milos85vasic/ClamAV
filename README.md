# ClamAV

The very basic configuration of ClamAV anti-virus running inside the Docker container.
Anti-virus monitors and scans the directory mounted to the following path: `/mnt/DATA`.

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
    ├── Entry.sh
    ├── RepairDb.sh
    ├── GenerateMsmtp.sh
    ├── ScanAndAlert.sh
    └── Schedule.sh
```

## Setup

Set the environment variables to set on host machine:

```shell
ALERT_EMAIL=""        # Comma separate recipiants list
SMTP_HOST=""          # e.g., smtp.gmail.com
SMTP_PORT=""          # e.g., 587
SMTP_USER=""          # your@email.com
SMTP_PASSWORD=""      # App password
```

Install everything by running the install script `Install.sh`.
