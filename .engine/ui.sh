#!/usr/bin/env bash
# Shared, deliberately small terminal UI helpers. ANSI color is supported by
# Git Bash; output remains readable in terminals that ignore escape sequences.

set -euo pipefail

TT_GREEN='\033[1;32m'
TT_DIM_GREEN='\033[0;32m'
TT_RED='\033[1;31m'
TT_YELLOW='\033[1;33m'
TT_RESET='\033[0m'

clear_screen() {
    command -v clear >/dev/null 2>&1 && clear || true
}

print_boot_sequence() {
    if [ "${TT_SKIP_ANIMATIONS:-0}" = "1" ]; then
        return 0
    fi
    clear_screen
    printf '%b\n' "${TT_GREEN}INITIALIZING RECOVERY TERMINAL${TT_RESET}"
    printf '%b\n' "${TT_DIM_GREEN}:: Secure link established ::${TT_RESET}"
    for _ in 1 2 3 4 5; do
        printf '%b' "${TT_GREEN}#${TT_RESET}"
        sleep 0.15
    done
    printf '\n'
}

print_progress_animation() {
    if [ "${TT_SKIP_ANIMATIONS:-0}" = "1" ]; then
        return 0
    fi
    message=$1
    printf '%b\n' "${TT_YELLOW}${message}${TT_RESET}"
    for _ in 1 2 3 4 5; do
        printf '%b' "${TT_GREEN}.${TT_RESET}"
        sleep 0.1
    done
    printf '\n'
}

print_banner() {
    printf '%b\n' "$TT_GREEN"
    printf '%s\n' '  _______                  _             _ _____     _       _     '
    printf '%s\n' ' |__   __|                (_)           | |  __ \   (_)     | |    '
    printf '%s\n' '    | | ___ _ __ _ __ ___  _ _ __   __ _| | |  | |_ __ _  __| |___ '
    printf '%s\n' '    | |/ _ \ ''__| ''_ ` _ \| | ''_ \ / _` | | |  | | ''__| |/ _` / __|'
    printf '%s\n' '    | |  __/ |  | | | | | | | | | (_| | | |__| | |  | | (_| \__ \'
    printf '%s\n' '    |_|\___|_|  |_| |_| |_|_|_| |_|\__,_|_|_____/|_|  |_|\__,_|___/'
    printf '%b\n' "$TT_RESET"
    printf '%b\n\n' "${TT_DIM_GREEN}:: OFFLINE RECOVERY SIMULATION ::${TT_RESET}"
}

print_welcome() {
    team_name=$1
    current_level=$2
    printf '%b\n' "${TT_GREEN}Welcome, ${team_name}.${TT_RESET}"
    printf '%b\n' "${TT_DIM_GREEN}Current sector: $(sector_name_for_level "$current_level")${TT_RESET}"
    printf '\n'
}

print_error() {
    printf '%b\n' "${TT_RED}ERROR: $1${TT_RESET}" >&2
}

print_denied() {
    printf '%b\n' "${TT_RED}ACCESS DENIED${TT_RESET}"
    printf '%b\n' "${TT_YELLOW}Recovery key mismatch. The terminal remains sealed.${TT_RESET}"
}

print_granted() {
    printf '%b\n' "${TT_GREEN}ACCESS GRANTED${TT_RESET}"
    printf '%b\n' "${TT_DIM_GREEN}Sector transfer complete. The terminal is reloading the next workspace.${TT_RESET}"
}

print_reset_complete() {
    printf '%b\n' "${TT_GREEN}RESET COMPLETE${TT_RESET}"
    printf '%b\n' "${TT_DIM_GREEN}runtime/current restored; progress cleared; logs retained.${TT_RESET}"
}

print_recovery_message() {
    printf '%b\n' "${TT_GREEN}UNIVERSITY RECOVERY TERMINAL${TT_RESET}"
    printf '%b\n' "${TT_DIM_GREEN}Authenticate your clearance token to advance.${TT_RESET}"
}

prompt_for_team_name() {
    while :; do
        printf 'Team Name: ' >&2
        IFS= read -r team_name || exit 1
        team_name=$(printf '%s' "$team_name" | tr -d '[:cntrl:]')
        if [ -n "$team_name" ]; then
            TT_TEAM_NAME=$team_name
            printf '%s\n' "$team_name"
            return 0
        fi
        print_error "Team name cannot be empty."
    done
}
