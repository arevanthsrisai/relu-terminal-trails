# Terminal Trials pre-event testing

Run these checks in Git Bash from the `TerminalTrials/` directory. Test a copied
project folder so event logs and progress stay clean.

## Static checks

```bash
bash -n start.sh access verify hint reset.sh .engine/*.sh .master/Level*/verify.sh
for level in .master/Level0[1-7]; do
  test -f "$level/README.txt" &&
  test -f "$level/.metadata.conf" &&
  test -d "$level/challenge" &&
  test -f "$level/.hints/.hint1.txt" &&
  test -f "$level/.hints/.hint2.txt" &&
  test -d "$level/assets" &&
  test -f "$level/verify.sh" || exit 1
done
```

## Fresh start

1. Double-click `start.bat`.
2. Enter a temporary team name such as `QA Team`.
3. Confirm the shell opens in `runtime/current`.
4. Confirm `access`, `verify`, and `hint` work from subdirectories.
5. Inspect `.progress/progress.conf` and `.logs/QA_Team.log`.

## Unlock checks

Solve each sector, run `verify`, then run `access`. Keys are stored only in each
sector's hidden `.metadata.conf`.

| Completed sector | Access key | Expected result |
| --- | --- | --- |
| 01 | `TT-OFFICE-7419` | Level02 deployed to `runtime/current` |
| 02 | `TT-ARCHIVE-2684` | Level03 deployed to `runtime/current` |
| 03 | `TT-INCIDENT-5931` | Level04 deployed to `runtime/current` |
| 04 | `TT-LOG-8042` | Level05 deployed to `runtime/current` |
| 05 | `TT-PIPE-5410` | Level06 deployed to `runtime/current` |
| 06 | `TT-MAP-6194` | Level07 deployed to `runtime/current` |
| 07 | `TT-LINK-7352` | Mission summary logged |

After each unlock, check:

```bash
cat .progress/progress.conf
tail -n 8 .logs/QA_Team.log
find runtime/current -maxdepth 2 -name access -o -name verify -o -name hint
```

Wrong keys must print `ACCESS DENIED` and leave progress unchanged.

## Reset check

From the project root:

```bash
./reset.sh
```

Confirm `runtime/current` contains the cleaned Level01 workspace,
`.progress/progress.conf` is cleared or recreated on the next start, and
existing files in `.logs/` remain present.

## Acceptance criteria

The project is ready when there are exactly seven playable sectors, no generated
command files or old visible key files exist, hidden `.metadata.conf` and
`.hints/` exist, all sectors verify, Level01 through
Level06 unlock the next sector, Level07 completes the mission, reset preserves
logs, and no test changed `.master/`.
