FROM ubuntu:latest

RUN apt update && \
    apt install -y --no-install-recommends \
    sudo \
    wget \
    gnupg \
    dos2unix \
    ca-certificates \
    msmtp \
    mailutils \
    inotify-tools
    
RUN wget https://www.clamav.net/downloads/production/clamav-1.0.8.linux.x86_64.deb
    
RUN apt install -y ./clamav-1.0.8.linux.x86_64.deb && \
    rm clamav-1.0.8.linux.x86_64.deb && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/clamav && \
    mkdir -p /etc/clamav/ && \
    touch /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.cn.clamav.net" > /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.local.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "Checks 4" >> /etc/clamav/freshclam.conf && \
    echo "MaxAttempts 3" >> /etc/clamav/freshclam.conf && \
    echo "ScriptedUpdates no" >> /etc/clamav/freshclam.conf && \
    chown -R clamav /var/lib/clamav && \
    chown -R clamav /etc/clamav && \
    chgrp -R clamav /var/lib/clamav && \
    chgrp -R clamav /etc/clamav

COPY Scripts/DownloadDb.sh /DownloadDb.sh

RUN chmod +x /DownloadDb.sh && /DownloadDb.sh

COPY Scripts/ /Scripts/

RUN chmod +x /Scripts/*.sh

VOLUME /etc/msmtprc
VOLUME /var/lib/clamav
VOLUME /scandir
VOLUME /quarantine

ENTRYPOINT ["/bin/bash", "/Scripts/Entry.sh"]