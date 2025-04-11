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
    freshclam

COPY Scripts/ /Scripts/
RUN chmod +x /Scripts/*.sh

VOLUME /etc/msmtprc
VOLUME /var/lib/clamav
VOLUME /scandir
VOLUME /quarantine

# Entrypoint
ENTRYPOINT ["/Scripts/Entry.sh"]