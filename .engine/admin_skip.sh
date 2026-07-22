#!/usr/bin/env bash
set -euo pipefail

GAME_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

# Load engine modules
source "$GAME_ROOT/.engine/progress.sh"
source "$GAME_ROOT/.engine/runtime_manager.sh"
source "$GAME_ROOT/.engine/logger.sh"

current_level=$(progress_get "$GAME_ROOT" CURRENT_LEVEL)

if [ -z "$current_level" ]; then
    echo "ERROR: No active game."
    exit 1
fi

echo "Current Sector: $(sector_name_for_level "$current_level")"
read -rp "Skip this sector? Score will be 0. [y/N]: " confirm

case "$confirm" in
    y|Y) ;;
    *)
        echo "Cancelled."
        exit 0
        ;;
esac

# Record zero score
progress_record_sector_score "$GAME_ROOT" "$current_level" 0

# Log the skip (only if your logger supports it)
if command -v log_event >/dev/null 2>&1; then
    log_event "$GAME_ROOT" "Sector skipped" \
        "level=$current_level sector=$(sector_name_for_level "$current_level") score=0"
fi

# Final level?
if [ "$current_level" -ge 7 ]; then
    progress_mark_complete "$GAME_ROOT"
    echo
    echo "Final sector skipped."
    echo "Run the normal completion flow if required."
    exit 0
fi

next_level=$((current_level + 1))

progress_advance "$GAME_ROOT" "$next_level"
runtime_deploy_level "$GAME_ROOT" "$next_level"

echo
echo "Sector skipped."
echo "Now entering $(sector_name_for_level "$next_level")."