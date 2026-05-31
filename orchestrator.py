#!/usr/bin/env python3
"""
DKSH Commercial AI — Python Orchestrator
Reads agent .md files from local disk, routes requests through the correct
agent pipeline using the Anthropic API, and streams the final output.

Usage:
    python orchestrator.py "วิเคราะห์ยอดขาย Q2 Big C และประเมิน DOH"
    python orchestrator.py --request "ร่าง promo proposal สำหรับ Lotus's"
    python orchestrator.py  # interactive mode
    python orchestrator.py --skills-dir /path/to/agents
"""

import argparse
import json
import os
import sys
from pathlib import Path

import anthropic

# ── Config ──────────────────────────────────────────────────────────────────

MODEL = "claude-sonnet-4-6"

DEFAULT_SKILLS_DIR = Path.home() / ".claude" / "skills" / "dksh-commercial-ai"

# Ordered agent list — matches the full pipeline from ORCHESTRATOR.md
ALL_AGENTS = [
    "DATA_VALIDATOR",
    "SALES_ANALYST",
    "FORECAST_PLANNER",
    "INVENTORY_RISK",
    "ORDERING_PLANNER",
    "PROMO_PLANNER",
    "FINANCE_ANALYST",
    "ACCOUNT_STRATEGIST",
    "DASHBOARD_BUILDER",
    "EMAIL_ASSISTANT",
    "EXCEL_AGENT",
    "PRESENTATION_BUILDER",
    "OBSIDIAN_BRIDGE",
    "QA_REVIEWER",
    "MANAGEMENT_REVIEWER",
]

# ── Agent loader ─────────────────────────────────────────────────────────────

def load_agents(skills_dir: Path) -> dict[str, str]:
    """Read all .md files from skills_dir. Returns {AGENT_NAME: content}."""
    agents = {}
    if not skills_dir.exists():
        print(f"[warn] Skills dir not found: {skills_dir}", file=sys.stderr)
        print(f"       Run install.sh first, or pass --skills-dir", file=sys.stderr)
        sys.exit(1)

    for md_file in skills_dir.glob("*.md"):
        name = md_file.stem.upper()
        agents[name] = md_file.read_text(encoding="utf-8")

    ref_path = skills_dir / "references" / "context.md"
    if ref_path.exists():
        agents["_CONTEXT"] = ref_path.read_text(encoding="utf-8")

    print(f"[ok] Loaded {len(agents)} files from {skills_dir}", file=sys.stderr)
    return agents


# ── Router ───────────────────────────────────────────────────────────────────

ROUTER_PROMPT = """\
You are the DKSH Commercial AI routing engine.

Given the user request below, return ONLY a valid JSON array of agent names
(uppercase, no .md extension) that should run — in the correct pipeline order.

Available agents (in pipeline order):
DATA_VALIDATOR, SALES_ANALYST, FORECAST_PLANNER, INVENTORY_RISK,
ORDERING_PLANNER, PROMO_PLANNER, FINANCE_ANALYST, ACCOUNT_STRATEGIST,
DASHBOARD_BUILDER, EMAIL_ASSISTANT, EXCEL_AGENT, PRESENTATION_BUILDER,
OBSIDIAN_BRIDGE, QA_REVIEWER, MANAGEMENT_REVIEWER

Rules:
- DATA_VALIDATOR first if the request involves any data file or numbers
- QA_REVIEWER before MANAGEMENT_REVIEWER on every analytical output
- MANAGEMENT_REVIEWER is the final agent on every request
- Most requests need 2–4 agents; full BRM/QBR uses the full loop
- EMAIL_ASSISTANT: only for drafting/replying to emails
- OBSIDIAN_BRIDGE: only when asked to save to vault

Return ONLY the JSON array. No explanation.
Example: ["DATA_VALIDATOR", "SALES_ANALYST", "QA_REVIEWER", "MANAGEMENT_REVIEWER"]
"""


def route_request(client: anthropic.Anthropic, request: str, orchestrator_md: str) -> list[str]:
    """Ask Claude which agents to run for this request."""
    response = client.messages.create(
        model=MODEL,
        max_tokens=256,
        system=[
            {
                "type": "text",
                "text": orchestrator_md,
                "cache_control": {"type": "ephemeral"},
            },
            {"type": "text", "text": ROUTER_PROMPT},
        ],
        messages=[{"role": "user", "content": request}],
    )

    raw = response.content[0].text.strip()
    # Strip markdown code fences if present
    if raw.startswith("```"):
        raw = raw.split("```")[1]
        if raw.startswith("json"):
            raw = raw[4:]

    try:
        agents = json.loads(raw)
    except json.JSONDecodeError:
        print(f"[warn] Router returned invalid JSON: {raw}", file=sys.stderr)
        agents = ["QA_REVIEWER", "MANAGEMENT_REVIEWER"]

    # Validate — keep only known agents, preserve order
    valid = [a for a in agents if a in ALL_AGENTS]
    if not valid:
        valid = ["MANAGEMENT_REVIEWER"]

    return valid


