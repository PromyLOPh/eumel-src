;****************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge ==================*
;*                                                                          *
;*   Graphikroutinen fuer IBM - PC                                          *
;*                                                                          *
;*                                                                          *
;****************************************************************************

gr_base dw 03d0h                 ;default grahpic adress

gr_pointer equ 4                 ;pointer register of 6845
gr_data equ 5                    ;data register of 6845
gr_msr equ 8                     ;mode select register
gr_csr equ 9                     ;color select register
gr_status equ 10                 ;status register
gr_xmsr equ 10                   ;extended mode select register
gr_cfgswitch equ 15              ;hercules config switch

switch_mode:
     cmp dh,1
     jz gm_switch                ;tecmar graphics master
     cmp dh,2                    ;hercules
     jz herc_switch
     push dx
     push ax
     mov dx,[gr_base]
     add dx,gr_xmsr              ;tecmar auf normal mode setzen
     mov al,0
     out (dx),al
     jmp short $+2               ;io pause machen
     add dx,gr_cfgswitch-gr_xmsr ;hercules configswitch
     out (dx),al
     pop ax
     pop dx
     mov byte ptr [plot_mode],0  ;kein mode, den wir direkt auswerten
     mov al,dl
     mov ah,0
     int 10h                     ;auf gewuenschten mode schalten
     mov cx,0
     jnc mode_ok
unallowed_mode:
     mov cx,-1
mode_ok:
     ret

herc_switch:
     mov word ptr [gr_base],03b0h
     cmp dl,1                    ;mode 0 ist erlaubt
     jnc unallowed_mode
     add dl,6                    ;da steht der erste herculesmode
     jmp short all_allowed
gm_switch:                       ;tecmar graphics master
     cmp dl,6                    ;werte 0 bis 5 erlaubt
     jnc unallowed_mode
     push dx
     mov dx,[gr_base]
     add dx,gr_status            ;statusregister holen
     in al,dx
     pop dx
     test al,80h                 ;schalter auf monochrom
     jnz all_allowed             ;nein, alle modi erlaubt
     cmp dh,2                    ;nur 0 und 1
     jnc unallowed_mode
all_allowed:
     mov byte ptr [plot_mode],1  ;merken, dass in erweitertem mode
     mov dh,0
     mov ax,offset mod_tb_length ;laenge einer tabelle
     mul dx                      ;auf passende tabelle zeigen
     mov bx,ax
     add bx,offset mod_tables    ;auf erstes byte der tabelle
;
     mov ah,13                   ;vierzehn register muessen ausgegeben werden
     mov dx,[gr_base]
     add dx,gr_msr               ;da ist mode select register unserer graphik
     mov al,0                    ;disable screen output
     out (dx),al
     jmp short $+2
     add dx,gr_cfgswitch-gr_msr  ;hercules einschalten (wenn da)
     mov al,3
     out (dx),al
     sub dx,gr_cfgswitch-gr_pointer

set_6845:
     mov al,ah
     out (dx),al                 ;in dieses register wollen wir schreiben
     inc dx                      ;und hier muss der wert hin
     mov al,byte ptr [bx]
     inc bx                      ;auf naechstes feld
     out (dx),al
     dec dx                      ;wieder auf zeiger_register
     dec ah
     jns set_6845                ;bis nummer negativ
;
     cld
     mov cx,08000h               ;fill 64k
     mov ax,0a000h
     mov es,ax
     xor ax,ax                   ;fill with 0
     xor di,di                   ;start at 0 in area
     rep stosw
     mov cx,08000h
     mov ax,0b000h               ;next 64k
     mov es,ax
     xor ax,ax                   ;fill with 0
     xor di,di                   ;start at 0 in area
     rep stosw
;
     mov al,byte ptr[bx]         ;csr wert holen
     inc bx
     add dx,gr_csr-gr_pointer
     out (dx),al
;
     inc dx                      ;to xmsr
     mov al,byte ptr [bx]
     inc bx
     out (dx),al
;
     sub dx,gr_xmsr-gr_msr       ;to msr
     mov al,byte ptr [bx]
     inc bx
     out (dx),al
