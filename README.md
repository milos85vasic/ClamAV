# ClamAV

The very basic configuration of ClamAV anti-virus running inside the Docker container.
Anti-virus monitors and scans the directory mounted to the following path: `/mnt/DATA`.
Communication with update server is performed throught the mandatory VPN connection.
The `config.ovpn` for VPN has to be provided and credentials env. variables set.

## Setup

Set the environment variables to set on host machine:

```shell
VPN_USER=""
VPN_PASSWORD=""
```

Install everything by running the install script `Install.sh`.
