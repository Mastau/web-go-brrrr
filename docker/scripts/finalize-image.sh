#!/bin/sh
set -eu

find /var/log -type f -exec truncate --size 0 {} \;
rm -rf /tmp/* /var/tmp/* /root/.cache /root/.cargo /root/.npm
rm -rf /opt/cyberlab/build