;
     mov ax,word ptr [bx]        ;laenge einer graphik zeile
     inc bx
     inc bx
     mov word ptr [gr_linelength],ax
;
     mov al,byte ptr [bx]        ;maske, um ein pixel zu behalten
     push ds
     pop es
     mov cx,16
     mov di,offset color_tab
     rep stosb                   ;farbtabelle auf 3 initalisieren
     mov ah,0
     inc bx
     mov word ptr [gr_pixel_mask],ax
     xor al,0ffh                 ;maske erzeugen, die ein pixel loescht
     mov byte ptr [gr_pixel_inv_mask],al
;
     mov word ptr [first_shift],9090h ;ersten shift wegnoppen
     test byte ptr [bx],1        ;vier segmente ?
     ifnz <mov word ptr [first_shift],0ebd1h> ;shift wieder eintragen
     inc bx
;
     mov al,byte ptr [bx]        ;mask fuer pixel_pro_byte holen
     inc bx
     mov byte ptr [gr_pixel_per_byte_mask],al
     mov word ptr [shift_count_shift],0c902h ;volles shift annehmen
     mov word ptr [shift_count_shift+2],0c902h ;add cl,cl
     mov ah,1                    ;anzahl shifts, um byteoffset zu kriegen
     shr al,1                    ;bei mehr als zwei pixel ein shift weniger
     jz shifts_nopped
     inc ah
     mov word ptr [shift_count_shift],09090h ;nops
     shr al,1                    ;bei acht pixel gar kein shift
     jz shifts_nopped
     inc ah
     mov word ptr [shift_count_shift+2],09090h ;nops
shifts_nopped:
     mov byte ptr [gr_byte_calc_shift],ah
;
     mov si,bx
     mov di,offset gr_segtable
     mov cx,4
     rep movsw                   ;segmentwerte uebertragen
     add bx,8
     mov cx,0
     ret

pen:
     mov word ptr [maske],dx
     mov byte ptr [linetype],bl
     ret

new_pen1:
     mov cx,bx                   ;bx merken
     mov bx,offset color_tab
     call set4
     mov cx,dx
     call set4
     ret

new_pen2:
     mov cx,bx                   ;bx merken
     mov bx,offset color_tab+8   ;zweite haelfte der tabelle
     call set4
     mov cx,dx
     call set4
     ret

set4:
     call set2
     mov cl,ch
set2:
     mov al,cl
     and al,15                   ;nur untersten 4 bits behalten
     mov byte ptr [bx],al
     inc bx
     mov al,cl
     mov cl,4
     shr al,cl                   ;obersten 4 bits
     mov byte ptr [bx],al
     inc bx
     ret

mask_mode:
     mov word ptr [jmp_or_not],9090h ;set mask mode
     mov cx,word ptr [mask_count] ;alten mask_count zurueckliefern
     mov word ptr [mask_count],bx
     cmp dx,0                    ;wirklich mask_mode gewuenscht
     ifz <mov word ptr [jmp_or_not],07ebh> ;nein, sprung wieder einbauen
     ret

move:
     mov word ptr [altx],dx      ;neuen x wert
     mov word ptr [alty],bx      ;und y wert setzen
     ret

draw:
     mov byte ptr [stepx],46h ;inc si
     mov byte ptr [stepy],47h ;inc di
     mov cx,dx                   ;in welche richtung wie weit gehen
     sub cx,word ptr [altx]
     jns positiv_x
     neg cx                      ;negative richtung, positiv machen und
     mov byte ptr [stepx],4eh ;dec si zum ausgleich
positiv_x:
     mov dx,bx                   ;y wert holen
     sub dx,word ptr [alty]      ;wie weit und welche richtung
     jns positiv_y
     neg dx                      ;negative richtung, positiv rechnen und
     mov byte ptr [stepy],4fh ;dec di zur korrektur
positiv_y:
     cmp dx,cx                   ;hauptrichtung entlang des groesseren
                                 ;offsets
     jc direction_ok             ;hauptrichtung war entlang si
     mov bx,word ptr [stepy]  ;richtungen tauschen
     xchg bh,bl
     mov word ptr [stepy],bx
     xchg cx,dx                  ;und richtungslaengen tauschen
                                 ;hauptrichtung ist jetzt entlang di
