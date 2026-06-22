---
name: hands-off
description: >
  Seamless context handoff between Claude sessions across home Mac, office Mac, and Claude Code via OneDrive. Read HANDS_OFF.md at session start to restore full context. Write HANDS_OFF.md at session end. Trigger on: "continue", "pick up", "hands off", "what was I doing", "resume", or session start on any machine.
---

# HANDS-OFF SESSION BRIDGE

File location: ~/Library/CloudStorage/OneDrive-DKSH/AI_WORKSPACE/HANDS_OFF.md

## On Session START
1. Read HANDS_OFF.md
2. Extract: Machine, Task, Status, Files, Open items, Last action, Next steps
3. Say: "Continuing from [MACHINE] — [TASK] — [STATUS]" then proceed

## On Session END
Update HANDS_OFF.md — machine, task, status, files, open items, last action, next 3 steps, append one line to session log. Keep file under 400 words.

## Rules
- One file only. Always overwrite.
- Session log: keep last 5 entries only.
- If missing → ask for context, then create it.
