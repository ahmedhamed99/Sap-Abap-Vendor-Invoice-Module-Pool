# PBO Include – Process Before Output

## Purpose
Handles screen initialization and dynamic UI behavior.

## Important Logic

### Screen 0300
- Calls selection subscreen
- Prepares ALV list

MODULE STATUS_0100 OUTPUT.
  IF POSTED = 'X'.
   LOOP AT SCREEN.
    IF SCREEN-NAME = 'ITEM_BTN' OR SCREEN-NAME = 'BACK_BTN'.
      SCREEN-INPUT = 1.
      MODIFY SCREEN.
      ELSE.
         SCREEN-INPUT = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
  ELSE.
  LOOP AT SCREEN.
    IF SCREEN-NAME = 'ITEM_BTN'.
      SCREEN-INPUT = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
  ENDIF.
ENDMODULE.

MODULE STATUS_0200 OUTPUT.
  IF LV_DISPLAY = 'X'.
  LOOP AT SCREEN.
    IF SCREEN-NAME = 'ADD_BTN'.
      SCREEN-INPUT = 0.
      MODIFY SCREEN.
    ELSEIF SCREEN-NAME = 'DISPLAY_BTN'.
      SCREEN-INPUT = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
  ELSE.
    LOOP AT SCREEN.
    IF SCREEN-NAME = 'DISPLAY_BTN'.
      SCREEN-INPUT = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.
    ENDIF.
ENDMODULE.

