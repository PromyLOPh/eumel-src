;***************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge =================*
;*                                                                         *
;*   Behandlung des PC Bildschirms und der Tastatur                        *
;*                                                                         *
;***************************************************************************

     device pc

     dtcbroutines iocontrol
     routine 1,devicetype
     routine 2,frout_ok
     routine 5,nil_size
     routine 6,priv_op_question
     routine 8,priv_op_question
     routine 9,priv_op_question
     routine -3,set_attribute
     routine -4,set_palette
     routine -5,switch_mode
     routine -6,draw
     routine -7,move
     routine -8,pen
     routine -9,new_pen1
     routine -10,new_pen2
     routine -11,mask_mode

     routine -1,unknowncontrol

     dtcbroutines control32
     routine -2,pc_init
     routine -1,no_channel_setup

     dtcbroutines blockin
     dtcbroutines blockout
     routine -1,unknowncontrol

     dtcbparams pc_output,3   ;typ = nur stream io


;***************************************************************************

pc_init:
breakaddress    equ     01bh*4  ;tastatur break adresse 
     mov bx,0
     mov es,bx                ;in die interrupt vektoren zeigen
     mov word ptr es:[breakaddress+2],cs
     mov word ptr es:[breakaddress],offset breakint
     mov dx,0                 ;cursor in die obere ecke 
     mov bh,0
     mov ah,2                 ;cursor setzen
     int 10h
     mov ax,0600h             ;clear entire window
     mov cx,0                 ;von oben
     mov dx,25*256+80         ;bis unten
     mov bh,7                 ;attribut
     int 10h 
     ret

;
breakint:
                push cx
                push ax
                push ds
                push cs
                pop ds
;               mov al,1
;               mov ch,'i'
;               call inputinterrupt
                mov al,1
                mov ch,2            ;sv
                call inputinterrupt
                pop ds
                pop ax
                pop cx
                iret
;
;
;
REVERS          EQU     01110000B       ;ATTRIBUT FUER REVERS-VIDEO
NORMAL          EQU     00000111B       ;ATTRIBUT FUER NORMAL-VIDEO
HOME            EQU     1 
RECHTS          EQU     2
OBEN            EQU     3
CLEOP           EQU     4               ;CLEAR TO END OF PAGE
CLEOL           EQU     5               ;CLEAR TO END OF LINE
CPOS            EQU     6               ;CURSOR-POSITIONIERUNG
;                                        ES FOLGEN X- UND Y-KOORDINATE
BELL            EQU     7 
LINKS           EQU     8
UNTEN           EQU     10
RETURN          EQU     13
BEGMARK         EQU     15
ENDMARK         EQU     14
MAXCOLS         EQU     79
MAXLINES        EQU     23
ATTRIBUT        DB      NORMAL
CURFLAG         DB      0
YPOS            DB      0
;
;***********************************************************************
;*   output auf bildschirm des pc
;*
pc_output:
       PUSH    CX     ;RETTE ORIGINALLAENGE DES STRINGS
       CLD            ;DIRECTION FLAG : INCREM. SI
       MOV     SI,BX
OUT:   mov al,es:[si]    ;HOLE ZEICHEN
       inc si
       MOV     AH,CURFLAG
       CMP     AH,0
       JNZ     s0
       CMP     AL,HOME
       JZ      s1     ;CURSOR HOME VERLANGT ?
       CMP     AL,RECHTS 
       JZ      s2     ;CURSOR NACH RECHTS ?
       CMP     AL,OBEN 
       JZ      s3     ;CURSOR NACH OBEN ?
       CMP     AL,CLEOP 
       JZ      s4     ;LOESCHEN BIS BILDSCHIRMENDE ?
       CMP     AL,CLEOL
       JZ      s5     ;LOESCHEN BIS ZEILENENDE ?
       CMP     AL,CPOS 
       JZ      s6     ;CURSOR POSITIONIEREN ?
       CMP     AL,LINKS
       JZ      s7     ;CURSOR NACH LINKS?
       CMP     AL,UNTEN
       JZ      s8     ;CURSOR NACH UNTEN ?
       CMP     AL,RETURN 
       JZ      s9     ;CURSOR AN DEN ANFANG DER AKT. ZEILE ?
       CMP     AL,BEGMARK 
       JZ      s10    ;AB JETZT REVERS ?
       CMP     AL,ENDMARK 
       JZ      s11    ;WIEDER NORMALE VIDEO-DARSTELLUNG ?
       CMP     AL,BELL
       JZ      s12    ;KLINGELN ?
