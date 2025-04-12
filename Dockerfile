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

RUN groupadd clamav && \
    useradd -g clamav -s /bin/false -d /dev/null clamav && \
    mkdir -p /var/lib/clamav && \
    chown -R clamav:clamav /var/lib/clamav && \
    mkdir -p /etc/clamav/ && \
    chown -R clamav:clamav /etc/clamav && \
    touch /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://ftp.swin.edu.au/sanesecurity" > /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror http://clamavdb.heanet.ie/sanesecurity" > /usr/local/etc/freshclam.conf && \
    echo "DatabaseCustomURL http://ftp.swin.edu.au/sanesecurity/jurlbl.ndb" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseCustomURL http://ftp.swin.edu.au/sanesecurity/jurlbla.ndb" >> /usr/local/etc/freshclam.conf && \
    echo "DatabaseCustomURL http://ftp.swin.edu.au/sanesecurity/ksp.hdb" >> /usr/local/etc/freshclam.conf

RUN freshclam --verbose
RUN grep "Kaspersky" /var/lib/clamav/*.ndb

COPY Scripts/ /Scripts/

RUN chmod +x /Scripts/*.sh

VOLUME /etc/msmtprc
VOLUME /var/lib/clamav
VOLUME /scandir
VOLUME /quarantine

ENTRYPOINT ["/bin/bash", "/Scripts/Entry.sh"]