FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo \
    wget \
    openconnect \
    openvpn \
    curl \
    iproute2 \
    iptables \
    gnupg \
    ca-certificates \
    msmtp \
    mailutils \
    inotify-tools \
    clamav clamav-daemon clamav-freshclam && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY Scripts/ /Scripts/
COPY config.ovpn /etc/openvpn/config.ovpn

RUN chmod +x /Scripts/*.sh

RUN cat /etc/openvpn/config.ovpn && test -e /etc/openvpn/config.ovpn
    
RUN groupadd clamav && \
    useradd -g clamav -s /bin/false -d /dev/null clamav && \
    mkdir -p /var/lib/clamav && \
    chown -R clamav:clamav /var/lib/clamav && \
    mkdir -p /etc/clamav/ && \
    chown -R clamav:clamav /etc/clamav && \
    touch /usr/local/etc/freshclam.conf && \
    mkdir -p /var/log/clamav && \
    chown -R clamav:clamav /var/log/clamav && \
    touch /var/log/clamav/clamav.log && \
    chown clamav:clamav /var/log/clamav/clamav.log && \
    mkdir -p /usr/local/share/clamav && \
    chown -R clamav:clamav /usr/local/share/clamav

VOLUME /scandir
VOLUME /quarantine
VOLUME /etc/msmtprc
VOLUME /var/lib/clamav

ENTRYPOINT ["/bin/bash", "/Scripts/Entry.sh"]