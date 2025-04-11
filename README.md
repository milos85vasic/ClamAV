# ClamAV

Very basic configuration for ClamAV running inside Docker container.

## Project structure

```
~/
├── docker-compose.yml
├── Dockerfile
├── msmtprc
├── clamav_db/       # Virus definitions
├── quarantine/      # Infected files
└── Scripts/
    └── ScanAndAlert.sh
```
