FROM clamav/clamav:latest
RUN apt update && apt install -y msmtp mailutils
COPY Scripts/GenerateMsmtp.sh /GenerateMsmtp.sh
RUN chmod +x /GenerateMsmtp.sh
ENTRYPOINT ["/GenerateMsmtp.sh && /bin/bash"]