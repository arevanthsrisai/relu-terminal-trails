#!/usr/bin/env bash
# Level 05 validator: verifies the repeated history credential.
set -u

LEVEL_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
expected_key=$(sed -n 's/^ACCESS_KEY=//p' "$LEVEL_DIR/.metadata.conf" | sed -n '1p')
printf 'Enter repeated history credential: '
IFS= read -r supplied_key || exit 1
supplied_key=$(printf '%s' "$supplied_key" | tr -d '[:cntrl:]')

if [ "$supplied_key" = "$expected_key" ]; then
    printf '%s\n' 'MISSION VERIFIED — Stack, Queue, and Pipeline insight unlocked.'
    exit 0
fi

printf '%s\n' 'MISSION NOT YET VERIFIED — Filter and deduplicate the history again.'
exit 1
