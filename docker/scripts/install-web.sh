#!/bin/sh
set -eu

ARJUN_VERSION="${ARJUN_VERSION:-2.2.7}"
WAFW00F_VERSION="${WAFW00F_VERSION:-2.3.2}"
NIKTO_VERSION="${NIKTO_VERSION:-2.5.0}"

apt-get update
apt-get install --yes --no-install-recommends \
    dirb \
    gobuster \
    libnet-ssleay-perl \
    sqlmap \
    whatweb
rm -rf /var/lib/apt/lists/*

git clone --branch "${NIKTO_VERSION}" --depth 1 https://github.com/sullo/nikto.git /opt/nikto
rm -rf /opt/nikto/.git
ln -s /opt/nikto/program/nikto.pl /usr/local/bin/nikto

pipx install "arjun==${ARJUN_VERSION}"
pipx install "wafw00f==${WAFW00F_VERSION}"
