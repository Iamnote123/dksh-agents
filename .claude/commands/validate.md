Validate a data file before analysis. Acts as the Data Validator agent.

File to validate: $ARGUMENTS

Steps:
1. Read the file at the path provided
2. Confirm it is in the correct data/ subfolder per CLAUDE.md folder structure
3. Check required columns exist for the file type:
   - Sales (NIS/IMS): Date, Brand, SKU/Product, Channel, Account, Value/Units
   - Stock/DOH: Date, Brand, SKU, Stock Qty, DOH
   - Forecast/LE: Period, Brand, SKU, Forecast Value
   - Order/PO: PO number, Brand, SKU, Order Qty, ETA
   - Master data: SKU code, Brand, Description, LTP, RSP
4. Confirm Brand column contains only valid values: Energizer, Eveready, Carglo
5. Flag any blank or null critical fields

## Write-target validation (when the task writes INTO an existing template)

Applies to SSFR, MRP, target files, dashboards — any task that places values into an existing file rather than only reading it.

6. Resolve every target column DYNAMICALLY by reading the header rows. Match on
   SECTION (e.g. row 3: "Fixed Order for Current Month..." vs "Orders in Transit")
   + MONTH-DATE (row 2/row 4 date serial) + SUB-LABEL (row 4: "Actual Order" vs
   "Additional Order"). NEVER reuse a column letter from a previous month — order
   month-blocks shift one column-block per month, so a fixed letter goes stale.
7. Convert the month-date serial to a readable month and confirm it equals the
   intended month before approving any write.
8. For multi-row-header files (SSFR, MRP), state which row is the true label row
   and where data rows begin before approving any write.
9. Flag any target column whose label is duplicated elsewhere in the sheet
   (e.g. "Additional Order" or "Actual Order" appearing in more than one block).
10. Output the resolved mapping as a table — source column -> target column, with
    the month each header reads — and surface it for one-line user confirmation
    BEFORE writing.

Return:
- PASS — [column list, row count, brands detected]
- BLOCKED — [specific missing columns or data issues that prevent analysis]
- For write tasks: also return the resolved source->target column mapping table
  with the month read from each header, for confirmation before writing.

Do not run analysis. Validation only.
