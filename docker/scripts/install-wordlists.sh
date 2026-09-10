#!/bin/sh
set -eu

mkdir -p /usr/share/wordlists
ln -sfn /usr/share/dirb/wordlists /usr/share/wordlists/dirb

cat > /usr/share/wordlists/README <<'EOF'
CyberLab deliberately ships only the compact wordlists installed with dirb.
Mount larger collections such as SecLists into /workspace when required.
EOF
