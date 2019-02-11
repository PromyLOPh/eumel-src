;************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge ==============*
;*                                                                      *
;*   Floppydisk archiv routinen                                         *
;*                                                                      *
;************************************************************************

     device archive

     dtcbroutines iocontrol
          routine 5,archive_size
          routine 1,devicetype
          routine 7,archive_format
          routine -1,unknowncontrol
     dtcbroutines control32
     ife pcd
          routine -2,archive_init
     endif
          routine -173,set173size
          routine -1,no_channel_setup
     dtcbroutines blockin
          routine 0,archive_read
     dtcbroutines blockout
          routine 0,archive_write
          routine -1,unknowncontrol
     if pcd
     dtcbparams nil_output,0ch     ;kein output, blockio device
     else
     dtcbparams nil_output,1ch     ;kein output, blockio device, format erlaubt
     endif

IBM equ 0
OLI equ 1
IBM_BIG equ 2
IBMsize equ 360*2
OLIsize equ 400*2
IBM_BIGsize equ 15*80*2

if pcd
romfd equ 1
 else
 if at
romfd equ 1
 else
romfd equ romfloppy
  endif
  endif 

floppyio macro
     if romfd
       if withhd
        int 40h
       else
        int 13h                 ;disketten routine aufrufen
       endif
     else
       call diskette_io
     endif
 endm

archive_ccb macro drive,drive_type
     startccb archive_&drive,0 ;kanalnummer ist uninterressant
ccbentry arch_typ
     db IBM                   ;standardmaessig IBM annehmen
ccbentry arch_size
     dw 0
ccbentry arch_drive
     db drive
ccbentry arch_drive_type
     db drive_type
ccbentry arch_default_format
     if drive_type eq highdensity
       db 3
     else
      if drive_type eq drive720
       db 2
      else
       db 1
      endif
     endif
     endm

highdensity equ 1             ;bit 0 ist highdensity bit
with_boot_on_it equ 2 	      ;bit 1 sagt, dass boot auf der floppy ist (fuer hg)
drive720 equ 4                ;bit 2 sagt, dass 80 track double density
eighty_tracks equ 8           ;bit 3 sagt, wir formatieren gerade 80 spuren
no_floppy equ 16              ;bit 4 sagt, hier ist kein laufwerk

diskvector equ 01eh*4
diskinterrupt equ 0eh*4

archive_init:
     mov ax,0
     mov es,ax                ;auf int vektoren zeigen
     mov word ptr es:[diskvector],offset nineblockvector
     mov word ptr es:[diskvector+2],cs
   ife romfd                  ;wenn nicht at
     mov word ptr es:[diskinterrupt],offset disk_int
     mov word ptr es:[diskinterrupt+2],cs
   endif
     ret

oliinout:
  mov ax,dx               ;blocknummer nach ax
  mov dl,20               ;20 sectoren pro cylinder
  div dl                  ;ax/dl
  mov ch,al               ;track nach ch
  mov al,ah               ;rest nach al
  mov ah,0                ;obere haelfte loeschen
  mov dl,10               ;10 sects pro spur
  div dl
  mov dh,al               ;head nach dh
  mov dl,(di+arch_drive)  ;drive nach dl
  mov cl,ah               ;sector nach cl
  inc cl                  ;beginnt mit eins
  mov al,1                ;einen sector
  mov ah,bl               ;auftrag nach ah
  pop bx
  push es
  floppyio
  pop es
  jc archive_diskerr
  mov cx,0
  ret


archive_write:
 push bx
 mov bl,3               ;auftrag schreiben nach bl
 jmp short archive_rw

archive_read:
  push bx
  mov bl,2              ;lesen nach bl

archive_rw:
  push bx
  mov bx,1                    ;floppy ist device 1
  call device_free            ;warten, bis frei
  pop bx
  test byte ptr (di+arch_drive_type),with_boot_on_it ;ist der boot mit drauf
  ifnz <add dx,boot_size>
  jc archive_highblock
  cmp dx,word ptr (di+arch_size) ;blocknummer zu hoch
  jnc archive_highblock
  cmp byte ptr (di+arch_typ),OLI       ;haben wir ein olivetti archiv
  jz oliinout
  mov ax,dx
  mov dh,0              ;erste seite annehmen
  mov cx,(di+arch_size)       ;gesamtgroesse
  shr cx,1                    ;halbieren
  cmp ax,cx            ;schon zweite seite
  jc notsecond
  mov dh,1              ;zweiten kopf
  sub ax,cx 
notsecond:
  mov dl,9
  cmp byte ptr (di+arch_typ),IBM_BIG
  ifz <mov dl,15>        ;15 sectoren pro spur
  div dl                  ;9 sectoren pro spur
  mov ch,al               ;track nach ch
  mov dl,(di+arch_drive)  ;drive nach dl
  mov cl,ah               ;sector nach cl
  inc cl                  ;beginnt mit eins
  mov al,1                ;einen sector
  mov ah,bl               ;auftrag nach ah
  pop bx
  push es
  floppyio
  pop es
  jc archive_diskerr
  mov cx,0
  ret

