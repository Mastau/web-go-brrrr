#!/bin/sh
set -eu

apt-get update
apt-get install --yes --no-install-recommends \
    dnsutils \
    iproute2 \
    iputils-ping \
    netcat-openbsd \
    nmap \
    openssl \
    socat \
    tcpdump \
    traceroute \
    whois
rm -rf /var/lib/apt/lists/*