;
       PUSH    CX
       PUSH    BX
       PUSH    SI 
       PUSH    AX     ;AKTUELLES ATTRIBUT
       MOV     AL,ATTRIBUT
       MOV     BL,AL
       POP     AX
       MOV     AH,9   ;SCHREIBEN MIT ATTRIBUT
       MOV     BH,0   ;PAGE #
       MOV     CX,1
       INT     010H   ;CALL BIOS
       MOV     AH,3   ;GET CURRENT CURSOR-POSITION
       MOV     BH,0   ;PAGE #
       INT     010H   ;CALL BIOS
       INC     DL     ;COL = COL + 1
       CMP     DL,MAXCOLS+1
       JNZ     SAME_LINE
       MOV     DL,0
       CMP     DH,MAXLINES 
       JZ      SCROLL_UP
       INC     DH
SAME_LINE:      MOV     AH,2
       mov bh,0     ;page number 
       INT     010H
       POP     SI
       POP     BX
       POP     CX
       JMP     DONE
;
SCROLL_UP:      CALL    SCROLL
       JMP     SAME_LINE 
;
DONE:  DEC     CX     ;ANZAHL ZEICHEN = ANZAHL ZEICHEN - 1
       JNZ     OUT    ;WEITER ?
       POP     CX     ;ANZAHL UEBERNOMMENE ZEICHEN (S.O.)
       RET
; 
s0:    JMP     CUR1
s1:    JMP     CURHOME
s2:    JMP     RIGHT
s3:    JMP     UP
s4:    JMP     CLEAREOP
s5:    JMP     CLEAREOL
s6:    JMP     CURPOS
s7:    JMP     LEFT
s8:    JMP     DOWN
s9:    JMP     ENTER
s10:   JMP     MARK
s11:   JMP     UNMARK
s12:   JMP     KLINGELN
;
;
CURPOS:MOV     AL,2
       MOV     CURFLAG,AL
       JMP     DONE
;
CUR1:  CMP     AH,1
       JZ      CURX
     cmp al,maxlines
     jc  cur1ok
     mov al,maxlines
cur1ok:
       MOV     YPOS,AL
       DEC     CURFLAG
       JMP     DONE

CURX:  DEC     CURFLAG
       MOV     DH,YPOS;Y-KOORDINATE
     cmp  al,maxcols
     jc   curxok
     mov  al,maxcols
curxok:
       MOV     DL,AL  ;X-KOORDINATE
       PUSH    BX
       PUSH    CX
       PUSH    SI
       MOV     BH,0   ;PAGE #
       MOV     AH,2   ;SET CURSOR POSITION
       INT     010H   ;CALL BIOS
       POP     SI
       POP     CX
       POP     BX
       JMP     DONE
;
CURHOME:        PUSH    BX
       PUSH    CX
       PUSH    SI
       MOV     BH,0   ;PAGE #
       MOV     DX,0000H        ;POSITION (0,0)
       MOV     AH,2
       INT     010H   ;CALL BIOS
       POP     SI
       POP     CX
       POP     BX
       JMP     DONE
;
RIGHT: PUSH    BX
       PUSH    CX
       PUSH    SI
       MOV     AH,3   ;GET CURRENT CURSOR-POSITION
       MOV     BH,0   ;PAGE #
       INT     010H   ;CALL BIOS
       CMP     DL,MAXCOLS      ;X-POSITION DES CURSOR ZU GROSS?
       JZ      RUNTER
       INC     DL     ;COL = COL + 1
       MOV     AH,2
       INT     010H
       POP     SI
       POP     CX
       POP     BX
       JMP     DONE
RUNTER:MOV     DL,0
       MOV     BH,0
     mov  ah,2
       INT     010H
       JMP     down1
; 
LEFT:  PUSH    BX     ;KOMMENTARE : S.O.
       PUSH    CX
       PUSH    SI
       MOV     AH,3
       MOV     BH,0
       INT     010H
       DEC     DL
       MOV     AH,2
       INT     010H
       POP     SI
       POP     CX
       POP     BX
       JMP     DONE
;
UP:    PUSH    BX
       PUSH    CX
       PUSH    SI
       MOV     AH,3
       MOV     BH,0
       INT     010H
       DEC     DH
       MOV     AH,2 
       INT     010H
       POP     SI
       POP     CX
       POP     BX
       JMP     DONE
;
DOWN:  PUSH    BX
       PUSH    CX
       PUSH    SI
