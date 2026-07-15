#!/usr/bin/env bash
# Level 07 validator: confirms the key assembled from opposite route ends.
set -u

LEVEL_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
expected_key=$(sed -n 's/^ACCESS_KEY=//p' "$LEVEL_DIR/.metadata.conf" | sed -n '1p')
printf 'Enter linked-evidence key: '
IFS= read -r supplied_key || exit 1
supplied_key=$(printf '%s' "$supplied_key" | tr -d '[:cntrl:]')

if [ "$supplied_key" = "$expected_key" ]; then
    printf '%s\n' 'MISSION VERIFIED — Linked Lists and Two Pointers insight unlocked.'
    exit 0
fi

printf '%s\n' 'MISSION NOT YET VERIFIED — Follow the references and compare route ends.'
exit 1
