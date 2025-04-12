FROM ubuntu:latest

RUN apt update && \
    apt install -y --no-install-recommends \
    sudo \
    wget \
    openconnect \
    openvpn \
    curl \
    iproute2 \
    iptables \
    gnupg \
    dos2unix \
    ca-certificates \
    msmtp \
    mailutils \
    inotify-tools

COPY Scripts/VPN.sh /usr/local/bin/
COPY config.ovpn /etc/openvpn/config.ovpn

RUN cat /etc/openvpn/config.ovpn && test -e /etc/openvpn/config.ovpn
RUN chmod +x /usr/local/bin/VPN.sh && sh /vpn.sh
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
    touch /usr/local/etc/freshclam.conf

RUN wget https://database.clamav.net/main.cvd
RUN wget https://database.clamav.net/daily.cvd
RUN wget https://ftp.swin.edu.au/sanesecurity/ksp.hdb
RUN wget https://ftp.swin.edu.au/sanesecurity/ksp.ldb

RUN cp *.cvd *.hdb *.ldb /var/lib/clamav/ && \
    chown clamav:clamav /var/lib/clamav/* && \
    echo "DatabaseDirectory /var/lib/clamav" > /usr/local/etc/freshclam.conf && \
    echo "DatabaseMirror file:///var/lib/clamav" > /usr/local/etc/freshclam.conf && \
    echo "ScriptedUpdates no" > /usr/local/etc/freshclam.conf && \
    echo "Checks 24" > /usr/local/etc/freshclam.conf 
    # echo "DatabaseMirror http://ftp.swin.edu.au/sanesecurity" > /usr/local/etc/freshclam.conf && \
    # echo "DatabaseMirror http://clamavdb.heanet.ie/sanesecurity" > /usr/local/etc/freshclam.conf && \
    # echo "DatabaseCustomURL http://ftp.swin.edu.au/sanesecurity/jurlbl.ndb" >> /usr/local/etc/freshclam.conf && \
    # echo "DatabaseCustomURL http://ftp.swin.edu.au/sanesecurity/jurlbla.ndb" >> /usr/local/etc/freshclam.conf && \
    # echo "DatabaseCustomURL http://ftp.swin.edu.au/sanesecurity/ksp.hdb" >> /usr/local/etc/freshclam.conf

# RUN freshclam --verbose && \
RUN clamscan --debug | grep Kaspersky && \
    clamscan --version && echo "X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-TEST-FILE!$H+H*" > test.txt && \
    clamscan test.txt && \
    rm test.txt

COPY Scripts/ /Scripts/

RUN chmod +x /Scripts/*.sh

VOLUME /etc/msmtprc
VOLUME /var/lib/clamav
VOLUME /scandir
VOLUME /quarantine

ENTRYPOINT ["/bin/bash", "/Scripts/Entry.sh"]