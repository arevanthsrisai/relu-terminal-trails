Terminal Trials - Level 04: Log Reconstruction
==============================================

Story
-----
The final incident log arrived out of order. Reconstruct its chronological
sequence so the first and last records can reveal the closing credential.

Objective
---------
Order the corrupted log and recover the final access key from its endpoints.

Allowed Commands
----------------
sort
Reorders lines of text so they appear in sorted order.

head
Displays the first few lines of a file.

tail
Displays the last few lines of a file.

Mission
-------
1. Work with the corrupted log as a large list of timestamped records.
2. Create a recovered version whose records are in chronological order.
3. Inspect only the beginning and end of the ordered result.
4. Use the boundary records to determine what to submit to `verify`.
5. Run `access` after verification succeeds.

Hints Available
---------------
- Use `hint` from the terminal when needed.

Learning Outcome
----------------
Order line-based records and inspect boundary elements of the resulting list.

DSA Insight (displayed only after completion)
---------------------------------------------
An array stores an ordered sequence. Once records are sorted, `head` observes
the first element and `tail` observes the last - constant-time boundary access
in the ordered representation.
