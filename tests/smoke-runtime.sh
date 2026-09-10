#!/bin/sh
set -eu

image_name="${CYBERLAB_IMAGE:-cyberlab:latest}"
test_uid="${LOCAL_UID:-12345}"
test_gid="${LOCAL_GID:-12345}"

actual="$(docker run --rm -e LOCAL_UID="${test_uid}" -e LOCAL_GID="${test_gid}" "${image_name}" id -u)"
[ "${actual}" = "${test_uid}" ]

docker run --rm "${image_name}" sh -c 'test "$PWD" = /workspace && test "$USER" != root'

echo "Runtime smoke tests passed"
