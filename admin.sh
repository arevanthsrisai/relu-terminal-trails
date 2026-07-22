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
    printf '%s\n' '5) Skip Current Sector'
    printf '%s\n' '6) Force Complete Tournament'
    printf '%s\n' '0) Exit'
}

view_status() {
    if ! progress_exists "$GAME_ROOT"; then
        printf '%s\n' 'No active session.'
        return 0
    fi

    printf '==================================\n'
    printf 'CURRENT SESSION\n'
    printf '==================================\n'
    printf 'Team            : %s\n' "$(progress_get "$GAME_ROOT" TEAM)"
    printf 'Current Sector  : %s\n' "$(progress_get "$GAME_ROOT" CURRENT_SECTOR)"
    printf 'Current Level   : %s / 7\n' "$(progress_get "$GAME_ROOT" CURRENT_LEVEL)"
    printf 'Elapsed Time    : %s\n' "$(progress_get "$GAME_ROOT" ELAPSED_TIME)"
    printf 'Current Score   : %s / 1000\n' "$(progress_get "$GAME_ROOT" CURRENT_SCORE)"
    printf 'Best Score      : %s\n' "$(progress_get "$GAME_ROOT" BEST_SCORE)"
    printf 'Hints Used      : %s\n' "$(progress_get "$GAME_ROOT" HINTS_USED)"
    printf 'Status          : %s\n' "$(progress_get "$GAME_ROOT" STATUS)"
    printf '==================================\n'
}

view_scoreboard() {
    if ! progress_exists "$GAME_ROOT"; then
        printf '%s\n' 'No scoreboard available.'
        return 0
    fi

    average=$(progress_average_scores "$GAME_ROOT" 7)

    printf '==================================\n'
    printf 'CURRENT SESSION\n'
    printf '==================================\n'
    printf 'Team            : %s\n' "$(progress_get "$GAME_ROOT" TEAM)"
    printf 'Current Sector  : %s\n' "$(progress_get "$GAME_ROOT" CURRENT_SECTOR)"
    printf 'Current Level   : %s / 7\n' "$(progress_get "$GAME_ROOT" CURRENT_LEVEL)"
    printf 'Status          : %s\n' "$(progress_get "$GAME_ROOT" STATUS)"
    printf 'Current Score   : %s / 1000\n' "$(progress_get "$GAME_ROOT" CURRENT_SCORE)"
    printf 'Tournament Avg  : %s / 1000\n' "$average"
    printf 'Hints Used      : %s\n' "$(progress_get "$GAME_ROOT" HINTS_USED)"
    printf '==================================\n'
}

view_logs() {
    if [ ! -d "$GAME_ROOT/.logs" ]; then
        printf '%s\n' 'No logs directory.'
        return
    fi

    logs=$(find "$GAME_ROOT/.logs" -maxdepth 1 -type f -name "*.log")

    if [ -z "$logs" ]; then
        printf '%s\n' 'No log files found.'
        return
    fi

    printf '%s\n' 'Available Logs'
    printf '%s\n' '--------------'

    printf '%s\n' "$logs" | while read -r log; do
        basename "$log"
    done
}

skip_current_sector() {
    "$GAME_ROOT/.engine/admin_skip.sh"
}

force_complete_tournament() {
    if ! progress_exists "$GAME_ROOT"; then
        printf '%s\n' 'No active session.'
        return 0
    fi

    read -rp "Force complete tournament? Remaining sectors will score 0. [y/N]: " confirm

    case "$confirm" in
        y|Y) ;;
        *)
            printf '%s\n' 'Cancelled.'
            return 0
            ;;
    esac

    current_level=$(progress_get "$GAME_ROOT" CURRENT_LEVEL)

    level=$current_level
    while [ "$level" -le 7 ]; do
        progress_record_sector_score "$GAME_ROOT" "$level" 0
        level=$((level + 1))
    done

    final_average=$(progress_average_scores "$GAME_ROOT" 7)

    progress_set_value "$GAME_ROOT" CURRENT_SCORE 0
    progress_set_value "$GAME_ROOT" STATUS COMPLETE
    progress_set_value "$GAME_ROOT" CURRENT_LEVEL 7
    progress_set_value "$GAME_ROOT" CURRENT_SECTOR "Sector Golf"

    printf '\n'
    printf '=========================================\n'
    printf ' TOURNAMENT FORCE COMPLETED\n'
    printf '=========================================\n'
    printf 'Remaining sector scores set to 0.\n'
    printf 'Final Average : %s / 1000\n' "$final_average"
    printf '=========================================\n'

    team=$(progress_get "$GAME_ROOT" TEAM | tr ' ' '_')
    log_file="$GAME_ROOT/.logs/${team}.log"

    {
        printf '\n'
        printf '==================================\n'
        printf 'TOURNAMENT FORCE COMPLETED\n'
        printf '==================================\n'
        printf 'Final Average : %s / 1000\n' "$final_average"
        printf 'Remaining sectors recorded as 0.\n'
        printf 'Tournament terminated by administrator.\n'
        printf '==================================\n'
    } >> "$log_file"
}

while :; do
    print_menu
    printf 'Selection: '
    IFS= read -r choice || exit 1

    case "$choice" in
        1)
            view_status
            ;;
        2)
            "$GAME_ROOT/reset.sh"
            ;;
        3)
            view_scoreboard
            ;;
        4)
            view_logs
            ;;
        5)
            skip_current_sector
            ;;
        6)
            force_complete_tournament
            ;;
        0)
            exit 0
            ;;
        *)
            printf '%s\n' 'Invalid choice.'
            ;;
    esac

    printf '\n'
done