# ── Agent runner ─────────────────────────────────────────────────────────────

def run_agent(
    client: anthropic.Anthropic,
    agent_name: str,
    agent_md: str,
    context_md: str,
    user_request: str,
    prior_outputs: list[dict],
    stream: bool = True,
) -> str:
    """Run a single agent. Returns the full text response."""

    # Build system: agent .md + context reference (cached — static per session)
    system = [
        {
            "type": "text",
            "text": agent_md,
            "cache_control": {"type": "ephemeral"},
        },
    ]
    if context_md:
        system.append(
            {
                "type": "text",
                "text": f"# System Context\n\n{context_md}",
                "cache_control": {"type": "ephemeral"},
            }
        )

    # Build messages: original request + all prior agent outputs
    messages = []
    if prior_outputs:
        prior_text = "\n\n".join(
            f"## {p['agent']} Output\n\n{p['output']}" for p in prior_outputs
        )
        messages.append({
            "role": "user",
            "content": (
                f"# Original Request\n\n{user_request}\n\n"
                f"# Prior Agent Outputs\n\n{prior_text}\n\n"
                f"---\nNow apply your role as {agent_name} to this request "
                f"and the prior outputs above."
            ),
        })
    else:
        messages.append({"role": "user", "content": user_request})

    if stream:
        output_parts = []
        with client.messages.stream(
            model=MODEL,
            max_tokens=4096,
            system=system,
            messages=messages,
        ) as s:
            for text in s.text_stream:
                print(text, end="", flush=True)
                output_parts.append(text)
        print()  # newline after stream
        return "".join(output_parts)
    else:
        response = client.messages.create(
            model=MODEL,
            max_tokens=4096,
            system=system,
            messages=messages,
        )
        return response.content[0].text


# ── Main pipeline ─────────────────────────────────────────────────────────────

def run_pipeline(request: str, skills_dir: Path) -> None:
    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        print("[error] ANTHROPIC_API_KEY not set.", file=sys.stderr)
        print("        export ANTHROPIC_API_KEY=sk-ant-...", file=sys.stderr)
        sys.exit(1)

    client = anthropic.Anthropic(api_key=api_key)
    agents = load_agents(skills_dir)

    orchestrator_md = agents.get("ORCHESTRATOR", "")
    context_md = agents.get("_CONTEXT", "")

    # 1. Route
    print("\n[routing...]", file=sys.stderr)
    agent_list = route_request(client, request, orchestrator_md)
    print(f"[pipeline] {' → '.join(agent_list)}\n", file=sys.stderr)

    # 2. Run pipeline
    prior_outputs: list[dict] = []
    final_output = ""

    for agent_name in agent_list:
        agent_md = agents.get(agent_name)
        if not agent_md:
            print(f"[skip] {agent_name}.md not found in {skills_dir}", file=sys.stderr)
            continue

        # Only stream the last agent's output to terminal; run others silently
        is_last = agent_name == agent_list[-1]
        is_second_to_last = (
            len(agent_list) >= 2 and agent_name == agent_list[-2]
        )

        if is_last:
            print(f"\n{'─'*60}", flush=True)
            print(f"  {agent_name}", flush=True)
            print(f"{'─'*60}\n", flush=True)

        output = run_agent(
            client=client,
            agent_name=agent_name,
            agent_md=agent_md,
            context_md=context_md,
            user_request=request,
            prior_outputs=prior_outputs,
            stream=is_last,
        )

        if not is_last:
            print(f"[done] {agent_name}", file=sys.stderr)

        prior_outputs.append({"agent": agent_name, "output": output})
        if is_last:
            final_output = output

    return final_output


# ── CLI ───────────────────────────────────────────────────────────────────────

def main() -> None:
    parser = argparse.ArgumentParser(
        description="DKSH Commercial AI — Python Orchestrator",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "request",
        nargs="?",
        help="Business request (Thai or English)",
    )
    parser.add_argument(
        "--request", "-r",
        dest="request_flag",
        help="Business request (alternative flag)",
    )
    parser.add_argument(
        "--skills-dir",
        type=Path,
        default=DEFAULT_SKILLS_DIR,
        help=f"Path to agent .md files (default: {DEFAULT_SKILLS_DIR})",
    )
    args = parser.parse_args()

    request = args.request or args.request_flag
    if not request:
        print("DKSH Commercial AI Orchestrator")
        print("Type your request (Thai or English), or Ctrl+C to exit.\n")
        try:
            request = input("Request: ").strip()
        except (KeyboardInterrupt, EOFError):
            print("\nBye.")
            sys.exit(0)

    if not request:
        parser.print_help()
        sys.exit(1)

    run_pipeline(request, args.skills_dir)


if __name__ == "__main__":
    main()
