#!/usr/bin/env bash
# Progress persistence. Values are read without sourcing the file, so team names
# cannot turn the configuration file into executable shell code.

set -euo pipefail

progress_file() {
    printf '%s/.progress/progress.conf\n' "$1"
}

ensure_game_directories() {
    mkdir -p "$1/runtime/current" "$1/.master" "$1/.engine" "$1/.progress" "$1/.logs" "$1/.logs/archive" "$1/.admin"
}

progress_exists() {
    [ -f "$(progress_file "$1")" ]
}

progress_get() {
    root=$1
    key=$2
    file=$(progress_file "$root")
    [ -f "$file" ] || return 0
    sed -n "s/^${key}=//p" "$file" | sed -n '1p'
}

sector_name_for_level() {
    case "$1" in
        1) printf 'Sector Alpha\n' ;;
        2) printf 'Sector Bravo\n' ;;
        3) printf 'Sector Charlie\n' ;;
        4) printf 'Sector Delta\n' ;;
        5) printf 'Sector Echo\n' ;;
        6) printf 'Sector Foxtrot\n' ;;
        7) printf 'Sector Golf\n' ;;
        *) printf 'Recovery Terminal\n' ;;
    esac
}

sector_short_name_for_level() {
    case "$1" in
        1) printf 'Alpha\n' ;;
        2) printf 'Bravo\n' ;;
        3) printf 'Charlie\n' ;;
        4) printf 'Delta\n' ;;
        5) printf 'Echo\n' ;;
        6) printf 'Foxtrot\n' ;;
        7) printf 'Golf\n' ;;
        *) printf 'Recovery\n' ;;
    esac
}

progress_level_score_key() {
    printf 'LEVEL%s_SCORE\n' "$1"
}

progress_level_hint_key() {
    printf 'HINTS_USED_LEVEL_%02d\n' "$1"
}

progress_tournament_start_time() {
    root=$1
    tournament_start=$(progress_get "$root" TOURNAMENT_START_TIME)
    if [ -z "$tournament_start" ]; then
        tournament_start=$(progress_get "$root" START_TIME)
    fi
    [ -n "$tournament_start" ] || tournament_start=$(date +%s)
    printf '%s\n' "$tournament_start"
}

progress_tournament_elapsed() {
    root=$1
    tournament_start=$(progress_tournament_start_time "$root")
    now=$(date +%s)
    if [ "$now" -lt "$tournament_start" ]; then
        printf '0\n'
        return 0
    fi
    printf '%s\n' "$((now - tournament_start))"
}

progress_elapsed_since_start() {
    root=$1
    start_time=$(progress_get "$root" START_TIME)
    [ -n "$start_time" ] || start_time=$(date +%s)
    now=$(date +%s)
    if [ "$now" -lt "$start_time" ]; then
        printf '0\n'
        return 0
    fi
    printf '%s\n' "$((now - start_time))"
}

progress_current_sector_hints() {
    root=$1
    level=$(progress_get "$root" CURRENT_LEVEL)
    [ -n "$level" ] || level=1
    hint_key=$(progress_level_hint_key "$level")
    hints=$(progress_get "$root" "$hint_key")
    [ -n "$hints" ] || hints=0
    printf '%s\n' "$hints"
}

progress_calculate_sector_score() {
    root=$1
    elapsed=$(progress_elapsed_since_start "$root")
    hints=$(progress_current_sector_hints "$root")
    score=$((1000 - ((elapsed / 15) * 25) - (hints * 150)))
    if [ "$score" -lt 0 ]; then
        score=0
    fi
    if [ "$score" -gt 1000 ]; then
        score=1000
    fi
    printf '%s\n' "$score"
}

progress_record_sector_score() {
    root=$1
    level=$2
    score=$3
    score_key=$(progress_level_score_key "$level")
    progress_set_value "$root" "$score_key" "$score"
    progress_set_value "$root" CURRENT_SCORE "$score"
}

