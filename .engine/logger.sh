#!/usr/bin/env bash
# Completion audit log. Team text is retained in each line; only the filename is
# sanitized for Windows portability.

set -euo pipefail

team_log_name() {
    safe_name=$(printf '%s' "$1" | tr -cs 'A-Za-z0-9._-' '_')
    safe_name=${safe_name#_}
    safe_name=${safe_name%_}
    [ -n "$safe_name" ] || safe_name='unnamed-team'
    printf '%s\n' "$safe_name"
}

log_completion() {
    root=$1
    team_name=$2
    level=$3
    seconds=$4
    log_file="$root/.logs/$(team_log_name "$team_name").log"
    duration=$(timer_format "$seconds")
    score_key=$(progress_level_score_key "$level")
    sector_score=$(progress_get "$root" "$score_key")
    [ -n "$sector_score" ] || sector_score=$(progress_get "$root" CURRENT_SCORE)
    hint_key=$(progress_level_hint_key "$level")
    hints_used=$(progress_get "$root" "$hint_key")
    [ -n "$hints_used" ] || hints_used=0
    running_average=$(progress_average_scores "$root" "$level")
    mkdir -p "$root/.logs"
    {
        printf '%s\n' '=================================='
        printf 'Team: %s\n' "$team_name"
        printf 'Sector Name: %s\n' "$(sector_name_for_level "$level")"
        printf 'Time: %s\n' "$duration"
        printf 'Hints Used: %s / 2\n' "$hints_used"
        printf 'Sector Score: %s / 1000\n' "$sector_score"
        printf 'Running Average: %s / 1000\n' "$running_average"
        printf '%s\n' '=================================='
    } >> "$log_file"
}

log_session_summary() {
    root=$1
    team_name=$2
    status=$3
    log_file="$root/.logs/$(team_log_name "$team_name").log"
    final_average=$(progress_average_scores "$root" 7)
    tournament_seconds=$(progress_get "$root" TOTAL_TOURNAMENT_TIME)
    [ -n "$tournament_seconds" ] || tournament_seconds=$(progress_tournament_elapsed "$root")
    tournament_time=$(timer_format "$tournament_seconds")
    total_hints=$(progress_get "$root" HINTS_USED)
    [ -n "$total_hints" ] || total_hints=0
    mkdir -p "$root/.logs"
    {
        if [ "$status" = "Completed" ]; then
            printf '%s\n' 'MISSION COMPLETE'
        else
            printf 'Session: %s\n' "$status"
        fi
        printf 'Team: %s\n' "$team_name"
        printf '%s\n' 'Sector Scores'
        for level in 1 2 3 4 5 6 7; do
            score_key=$(progress_level_score_key "$level")
            score=$(progress_get "$root" "$score_key")
            [ -n "$score" ] || score=0
            printf '%-7s : %s\n' "$(sector_short_name_for_level "$level")" "$score"
        done
        printf 'Final Average: %s / 1000\n' "$final_average"
        printf 'Tournament Time: %s\n' "$tournament_time"
        printf 'Hints Used: %s\n' "$total_hints"
    } >> "$log_file"
}
