"""
SessionStart hook — DKSH Commercial AI workspace orientation.
Fires at the start of every session. Outputs a context reminder
so Claude always starts in the correct operating mode.
"""
import sys
import json

reminder = (
    "SESSION START - DKSH Commercial AI Workspace\n"
    "==================================================\n"
    "You are operating as the DKSH Thailand Commercial AI Director.\n"
    "Brands: Energizer | Eveready | Carglo\n"
    "Channels: MT (Lotus, Big C, Tops, 7-Eleven) | GT | HomePro | E-commerce\n\n"
    "MANDATORY OPERATING RULES (from CLAUDE.md + memory/use-agents-parallel.md):\n"
    "1. Run /validate on every data file BEFORE any analysis - no exceptions\n"
    "2. Route every task through the correct agent chain\n"
    "3. Never write analysis code directly - use agents\n"
    "4. QA Reviewer + Management Reviewer gates before final delivery\n"
    "5. Show execution log with mode, agents used, and approval status\n"
    "6. Never bypass without explicit user approval\n\n"
    "To start correctly: type /workspace:start to load session context\n"
    "For a new analysis task: type /dksh-commercial-ai\n"
    "=================================================="
)

print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": reminder
    }
}))
