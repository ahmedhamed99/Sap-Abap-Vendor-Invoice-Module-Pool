MODULE USER_COMMAND_0300 INPUT.

IF SY-UCOMM = 'EXEC'.
  DATA: LT_FINAL TYPE TABLE OF ZVIM_HDR.

  SELECT * FROM ZVIM_HDR INTO TABLE LT_FINAL
    WHERE INVNO IN S_INVNO
     AND BUKRS IN S_BUKRS
     AND LIFNR IN S_LIFNR
     AND BLDAT IN S_BLDAT.

  IF SY-SUBRC <> 0.
    MESSAGE I009(ZVIM_MSG).
    ELSE.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
     I_CALLBACK_PROGRAM                = SY-REPID
     I_CALLBACK_PF_STATUS_SET          = 'PF_STATUS'
     I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
      I_STRUCTURE_NAME                  = 'ZVIM_HDR'
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
*     IS_LAYOUT                         =
*     IT_FIELDCAT                       =
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT                           =
*     IT_FILTER                         =
*     IS_SEL_HIDE                       =
*     I_DEFAULT                         = 'X'
*     I_SAVE                            = ' '
*     IS_VARIANT                        =
*     IT_EVENTS                         =
*     IT_EVENT_EXIT                     =
*     IS_PRINT                          =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB                          = LT_FINAL
   EXCEPTIONS
     PROGRAM_ERROR                     = 1
     OTHERS                            = 2
            .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
  LV_GRID = 'X'.
  ENDIF.
ENDIF.


IF SY-UCOMM = 'BACK'.
  IF LV_GRID = 'X'.
    LV_GRID = 'Z'.
    CALL SCREEN 300.
  ELSE.
  CALL SCREEN 200.
  ENDIF.
ENDIF.

ENDMODULE.


FORM pf_status USING rt_extab TYPE slis_t_extab.
   SET PF-STATUS 'ALV_STATUS' EXCLUDING RT_EXTAB.
ENDFORM.

FORM USER_COMMAND  USING r_ucomm LIKE sy-ucomm
                                   rs_selfield TYPE slis_selfield.

  IF SY-UCOMM = 'PRINTPREV'.


    READ TABLE LT_FINAL INTO DATA(LWA_TMP) INDEX rs_selfield-TABINDEX.

    DATA: LWA_FORM_HEADER TYPE ZVIM_HDR.
    DATA: LT_FORM_ITEMS TYPE ZTT_ITM.

DATA : IE_OUTPUTPARAMS TYPE  SFPOUTPUTPARAMS,
       E_FUNCNAME      TYPE  FUNCNAME.
    IE_OUTPUTPARAMS-NODIALOG = abap_true.
    IE_outputparams-preview    = abap_true.
    IE_outputparams-dest       = 'LP01'.


 CLEAR: LWA_FORM_HEADER.
    REFRESH: LT_FORM_ITEMS.

SELECT SINGLE * FROM ZVIM_HDR
  INTO LWA_FORM_HEADER
  WHERE INVNO = LWA_TMP-INVNO.

SELECT * FROM ZVIM_ITM
  INTO CORRESPONDING FIELDS OF TABLE LT_FORM_ITEMS
  WHERE INVNO = LWA_TMP-INVNO.

CLEAR: LWA_TMP.

* 1) FIRST FM
CALL FUNCTION 'FP_JOB_OPEN'
  CHANGING
    IE_OUTPUTPARAMS = IE_OUTPUTPARAMS
  EXCEPTIONS
    CANCEL          = 1
    USAGE_ERROR     = 2
    SYSTEM_ERROR    = 3
    INTERNAL_ERROR  = 4
    OTHERS          = 5.
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


* 2) SECOND FM
CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
  EXPORTING
    I_NAME     = 'ZVIM_FORM'  "ASSIGN FORM NAME TO RETURN THE NUMBER OF FORM
  IMPORTING
    E_FUNCNAME = E_FUNCNAME  " THIS CARRY THE NUMBER OF FORM
*   E_INTERFACE_TYPE           =
*   EV_FUNCNAME_INBOUND        =
  .
* 3) THIRD FM
CALL FUNCTION E_FUNCNAME "'/1BCDWB/SM00000564'
  EXPORTING
*   /1BCDWB/DOCPARAMS        =
    WA_HEADER                 = LWA_FORM_HEADER
    T_ITEMS               = LT_FORM_ITEMS
* IMPORTING
*   /1BCDWB/FORMOUTPUT       =
 EXCEPTIONS
   USAGE_ERROR              = 1
   SYSTEM_ERROR             = 2
   INTERNAL_ERROR           = 3
   OTHERS                   = 4
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


* 4) FOURTH FM
CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
  EXCEPTIONS
    USAGE_ERROR    = 1
    SYSTEM_ERROR   = 2
    INTERNAL_ERROR = 3
    OTHERS         = 4.
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

  ENDIF.

IF SY-UCOMM = 'BACK'.
  CALL SCREEN 300.
ENDIF.
ENDFORM.
