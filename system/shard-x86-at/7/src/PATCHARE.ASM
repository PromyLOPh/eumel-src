;********************************************************
;*==== Copyright (C) 1985,86 Martin Schoenbeck, Spenge =*
;*                                                      *
;* Bereich, der vom setup-Programm gepatcht wird        *
;*                                                      *
;********************************************************

     if at
bb_table dw 32 DUP (-1)
         dw 32 DUP (-1)
max_bb equ 32
bb_anz dw 0
     else
bt_table dw 8 DUP (-1)   ;diese kopf/spur Kombination ist unmoeglich
bt_replace dw 8 DUP (-1) ;ersatz
     endif
