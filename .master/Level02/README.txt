Terminal Trials - Level 02: Archive Descent
===========================================

Story
-----
An archive was scattered across a deep backup hierarchy during the outage. The
recovery index says one surviving file contains the next credential.

Objective
---------
Search the nested archive and recover its access key.

Allowed Commands
----------------
find
Searches through folders recursively and prints paths that match what you are
looking for.

Mission
-------
1. Start from the current level directory.
2. Use `find` to search through the archive instead of opening folders one by
   one.
3. Read the path that matches the recovery clue and identify the key.
4. Run `verify`, then run `access` after verification succeeds.

Hints Available
---------------
- Use `hint` from the terminal when needed.

Learning Outcome
----------------
Search a directory hierarchy recursively with `find`.

DSA Insight (displayed only after completion)
---------------------------------------------
Recursive file discovery follows a depth-first search pattern: explore one
branch deeply, then backtrack to the next branch.