direction_ok:
                                 ;der wert fuer die hauptrichtung ist
                                 ;in cx, fuer die nebenrichtung in dx
                                 ;der fehlerwert der nebenrichtung in
                                 ;1/abs(hauptrichtung) - einheiten ist in bx
     mov bx,0                    ;fehlerwert ist im moment 0
     mov word ptr [delta_x],cx   ;wert fuer hauptrichtung merken
     mov si,word ptr [altx]      ;alte werte holen
     mov di,word ptr [alty]
paint:
     jcxz paint_done             ;fertig, letzten punkt noch malen
     sub bx,dx                   ;ist gerader fehler schon negativ
     jns stepx                   ;nur hauptrichtung nehmen
     mov ax,bx                   ;geraden fehler nach ax
     add ax,ax                   ;
     add ax,word ptr [delta_x]   ;
     jns stepx                   ;nur hauptrichtung
     add bx,word ptr [delta_x]
stepy:
     inc di
stepx:
     inc si

; errechneten punkt setzen

     call punkt

     loop paint

paint_done:
     call punkt                  ;letzten punkt setzen
     mov word ptr [alty],di
     mov word ptr [altx],si
     ret


punkt:
     test byte ptr [plot_mode],0ffh
     jnz new_punkt
     push cx
     push dx
     mov dx,di
     mov cx,si
     ror word ptr maske,1
linetype equ $+1
     mov ax,0c01h                ;write dot
     and al,byte ptr [maske]      ;linie einbauen
     int 10h
     pop dx
     pop cx
     ret

new_punkt:
     push ax
     push bx
     push cx
     push dx
     push es
     mov bx,di
     and bx,3
     add bx,bx                   ; *2
     mov es,[bx+gr_segtable]     ;in diesem segment liegt unser punkt
gr_linelength equ $+1
     mov ax,720/4                ;bytes pro zeile horizontal
     mov bx,di                   ;y wert wieder holen
first_shift:                     ;dieser shift faellt bei zwei segmenten aus
     shr bx,1
     shr bx,1                    ;di / 4
     mul bx                      ;mal anzahl bytes pro graphikzeile
     mov bx,si                   ;byte in zeile ausrechnen
gr_byte_calc_shift equ $+1
     mov cl,2                    ;so oft si shiften, fuer byte in zeile
     shr bx,cl
     add bx,ax                   ;dies byte enthaelt unseren punkt
     mov cx,si                   ;untersten bits geben shiftfaktor an
     inc cx                      ;einmal mehr shiften (oder gar nicht)
