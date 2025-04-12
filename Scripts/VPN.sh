#!/bin/bash
set -e

if test -e /etc/openvpn/config.ovpn; then

    echo "The '/etc/openvpn/config.ovpn' has been found:" && \
        cat /etc/openvpn/config.ovpn

else

    echo "ERROR: There is no '/etc/openvpn/config.ovpn' found"
    exit 1
fi

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

echo "Waiting for VPN connection..."

if ! openvpn --config /etc/openvpn/config.ovpn --auth-user-pass /etc/openvpn/auth.txt; then

    echo "VPN failed"
    exit 1
fi

if ip a show tun0 >/dev/null 2>&1; then

    echo "VPN seems ready"

    if curl --max-time 2 --silent ifconfig.me >/dev/null; then
        
        echo "VPN has the internet connection"
        echo "VPN connected with IP: $(curl -s ifconfig.me)"
        
        exit 0
    fi
fi

echo "VPN failed to initialize"
exit 1