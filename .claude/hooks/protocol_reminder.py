"""
UserPromptSubmit hook — DKSH Commercial AI Protocol Enforcer
Fires on every user prompt. If business keywords are detected, injects
a mandatory protocol reminder into Claude's context before it responds.
"""
import sys
import json

data = json.load(sys.stdin)
prompt = str(data.get('prompt', '')).lower()

KEYWORDS = [
    'carglo', 'energizer', 'eveready',
    'nis', 'ims', 'doh', 'mape', 'cfr',
    'sales', 'inventory', 'forecast', 'dashboard',
    'stock', 'channel', 'sku', 'excess', 'depletion',
    'order', 'shipment', 'mrp', 'po ',
    'le ', ' le', 'abp', 'target',
    'ti ', ' ti', 'trade investment',
    'buyer', 'presentation', 'business review', 'mbr',
    'data file', 'upload', 'validate', 'analysis', 'report',
    'customer', 'account', 'retailer',
    'big c', 'lotus', '7-eleven', 'tops', 'homepro',
]

if any(kw in prompt for kw in KEYWORDS):
    reminder = (
        "PROTOCOL REMINDER - DKSH Commercial AI Workspace\n"
        "==================================================\n"
        "MANDATORY STEPS before any analysis, dashboard, or file work:\n\n"
        "STEP 1 - Identify mode:\n"
        "  Inline: simple edits/fixes only\n"
        "  Hybrid: most day-to-day (validate -> agent -> QA -> mgmt)\n"
        "  Selective Agent: ordering/excess/forecast/account review\n"
        "  Full Agent: board/management/client output\n\n"
        "STEP 2 - Run /validate skill FIRST on any data files\n"
        "  Never skip. Data Validator must return PASS before analysis starts.\n\n"
        "STEP 3 - Route through the correct agents:\n"
        "  Sales/NIS/IMS   -> sales-analyst -> qa-reviewer -> management-reviewer\n"
        "  Inventory/DOH   -> inventory-risk -> finance-analyst -> qa -> mgmt\n"
        "  Forecast/LE     -> forecast-planner -> sales-analyst -> mgmt\n"
        "  Dashboard       -> [relevant analyst] -> dashboard-builder -> qa -> mgmt\n"
        "  Buyer deck      -> full chain -> account-strategist -> dashboard -> qa -> mgmt\n\n"
        "STEP 4 - NEVER write analysis code directly without going through agents\n"
        "STEP 5 - Show execution log before delivering any output\n"
        "STEP 6 - If in doubt about mode, ASK the user before proceeding\n\n"
        "No bypass without explicit user approval.\n"
        "Reference: CLAUDE.md Agent Routing table + memory/use-agents-parallel.md\n"
        "=================================================="
    )
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "UserPromptSubmit",
            "additionalContext": reminder
        }
    }))
