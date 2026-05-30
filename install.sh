#!/bin/bash
# ============================================================
# DKSH Commercial AI — Agent Skill Installer
# Mac / Linux
# Usage: curl -fsSL https://raw.githubusercontent.com/Iamnote123/dksh-agents/main/install.sh | bash
# ============================================================

set -e

REPO_RAW="https://raw.githubusercontent.com/Iamnote123/dksh-agents/main"
INSTALL_DIR="$HOME/.claude/skills/dksh-commercial-ai"
REF_DIR="$INSTALL_DIR/references"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  DKSH Commercial AI — Agent Installer     ${NC}"
echo -e "${CYAN}  Energizer / Eveready / Carglo            ${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

command -v curl &>/dev/null || { echo -e "${RED}✗ curl not found.${NC}"; exit 1; }

mkdir -p "$INSTALL_DIR" "$REF_DIR"

AGENTS=(
  "ORCHESTRATOR.md"
  "FORECAST_PLANNER.md"
  "ACCOUNT_STRATEGIST.md"
  "PROMO_PLANNER.md"
  "DATA_VALIDATOR.md"
)

FAIL=0

echo -e "${YELLOW}→ Downloading agent files...${NC}"
echo ""
for file in "${AGENTS[@]}"; do
  if curl -fsSL "$REPO_RAW/$file" -o "$INSTALL_DIR/$file" 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} $file"
  else
    echo -e "  ${RED}✗ FAILED: $file${NC}"; FAIL=1
  fi
done

echo ""
echo -e "${YELLOW}→ Downloading reference files...${NC}"
echo ""
if curl -fsSL "$REPO_RAW/references/context.md" -o "$REF_DIR/context.md" 2>/dev/null; then
  echo -e "  ${GREEN}✓${NC} references/context.md"
else
  echo -e "  ${RED}✗ FAILED: references/context.md${NC}"; FAIL=1
fi

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
  echo -e "${RED}✗ Some files failed. Check repo is Public.${NC}"; exit 1
fi
