Terminal Trials - Level 01: Office Recovery
===========================================

Story
-----
The first network outage left a field office sealed behind an old terminal
directory. A recovery credential was left somewhere inside the office.

Objective
---------
Explore the office workspace and recover the Level 01 access key.

Allowed Commands
----------------
ls
Lists the files and folders in your current location.

cd <directory>
Moves you into another folder or back toward a previous folder.

cat <file_name>
Displays the contents of a text file.

Mission
-------
1. Use the allowed commands to understand where you are. Start the level from challenge/ directory.
2. Move through folders carefully and read files that look relevant using cat.
3. When you find an access key, run `verify`.
4. If verification succeeds, run `access` to continue.

Hints Available
---------------
- Use `hint` from the terminal when needed.

Learning Outcome
----------------
Navigate a filesystem deliberately and read a file after locating it.

DSA Insight (displayed only after completion)
---------------------------------------------
A filesystem is a tree: directories are internal nodes and files are leaves.
`cd` moves along tree edges; `ls` reveals the children of the current node.
