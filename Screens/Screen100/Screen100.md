# Screen 0100 – Invoice Header

## Purpose
Collects invoice header information before item entry.

## Screen Type
Main screen

## UI Components
- Vendor (LIFNR)
- Company Code (BUKRS)
- Invoice Date
- Currency
- Header Subscreen

## PBO Logic
- Set GUI status
- Apply dynamic field control

## PAI Logic
- Vendor validation
- Company Code Validation
- Navigation to item screen (0200)

## Navigation
- Next → Screen 0200
- Back → Exit transaction
