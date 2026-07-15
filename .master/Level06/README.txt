Terminal Trials - Level 06: Dispatch Map Repair
===============================================

Story
-----
The automation dispatcher survived the incident, but its variable expansion is
broken. Repair it before the next deployment window closes.

Objective
---------
Repair the shell script so it emits the dispatch message and access key.

Allowed Commands
----------------
variables
Store values under names so a script can reuse them later.

echo
Prints text to the terminal.

simple shell scripts
Small Bash files can run several shell commands in order.

double quotes
Allow variables such as `$name` to expand into their stored values.

single quotes
Print the characters inside them literally, without expanding variables.

Mission
-------
1. Inspect the broken dispatch script.
2. Repair its variable names and quoting so variable values expand correctly.
3. Run the script and compare its output with the mission requirements.
4. Run `verify`, then run `access` after verification succeeds.

Hints Available
---------------
- Use `hint` from the terminal when needed.

Learning Outcome
----------------
Assign shell variables, expand them with `$name` or `${name}`, and produce
reliable output from a small Bash script.

DSA Insight (displayed only after completion)
---------------------------------------------
Variable names map to values much like a hash map maps keys to values. Correct
lookup depends on using the exact key name; a typo resolves to nothing.
