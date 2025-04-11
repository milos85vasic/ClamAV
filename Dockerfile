FROM clamav/clamav:latest
RUN apt-get update && apt-get install -y msmtp mailutils
COPY Scripts/GenerateMsmtp.sh /GenerateMsmtp.sh
RUN chmod +x /GenerateMsmtp.sh
ENTRYPOINT ["/GenerateMsmtp.sh && /bin/bash"]