# Full Video Preview on LinkedIn:
https://www.linkedin.com/feed/update/urn:li:activity:7416885318999691264/
# SAP ABAP Vendor Invoice Management (Module Pool)

## Overview
This project is a custom SAP ABAP **Module Pool (Dialog) application**
that simulates **non-PO vendor invoice processing** using FI accounting principles.

The application allows finance users to:
- Create vendor invoices
- Validate accounting rules
- Store invoices in custom tables
- Display invoices in read-only mode using ALV

---

## Business Scenario
Standard SAP transactions (MIRO) are not always suitable for
manual or simplified vendor invoice entry.
This solution provides a controlled dialog-based alternative.

---

## Key SAP Concepts Demonstrated
- Module Pool programming
- Dynpro PBO / PAI logic
- Subscreens
- ALV Grid 
- Select-options in dialog programs
- Number range handling

---

## Screen Flow
0100 (Create Invoice)
→ 0200 (Line Items)
→ 0300 (Invoice List + Print Priview)

---

## Data Model
Custom tables:
- ZVIM_HDR – Invoice Header
- ZVIM_ITM – Invoice Line Items

Standard SAP references:
- LFA1 (Vendor)
- SKA1 (G/L Accounts)
- T001 (Company Code)

---

## Advanced Features Implemented
- Display / Edit modes
- Dynamic screen control
- Search help (F4) for vendor selection

---

## Limitations
- No real FI posting to BKPF/BSEG
- No payment processing
- No tax calculation

This project focuses on **ABAP dialog programming**, not FI configuration.

---
