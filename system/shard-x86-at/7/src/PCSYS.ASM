;**************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge ================*
;*                                                                        *
;*   PC spezifische, deviceunabhaengige routinen                          *
;*                                                                        *
;************************************************************************** 

limit:
        mov dx,0FFFh
        push ax
        push cx
        int 12h      ;Speichergroesse abholen
        mov cl,6h
        shl ax,cl
        dec ax
        mov dx,ax
        mov ax,cs
        sub dx,ax                        ;must be relativ to cs
        pop cx
        pop ax
        ret

paragraphs:
        mov dx,0FFFh
        push ax
        push cx
        int 12h      ;Speichergroesse abholen
        mov cl,6h
        shl ax,cl
        dec ax
        mov dx,ax
        pop cx
        pop ax
        ret
 

;**************************************************************************
timerint equ 08*4
timercont equ 018h*4	;resident basic ist ueberfluessig
timer_init:
     mov ax,0
     mov es,ax
     mov bx,word ptr es:[timerint+2]
     mov word ptr es:[timercont+2],bx
     mov bx,word ptr es:[timerint]
     mov word ptr es:[timercont],bx
     mov word ptr es:[timerint+2],cs
     mov word ptr es:[timerint],offset timer_tick
     ret
; 
timer_tick:
     int 18h 
     push ax
     push ds
     push cs                  ;ds := cs
     pop ds
   sti
     call checkkey            ;keybord abfragen
   if pcd
     mov al,50
   else
     mov al,55                ;ungefaehr 55 millisekunden
   endif
   cli
     call timerinterrupt
     inc tickcount
     cmp tickcount,1000/55    ;schon eine sekunde um
     jnc sec_tick
     pop ds
     pop ax
     iret
;
;**************************************************************************
;*
;*   Die Initialisierung der einzelnen Kanaele kann in der Zelle sec_entry
;*   eine Routine eintragen, die im Sekundentack (ungefaehr) aufgerufen
;*   werden soll. Diese Routine muss dann die vorher dort eingetragene 
;*   Routine aufrufen. Ebenfalls kann ein di und si registerinhalt
;*   eingetragen werden, der beim aufruf gegeben sein soll. Dann ist dafuer
;*   Sorge zu tragen, dass die nachfolgenden Routine den jeweils vorher
;*   dort eingetragenen Wert erhaelt. Alle Register ausser di, si und !!ds!!
;*   duerfen beliebig zerstoert werden.
;*   ds ist immer auf das datensegment (momentan = cs) gesetzt.
sec_tick:
     mov tickcount,0          ;wieder vorn anfangen zu zaehlen
     push si
     push di
     push bp
     push bx
     push cx
     push dx
     push es
     mov di,word ptr sec_di
     mov si,word ptr sec_si
     jmp word ptr sec_entry
sec_cont:
     pop es
     pop dx
     pop cx
     pop bx
     pop bp
     pop di
     pop si
     pop ds
     pop ax
     iret

sec_entry dw offset sec_cont
sec_di    dw 0                ;hier koennen routinen das di und das si
sec_si    dw 0                ;ablegen, mit dem sie aufgerufen werden wollen

tickcount db 0

;****************************************************************************
;* neuen bootvorgang einleiten
reboot:
   if hdsystem
     mov ax,0401h             ;sector verify
     mov cx,1                 ;spur 0, sector 1
     mov dx,80h               ;drive 0, head 0
     int 13h
   endif
     mov ax,40h
     mov ds,ax                ;auf datensegment
     mov word ptr ds:[0072h],1234h ;reset flag
     db 0eah                  ;jmp 0ffffh:0
     dw 0 
     dw 0ffffh


