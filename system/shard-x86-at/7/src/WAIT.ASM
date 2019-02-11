;****************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge ==================*
;*                                                                          *
;*   Support fuer die Wartelogik des IBM PC-AT ueber int 15h                *
;*                                                                          *
;*                                                                          *
;****************************************************************************

int15 proc far
     sti
     push ax
     cmp ah,90h                  ;hat ein treiber nichts zu tun
     jz device_is_busy
     cmp ah,91h                  ;oder ist er gerade fertig
     jz device_ready
not_for_me:                      ;hab ich nichts mit am hut
     pop ax
     jmp dword ptr cs:[int15_cont]

device_ready:
     cmp al,2                    ;0 (platte) oder 1 (floppy)
     jnc not_for_me
     mov ah,0
     push bx
     mov bx,ax
     mov byte ptr cs:device_busy[bx],2  ;device ist fertig geworden
     pop bx
     pop ax
     iret

device_is_busy:
     mov ah,8                    ;annahme: 6 sekunden fuer platte
     cmp al,0                    ;ist es platte
     jz device_wait              ;ja
     mov ah,3                    ;annahme: 2 sekunden fuer floppy
     cmp al,1
     jz device_wait              ;ist floppy
     cmp al,0fdh                 ;warten auf floppy_motor 
     jnz not_for_me              ;mit allem anderen haben wir nichts am hut
     mov ax,0301h                ;zwei sekunden warten; device floppy
device_wait:
     push bx                     ;den ganzen ramsch sichern
     push cx
     push dx
     push bp
     push di
     push si
     push es
     push ds
     mov bl,al
     mov bh,0
   cli
     mov byte ptr cs:device_table[bx],1          ;device busy setzen
     mov byte ptr cs:device_timeout_table[bx],ah ;anzahl sekunden eintragen
   sti
device_wait_loop:
     cmp byte ptr cs:device_busy[bx],0  ;noch kein interrupt gekommen
     jnz device_wait_end
     push bx
     call cs:warte
     pop bx
     jmp device_wait_loop
device_wait_end:
     cmp byte ptr cs:device_busy[bx],2 ;normales ende
     ifnz <stc>                         ;nicht normal, war timeout
     mov byte ptr cs:device_table[bx],0 ;device ist wieder frei
     mov byte ptr cs:device_busy[bx],0 ;device kann wieder auf int warten
;    jnc devcont
;    call cs:info
;    jmp short devcont
;    db ' timeout'
devcont:
     pop ds
     pop es
     pop si
     pop di
     pop bp
     pop dx
     pop cx
     pop bx
     pop ax
     ret 2                       ;kill flags on stack

int15 endp

device_timing:
     mov bx,-1                   ;mit 0 fangen wir an
     mov cx,2                    ;zwei durchlaeufe
device_timing_loop:
     inc bx
     mov al,byte ptr device_timeout_table[bx] ;timeout zaehler holen
     cmp al,0ffh                 ;schon fertig mit zaehlen
     jz device_timing_end
     dec al
     mov byte ptr device_timeout_table[bx],al ;timeout zaehler neu setzen
     jns device_timing_end
     cmp byte ptr device_table[bx],1 ;noch aktiv?
     ifz <cmp byte ptr device_busy[bx],0> ;und noch kein endeinterrupt
     ifz <mov byte ptr device_busy[bx],3> ;timeout aufgetreten
device_timing_end:
     loop device_timing_loop
     jmp word ptr device_cont

;***********************************************************************
;* warten, bis das in bx uebergebene device frei ist
;* ds = cs ist bedingung, alle register (ausser flags) bleiben erhalten
  db 'device free'
device_free:
     cmp byte ptr device_table[bx],0 ;ist das device frei 
     jnz device_not_free
     mov byte ptr device_busy[bx],0 ;evtl. nachgeklapperte ints loeschen
     ret                         ;device kann benutzt werden
device_not_free:
     push ax
     push bx
     push cx
     push dx
     push si
     push di
     push bp
     push ds
     push es
     call warte
     pop es
     pop ds
     pop bp
     pop di
     pop si
     pop dx
     pop cx
     pop bx
     pop ax
     jmp device_free

device_lock:
     mov byte ptr device_table[bx],1 ;device sperren 
     ret

device_unlock:
     mov byte ptr device_table[bx],0 ;device freigeben 
     ret

device_init:
     mov ax,0
     mov es,ax
     mov bx,word ptr es:[15h*4]         ;int routine holen
     mov cx,word ptr es:[15h*4+2]       ;int segment holen
     mov word ptr es:[15h*4],offset int15
     mov word ptr es:[15h*4+2],cs
     mov word ptr [int15_cont],bx
     mov word ptr [int15_cont+2],cx
     mov ax,word ptr [sec_entry]       ;alte adresse fuer sec_tick holen
     mov word ptr [device_cont],ax     ;eintragen fuer weitergabe
     mov word ptr [sec_entry],offset device_timing ;unseren aufruf eintragen 
     ret

int15_cont:
     dw 0
     dw 0

device_cont:
     dw 0

device_table:
     db 0
     db 0

device_busy:
     db 0
     db 0

device_timeout_table:
     db 0
     db 0

