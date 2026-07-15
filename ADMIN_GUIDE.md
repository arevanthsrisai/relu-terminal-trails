# Terminal Trials volunteer guide

## Before players arrive

1. Keep one untouched master copy of `TerminalTrials/`.
2. Make one complete copy per team or station.
3. Run the checks in `TESTING.md`.
4. Confirm PortableGit / Git Bash is installed and `start.bat` opens Git Bash.

## Start a game

1. Open the team project copy in Windows Explorer.
2. Double-click `start.bat`.
3. Ask the team for its name at the `Team Name:` prompt.
4. Leave the terminal open in `runtime/current`.

Players should use only `access`, `verify`, and `hint`. Hidden `.master/`,
`.engine/`, `.admin/`, `.progress/`, `.logs/`, `.metadata.conf`, and `.hints/`
paths are for organizers.

## Monitor a game

From a separate Git Bash terminal in the project root:

```bash
cat .progress/progress.conf
tail -n 8 .logs/<team-file-name>.log
find runtime/current -maxdepth 2 -type f
```

Team log file names replace unsupported filename characters with underscores.
For example, `QA Team` becomes `.logs/QA_Team.log`.

## Stop a game safely

Ask the team to type `exit`. Runtime files, progress, timer state, and logs stay
on disk. To resume, run `start.bat` again in the same project copy.

## Reset a team

Only reset with the team's agreement:

```bash
./reset.sh
```

Reset removes the active workspace and restores `runtime/current` from cleaned
Level01. Logs are retained.

## Common recovery

- Wrong key: no action needed; `ACCESS DENIED` leaves state unchanged.
- Closed terminal: run `start.bat` again in the same project copy.
- Damaged runtime: run `reset.sh` only after explaining that work is lost.
- Damaged master: discard that station copy and replace it from the untouched
  master copy.
- Sector Golf completed: the final `access` writes the mission summary.

## After the event

Archive `.logs/` and `.progress/progress.conf` if the event needs results.
