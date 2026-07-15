#!/usr/bin/env bash
# Epoch-second timer helpers; compatible with Git Bash's GNU core utilities.

set -euo pipefail

timer_elapsed() {
    started=${1:-0}
    now=$(date +%s)
    case $started in
        ''|*[!0-9]*) printf '0\n' ;;
        *)
            if [ "$now" -lt "$started" ]; then
                printf '0\n'
            else
                printf '%s\n' $((now - started))
            fi
            ;;
    esac
}

timer_format() {
    total=${1:-0}
    minutes=$((total / 60))
    seconds=$((total % 60))
    printf '%02d:%02d\n' "$minutes" "$seconds"
}
