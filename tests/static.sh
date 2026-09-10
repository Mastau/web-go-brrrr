#!/bin/sh
set -eu

project_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

find "${project_root}/docker" "${project_root}/scripts" "${project_root}/tests" \
    -type f \( -name '*.sh' -o -path "${project_root}/scripts/*" \) | while IFS= read -r script; do
        sh -n "${script}"
        [ -x "${script}" ] || { echo "Not executable: ${script}" >&2; exit 1; }
    done

if command -v shellcheck >/dev/null 2>&1; then
    find "${project_root}/docker" "${project_root}/scripts" "${project_root}/tests" \
        -type f \( -name '*.sh' -o -path "${project_root}/scripts/*" \) \
        -exec shellcheck {} +
fi

echo "Static checks passed"
