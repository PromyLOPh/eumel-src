;***************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge =================*
;*                                                                         *
;*   Dieses Modul definiert alle Routinen, die benoetigt werden, wenn      *
;*   ein Kanal nicht existiert oder bestimmte Funktionen nicht durch-      *
;*   fuehren kann.                                                         *
;*                                                                         *
;***************************************************************************

     device nilchannel

     dtcbroutines iocontrol
          routine 1,devicetype
          routine 2,frout_ok
          routine 5,nil_size
          routine -1,unknowncontrol
     dtcbroutines control32
          routine -1,no_channel_setup
     dtcbroutines blockin
     dtcbroutines blockout
          routine -1,no_blockinout
     dtcbparams nil_output,0            ;output; niltype

nil_size:
     mov al,0
     mov cx,0
     ret

unknowncontrol:
no_blockinout:
     mov cx,-1
     ret

frout_ok:
     mov cx,200                    ;200 bytes frei
     stc                           ;puffer leer
     ret

no_baud:
no_bits:
no_flow:
no_channel_setup:
     mov cx,1
     ret

nil_output:
     stc
     ret                           ;alle zeichen uebernommen

devicetype:
     mov ch,0                      ;hoeherwertige teil immer null
     mov cl,shard:(si+devtype)     ;type dazu
     ret
