#!/usr/bin/env bash
# Level 01 validator: confirms that the player recovered the office key.
set -u

LEVEL_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
expected_key=$(sed -n 's/^ACCESS_KEY=//p' "$LEVEL_DIR/.metadata.conf" | sed -n '1p')
printf 'Enter recovered office key: '
IFS= read -r supplied_key || exit 1
supplied_key=$(printf '%s' "$supplied_key" | tr -d '[:cntrl:]')

if [ "$supplied_key" = "$expected_key" ]; then
    printf '%s\n' 'MISSION VERIFIED — Filesystem Tree insight unlocked.'
    exit 0
fi

printf '%s\n' 'MISSION NOT YET VERIFIED — Continue searching the office.'
exit 1
