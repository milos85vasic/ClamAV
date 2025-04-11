FROM clamav/clamav:latest
RUN apt-get update && apt-get install -y msmtp mailutils
COPY msmtprc /etc/msmtprc