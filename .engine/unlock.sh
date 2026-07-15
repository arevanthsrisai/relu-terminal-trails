#!/usr/bin/env bash
# Access-key validation. Each deployed sector stores its key in .metadata.conf.
# The metadata file is deliberately data, never sourced.

set -euo pipefail

unlock_validate_key() {
    root=$1
    level=$2
    entered_key=$3
    key_file="$root/runtime/current/.metadata.conf"

    [ -f "$key_file" ] || return 1
    expected_key=$(sed -n 's/^ACCESS_KEY=//p' "$key_file" | sed -n '1p')
    [ -n "$expected_key" ] || return 1
    [ "$entered_key" = "$expected_key" ]
}

unlock_validate_progress() {
    root=$1
    expected_level=$2
    current_level=$(progress_get "$root" CURRENT_LEVEL)
    [ -n "$current_level" ] || current_level=1
    [ "$current_level" -eq "$expected_level" ]
}
