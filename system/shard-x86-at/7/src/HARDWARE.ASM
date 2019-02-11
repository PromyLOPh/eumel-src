;****************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge ==================*
;*                                                                          *
;*   Lesen des Hardware Kennzeichen-Bytes                                   *
;*                                                                          *
;****************************************************************************

hardware:
     push es
     mov ax,0ffffh
     mov es,ax
     mov al,byte ptr es:14          ;hardware byte holen
     pop es
     ret


