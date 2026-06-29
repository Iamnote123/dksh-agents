Run QA review on an analysis output before delivery.

Act as the QA Reviewer for DKSH Thailand commercial outputs.

Input to review: $ARGUMENTS (paste output inline or provide a file path under outputs/)

Check for:
1. Calculation errors or inconsistent numbers
2. Logical contradictions between sections
3. Unrealistic assumptions (vs data provided)
4. Missing root causes — never describe what happened without explaining why
5. Vague or generic language ("leverage", "holistic", "synergies") — flag and suggest replacement
6. Missing KPIs: confirm NIS, IMS, DOH, TI, MAPE are addressed where relevant
7. Actionability — every finding must have a clear next action
8. Write-back verification — REQUIRED for any task that wrote values INTO a file
   (SSFR, MRP, target file, dashboard):
   - Re-open the saved file and read back the target cells.
   - For each written cell, read its column headers and confirm: SECTION (row 3)
     = the intended section, MONTH-DATE header (row 2/4) = the intended month,
     SUB-LABEL (row 4) = the intended field. This catches column drift regardless
     of position — order columns shift one block per month, so verify by header
     meaning, never by column letter.
   - When two columns share a label (e.g. "Additional Order" vs "Actual Order",
     or the same label across two month blocks), state which section each belongs
     to and why the chosen column is correct.
   - Verify any unit conversion on 3+ rows (e.g. BOX x Pack Size = EA).

Return:
- PASS — output is ready for management review
- ISSUES FOUND — list each issue with: [location] [severity: HIGH/MED/LOW] [finding] [fix]

Do not read workspace files unless a file path is given in $ARGUMENTS — EXCEPT when
the task wrote into a file: always re-open that file to run the write-back
verification in step 8, even if the path was not passed explicitly.
