# SAP ABAP Vendor Invoice Management (Module Pool)

## Overview
This project is a custom SAP ABAP Module Pool application that simulates
vendor invoice posting using FI accounting principles.

## Business Scenario
Finance users can enter non-PO vendor invoices, validate accounting rules,
store invoices, and display them in a read-only format.

## Key Features
- Module Pool (Dialog) programming
- PBO / PAI screen logic
- Custom tables (ZVIM_HDR, ZVIM_ITM)
- ALV Grid 
- Header ALV
- Header + Item Details Adobe Form
- Number range handling
- Validations 

## Screen Flow
0100 → 0200 → 0300 

## Technologies Used
- SAP ABAP
- Module Pool
- ALV Grid 
- Subscreens
- FI concepts

## Limitations
This project simulates FI posting and does not update BKPF/BSEG.
