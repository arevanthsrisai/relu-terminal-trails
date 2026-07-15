Terminal Trials - Level 05: Ghost History
=========================================

Story
-----
The previous operator vanished after issuing a chain of terminal commands. A
preserved command history is all that remains of their access trail.

Objective
---------
Analyze the preserved history and recover the repeated next-level key.

Allowed Commands
----------------
history
Shows commands that were previously entered in the shell.

|
Sends the output of one command into the next command.

grep
Searches text and displays only lines containing matching text.

Mission
-------
1. The process to follow is mentioned inside analysis_note.txt file inside challenge
2. Use terminal_history file to view the recovered command stream.
3. Use a small pipeline to narrow the stream to credential-looking lines.
4. Identify the credential that appears more than once.
5. Run `verify`, then run `access` after verification succeeds.

Hints Available
---------------
- Use `hint` from the terminal when needed.

Learning Outcome
----------------
Compose simple commands into a pipeline that filters a stream of text.

DSA Insight (displayed only after completion)
---------------------------------------------
Shell history behaves like a stack: recent commands are appended at one end.
Pipeline stages behave like queues: each stage receives a stream, processes it,
and passes a stream to the next stage.
