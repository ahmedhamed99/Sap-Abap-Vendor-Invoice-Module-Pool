# PAI Include – Process After Input

## Purpose
Handles user actions and validations.

## Responsibilities
- OK_CODE processing
- Navigation between screens
- Save and Post actions
- Authorization checks

## Important Logic

### Save Invoice
- Validates header and item data
- Updates ZVIM_HDR and ZVIM_ITM

### Post Invoice
- Updates invoice status to Posted

### Back / Exit
- Screen navigation control

MODULE USER_COMMAND_0100 INPUT.
IF SY-UCOMM = 'POST'.

  PERFORM GET_ID.

  LWA_HEADER-INVNO = lv_generated_id.
  LWA_HEADER-BUKRS = ZVIM_HDR-BUKRS.
  LWA_HEADER-LIFNR = ZVIM_HDR-LIFNR.
  LWA_HEADER-BLDAT = ZVIM_HDR-BLDAT.
  LWA_HEADER-BUDAT = ZVIM_HDR-BUDAT.
  LWA_HEADER-WRBTR = ZVIM_HDR-WRBTR.
  LWA_HEADER-XBLNR = ZVIM_HDR-XBLNR.
  LWA_HEADER-BKTXT = ZVIM_HDR-BKTXT.
  LWA_HEADER-WAERS = ZVIM_HDR-WAERS.
  LWA_HEADER-STATUS = 'P'.
  LWA_HEADER-ERNAM = SY-UNAME.
  LWA_HEADER-ERDAT = SY-DATUM.
  LWA_HEADER-ERZET = SY-UZEIT.

  INSERT ZVIM_HDR FROM LWA_HEADER.
  IF SY-SUBRC = 0.
    MESSAGE S002(ZVIM_MSG).
    POSTED = 'X'.
  ENDIF.
ELSEIF SY-UCOMM = 'ITEM'.
  CALL SCREEN 200.
ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_CC  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_CC INPUT.
  SELECT SINGLE BUKRS FROM T001
    INTO LWA_HEADER
    WHERE BUKRS = ZVIM_HDR-BUKRS.
  IF SY-SUBRC <> 0.
    MESSAGE E000(ZVIM_MSG).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_VENDOR  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_VENDOR INPUT.
  SELECT SINGLE LIFNR FROM LFA1
    INTO LWA_HEADER
    WHERE LIFNR = ZVIM_HDR-LIFNR.
  IF SY-SUBRC <> 0.
    MESSAGE E001(ZVIM_MSG).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT INPUT.
IF SY-UCOMM = 'BACK'.
  LEAVE PROGRAM.
ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  GET_ID
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_ID .
CALL FUNCTION 'NUMBER_GET_NEXT'
  EXPORTING
    NR_RANGE_NR                   = '01'
    OBJECT                        = 'ZINVNO'
*   QUANTITY                      = '1'
*   SUBOBJECT                     = ' '
*   TOYEAR                        = '0000'
*   IGNORE_BUFFER                 = ' '
 IMPORTING
    NUMBER                        = lv_generated_id
*   QUANTITY                      =
*   RETURNCODE                    =
 EXCEPTIONS
   INTERVAL_NOT_FOUND            = 1
   NUMBER_RANGE_NOT_INTERN       = 2
   OBJECT_NOT_FOUND              = 3
   QUANTITY_IS_0                 = 4
   QUANTITY_IS_NOT_1             = 5
   INTERVAL_OVERFLOW             = 6
   BUFFER_OVERFLOW               = 7
   OTHERS                        = 8
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_AMOUNT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_AMOUNT INPUT.
IF ZVIM_HDR-WRBTR <= 0.
  MESSAGE E005(ZVIM_MSG).
ENDIF.
ENDMODULE.

MODULE USER_COMMAND_0200 INPUT.
IF SY-UCOMM = 'ADD'.
  DESCRIBE TABLE LT_ITEMS LINES DATA(len).
  IF LEN < 2.
    MESSAGE E003(ZVIM_MSG).
    ELSE.

      LV_ITEMNO = 1.
      LV_SUMOFITEMS = 0.
      LOOP AT LT_ITEMS INTO LWA_ITEMS.



        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT         = lwa_ITEMS-SAKNR
       IMPORTING
         OUTPUT        = LV_SAKNR
                .

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT         = lwa_ITEMS-KOSTL
       IMPORTING
         OUTPUT        = LV_KOSTL
                .

        SELECT SINGLE SAKNR FROM SKA1 INTO @DATA(LWA_TMP) WHERE SAKNR = @LV_SAKNR.
        IF SY-SUBRC <> 0.
          MESSAGE E006(ZVIM_MSG).
        ENDIF.

      SELECT SINGLE KOSTL FROM CSKS INTO @DATA(LWA_TMP2) WHERE KOSTL = @LV_KOSTL.
        IF SY-SUBRC <> 0.
          MESSAGE E007(ZVIM_MSG).
        ENDIF.

         LWA_ITEMS-INVNO = LWA_HEADER-INVNO.
         LWA_ITEMS-ITEMNO = LV_ITEMNO.
         MODIFY LT_ITEMS FROM LWA_ITEMS INDEX SY-TABIX TRANSPORTING INVNO ITEMNO .
         IF SY-SUBRC = 0.
         LV_ITEMNO = LV_ITEMNO + 1.
         LV_SUMOFITEMS = LV_SUMOFITEMS + LWA_ITEMS-WRBTR.
         ENDIF.
      ENDLOOP.

      IF LV_SUMOFITEMS <> LWA_HEADER-WRBTR.
        MESSAGE E008(ZVIM_MSG).
      ENDIF.

      MODIFY ZVIM_ITM FROM TABLE LT_ITEMS.
      IF SY-SUBRC = 0.
        MESSAGE S004(ZVIM_MSG).
        LV_DISPLAY = 'X'.
      ENDIF.

  ENDIF.

ENDIF.

IF SY-UCOMM = 'DISPLAY'.
  CALL SCREEN 300.
ENDIF.

IF SY-UCOMM = 'BACK'.
  CALL SCREEN 100.
ENDIF.
ENDMODULE.
