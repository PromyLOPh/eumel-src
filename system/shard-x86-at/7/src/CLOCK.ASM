;****************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge ==================*
;*                                                                          *
;*   Lesen der Echtzeituhr des IBM PC-AT                                    *
;*   Schreiben dummy routine	                                            *
;*        Aufruf: blockin/blockout mit code -4 ueber kanal 32               *
;*        Puffer: ROW 7 INT VAR                                             *
;*                                                                          *
;****************************************************************************

clockread:
     call hardware
     cmp al,IBMat                ;haben wir den IBM PC-AT
     jnz no_clock
     mov ah,4                    ;read date
     int 1ah
     jc no_clock
     mov al,ch                   ;jahrhundert
     call putbcd                 ;ueber bx wegschreiben
     mov al,cl                   ;jahr
     call putbcd
     mov al,dh                   ;monat
     call putbcd
     mov al,dl                   ;tag
     call putbcd
     mov ah,2                    ;read time
     int 1ah
     jc no_clock
     mov al,ch                   ;stunden
     call putbcd
     mov al,cl                   ;minuten
     call putbcd
     mov al,dh                   ;sekunden
     call putbcd
     mov cx,0                    ;keine fehler
     ret

no_clock:
     mov cx,-1                   ;geht nicht
     ret

clockwrite:
     mov cx,-1
     ret

putbcd:
     mov ah,al
     and ah,0fh                  ;in al niedrige nibble behalten
     ib shr al,4                 ;rueberschieben
     or ax,3030h                 ;ziffern draus machen
     mov word ptr es:[bx],ax     ;eintragen
     inc bx
     inc bx                      ;zum naechsten
     ret

