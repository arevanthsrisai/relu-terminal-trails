#!/usr/bin/env bash
# Level 03 validator: checks the account discovered through text search.
set -u

LEVEL_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
expected_account='evelyn.kline'
access_key=$(sed -n 's/^ACCESS_KEY=//p' "$LEVEL_DIR/.metadata.conf" | sed -n '1p')

printf 'Enter infected account identifier: '
IFS= read -r supplied_account || exit 1
supplied_account=$(printf '%s' "$supplied_account" | tr -d '[:cntrl:]')

if [ "$supplied_account" = "$expected_account" ]; then
    printf '%s\n' 'MISSION VERIFIED - Linear Search insight unlocked.'
    printf 'Access key: %s\n' "$access_key"
    exit 0
fi

printf '%s\n' 'MISSION NOT YET VERIFIED - Search the employee records again.'
exit 1
