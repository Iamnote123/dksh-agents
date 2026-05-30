# DKSH Commercial AI — Agent Skills

AI agent workflow for Energizer / Eveready / Carglo commercial analysis at DKSH Thailand.

---

## Full Agent Roster (14 agents)

| # | Agent | Role |
|---|---|---|
| 1 | `ORCHESTRATOR.md` | Master router — routes requests to the correct agents |
| 2 | `DATA_VALIDATOR.md` | Validates input files before analysis (PASS/WARNING/BLOCKED) |
| 3 | `SALES_ANALYST.md` | NIS/IMS/growth diagnosis with root cause |
| 4 | `FORECAST_PLANNER.md` | MAPE, LE revision, demand rate, forecast bias |
| 5 | `INVENTORY_RISK.md` | DOH, excess, depletion, OOS risk |
| 6 | `ORDERING_PLANNER.md` | Order/Hold/Reduce/Delay decisions |
| 7 | `PROMO_PLANNER.md` | Promo mechanics, calendar, TI, uplift |
| 8 | `FINANCE_ANALYST.md` | Margin, ROI, TI — financial gate |
| 9 | `ACCOUNT_STRATEGIST.md` | Retailer-specific buyer narrative |
| 10 | `DASHBOARD_BUILDER.md` | Charts, dashboards, slide visuals |
| 11 | `QA_REVIEWER.md` | Quality gate on every output |
| 12 | `MANAGEMENT_REVIEWER.md` | Executive-ready final layer |
| 13 | `EMAIL_ASSISTANT.md` | Bilingual email draft/reply/revise + table & file refs |
| 14 | `PRESENTATION_BUILDER.md` | Template-faithful .pptx decks (strict + branded modes) |

---

## Agent Loop

\`\`\`
Request
  -> Data Validator
  -> Orchestrator
  -> Sales Analyst / Forecast Planner / Inventory Risk
  -> Ordering Planner / Promo Planner / Finance Analyst
  -> Account Strategist / Dashboard Builder
  -> QA Reviewer -> Management Reviewer
  -> Final Output
\`\`\`

---

## Install

### Mac / Linux
\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/Iamnote123/dksh-agents/main/install_all.sh | bash
\`\`\`

Installs to: \`~/.claude/skills/dksh-commercial-ai/\`

---

## Usage

Add the contents of \`ORCHESTRATOR.md\` to your Claude Project instructions, or run Claude Code from the install directory. The Orchestrator routes each request to the right agents automatically.

---

## Brands & Channels

**Brands:** Energizer / Eveready / Carglo
**Channels:** Hypermarket / Supermarket / CVS / GT / E-commerce
**KPIs:** NIS / IMS / DOH / CFR / TI / MAPE / GP / ROI
