#!/bin/sh
set -eu

runtime_user="${LAB_USER:-lab}"
runtime_uid="${LOCAL_UID:-1000}"
runtime_gid="${LOCAL_GID:-1000}"

case "${runtime_uid}:${runtime_gid}" in
    *[!0-9:]*|:*|*:) echo "LOCAL_UID and LOCAL_GID must be numeric" >&2; exit 64 ;;
esac

current_uid="$(id -u "${runtime_user}")"
current_gid="$(id -g "${runtime_user}")"

if [ "${runtime_gid}" != "${current_gid}" ]; then
    if getent group "${runtime_gid}" >/dev/null 2>&1; then
        usermod --gid "${runtime_gid}" "${runtime_user}"
    else
        groupmod --gid "${runtime_gid}" "${runtime_user}"
    fi
fi

if [ "${runtime_uid}" != "${current_uid}" ]; then
    usermod --uid "${runtime_uid}" --gid "${runtime_gid}" "${runtime_user}"
fi

export HOME="$(getent passwd "${runtime_user}" | cut -d: -f6)"
chown -R "${runtime_uid}:${runtime_gid}" "${HOME}"
export USER="${runtime_user}"
export LOGNAME="${runtime_user}"

if [ "$#" -eq 0 ]; then
    set -- zsh -l
elif [ "${1#-}" != "$1" ]; then
    set -- zsh "$@"
fi

exec gosu "${runtime_user}" "$@"
