# Changelog

## 2026-07-14

### Game scope
- Reduced the campaign to seven sectors: Alpha through Golf.
- Declared Sector Golf as the final AI Core and ending sector.
- Removed the old extra-sector progression logic from the access flow.

### Scoring and progression
- Standardized per-sector scoring to a clamp between 0 and 1000 using 25 points lost every 15 seconds and 150 points lost per hint.
- Saves completed sector scores and computes the final average from completed sectors.
- Final completion now shows sector scores, final average, total tournament time, total hints, and logs the session summary.

### Hints and verification
- Enforced two hidden hints per sector through the root `hint` command.
- Root `verify`, `access`, and `hint` are available through PATH from anywhere
  inside runtime/current.

### Hidden layout and runtime
- Renamed internal folders to hidden Unix-style names and updated scripts to use them.
- Ensured runtime/current deploys and restores correctly with the new hidden layout.
- Reset now clears active state while preserving logs and restoring runtime from the hidden master copy.

### Logging
- Reduced logging noise by replacing frequent variable-change events with sector-completion summaries and session summaries.
- Stored team names in logs as the plain team identifier only.
