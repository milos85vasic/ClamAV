FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
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

RUN if [ ! -f "/var/lib/clamav/main.cvd" ]; then \
    wget -q --tries=3 --timeout=15 \
    -O /var/lib/clamav/main.cvd \
    http://db.cn.clamav.net/main.cvd && \
    chown clamav:clamav /var/lib/clamav/main.cvd; \
fi

COPY Scripts/ /Scripts/
RUN chmod +x /Scripts/*.sh

VOLUME /etc/msmtprc
VOLUME /var/lib/clamav
VOLUME /scandir
VOLUME /quarantine

HEALTHCHECK --interval=1h --timeout=3s \
    CMD freshclam --quiet --on-update-execute=echo "Mirror working" || exit 1
    
ENTRYPOINT ["/Scripts/Entry.sh"]