archive_diskerr:
   push ax
   mov ah,0
   floppyio                   ;reset disk system
   pop ax
  jmp blockerr
archive_highblock:
     pop bx
     jmp highblock

set173size:
     cmp word ptr [hgver],1742
     ifz <mov word ptr (di+arch_size),IBMsize>
     ret

;************************************************************************
;* archive_size liefert die groesse einer aktuell eingelegten floppy
;*
;* und zwar wird unterschieden zwischen IBM-Format (9 Sectoren pro Spur)
;* und Olivetti (M20) Format mit 10 Sectoren pro Spur sowie IBM Format mit
;* 15 Sectoren pro Spur
archive_size:
     mov bx,1              ;floppy ist device 1
     call device_free
     mov word ptr (di+arch_size),0  ;annehmen, dass keine floppy da
; falls noch version 1.7.3, dann in diesem Fall 360K annehmen
     cmp word ptr [hgver],1742
     ifz <mov word ptr (di+arch_size),IBMsize>
    if pcd
     and byte ptr (di+arch_drive),0ffh-20h ;96 tpi ausschalten
    endif

     mov dl,(di+arch_drive) ;drive nummer holen
     mov dh,0        ;head 0
     mov cx,1        ;track 0, sector 1 
     mov ax,0401h    ;verify, ein sector
     floppyio        ;ist ueberhaupt ne floppy da
     jnc arch_det_size
     mov dl,(di+arch_drive) ;drive nummer holen
     mov dh,0        ;head 0
     mov cx,1        ;track 0, sector 1 
     mov ax,0401h    ;verify, ein sector
     floppyio        ;ist ueberhaupt ne floppy da
     jc arch_size_end ;fertig
arch_det_size:
     mov dl,(di+arch_drive) ;drive nummer holen
     mov dh,0        ;head 0
     mov cx,14       ;track 0, sector 14
     mov ax,0401h    ;verify, ein sector
     floppyio
     mov byte ptr (di+arch_typ),IBM_BIG
     mov word ptr (di+arch_size),IBM_BIGsize
     jnc arch_size_end ;wir sind fertig

     mov dl,(di+arch_drive) ;drive nummer holen
     mov dh,0        ;head 0
     mov cx,10       ;track 0, sector 10
     mov ax,0401h    ;verify, ein sector
     floppyio
     mov byte ptr (di+arch_typ),OLI
     mov word ptr (di+arch_size),OLIsize
     jnc arch_is_oli
     mov byte ptr (di+arch_typ),IBM ;konnten nicht finden, dann IBM Format 
     mov word ptr (di+arch_size),IBMsize
arch_is_oli:
     mov dl,(di+arch_drive) ;drive nummer holen
  if pcd
     or dl,20h             ;96 tpi floppy?
  endif
     test byte ptr (di+arch_drive_type),highdensity ;high density laufwerk
     jnz arch_test_720k
  ife limited_to_360
     mov dh,0        ;head 0
     mov cx,2901h      ;track 41, sector 1
     mov ax,0401h    ;verify, ein sector
     floppyio
     jc arch_size_end
     mov bx,word ptr (di+arch_size)
     add bx,bx             ;doppelte kapazitaet
     mov word ptr (di+arch_size),bx
    if pcd
     or byte ptr (di+arch_drive),20h  ;96 tpi einstellen
    endif
    endif
arch_size_end:
     mov al,0
     mov cx,word ptr (di+arch_size)
     test byte ptr (di+arch_drive_type),with_boot_on_it ;ist der boot mit drauf
     ifnz <sub cx,boot_size>
     ret

arch_test_720k:
     mov dh,0  ;head 0
     mov cx,0201h   ;spur 2, sector 1
     mov ax,0401h
     floppyio
     mov al,0       ;annehmen, muss nicht gewechselt werden
     jnc arch_skip_flip  ;erkannt, groesse setzen
     mov dl,(di+arch_drive)
     mov dh,0  ;zurueck auf spur 0
     mov cx,1       ;spur 0, sector 1
     mov ax,0401h
     floppyio
     mov al,20h     ;muss gewechselt werden
arch_skip_flip:
     mov bx,40h     ;auf datensegment gehen
     mov es,bx
     mov bx,90h
     add bl,byte ptr (di+arch_drive)
     xor byte ptr es:[bx],al            ;ggf. flag flippen
     test byte ptr es:[bx],20h		;wenn double step stimmt groesse
     jnz arch_size_end
     mov bx,word ptr (di+arch_size)
     add bx,bx             ;doppelte kapazitaet
     mov word ptr (di+arch_size),bx
     jmp arch_size_end


arch_form_unallowed:
     mov cx,3
     ret

