Run the Monthly Business Review pipeline for DKSH Thailand.

Brand and period: $ARGUMENTS (e.g. "Energizer May 2026" or "Energizer + Eveready Q1 2026")

Execute agents in this order — stop and report if any step returns BLOCKED:

1. DATA VALIDATOR — confirm all MBR input files are present and valid (sales, stock, forecast, master data)
2. SALES ANALYST — NIS vs ABP, IMS vs client target, channel mix, top/bottom SKUs, growth drivers and gaps
3. FORECAST PLANNER — MAPE by SKU/channel, LE accuracy, revised demand rate if needed
4. INVENTORY RISK — DOH by SKU, excess stock exposure (units + THB value), depletion timeline
5. FINANCE ANALYST — TI ROI, gross margin, payment status, provision risk
6. QA REVIEWER — check calculations, logic, root causes, tone across all sections
7. MANAGEMENT REVIEWER — final commercial gate: feasibility, relationship risk, execution readiness

Output structure:
- Executive summary (5 lines max)
- Performance vs target (NIS, IMS, DOH table)
- Top 3 risks with root cause and recommended action
- Top 3 opportunities with action owner and timeline
- Next steps (numbered, specific, with deadlines)

If a required data file is missing, name it explicitly and stop.
