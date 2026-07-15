#!/usr/bin/env bash
# All player workspace changes live here. .master/ is read-only by convention and
# is never a destination for copy, remove, or reset operations.

set -euo pipefail

format_level() {
    printf '%02d' "$1"
}

master_level_path() {
    printf '%s/.master/Level%s\n' "$1" "$(format_level "$2")"
}

runtime_current_path() {
    printf '%s/runtime/current\n' "$1"
}

runtime_is_empty() {
    root=$1
    current_dir=$(runtime_current_path "$root")
    if [ ! -d "$current_dir" ]; then
        return 0
    fi
    contents=$(find "$current_dir" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null || true)
    [ -z "$contents" ]
}

runtime_level_exists() {
    [ -d "$(master_level_path "$1" "$2")" ]
}

runtime_deploy_level() {
    root=$1
    level=$2
    source_dir=$(master_level_path "$root" "$level")
    destination_dir=$(runtime_current_path "$root")
    [ -d "$source_dir" ] || return 1
    [ "$destination_dir" = "$root/runtime/current" ] || return 1

    cd "$root" || return 1
    rm -rf "$destination_dir"
    mkdir -p "$destination_dir"
    if ! cp -R "$source_dir"/. "$destination_dir"/; then
        rm -rf "$destination_dir"
        return 1
    fi
}

runtime_restore_current() {
    root=$1
    progress_level=$(progress_get "$root" CURRENT_LEVEL)
    [ -n "$progress_level" ] || progress_level=1
    current_dir=$(runtime_current_path "$root")
    source_dir=$(master_level_path "$root" "$progress_level")
    if [ ! -d "$current_dir" ] || [ ! -f "$current_dir/README.txt" ] || [ ! -f "$current_dir/verify.sh" ]; then
        runtime_deploy_level "$root" "$progress_level"
    fi
}

runtime_reset() {
    root=$1
    runtime_dir="$root/runtime"
    expected="$root/runtime"
    [ "$runtime_dir" = "$expected" ] && [ -n "$runtime_dir" ] || return 1
    rm -rf "$runtime_dir"
    mkdir -p "$runtime_dir/current"
    runtime_deploy_level "$root" 1
}