;*********************************************************************
; formatieren einer floppy mit 9 oder 15 sects pro spur
archive_format:
     mov bx,1                 ;floppy ist device 1
     call device_free
     and byte ptr (di+arch_drive_type),0ffh-eighty_tracks
     cmp dx,0
     ifz <mov dl,byte ptr (di+arch_default_format)>
     cmp dx,1
     jz arch_form_1
     or byte ptr (di+arch_drive_type),eighty_tracks
     cmp dx,2
     jz arch_form_2
     cmp dx,3
     jnz arch_form_unallowed
;format 3
     test byte ptr (di+arch_drive_type),highdensity ;high density laufwerk 
     jz arch_form_unallowed   ;nur bei highdensity geht 3
     mov ax,1703h             ;1.2M in 1.2M laufwerk
     mov dl,(di+arch_drive)
     floppyio
     mov dx,offset fifteenblockvector
     mov bx,offset archive_format_buffer15
     jmp short arch_form_go

;format 2
arch_form_2:
     test byte ptr (di+arch_drive_type),drive720+highdensity ;kann es 720k
     jz arch_form_unallowed     ;weder highdensity noch 720k, da geht nur 1
     test byte ptr (di+arch_drive_type),highdensity
     jz arch_form_1           ;wie 1, 80 track bit steht schon
     mov ax,1702h             ;low density in high density drive
     mov dl,(di+arch_drive)
     floppyio
     mov bx,40h     ;auf datensegment gehen
     mov es,bx
     mov bx,90h                    ;zur state variablen
     add bl,byte ptr (di+arch_drive)
     and byte ptr es:[bx],0ffh-20h      ;double step flag loeschen
     jmp short arch_form_low_density

;format 1
arch_form_1:
     mov ax,1701h             ;normal drive
     mov dl,(di+arch_drive)
     floppyio
     test byte ptr (di+arch_drive_type),highdensity 
     jz arch_form_low_density ;kein highdensity laufwerk, einstellung bleibt
     mov ax,1702h             ;low density in high density drive
     mov dl,(di+arch_drive)
     floppyio
     
arch_form_low_density:
     mov dx,offset nineblockvector
     mov bx,offset archive_format_buffer
arch_form_go:
     push es
     mov ax,0
     mov es,ax                ;auf int vektoren zeigen
     mov word ptr es:[diskvector],dx
     mov word ptr es:[diskvector+2],cs
     pop es
     mov dl,(di+arch_drive)                  ;drive nummer holen
     mov ch,0                                ;bei track 0 anfangen
archive_form_track_loop:
     mov dh,0
archive_form_head_loop:
     push cs
     pop es         ;buffer liegt in cs
     mov al,15
     mov bp,bx      ;wir muessen was eintragen
arch_track_set_loop:
     mov byte ptr cs:[bp],ch       ;track
     inc bp
     mov byte ptr cs:[bp],dh       ;head
     inc bp
     inc bp
     inc bp
     dec al
     jnz arch_track_set_loop
     mov ax,0501h                  ;format
     floppyio
     jnc arch_form_cont
     mov cx,2                 ;fehler melden
     ret
arch_form_cont:
  if romfd
     push bx
     push cx
     push dx
     push di
     push si
     call warte
     call warte
     pop si
     pop di
     pop dx
     pop cx
     pop bx
   endif
     inc dh         ;naechste kopf
     cmp dh,2       ;fertig
     jnz archive_form_head_loop
     inc ch         ;naechste track
     cmp ch,40
     jc archive_form_track_loop
     test byte ptr (di+arch_drive_type),eighty_tracks ;80 spuren ?
     jz arch_form_end
     cmp ch,80
     jnz archive_form_track_loop
arch_form_end:
     mov cx,0       ;ok
     ret

archive_format_buffer:
     irp x,<1,6,2,7,3,8,4,9,5,10>
     db 0,0,x,2          ;;track und head wird per programm eingetragen
     endm
;;achtung: hier nichts einfuegen, da beim initialisieren vom ersten buffer
;;auch ein teil vom zweiten initialisiert wird
archive_format_buffer15:
     irp x,<1,9,2,10,3,11,4,12,5,13,6,14,7,15,8>
     db 0,0,x,2          ;;track und head wird per programm eingetragen
     endm

nineblockvector:
     db 11011111b                ;step rate und hut
     db 2                        ;hd load = 1
     db 37                       ;let motor run 37 seconds
     db 2                        ;512 byte per sector
     db 9                        ;last sector is 9
     db 42                       ;gap length
     db 0ffh                     ;dtl
     db 80                       ;gap length format
     db 0f6h                     ;fill byte fuer format
     db 15                       ;head settle time
     db 2                        ;motor start time

fifteenblockvector:
     db 11011111b                ;step rate und hut
     db 2                        ;hd load = 1
     db 37                       ;let motor run 37 seconds
     db 2                        ;512 byte per sector
     db 15                       ;last sector is 15
     db 01bh                     ;gap length
     db 0ffh                     ;dtl
     db 054h                     ;gap length format
     db 0f6h                     ;fill byte fuer format
     db 15                       ;head settle time
     db 8                        ;motor start time (1/8 sekunden)


 ife romfd
     include FDISK.ASM
 endif