down1:       MOV     AH,3
       MOV     BH,0
       INT     010H
       CMP     DH,MAXLINES
       JZ      SCRL
       INC     DH
       MOV     AH,2
       INT     010H
       POP     SI
       POP     CX
       POP     BX
       JMP     DONE
SCRL:  CALL    SCROLL
       POP     SI
       POP     CX
       POP     BX
       JMP     DONE
;
;
ENTER: PUSH    BX
       PUSH    CX
       PUSH    SI
       MOV     AH,3
       MOV     BH,0
       INT     010H
       MOV     DL,0
       MOV     AH,2
       INT     010H
       POP     SI
       POP     CX
       POP     BX
       JMP     DONE
;
;
CLEAREOP:       PUSH    BX
       PUSH    CX
       PUSH    SI
       MOV     AH,3   ;GET CURRENT CURSOR-POSITION
       MOV     BH,0   ;PAGE #
       INT     010H   ;CALL BIOS
       MOV     CX,DX  ;CURRENT CURS.POS = UPPER LEFT CORNER
       MOV     DL,maxcols      ;END OF LINE
       MOV     AX,600H;AH=6 : SCROLL AL=0 : BLANK WINDOW
       MOV     BH,7   ;ATTRIBUTE FOR CLS
       INT     010H   ;CLEAR TO END OF LINE
       MOV     CL,0
       CMP     DH,MAXLINES
       JZ      FERTIG
       INC     CH
       MOV     DH,MAXLINES     ;NEW LOWER RIGHT CORNER 
       MOV     DL,MAXCOLS
       MOV     AX,600H
       MOV     BH,7   ;ATTRIBUTE FOR CLS
       INT     010H
FERTIG:POP     SI
       POP     CX
       POP     BX
       JMP     DONE
;
CLEAREOL:       PUSH    BX
       PUSH    CX
       PUSH    SI
       MOV     AH,3   ;GET CURRENT CURSOR-POSITION
       MOV     BH,0   ;PAGE #
       INT     010H   ;CALL BIOS
       MOV     CX,DX  ;CURRENT CURS.POS = UPPER LEFT CORNER
       MOV     DL,maxcols      ;END OF LINE
       MOV     AX,600H;AH=6 : SCROLL AL=0 : BLANK WINDOW
       MOV     BH,7   ;ATTRIBUTE FOR CLS
       INT     010H   ;CLEAR TO END OF LINE
       POP     SI
       POP     CX
       POP     BX
       JMP     DONE
;
MARK:
       MOV     ATTRIBUT,revers
       JMP     DONE
;
UNMARK:
       MOV     ATTRIBUT,normal 
       JMP     DONE
;
SCROLL:MOV     AH,6
       MOV     AL,1   ;SCROLL WINDOW ONE LINE UP
       MOV     CX,0000H        ;UPPER LEFT CORNER : (0,0)
       MOV     DH,MAXLINES
       MOV     DL,MAXCOLS
       mov bh,7          ;attribute for scroll
       INT     010H
       MOV     DH,MAXLINES
       MOV     DL,0
       MOV     BH,0   ;PAGE #
       RET
;
;
KLINGELN:       PUSH    BX
       PUSH    CX
       PUSH    SI
       MOV     AH,14
       MOV     BH,0
       INT     010H   ;PIEEPS
       POP     SI
       POP     CX
       POP     BX
       JMP     DONE
;
set_attribute:
     mov attribut,dl
     ret

set_palette:
     mov ah,11                ;set color palette
     int 10h
     ret

;
;
;
;**********************************************************************
;*
;*   checkkey prueft ob ein zeichen auf der tastatur eingegeben wurde
;*   und uebergibt dies ggf. dem EUMEL;
;*   muss regelmaessig (z.B. aus timerinterrupt aufgerufen werden
; 
checkkey:
     push ax
checkagain:
     MOV     AH,1    ;Z-FLAG GESETZT : ZEICHEN !
   cli
     INT     016H    ;INPUT FROM KEYBOARD
     JZ      NO_KEY  ;NEIN,KEINE TASTE GEDRUECKT
     MOV     AH,0
     INT     016H    ;JA, ZEICHEN ABHOLEN
     cmp ax,0        ;kommt von 'break'
     jz no_key
     cmp al,0        ;extended code
     jnz normal_key
     mov al,ah       ;mit bit acht kennzeichnen
     or  al,80h
normal_key:
     push cx
     MOV     CH,AL
     MOV     AL,1    ;KANAL-NUMMER
     CALL    inputinterrupt
     pop cx
   sti
     jmp checkagain
NO_KEY:
   sti
     pop ax
     ret
;
