;***************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge =================*
;*                                                                         *
;*   Routinen fuer IBM - PC Parallel - Schnittstelle im EUMEL - System     *
;*                                                                         *
;*                                                                         *
;***************************************************************************

     device parallel

     dtcbroutines iocontrol
     routine 1,para_devicetype
     routine 2,para_frout
     routine 5,nil_size
     routine -3,para_force_rom_output
     routine -4,para_set_wait
     routine -1,no_channel_setup

     dtcbroutines control32
     routine -2,para_init
     routine -1,no_channel_setup

     dtcbroutines blockin
     dtcbroutines blockout
     routine -1,unknowncontrol

     dtcbparams para_output,3   ;typ = nur stream io


;******************************************************************
;*   der macro para_ccb muss fuer jede parallelschnittstelle im system
;*   einmal aufgerufen werden
;*
;*   parameter: 

para_ccb macro par,kanal
     startccb para&par&ccb,kanal
ccbentry para_number
     dw par
ccbentry para_stat
     db 0
ccbentry para_statusandmask
     db 80h                        ;;busy abfragen
ccbentry para_statusxormask
     db 80h                        ;;active high
ccbentry para_wait                 ;;wie lange vor busy warten
     db 1
ccbentry para_retry
     db 30                         ;;> 100 usec minimum
     endm

para_rom_mode equ 1

para_devicetype:
     mov cx,0                      ;erstmal 0 setzen
     call para_get_port
     ifnz <mov cl,shard:(si+devtype)>     ;type dazu
     ret

para_init:
     call para_get_port
     ifz <ret>
     test dx,0fc03h                ;ist die adresse ibm like
     jnz para_rom_init
     inc dx
     inc dx                        ;auf status ausgabe zeigen
     mov al,8                      ;init leitung aktivieren
     out (dx),al
     mov ax,4000
para_ini_loop:
     dec ax
     jnz para_ini_loop             ;warte ein weilchen
     mov al,0ch                    ;kein auto lf, init high
     out (dx),al
     ret

para_rom_init:
     mov ah,1
     mov dx,[di+para_number]
     int 17h
     ;es passt noch
     mov bx,dx                     ;nummer nach bx
     mov byte ptr es:[078h+bx],1 ;timeout wert,falls er doch mal busy kriegt
     ret

para_set_wait:
     inc dl
     mov [di+para_wait],dl
     inc dh
     mov [di+para_retry],dh
     ret

para_force_rom_output:
     or byte ptr [di+para_stat],para_rom_mode
     ret

para_output:
     jcxz para_all
     push es
     push bx
     call para_get_port
     pop bx
     pop es
     jz para_all                   ;kein port, dann wegwerfen
     test dx,0fc03h                ;ist die adresse ibm like
     jnz para_rom_output           ;nein, ueber rom raus
     test byte ptr [di+para_stat],para_rom_mode
     jnz para_rom_output
     push cx
     inc dx                   ;auf status gehen
para_out_loop:
     push cx
     mov cl,[di+para_wait]
     sub ch,ch                ;0 nach ch
     loop $                   ;pause fuer langsame drucker
     mov cl,[di+para_retry]
     ;ch ist 0
para_ow_loop:                 ;warten, bis output erlaubt
     in al,dx                 ;status holen
     and al,(di+para_statusandmask) ;welche bits interessieren uns
     xor al,(di+para_statusxormask) ;und wie sollen sie stehen
     jz para_ready            ;passt, ausgeben
     loop para_ow_loop
     pop dx                   ;restlaenge holen
     pop cx                   ;gesamtlaenge holen
     sub cx,dx                ;uebernommene laenge melden
                              ;carry ist geloescht
     ret

para_ready:
     pop cx                   ;zeichenzaehler zurueckholen
     dec dx                   ;auf port direkt gehen
     mov al,byte ptr es:[bx]  ;zeichen holen
     inc bx                   ;auf naechstes zeichen
     out (dx),al              ;zeichen ausgeben
     inc dx
     inc dx                   ;auf port fuer strobe zeigen
     mov al,0dh               ;strobe ist bit 0
     out (dx),al
     jmp short $+2
     mov al,0ch               ;und strobe zuruecknehmen
     out (dx),al
     dec dx                   ;auf status port gehen
     loop para_out_loop       ;naechstes ausgeben
     pop cx                   ;alles ausgegeben
para_all:
     stc
     ret

para_rom_output:
     push cx
     mov dx,[di+para_number]
para_rom_out_loop:
     push cx
     mov cl,[di+para_wait]
     sub ch,ch
     loop $                   ;pause fuer langsame drucker
     mov cl,[di+para_retry]
     shr cl,1                 ;durch 16
     shr cl,1
     shr cl,1
     shr cl,1                 
     inc cl                   ;aber nie 65000 mal     
para_rom_ow_loop:             ;warten, bis output erlaubt
     mov ah,2                 ;status holen
     int 17h
     and ah,(di+para_statusandmask) ;welche bits interessieren uns
     xor ah,(di+para_statusxormask) ;und wie sollen sie stehen
     jz para_rom_ready            ;passt, ausgeben
     loop para_rom_ow_loop
     pop dx                   ;restlaenge holen
     pop cx                   ;gesamtlaenge holen
     sub cx,dx                ;uebernommene laenge melden
                              ;carry ist geloescht
     ret

para_rom_ready:
     pop cx                   ;zeichenzaehler zurueckholen
     mov al,byte ptr es:[bx]  ;zeichen holen
     inc bx                   ;auf naechstes zeichen
     mov ah,0                 ;zeichen ausgeben
     int 17h
     loop para_rom_out_loop   ;naechstes ausgeben
     pop cx                   ;alles ausgegeben
     stc
     ret

para_frout:
     call para_get_port
     jz para_frout_ok
     test dx,0fc03h                ;ist die adresse ibm like
     jnz para_rom_frout            ;nein, ueber rom fragen
     test byte ptr [di+para_stat],para_rom_mode
     jnz para_rom_frout
     inc dx                   ;auf status gehen
     in al,dx                 ;status holen
     and al,(di+para_statusandmask) ;welche bits interessieren uns
     xor al,(di+para_statusxormask) ;und wie sollen sie stehen
     jnz para_frout_not_ok    ;passt nicht, melden
para_frout_ok:
     mov cx,50                ;kann ausgeben
     stc                      ;puffer leer
     ret

para_rom_frout:
     mov dx,[di+para_number]
     mov ah,2                 ;status holen
     int 17h
     and ah,(di+para_statusandmask) ;welche bits interessieren uns
     xor ah,(di+para_statusxormask) ;und wie sollen sie stehen
     jz para_frout_ok         ;passt, melden
para_frout_not_ok:
     mov cx,0                 ;nichts passt
     clc                      ;puffer nicht leer
     ret

para_get_port:
     ;setzt zero flag, wenn port = 0
     mov ax,40h                    ;ins pc datensegment
     mov es,ax
     mov bx,[di+para_number]       ;welcher printer
     shl bx,1                      ;fuer basis adresse passend
     mov dx,es:[8+bx]              ;printer basis adresse holen
     or dx,dx                      ;0?
     ret
