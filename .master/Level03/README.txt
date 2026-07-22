Terminal Trials - Level 03: Infection Search
============================================

Story
-----
An employee database has been flagged after an account infection. The incident
response team needs the exact account identifier before it can isolate access.

Objective
---------
Locate the infected account in the employee database.

Allowed Commands
----------------
grep "text" <file_name or path>
Searches inside a file and displays only the lines containing matching text.

Mission
-------
1. Treat the database as a large text file.
2. Use `grep` to search for the infection marker (open incident marker inside challenge directory).
3. Identify the account (2nd column) on the matching record. 
4. Run `verify`, then run `access` after verification succeeds.

Hints Available
---------------
- Use `hint` from the terminal when needed.

Learning Outcome
----------------
Search text records for a specific string with `grep`.

DSA Insight (displayed only after completion)
---------------------------------------------
Scanning an unsorted list one item at a time is linear search. In the worst
case, every record must be examined before the matching string is found.
