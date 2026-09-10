#!/bin/sh
set -eu

apt-get update
apt-get install --yes --no-install-recommends \
    build-essential \
    pipx \
    python3 \
    python3-pip \
    python3-venv
rm -rf /var/lib/apt/lists/*
