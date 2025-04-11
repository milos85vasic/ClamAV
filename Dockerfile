FROM clamav/clamav:latest
RUN apk update && apk add --no-cache msmtp mailx
COPY Scripts/GenerateMsmtp.sh /GenerateMsmtp.sh
RUN chmod +x /GenerateMsmtp.sh
CMD ["/GenerateMsmtp.sh && freshclam && clamd"]