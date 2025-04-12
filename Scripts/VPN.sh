#!/bin/bash
set -e

echo "VPN user: '$VPN_USER'"
echo "VPN pass: '$VPN_PASSWORD'"

echo "$VPN_USER" > /etc/openvpn/auth.txt
echo "$VPN_PASSWORD" >> /etc/openvpn/auth.txt
    
if test -e /etc/openvpn/auth.txt; then

    echo "The '/etc/openvpn/auth.txt' has been found:" && \
        cat /etc/openvpn/auth.txt

else

    echo "ERROR: There is no '/etc/openvpn/auth.txt' found"
    exit 1
fi

openvpn --config /etc/openvpn/config.ovpn --auth-user-pass /etc/openvpn/auth.txt --daemon

echo "Waiting for VPN connection..."

while : ; do

    if ip a show tun0 >/dev/null 2>&1; then

        echo "VPN seems ready"

        if curl --max-time 2 --silent ifconfig.me >/dev/null; then
            
            echo "VPN has the internet connection"
            break
        fi
    fi

    echo "VPN not yet ready"
    sleep 1
done

echo "VPN connected with IP: $(curl -s ifconfig.me)"
exec "$@"