Terminal Trials - Level 07: Chain of Evidence
=============================================

Story
-----
The incident investigator split a message across a chain of evidence files.
Every node points to the next one, but only the final two routes reveal the
credential.

Objective
---------
Follow the linked evidence files and recover the next access key.

Allowed Commands
----------------
Use what you learned in the previous sectors: navigation, recursive search,
text search, file reading, and small shell steps.

grep -R "text" <directory>
for recursive search inside every file in a directory instead of a single file.

head <file_name>
Reads the beginning of a file.

tail <file_name>
Reads the end of a file.

Mission
-------
1. Use find to survey the evidence files below challenge/ . (for this level don't cd into challenge/)
2. Locate the starting node by searching for START_NODE with grep and flag -R in "challenge" directory from current/ directory.
3. Use cat to read each node. Its NEXT= value identifies the next file.
4. At the terminal node, compare the two ordered route files from opposite ends. Their exposed fragments form the access key.
5. Submit the key with verify, then run access.

Hints Available
---------------
- Use `hint` from the terminal when needed.

Learning Outcome
----------------
Review earlier terminal skills and inspect the useful edge records of large
ordered files.

DSA Insight (displayed only after completion)
---------------------------------------------
A linked list stores each item with a reference to its successor. Traversal
follows one reference at a time. Comparing the two route ends is analogous to
using two pointers that approach a structure from opposite directions.
