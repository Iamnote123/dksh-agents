#!/usr/bin/env python3
"""
Async post-write logger. Appends one line to logs/claude_writes.log per file written.
Non-blocking — runs after the tool call completes.
"""
import json
import os
import sys
from datetime import datetime

event = json.load(sys.stdin)
file_path = event.get("tool_input", {}).get("file_path", "unknown")
timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

log_dir = os.path.join(
    os.environ.get("CLAUDE_PROJECT_DIR", "."),
    "logs",
)
os.makedirs(log_dir, exist_ok=True)

log_path = os.path.join(log_dir, "claude_writes.log")
with open(log_path, "a", encoding="utf-8") as f:
    f.write(f"{timestamp} | WRITE | {file_path}\n")

sys.exit(0)
