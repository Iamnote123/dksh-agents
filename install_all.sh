#!/bin/bash
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
fail() { echo -e "  ${RED}✗${NC} $1"; }
head() { echo -e "\n${BOLD}${CYAN}── $1 ──${NC}"; }
echo ""
echo -e "${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Master Installer — All Tools       ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════╝${NC}"
head "1/4  DKSH Commercial AI Agents"
mkdir -p ~/.claude/skills/dksh-commercial-ai/references
BASE="https://raw.githubusercontent.com/Iamnote123/dksh-agents/main"
for f in ORCHESTRATOR.md FORECAST_PLANNER.md ACCOUNT_STRATEGIST.md PROMO_PLANNER.md DATA_VALIDATOR.md; do
  curl -fsSL "$BASE/$f" -o ~/.claude/skills/dksh-commercial-ai/$f && ok "$f" || fail "$f"
done
curl -fsSL "$BASE/references/context.md" -o ~/.claude/skills/dksh-commercial-ai/references/context.md && ok "context.md" || warn "context.md skipped"
head "2/4  Agency Agents (147 agents)"
mkdir -p ~/.claude/agents
TMP=$(mktemp -d)
curl -fsSL https://github.com/msitarzewski/agency-agents/archive/refs/heads/main.tar.gz | tar -xz -C $TMP 2>/dev/null
cp $TMP/agency-agents-main/*.md ~/.claude/agents/ 2>/dev/null && ok "Agency agents → ~/.claude/agents/" || fail "Agency agents failed"
rm -rf $TMP
head "3/4  Superpowers"
warn "Open Claude Code → run: /plugin install superpowers"
head "4/4  Python Tools"
pip3 install streamlit dash plotly pandas --quiet && ok "streamlit + dash + plotly" || fail "pip3 failed"
echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Install complete!                  ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
