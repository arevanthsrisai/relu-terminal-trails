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
nano <file_name>
Edits text content of a file. use arrow keys to navigate. ctrl+x , y , enter to save the changes to the file

double quotes
Allow variables such as `$name` to expand into their stored values.

single quotes
Print the characters inside them literally, without expanding variables.

Mission
-------
1. Inspect the broken dispatch script.
2. Repair its quoting so variable values expand correctly.
3. Run the script (./broken_dispatch.sh) and compare its output with the mission requirements.
4. Run `verify`, then run `access` after verification succeeds.

Hints Available
---------------
- Use `hint` from the terminal when needed.

Learning Outcome
----------------
double quotes
Allow variables such as `$name` to expand into their stored values.

single quotes
Print the characters inside them literally, without expanding variables.

DSA Insight (displayed only after completion)
---------------------------------------------
Variable names map to values much like a hash map maps keys to values. Correct
lookup depends on using the exact key name; a typo resolves to nothing.
