#!/usr/bin/env python3
"""
Block any Write or Edit tool call targeting read-only input folders.
Exit 2 = blocked (Claude Code hard-stops the tool call).
"""
import json
import sys

event = json.load(sys.stdin)
file_path = event.get("tool_input", {}).get("file_path", "") or \
            event.get("tool_input", {}).get("path", "")

READONLY = [
    "/01_Input/",
    "/01_sales_actual/",
    "/02_targets/",
    "/03_stock/",
    "/04_order_shipment/",
    "/05_master_data/",
    "/06_financials/",
    "/99_raw_uploads/",
    "/Payment/",
    "/data/",
]

for pattern in READONLY:
    if pattern in file_path:
        print(
            f"BLOCKED: '{file_path}' is in a read-only input folder.\n"
            f"Write to outputs/, Big C/03_Output/, Reports/, or the relevant account 04_Final/ folder instead.",
            file=sys.stderr,
        )
        sys.exit(2)

sys.exit(0)
