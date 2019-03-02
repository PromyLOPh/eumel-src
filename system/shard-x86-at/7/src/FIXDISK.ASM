;************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge ==============*
;*                                                                      *
;*   Harddisk routinen                                                  *
;*                                                                      *
;************************************************************************

     device fixdisk

     dtcbroutines iocontrol
          routine 5,fixed_size
          routine -10,fixed_tracks
          routine -11,fixed_sects
          routine -12,fixed_heads
          routine 1,devicetype
          routine -1,unknowncontrol
     dtcbroutines control32
          routine -2,fixed_init
          routine -100,fixed_size_set
          routine -101,fixed_start_set
          routine -102,fixed_landing_zone
          routine -1,no_channel_setup
     dtcbroutines blockin
          routine -1,fixed_read
     dtcbroutines blockout
          routine -1,fixed_write
     dtcbparams nil_output,0ch     ;kein output, blockio device


heads equ 4
sects equ 17

 if pcxt
  if at
   bitte nicht at und pcxt gleichzeitig
  endif
 endif

 if pcd
romhd equ 1
 else
 if at
romhd equ 1
 else
romhd equ romharddisk
  endif
  endif

fix_ccb macro kanal
startccb hgccb&kanal,kanal
ccbentry fix_size
    dw 0
    db 0
ccbentry fix_firstblock
    dw 0
    db 0
ccbentry fix_sects
    db 0
ccbentry fix_cylsize
    dw 0
    endm

fixed_size_set:
     mov [di+fix_size],dx
     mov [di+fix_size+2],bl
     ret
 
fixed_start_set:
     mov [di+fix_firstblock],dx
     mov [di+fix_firstblock+2],bl
     ret

fixed_init:
     mov ax,0801h                      ;return drive type
     mov dl,80h                        ;drive 0
     int 13h
     mov al,cl                         ;anzahl sects holen
     and al,3fh                        ;nur sector anzahl
     mov [di+fix_sects],al             ;eintragen
     inc dh                            ;anzahl koepfe (statt hoechste nummer)
     mul dh                            ;sects pro cylinder
     mov [di+fix_cylsize],ax           ;eintragen
     mov dl,cl                         ;cylinder anzahl nach dx packen
     shl dx,1
     shl dx,1
     and dh,3                          ;nur unterste zwei bits behalten
     mov dl,ch                         ;rest cylindernummer holen
     inc dx                            ;anzahl draus machen
     mul dx                            ;anzahl bloecke ausrechnen
     mov [di+fix_size],ax
     mov [di+fix_size+2],dl
     ret

fixed_tracks:
     call fix_drive
     rol cl,1                          ;trackzahl in cx melden
     rol cl,1
     and cl,3                          ;nur zwei bits sind noch track
     xchg cl,ch
     inc cx                            ;meldet hoechste nummer, anzahl draus
     ret

fixed_sects:
     call fix_drive
     and cl,03fh                       ;nur sectorenzahl behalten
     mov ch,0                          ;high byte 0
     ret

fixed_heads:
     call fix_drive
     mov cl,dh
     mov ch,0
     inc cx                            ;hoechsten head -> anzahl umrechnen
     ret

fix_drive:
     mov ax,0801h                      ;return drive type
     mov dl,80h                        ;drive 0
     int 13h
     ret

fixed_landing_zone:
     mov bx,0
     call device_free              ;auf freigabe warten
     call hardware                 ;pruefen, ob at
     cmp al,IBMat
     jz fixed_at_landing
     call fix_drive
     mov ax,0c01h                  ;seek
     mov dl,80h                    ;immer auf erstem drive
     inc ch                        ;auf naechste spur
     ifz <add cl,40h>              ;hoeherwertigen bits auch zaehlen
     int 13h
     ret

fixed_at_landing:
     sub ax,ax
     mov ds,ax
     les bx,dword ptr ds:[(41h*4)]
     mov ax,es:[bx+12]             ;landing zone
     mov ch,al                     ;unterste byte der cylinder number
     and ax,0300h                  ;obersten zwei bits
     shr ax,1
     shr ax,1
     or al,1                       ;immer sector 1
     mov cl,al
     mov dx,80h                    ;drive und head 0
     mov ax,0c01h                  ;seek
     int 13h
     ret                           ;device nicht wieder freigeben
                                   ;aendern, wenn zwei laufwerke

fix_highblock:
     pop bx
     jmp highblock

