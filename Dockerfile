FROM ubuntu:latest

RUN apt update && \
    apt install -y \
    wget \
    dos2unix \
    clamav \
    clamav-daemon \
    clamdscan \
    clamav-freshclam \
    msmtp \
    mailutils \
    inotify-tools

RUN mkdir -p /var/lib/clamav/tmp && \
    mkdir -p /var/run/clamav && \
    chown -R clamav:clamav /var/lib/clamav /var/run/clamav && \
    chmod -R 775 /var/lib/clamav /var/run/clamav && \
    install -d -o clamav -g clamav -m 775 /var/lib/clamav/tmp

RUN echo "DatabaseMirror db.cn.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.local.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.hk.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.jp.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.by.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.kz.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.tr.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "Checks 4" >> /etc/clamav/freshclam.conf && \
    echo "MaxAttempts 5" >> /etc/clamav/freshclam.conf && \
    echo "AllowSupplementaryGroups yes" >> /etc/clamav/freshclam.conf

COPY Scripts/ /Scripts/
RUN chmod +x /Scripts/*.sh
RUN find /Scripts/ -type f -exec chmod +x {} \; && dos2unix /Scripts/*

VOLUME /etc/msmtprc
VOLUME /var/lib/clamav
VOLUME /scandir
VOLUME /quarantine

ENTRYPOINT ["/bin/bash", "/Scripts/Entry.sh"]