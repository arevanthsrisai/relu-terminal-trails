#!/usr/bin/env bash
# Level 04 validator: requires both the reconstructed file and final key.
set -u

LEVEL_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_log="$LEVEL_DIR/challenge/corrupted_log.txt"
recovered_log="$LEVEL_DIR/challenge/recovered_log.txt"
expected_key=$(sed -n 's/^ACCESS_KEY=//p' "$LEVEL_DIR/.metadata.conf" | sed -n '1p')

if [ ! -f "$recovered_log" ]; then
    printf '%s\n' 'MISSION NOT YET VERIFIED — Create challenge/recovered_log.txt first.'
    exit 1
fi

if ! sort "$source_log" | cmp -s - "$recovered_log"; then
    printf '%s\n' 'MISSION NOT YET VERIFIED — recovered_log.txt is not the ordered source log.'
    exit 1
fi

printf 'Enter final reconstructed key: '
IFS= read -r supplied_key || exit 1
supplied_key=$(printf '%s' "$supplied_key" | tr -d '[:cntrl:]')

if [ "$supplied_key" = "$expected_key" ]; then
    printf '%s\n' 'MISSION VERIFIED — Terminal Trials complete.'
    printf '%s\n' 'DSA Insight: sorted records make the first and last array elements easy to inspect.'
    exit 0
fi

printf '%s\n' 'MISSION NOT YET VERIFIED — Read the first and last ordered records again.'
exit 1
