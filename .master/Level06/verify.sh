#!/usr/bin/env bash
# Level 06 validator: runs the repaired automation script and checks its output.
set -u

LEVEL_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
script="$LEVEL_DIR/challenge/broken_dispatch.sh"
access_key=$(sed -n 's/^ACCESS_KEY=//p' "$LEVEL_DIR/.metadata.conf" | sed -n '1p')

if [ ! -f "$script" ]; then
    printf '%s\n' 'MISSION NOT YET VERIFIED — Dispatcher script is missing.'
    exit 1
fi

output=$(bash "$script" 2>&1) || {
    printf '%s\n' 'MISSION NOT YET VERIFIED — Dispatcher script does not run.'
    exit 1
}

expected_output='Dispatching NightShift to alpha
Access key: '"$access_key"

if [ "$output" = "$expected_output" ]; then
    printf '%s\n' 'MISSION VERIFIED — Hash Map insight unlocked.'
    printf '%s\n' 'Access Key: TT-MAP-6194'
    exit 0
fi

printf '%s\n' 'MISSION NOT YET VERIFIED — Compare the script output to repair_requirements.txt.'
exit 1