fixed_write:
    push bx
 if romhd
    mov bl,3
 else
    mov bl,0               ;auftrag schreiben nach bl
 endif
    jmp short fixed_rw
fixed_read:
     push bx
  if romhd
     mov bl,2              ;lesen nach bl
  else
     mov bl,1
  endif
fixed_rw:
     cmp ch,0                 ;wirklich read oder write
     ifnz <jmp unknowncontrol>
     cmp cl,[di+fix_size+2]
     ifz <cmp dx,[di+fix_size]> ;blocknummer zu hoch?
     jnc fix_highblock
     push bx
     mov bx,0
     call device_free

     pop bx
     mov ax,dx               ;blocknummer nach ax
     add ax,[di+fix_firstblock] ;offset fuer ersten block dazu
     adc cl,[di+fix_firstblock+2]
     mov dx,cx                ;high byte muss nach dx

     if at                    ;translate bad blocks if at
; jetzt erstmal schlechte sectoren suchen
     push es
     push ds
     pop es
     push di
     mov di,offset bb_table
     cld
     mov cx,[bb_anz]          ;anzahl schlechte sectoren
fix_search_bb:
     jcxz fix_no_translate
     repnz scasw              ;sieh mal nach
     jnz fix_no_translate
     cmp dl,byte ptr [di+max_bb*2-2] ;obere byte ebenfalls pruefen
     jnz fix_search_bb
; schlechten sector gefunden
     pop di
     mov ax,[di+fix_firstblock]        ;direkt hinter letzten block
     mov dl,[di+fix_firstblock+2]
     add ax,[di+fix_size]
     adc dl,[di+fix_size+2]
     add ax,cx
     adc dl,0
     push di
fix_no_translate:
     pop di
     pop es
     endif

     div word ptr (di+fix_cylsize)    ;dxax / sectoren pro zylinder
                             ;der rest passt immer in 32 bit
     mov ch,al               ;low byte tracknummer nach ch
     ror ah,1
     ror ah,1
     mov cl,ah               ;high bits der cylindernummer nach cl 
     mov ax,dx               ;rest nach ax
     div byte ptr (di+fix_sects)

     if at
     mov dh,al                ;kopf nach dh
     else
; jetzt erstmal schlechte spuren suchen
     or cl,al                 ;kopf zur spur dazu
     push ax                  ;retten
     mov ax,cx                ;zum suchen da rueber
     push di
     push es
     push ds
     pop es
     mov di,offset bt_table
     mov cx,8                 ;8 moegliche schlechte spuren
     cld
     repnz scasw              ;sieh mal nach
     ifz <mov ax,word ptr [di+14]> ersatzwert holen
     pop es
     pop di
     mov cx,ax                ;zurueckgeben
     and cl,0c0h              ;nur cylinderbits behalten
     and al,03fh              ;nur kopf bits
     mov dh,al               ;head nach dh
     pop ax
     endif

     mov dl,080h   ;drive nach dl
     or cl,ah                ;sector nach cl reinbasteln
     mov al,1                ;einen sector
     mov ah,bl               ;auftrag nach ah
     pop bx
 if romhd
     inc cl
     push es
     int 13h
     pop es
     jc diskerr
 else
     push bx
     mov bx,0
     call device_lock
     pop bx
     mov byte ptr [cmd_block+1],dh ;kopfnummer
     mov byte ptr [cmd_block+2],cl ;cylinder + sect
     mov byte ptr [cmd_block+3],ch ;cylinder
     push es
     call hard_dsk
     pop es
     xor bx,bx     ;device 0 freigeben
     call device_unlock
     mov ah,byte ptr [disk_status]  ;haben wir fehler
     or ah,ah
     jnz diskerr
 endif
     mov byte ptr fix_err,0       ;ein aufruf war ohne fehler
     mov cx,0
     ret

diskerr:
  inc byte ptr fix_err
  cmp byte ptr fix_err,4 ;schon viermal hintereinander fehler
  jnz fix_blockerr
  mov byte ptr fix_err,0
  push ax
  mov ah,13               ;nur harddisk zuruecksetzen
  mov dl,80h    ;disk reset
  int 13h
  pop ax
fix_blockerr:
  jmp blockerr

fixed_size:
        mov al,[di+fix_size+2]
        mov cx,[di+fix_size]
        ret

fix_err db 0


   ife romhd
     include HDISK.ASM
   endif
