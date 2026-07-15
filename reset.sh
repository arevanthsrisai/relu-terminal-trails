#!/usr/bin/env bash
# Reset only the player's workspace and progress. Completion logs are retained.

set -euo pipefail

GAME_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

. "$GAME_ROOT/.engine/ui.sh"
. "$GAME_ROOT/.engine/logger.sh"
. "$GAME_ROOT/.engine/progress.sh"
. "$GAME_ROOT/.engine/runtime_manager.sh"

ensure_game_directories "$GAME_ROOT"
hide_internal_paths "$GAME_ROOT"

team_name=""
if progress_exists "$GAME_ROOT"; then
    team_name=$(progress_get "$GAME_ROOT" TEAM)
fi

if [ -n "$team_name" ]; then
    archive_dir="$GAME_ROOT/.logs/archive"
    mkdir -p "$archive_dir"
    archive_name="$(printf '%s' "$team_name" | tr -cs 'A-Za-z0-9._-' '_')"
    archive_file="$archive_dir/${archive_name}_$(date +%Y%m%d%H%M%S).log"
    if progress_exists "$GAME_ROOT"; then
        cp "$(progress_file "$GAME_ROOT")" "$archive_file"
    fi
fi

rm -f "$GAME_ROOT/.progress/progress.conf"
rm -f "$GAME_ROOT/.progress"/*.tmp 2>/dev/null || true
runtime_reset "$GAME_ROOT" || exit 1
progress_clear "$GAME_ROOT"
hide_internal_paths "$GAME_ROOT"

print_reset_complete
printf '%s\n' "Start a new session with ./start.sh (or start.bat from Windows)."
