#!/bin/bash
# ============================================================
# DKSH Commercial AI — Agent Skill Installer
# Mac / Linux
# Usage (from repo):  bash install.sh
# Usage (remote):     curl -fsSL https://raw.githubusercontent.com/Iamnote123/dksh-agents/main/install.sh | bash
# ============================================================

set -e

REPO_RAW="https://raw.githubusercontent.com/Iamnote123/dksh-agents/main"
INSTALL_DIR="$HOME/.claude/skills/dksh-commercial-ai"
REF_DIR="$INSTALL_DIR/references"

# Resolve the directory where this script lives (empty when piped via curl)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" 2>/dev/null && pwd || echo "")"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  DKSH Commercial AI — Agent Installer     ${NC}"
echo -e "${CYAN}  Energizer / Eveready / Carglo            ${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

mkdir -p "$INSTALL_DIR" "$REF_DIR"

# Determine source mode
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/ORCHESTRATOR.md" ]; then
  MODE="local"
  echo -e "${CYAN}→ Source: local disk ($SCRIPT_DIR)${NC}"
else
  MODE="remote"
  command -v curl &>/dev/null || { echo -e "${RED}✗ curl not found.${NC}"; exit 1; }
  echo -e "${CYAN}→ Source: GitHub (${REPO_RAW})${NC}"
fi
echo ""

# copy_file <filename> <dest_dir> [subpath-in-repo]
copy_file() {
  local file="$1"
  local dest_dir="$2"
  local subpath="${3:-}"

  if [ "$MODE" = "local" ]; then
    local src="$SCRIPT_DIR/${subpath:+$subpath/}$file"
    if cp "$src" "$dest_dir/$file" 2>/dev/null; then
      echo -e "  ${GREEN}✓${NC} $file"
    else
      echo -e "  ${RED}✗ FAILED: $file${NC}"; return 1
    fi
  else
    local url="$REPO_RAW/${subpath:+$subpath/}$file"
    if curl -fsSL "$url" -o "$dest_dir/$file" 2>/dev/null; then
      echo -e "  ${GREEN}✓${NC} $file"
    else
      echo -e "  ${RED}✗ FAILED: $file${NC}"; return 1
    fi
  fi
}

AGENTS=(
  "ORCHESTRATOR.md"
  "FORECAST_PLANNER.md"
  "ACCOUNT_STRATEGIST.md"
  "PROMO_PLANNER.md"
  "DATA_VALIDATOR.md"
)

FAIL=0

echo -e "${YELLOW}→ Installing agent files...${NC}"
echo ""
for file in "${AGENTS[@]}"; do
  copy_file "$file" "$INSTALL_DIR" || FAIL=1
done

echo ""
echo -e "${YELLOW}→ Installing reference files...${NC}"
echo ""
copy_file "context.md" "$REF_DIR" "references" || FAIL=1

echo ""
if [ $FAIL -eq 0 ]; then
  echo -e "${GREEN}============================================${NC}"
  echo -e "${GREEN}  ✓ Install complete!${NC}"
  echo -e "${GREEN}============================================${NC}"
  echo ""
  echo -e "  Location: ${CYAN}$INSTALL_DIR${NC}"
  echo ""
  echo -e "  ${YELLOW}Next:${NC} Add ORCHESTRATOR.md to Claude Project instructions"
  echo ""
else
  echo -e "${RED}✗ Some files failed.${NC}"; exit 1
fi
