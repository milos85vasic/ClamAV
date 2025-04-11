# ClamAV

Very basic configuration for ClamAV running inside Docker container.

## Project structure

```
~
├── docker-compose.yml
├── Dockerfile
├── msmtprc
├── clamav_db/       # Virus definitions
├── quarantine/      # Infected files
└── Scripts/
    └── ScanAndAlert.sh
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

Generate the `msmtprc` by running the script `Scripts/GenerateMsmtp.sh`