gr_pixel_per_byte_mask equ $+2
     and cl,3                    ;vier pixel pro byte (15 fuer zwei pixel etc
shift_count_shift:
     add cl,cl                   ;shiftfaktor verdoppeln
     add cl,cl                   ;oder vervierfachen
     mov al,byte ptr es:[bx]     ;byte holen
     rol al,cl                   ;pixel nach 0 holen
     mov bp,ax                   ;evtl. wird pixelwert als index benutzt
gr_pixel_mask equ $+2
     and bp,3                    ;die pixel bits behalten
jmp_or_not:
     jmp short punkt_no_mask
mask_count equ $+1               ;zaehler fuer maske
     mov bp,0
     and bp,15                   ;maskenzaehler MOD 16 nehmen
punkt_no_mask:
gr_pixel_inv_mask equ $+1
     and al,0fch                 ;rest behalten
     or al,byte ptr ds:[bp+color_tab] ;pixel setzen
     ror al,cl                   ;zurueckdrehen
     mov byte ptr es:[bx],al     ;wieder eintragen
     inc word ptr ds:[mask_count]
     pop es
     pop dx
     pop cx
     pop bx
     pop ax
     ret

 even

maske dw 0ffffh
altx dw 0
alty dw 0
delta_x dw 0
;gr_pixel_mask dw 3               ;maske, welche bits zum pixel gehoeren
;mask_count dw 0                  ;zaehler fuer maskiertes schreiben

gr_segtable dw 0a000h            ;tabelle der graphik segmente
            dw 0a800h
            dw 0b000h
            dw 0b800h


;gr_linelength dw 720/4           ;laenge einer graphikzeile
;mask_mod db 0                    ;nicht 0, wenn mit maske
color_tab db 16 DUP (3)          ;farbtabelle

plot_mode db 0

;gr_pixel_inv_mask db 0fch        ;invertiert, nur byte



mod_tables equ $
;mode 0
; 6845 regs 13       -                     0,csr,xmsr,msr
     db 0,0,0,32,3,2,88,86,1,91,14,90,90,109,  0, 191, 11
     dw 720/4                    ;laenge einer graphikzeile
     db 3                        ;maske, um ein pixel zu behalten
     db 1                        ;1 = 4 segmente, 0 = 2 segmente
     db 3                        ;maske, um si MOD pixel_pro_byte zu machen
     dw 0a000h,0a800h,0b000h,0b800h ;die vier segmente
mod_tb_length equ $-mod_tables
;mode 1
; 6845 regs 13       -                     0,csr,xmsr,msr
     db 0,0,0,32,3,3,88,86,1,91,14,90,90,109,  0, 191, 11
     dw 720/4                    ;laenge einer graphikzeile
     db 3                        ;maske, um ein pixel zu behalten
     db 1                        ;1 = 4 segmente, 0 = 2 segmente
     db 3                        ;maske, um si MOD pixel_pro_byte zu machen
     dw 0a000h,0a800h,0b000h,0b800h ;die vier segmente
;mode 2
; 6845 regs 13       -                          0,csr,xmsr,msr
     db 0,0,0,32,1,2,112,100,6,127,15,184,160,227,  0,  31, 24
     dw 640/2                    ;laenge einer graphikzeile
     db 15                       ;maske, um ein pixel zu behalten
     db 0                        ;1 = 4 segmente, 0 = 2 segmente
     db 1                        ;maske, um si MOD pixel_pro_byte zu machen
     dw 0a000h,0a800h,0a000h,0a800h ;die vier segmente
;mode 3
; 6845 regs 13       -                       0,csr,xmsr,msr
     db 0,0,0,32,3,3,56,50,1,64,15,184,160,227,  0,  31, 24
     dw 640/2                    ;laenge einer graphikzeile
     db 15                       ;maske, um ein pixel zu behalten
     db 1                        ;1 = 4 segmente, 0 = 2 segmente
     db 1                        ;maske, um si MOD pixel_pro_byte zu machen
     dw 0a000h,0a800h,0b000h,0b800h ;die vier segmente
;mode 4
; 6845 regs 13       -                        0,csr,xmsr,msr
     db 0,0,0,32,1,2,112,100,7,127,15,98,90,128,  0,  63, 11
     dw 720/4                    ;laenge einer graphikzeile
     db 3                        ;maske, um ein pixel zu behalten
     db 0                        ;1 = 4 segmente, 0 = 2 segmente
     db 3                        ;maske, um si MOD pixel_pro_byte zu machen
     dw 0a000h,0a800h,0a000h,0a800h ;die vier segmente
;mode 5
; 6845 regs 13       -                     0,csr,xmsr,msr
     db 0,0,0,32,3,3,56,50,3,64,15,98,90,128,  0,  63, 11
     dw 720/4                    ;laenge einer graphikzeile
     db 3                        ;maske, um ein pixel zu behalten
     db 1                        ;1 = 4 segmente, 0 = 2 segmente
     db 3                        ;maske, um si MOD pixel_pro_byte zu machen
     dw 0a000h,0a800h,0b000h,0b800h ;die vier segmente
;mode 6 (hercules)
; 6845 regs 13       -                  0,csr,xmsr,msr
     db 0,0,0,0,3,2,87,87,2,91,7,46,45,53,  0,  0, 10
     dw 720/8                    ;laenge einer graphikzeile
     db 1                        ;maske, um ein pixel zu behalten
     db 1                        ;1 = 4 segmente, 0 = 2 segmente
     db 7                        ;maske, um si MOD pixel_pro_byte zu machen
     dw 0b000h,0b200h,0b400h,0b600h ;die vier segmente
