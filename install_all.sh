#!/bin/bash
# ============================================================
# Master Installer — All Tools
# Claude Code Agents + Data Viz + BI
# ============================================================

set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
fail() { echo -e "  ${RED}✗${NC} $1"; }
head() { echo -e "\n${BOLD}${CYAN}── $1 ──${NC}"; }

echo ""
echo -e "${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Master Installer — All Tools       ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════╝${NC}"
echo ""

# ── 1. DKSH Agents ─────────────────────────────────────────
head "1/5  DKSH Commercial AI Agents"

DKSH_DIR="$HOME/.claude/skills/dksh-commercial-ai"
mkdir -p "$DKSH_DIR/references"

DKSH_BASE="https://raw.githubusercontent.com/Iamnote123/dksh-agents/main"
DKSH_FILES=("ORCHESTRATOR.md" "DATA_VALIDATOR.md" "SALES_ANALYST.md" "FORECAST_PLANNER.md" "INVENTORY_RISK.md" "ORDERING_PLANNER.md" "PROMO_PLANNER.md" "FINANCE_ANALYST.md" "ACCOUNT_STRATEGIST.md" "DASHBOARD_BUILDER.md" "QA_REVIEWER.md" "MANAGEMENT_REVIEWER.md" "EMAIL_ASSISTANT.md" "PRESENTATION_BUILDER.md" "OBSIDIAN_BRIDGE.md" "EXCEL_AGENT.md")

for f in "${DKSH_FILES[@]}"; do
  if curl -fsSL "$DKSH_BASE/$f" -o "$DKSH_DIR/$f" 2>/dev/null; then
    ok "$f"
  else
    fail "$f — check repo is Public"
  fi
done

curl -fsSL "$DKSH_BASE/references/context.md" -o "$DKSH_DIR/references/context.md" 2>/dev/null \
  && ok "references/context.md" || warn "context.md not found — skip"

# ── 2. Agency Agents (Claude Code) ─────────────────────────
head "2/5  Agency Agents (147 agents for Claude Code)"

AGENCY_DIR="$HOME/.claude/agents"
mkdir -p "$AGENCY_DIR"

AGENCY_TMP=$(mktemp -d)
if curl -fsSL https://github.com/msitarzewski/agency-agents/archive/refs/heads/main.tar.gz \
   | tar -xz -C "$AGENCY_TMP" 2>/dev/null; then
  cp "$AGENCY_TMP"/agency-agents-main/*.md "$AGENCY_DIR/" 2>/dev/null || true
  ok "Agency agents installed → ~/.claude/agents/"
  warn "Activate in Claude Code: 'Use Frontend Developer agent'"
else
  fail "Agency agents — check internet connection"
fi
rm -rf "$AGENCY_TMP"

# ── 3. Superpowers (note only) ──────────────────────────────
head "3/5  Superpowers (Claude Code Plugin)"

warn "Superpowers installs via Claude Code plugin marketplace"
warn "Open Claude Code and run:  /plugin install superpowers"
warn "Or: curl -fsSL https://raw.githubusercontent.com/obra/superpowers/main/install.sh | bash"

# ── 4. Python Data Tools ────────────────────────────────────
head "4/5  Python Data Tools (Streamlit + Dash)"

if command -v pip3 &>/dev/null; then
  PIP=pip3
elif command -v pip &>/dev/null; then
  PIP=pip
else
  fail "pip not found — install Python first: https://python.org"
  PIP=""
fi

if [ -n "$PIP" ]; then
  echo ""
  echo -e "  Installing streamlit..."
  if $PIP install streamlit --quiet 2>/dev/null; then
    ok "streamlit installed — run: streamlit hello"
  else
    fail "streamlit install failed"
  fi

  echo -e "  Installing dash + plotly..."
  if $PIP install dash plotly pandas --quiet 2>/dev/null; then
    ok "dash + plotly installed"
  else
    fail "dash install failed"
  fi
fi

# ── 5. Metabase ─────────────────────────────────────────────
head "5/5  Metabase (BI Dashboard)"

METABASE_DIR="$HOME/tools/metabase"
mkdir -p "$METABASE_DIR"

if [ ! -f "$METABASE_DIR/metabase.jar" ]; then
  echo -e "  Downloading Metabase JAR (~300MB)..."
  if curl -fsSL \
    "https://downloads.metabase.com/v0.50.31/metabase.jar" \
    -o "$METABASE_DIR/metabase.jar" \
    --progress-bar; then
    ok "Metabase downloaded → ~/tools/metabase/metabase.jar"

    cat > "$METABASE_DIR/start.sh" << 'MBEOF'
#!/bin/bash
echo "Starting Metabase on http://localhost:3000 ..."
cd ~/tools/metabase
java -jar metabase.jar
MBEOF
    chmod +x "$METABASE_DIR/start.sh"
    ok "Start script created → ~/tools/metabase/start.sh"
  else
    fail "Metabase download failed — check internet or download manually"
    warn "Manual: https://www.metabase.com/start/oss/"
  fi
else
  ok "Metabase already installed"
fi

# ── Summary ─────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Install complete!                  ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}How to use:${NC}"
echo ""
echo -e "  ${CYAN}DKSH Agents${NC}"
echo -e "  Location: ~/.claude/skills/dksh-commercial-ai/"
echo ""
echo -e "  ${CYAN}Agency Agents (Claude Code)${NC}"
echo -e "  Location: ~/.claude/agents/"
echo -e "  Use: 'Activate Marketing Strategist agent'"
echo ""
echo -e "  ${CYAN}Superpowers${NC}"
echo -e "  Open Claude Code → /plugin install superpowers"
echo ""
echo -e "  ${CYAN}Streamlit${NC}"
echo -e "  Run: streamlit hello"
echo -e "  Build: streamlit run your_app.py"
echo ""
echo -e "  ${CYAN}Dash${NC}"
echo -e "  Run: python your_dashboard.py"
echo ""
echo -e "  ${CYAN}Metabase${NC}"
echo -e "  Requires Java. Run: ~/tools/metabase/start.sh"
echo -e "  Then open: http://localhost:3000"
echo ""
