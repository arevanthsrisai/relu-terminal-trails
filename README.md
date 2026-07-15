# Terminal Trials – Bash & DSA Event

An offline Bash-based terminal game developed for a university technical event to introduce Linux command-line fundamentals and basic Data Structures & Algorithms through interactive challenges.

> Designed and conducted as a live competitive event for engineering students using only Portable Git (Git Bash) on Windows.

---

## Overview

Terminal Trials is an escape-room style terminal simulation where participants solve progressively harder missions using Bash commands while learning fundamental DSA concepts.

Instead of traditional lectures, teams interact directly with the terminal to unlock new sectors by solving filesystem puzzles and algorithm-inspired challenges.

---

## Event Details

- **Organizer:** ReLU.exe Technical Club
- **Platform:** Windows + Portable Git (Git Bash)
- **Participants:** Team-based competition
- **Mode:** Offline
- **Levels:** 7
- **Duration:** ~10 minutes

---

## Topics Covered

### Bash

- pwd
- ls
- cd
- cat
- find
- grep
- pipes
- file navigation
- recursion
- shell scripting basics

### Data Structures & Algorithms

- Arrays
- Strings
- Stack
- Queue
- Linked List
- Two Pointers
- Sliding Window
- Searching
- Pattern Recognition

---

## Features

- Offline gameplay
- Portable Git compatible
- No Linux installation required
- Automatic level progression
- Hidden metadata
- Hint system
- Time-based scoring
- Tournament scoring
- Session logging
- Team tracking
- One-command reset
- Admin-friendly deployment

---

## Project Structure

```
TerminalTrials/
│
├── access
├── verify
├── hint
├── start.sh
├── reset.sh
│
├── .engine/
├── .master/
├── runtime/
├── .logs/
└── .progress/
```

---

## Competition Flow

1. Team enters its name.
2. Timer starts automatically.
3. Complete all 7 sectors.
4. Use `verify` to validate puzzle completion.
5. Use `access` to unlock the next sector.
6. Finish the final mission.
7. Final average score is calculated.
8. Logs are generated automatically.

---

## Technologies Used

- Bash
- Portable Git (Git Bash)
- Windows Batch
- POSIX Shell Utilities

---

## Learning Objectives

Participants gain hands-on experience with:

- Linux filesystem navigation
- Command-line problem solving
- Debugging
- Pattern recognition
- Basic algorithmic thinking
- Working efficiently inside a terminal

---

## Screenshots

> Add screenshots or GIFs of the gameplay here.

---

## Future Improvements

- Additional challenge packs
- Advanced Bash scripting levels
- Git challenges
- Networking challenges
- Leaderboard dashboard

---

## Acknowledgements

Inspired by terminal-based cybersecurity learning platforms such as **OverTheWire: Bandit**, while focusing on teaching Bash fundamentals and introductory DSA concepts in a beginner-friendly competitive environment.

---

## License

MIT License