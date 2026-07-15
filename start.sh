#!/usr/bin/env bash
# Terminal Trials entry point. Run this from Git Bash (normally via start.bat).

set -euo pipefail

GAME_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

. "$GAME_ROOT/.engine/ui.sh"
. "$GAME_ROOT/.engine/logger.sh"
. "$GAME_ROOT/.engine/progress.sh"
. "$GAME_ROOT/.engine/timer.sh"
. "$GAME_ROOT/.engine/runtime_manager.sh"

ensure_game_directories "$GAME_ROOT"
hide_internal_paths "$GAME_ROOT"

if ! progress_exists "$GAME_ROOT" || [ -z "$(progress_get "$GAME_ROOT" TEAM)" ]; then
    clear_screen
    print_boot_sequence
    print_banner
    prompt_for_team_name >/dev/null
    team_name=$TT_TEAM_NAME
    progress_initialize "$GAME_ROOT" "$team_name"
    progress_set_value "$GAME_ROOT" START_TIME "$(date +%s)"
else
    progress_load "$GAME_ROOT"
fi

if [ -f "$GAME_ROOT/.progress/progress.conf" ]; then
    team_name=$(progress_get "$GAME_ROOT" TEAM)
    if [ -n "$team_name" ]; then
        trap 'status=$(progress_get "$GAME_ROOT" STATUS); if [ "$status" = "COMPLETE" ]; then exit 0; fi; elapsed=$(timer_elapsed "$(progress_get "$GAME_ROOT" START_TIME)"); progress_set_value "$GAME_ROOT" ELAPSED_TIME "$elapsed"; exit 0' EXIT
    fi
fi

if runtime_is_empty "$GAME_ROOT"; then
    runtime_deploy_level "$GAME_ROOT" 1 || {
        print_error "Starter placeholder Level01 is missing from .master/."
        exit 1
    }
else
    runtime_restore_current "$GAME_ROOT"
fi

cd "$GAME_ROOT/runtime/current" || exit 1
clear_screen
print_banner
print_welcome "$(progress_get "$GAME_ROOT" TEAM)" "$(progress_get "$GAME_ROOT" CURRENT_LEVEL)"

printf '%s\n' "Workspace: $PWD"
printf '%s\n' "Use access, verify and hint from anywhere in the current workspace."
printf '%s\n\n' "Run ./../reset.sh to begin again."

if [ "${TT_NON_INTERACTIVE:-0}" = "1" ]; then
    exit 0
fi

export TERMINAL_TRIALS_ROOT="$GAME_ROOT"
case ":$PATH:" in
    *":$GAME_ROOT:"*) ;;
    *) PATH="$GAME_ROOT:$PATH" ;;
esac
export PATH
hash -r 2>/dev/null || true

for command_name in access verify hint; do
    command -v "$command_name" >/dev/null 2>&1 || true
done

exec bash --noprofile --rcfile "$GAME_ROOT/.engine/game_shell.rc" -i
