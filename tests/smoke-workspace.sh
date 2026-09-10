#!/bin/sh
set -eu

image_name="${CYBERLAB_IMAGE:-cyberlab:latest}"
test_workspace="$(mktemp -d "${TMPDIR:-/tmp}/cyberlab-workspace.XXXXXX")"
trap 'rm -rf "${test_workspace}"' EXIT HUP INT TERM

if [ "$(uname -s)" = "Linux" ]; then
    test_uid="$(id -u)"
    test_gid="$(id -g)"
else
    test_uid=1000
    test_gid=1000
fi

docker run --rm \
    -e LOCAL_UID="${test_uid}" \
    -e LOCAL_GID="${test_gid}" \
    --mount "type=bind,source=${test_workspace},target=/workspace" \
    "${image_name}" sh -c 'printf persisted > /workspace/probe'

[ "$(cat "${test_workspace}/probe")" = "persisted" ]

if [ "$(uname -s)" = "Linux" ]; then
    [ "$(stat -c %u "${test_workspace}/probe")" = "${test_uid}" ]
fi

echo "Workspace smoke tests passed"
