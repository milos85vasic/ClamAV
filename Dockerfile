FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
      wget \
      clamav \
      clamav-daemon \
      clamdscan \
      clamav-freshclam \
      msmtp \
      mailutils \
      inotify-tools && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    echo "DatabaseMirror db.cn.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.local.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.hk.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.jp.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.by.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.kz.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror db.tr.clamav.net" >> /etc/clamav/freshclam.conf && \
    echo "Checks 4" >> /etc/clamav/freshclam.conf && \
    echo "MaxAttempts 5" >> /etc/clamav/freshclam.conf

COPY Scripts/ /Scripts/
RUN chmod +x /Scripts/*.sh

VOLUME /etc/msmtprc
VOLUME /var/lib/clamav
VOLUME /scandir
VOLUME /quarantine

ENTRYPOINT ["/Scripts/Entry.sh"]