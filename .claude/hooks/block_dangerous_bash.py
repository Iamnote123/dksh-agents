#!/usr/bin/env python3
"""
Block dangerous Bash commands before they execute.
Exit 2 = blocked (Claude Code hard-stops the tool call).
"""
import json
import re
import sys

event = json.load(sys.stdin)
command = event.get("tool_input", {}).get("command", "")

DANGEROUS = [
    (r"\brm\s+.*-[a-z]*r[a-z]*f", "recursive rm"),
    (r"\bchmod\s+777\b",           "world-writable chmod"),
    (r"\bsudo\b",                  "sudo"),
    (r"git\s+push\s+--force",      "force push"),
    (r"git\s+reset\s+--hard",      "hard reset"),
    (r"git\s+clean\s+-[a-z]*f",    "git clean -f"),
    (r"git\s+branch\s+-[Dd]\b",    "branch delete"),
]

for pattern, label in DANGEROUS:
    if re.search(pattern, command):
        print(
            f"BLOCKED: Dangerous command detected ({label}).\n"
            f"Command: {command[:120]}",
            file=sys.stderr,
        )
        sys.exit(2)

sys.exit(0)
