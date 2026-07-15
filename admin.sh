#!/usr/bin/env bash
# Lightweight admin console for Terminal Trials.

set -euo pipefail

GAME_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

. "$GAME_ROOT/.engine/ui.sh"
. "$GAME_ROOT/.engine/progress.sh"

ensure_game_directories "$GAME_ROOT"

print_menu() {
    printf '%b\n' "${TT_GREEN}ADMIN CONSOLE${TT_RESET}"
    printf '%s\n' '1) View Status'
    printf '%s\n' '2) Reset Game'
    printf '%s\n' '3) View Scoreboard'
    printf '%s\n' '4) View Logs'
    printf '%s\n' '5) Force Unlock'
    printf '%s\n' '0) Exit'
}

view_status() {
    if ! progress_exists "$GAME_ROOT"; then
        printf '%s\n' 'No active session.'
        return 0
    fi
    printf 'Team: %s\n' "$(progress_get "$GAME_ROOT" TEAM)"
    printf 'Current Sector: %s\n' "$(progress_get "$GAME_ROOT" CURRENT_SECTOR)"
    printf 'Elapsed Time: %s\n' "$(progress_get "$GAME_ROOT" ELAPSED_TIME)"
    printf 'Current Score: %s\n' "$(progress_get "$GAME_ROOT" CURRENT_SCORE)"
    printf 'Best Score: %s\n' "$(progress_get "$GAME_ROOT" BEST_SCORE)"
    printf 'Hints Used: %s\n' "$(progress_get "$GAME_ROOT" HINTS_USED)"
    printf 'Completion %%: %s\n' "$(progress_get "$GAME_ROOT" CURRENT_LEVEL)"
    printf 'Status: %s\n' "$(progress_get "$GAME_ROOT" STATUS)"
}

view_scoreboard() {
    if ! progress_exists "$GAME_ROOT"; then
        printf '%s\n' 'No scoreboard available.'
        return 0
    fi
    printf '%s\n' 'TEAM | CURRENT SECTOR | SCORE | HINTS'
    printf '%s\n' "$(progress_get "$GAME_ROOT" TEAM) | $(progress_get "$GAME_ROOT" CURRENT_SECTOR) | $(progress_get "$GAME_ROOT" CURRENT_SCORE) | $(progress_get "$GAME_ROOT" HINTS_USED)"
}

view_logs() {
    if [ -d "$GAME_ROOT/.logs" ]; then
        ls "$GAME_ROOT/.logs" | sed -n '1,20p'
    fi
}

force_unlock() {
    if ! progress_exists "$GAME_ROOT"; then
        printf '%s\n' 'No active session.'
        return 0
    fi
    progress_mark_complete "$GAME_ROOT"
    printf '%s\n' 'Force unlock applied.'
}

while :; do
    print_menu
    printf 'Selection: '
    IFS= read -r choice || exit 1
    case "$choice" in
        1) view_status ;;
        2) "$GAME_ROOT/reset.sh" ;;
        3) view_scoreboard ;;
        4) view_logs ;;
        5) force_unlock ;;
        0) exit 0 ;;
        *) printf '%s\n' 'Invalid choice.' ;;
    esac
    printf '\n'
done