progress_average_scores() {
    root=$1
    completed_count=$2
    sum=0
    count=0
    level=1
    while [ "$level" -le "$completed_count" ]; do
        score_key=$(progress_level_score_key "$level")
        score=$(progress_get "$root" "$score_key")
        if [ -n "$score" ]; then
            sum=$((sum + score))
            count=$((count + 1))
        fi
        level=$((level + 1))
    done
    if [ "$count" -eq 0 ]; then
        printf '0\n'
        return 0
    fi
    printf '%s\n' "$(((sum + (count / 2)) / count))"
}

progress_initialize() {
    root=$1
    team_name=$2
    file=$(progress_file "$root")
    start_time=$(date +%s)
    (
        umask 077
        {
            printf 'TEAM=%s\n' "$team_name"
            printf 'CURRENT_LEVEL=1\n'
            printf 'START_TIME=%s\n' "$start_time"
            printf 'TOURNAMENT_START_TIME=%s\n' "$start_time"
            printf 'HINTS_USED=0\n'
            printf 'CURRENT_SCORE=1000\n'
            printf 'BEST_SCORE=1000\n'
            printf 'ELAPSED_TIME=0\n'
            printf 'CURRENT_SECTOR=Sector Alpha\n'
            printf 'STATUS=ACTIVE\n'
            printf 'HINTS_USED_LEVEL_01=0\n'
        } > "$file"
    )
}

progress_load() {
    :
}

progress_set_value() {
    root=$1
    key=$2
    value=$3
    file=$(progress_file "$root")
    [ -f "$file" ] || return 1
    temp_file="$file.tmp.$$"
    if awk -F= -v key="$key" -v value="$value" '
        $1 == key { print key "=" value; found=1; next }
        { print }
        END { if (!found) print key "=" value }
    ' "$file" > "$temp_file" && mv "$temp_file" "$file"; then
        return 0
    fi
    rm -f "$temp_file"
    return 1
}

progress_record_hint() {
    root=$1
    current_hints=$(progress_get "$root" HINTS_USED)
    [ -n "$current_hints" ] || current_hints=0
    next_hints=$((current_hints + 1))
    progress_set_value "$root" HINTS_USED "$next_hints"
}

hide_internal_paths() {
    root=$1
    for target in "$root/.master" "$root/.engine" "$root/.progress" "$root/.admin" "$root/.logs"; do
        [ -e "$target" ] || continue
    done
}

progress_advance() {
    root=$1
    next_level=$2
    file=$(progress_file "$root")
    [ -f "$file" ] || return 1
    temp_file="$file.tmp.$$"
    next_start=$(date +%s)
    next_sector=$(sector_name_for_level "$next_level")
    next_hint_key=$(progress_level_hint_key "$next_level")

    if awk -F= -v level="$next_level" -v started="$next_start" -v sector="$next_sector" -v hint_key="$next_hint_key" '
        $1 == "CURRENT_LEVEL" { print "CURRENT_LEVEL=" level; next }
        $1 == "START_TIME" { print "START_TIME=" started; next }
        $1 == "CURRENT_SCORE" { print "CURRENT_SCORE=1000"; next }
        $1 == "CURRENT_SECTOR" { print "CURRENT_SECTOR=" sector; next }
        $1 == "STATUS" { print "STATUS=ACTIVE"; next }
        $1 == hint_key { found_hint=1; print hint_key "=0"; next }
        { print }
        END { if (!found_hint) print hint_key "=0" }
    ' "$file" > "$temp_file" && mv "$temp_file" "$file"; then
        return 0
    fi

    rm -f "$temp_file"
    return 1
}

progress_mark_complete() {
    root=$1
    progress_set_value "$root" STATUS COMPLETE
    progress_set_value "$root" CURRENT_LEVEL 7
    progress_set_value "$root" CURRENT_SECTOR "Sector Golf"
}

progress_clear() {
    rm -f "$(progress_file "$1")"
}
