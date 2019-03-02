;*****************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge ===================*
;*                                                                           *
;*        Laden des EUMEL - Restsystems vom Archiv oder HG                   *
;*                                                                           *
;*****************************************************************************

; Versionsschluessel:
;2.2 enthaelt mehrere Partition, Floppy size = 0 bei start und fehler
;2.3 enhaelt Floppy mit Block 0 lesen immer erlaubt
;2.4 Drucker geht ueber rom, wenn adresse nicht ibmlike
;    mehrere Drucker moeglich
;    busy Abfrage kann verzoegert werden (Problem LQ1000)
;    es werden nur die vorhandenen Schnittstellen angezeigt
;    Lesezugriffe bis Block 6 auf Floppy werden immer erlaubt
;2.5 Hercules Karte wird unterstuetzt
;    Bei AT werden schlechte sectoren statt spuren behandelt
;2.6 Fehler in Plattengröße bei behoben (meldete immer al <> 0)
;2.7 Floppylogik fuer 1.7.3 restauriert, Floppy steht jetzt immer
;    auf 360k, wenn keine Floppy erkannt wird, und der Urlader die
;    HG-Version 1742 hat.
;    die Schnittstellen der Addonics-Karte sind jetzt immer mit drin,
;    wenn COM4 generiert sind.
;    Die Druckerkanäle liegen auf 15,14,16
;    Die Baudrateabfrage verneint auch 0

los_gehts:
     cli
; achtung: es und si muessen bis zum einstellen der Festplatte
; unveraendert bleiben !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     mov ax,cs
     mov ds,ax
; cs in vorlaeufige EUMEL Tabelle eintragen
     mov bx,offset systemstart+2
     mov cx,eumel_cs_init_length
self_cs_init_loop:
     mov word ptr [bx],ax
     add bx,4
     loop self_cs_init_loop
; cs in SHard - Tabelle eintragen
     mov bx,offset first_shard_cs_to_alter
     mov cx,shard_cs_alter_length
shard_cs_init_loop:
     mov word ptr [bx],cs     ;put in my code segment
     add bx,4
     loop shard_cs_init_loop 
; berechnen, wohin der EUMEL spaeter soll
     mov bx,offset lastbootbyte  ;relativen paragraph ausrechnen
     mov cl,4
     shr bx,cl
     inc bx
     add ax,bx                ;hier soll spaeter der EUMEL hin
     mov ss,ax
     mov sp,0
     push si                  ;werte fuer plattensetup merken
     push es
; warte routine fuer Platten und Floppytreiber eintragen
     call device_init           ;int 15 eintragen
; alle Kanaele initialisieren
     mov dh,33
     mov al,0
inilop:
     mov cx,-2
     push ax
     call control32
     pop ax
     cli
     inc al
     dec dh
     jnz inilop
     sti                      ;interrupts sind erlaubt
     mov bx,offset signon     ;sag ihm, wer wir sind
     call print
; alle kanaele fuer festplatte einstellen (falls vorhanden)
     pop es
     pop si                   ;zeiger auf partitiontabelle wiederholen
     call setup_fix_disk
; EUMEL 0 laden
getagain:
   ife gensys
     mov al,31      ;zuerst von kanal 31 versuchen
     mov bx,offset archtext
     call geteumel
   endif
     mov al,0
     mov bx,offset hgtext
     call geteumel
     mov bx,offset noeutext
     call print
     call waitchar
     jmp getagain

geteumel:	;EUMEL 0 laden und bei Erfolg starten
     push ax
     mov cx,5       ;size
     call cs:iocontrol
     pop ax
     push bx        ;text fuer medium merken
     mov cx,ss      ;ausrechnen, wohin der urlader muss (ss:0)
     add cx,31                ;damit wir nicht rueckwaerts gehen
     and cx,0ffe0h  ;auf 512 byte boundary
     mov ds,cx      ;segment nach ds
     mov bx,0       ;bei 0 im segment laden wir zuerst
     mov cx,0       ;auftrag
     mov dx,10      ;erster urlader block ist 10
     mov ah,1       ;nur ein versuch 
     cmp al,0
     ifz <mov ah,3> ;hintergrund muss lesbar sein
     push bx 
     push ds
     call getblock
     pop ds
     pop bx
     or cx,cx       ;fehlerfrei?
     jz firstok
     pop bx         ;text fuer medium vergessen
     ret
firstok:
     push ax
     mov cx,5       ;text EUMEL hat 5 buchstaben
     mov si,offset eutext     ;text EUMEL
     mov di,bx                ;puffer
textloop: 
     lods byte ptr cs:[si]
     cmp al,byte ptr ds:[di]
     jz charok
     pop ax         ;stack saeubern
     pop bx
     ret            ;nicht gleich, kein eumel urlader
charok:
     inc di
     loop textloop
     pop ax         ;kanal fuer urlader wiederholen
     pop bx         ;text fuer medium holen
     call print     ;ausgeben
     mov bx,0       ;bx ist zerstoert, aber wir wissen, wohin
     mov ah,8       ;ab hier mit acht versuchen
euloop:
     mov cx,0
     inc dx
     add bx,512     ;auf naechsten block schalten
     push bx
     push ds
     call getblock
     or cx,cx
     jnz booterr
     pop ds
     pop bx
     cmp dx,10+100  ;schon kompletten urlader gelesen
     jnz euloop
; Sprungleiste vom EUMEL abholen
     push cs
     pop es                   ;ziel ist codesegment
     mov si,0
     mov di,offset eumel0id
     mov cx,eumel_leisten_laenge 
     cli
     cld
     rep movsb
     mov ax,ds                ;eumel codesegment nach ax
     push cs                  ;datensegment wieder auf shard
     pop ds
; und passendes cs eintragen
     mov bx,offset systemstart+2
     mov cx,eumel_cs_init_length
eumel_cs_init_loop:
     mov word ptr [bx],ax
     add bx,4
     loop eumel_cs_init_loop 
     call paragraphs
     sub dx,ax                ;rest fuer eumel ausrechnen
    if ramsys
     urram equ 1000h

     sub dx,urram             ;64k fuer urlader und paging
     mov M3SIZE,dx
     mov M0SIZE,urram
     mov M0START,ax
     add ax,urram
     mov M3START,ax
    else
     mov M0SIZE,dx
     mov M0START,ax           ;eumel codesegment eintragen
    endif
     mov ax,31           ;allen floppies die chance geben
i173lop:                 ;sich auf 173 einzustellen
     mov cx,-173
     push ax
     call control32
     pop ax
     dec al
     jnz i173lop
     mov bx,offset SHard_leiste
     jmp systemstart
 

booterr:
     push ds
     push bx
     mov bx,offset booterrtext
     call print
     pop bx
     pop ds
     call dsprint
     jmp $
 
getblock:
     push ax        ;original ax merken
getloop:
     push bx
     push ds 
     push ax        ;ax mit retry zaehler
     mov cx,0
     call cs:blockin
     pop ax
     or cx,cx
     jnz geterr
     pop ds
     pop bx
     pop ax
     ret
geterr:
     dec ah         ;genuegend retries
     jnz getcontinue
     pop ax         ;kill ds
     pop ax         ;kill bx
     pop ax         ;altes ax holen
     ret
getcontinue:
     pop ds
     pop bx
     jmp getloop

waitchar:
     sti
     mov byte ptr cs:waschar,0
waitcloop:
     cmp byte ptr cs:waschar,0
     jz waitcloop
     ret

iint proc far
     cmp al,1                 ;nur kanal 1 ist interessant
     ifnz <ret>
     mov byte ptr cs:waschar,1
     ret
iint endp

waschar db 0

print:
     push ds
     push cs
     pop ds
     call dsprint
     pop ds
     ret

dsprint:
     push cx
     push ax
     mov cl,byte ptr [bx]     ;laenge holen
     inc bx                   ;auf text schalten
     mov ch,0
     mov al,1                 ;auf terminal 1
     call cs:output
     pop ax
     pop cx
     ret

setup_fix_disk:
  if hdsystem
     mov di,si                ;si retten
     mov dl,4
eumel_partition_search_loop:
     test byte ptr es:[si],80h  ;aktivierte Partition
     jnz eu_found
     add si,10h
     dec dl
     jnz eumel_partition_search_loop
; keine EUMEL Partition, Sauerei
no_eu_part:
     mov bx,offset no_eumel_partition_text
     call print
     sti
     jmp $

eu_found:
     cmp byte ptr es:[si+4],'E' ;EUMEL partition
     jc no_eu_part
     mov dx,es:[si+8]    ;low word partition start holen
     mov bx,es:[si+10]   ;high word partition start holen
     add dx,68           ;50k fuer shard etc. frei lassen
     adc bl,0
     mov cx,-101         ;partition start einstellen
     mov al,0            ;fuer HG
     call control32
     mov cx,-100         ;dasselbe als groesse fuer Setup Kanal
     mov al,setup_channel
     call control32
     mov dx,es:[si+12]   ;low word partition size holen
     mov bx,es:[si+14]   ;high word partition size holen
     
    if at
     sub dx,68           ;platz fuer SHard
     sbb bl,0
     sub dx,[bb_anz]     ;platz fuer schlechte sectoren lassen
     sbb bl,0
    else
     sub dx,68+(2*68)    ;das, was wir fuers SHard lassen, abziehen
                         ;und das, was fuer schlechte spuren bleiben muss
     sbb bl,0
    endif

     mov cx,-100         ;size einstellen
     mov al,0            ;fuer hg
     call control32
; DOS partition suchen
     mov si,di           ;si wieder holen
     mov dl,4
dos_partition_search_loop:
     cmp byte ptr es:[si+4],1 ;DOS partition
     jz dos_found
     add si,10h
     dec dl
     jnz dos_partition_search_loop
     xor dx,dx
     mov bx,dx           ;DOS Partition existiert nicht
     jmp short dos_size
dos_found:
     mov dx,es:[si+8]    ;low word partition start holen
     mov bx,es:[si+10]   ;high word partition start holen
     mov cx,-101         ;partition start einstellen
     mov al,dos_channel  ;fuer DOS
     call control32
     mov dx,es:[si+12]   ;low word partition size holen
     mov bx,es:[si+14]   ;high word partition size holen
dos_size:
     mov cx,-100         ;size einstellen
     mov al,dos_channel  ;fuer DOS
     call control32
  endif
     ret

 if 0
     mov ax,0
     mov cx,5
     call cs:iocontrol           ;get size of harddisk
  if mit_msdos
     mov bx,17068
  else
     mov bx,100               ;50k freilassen
  endif
     sub cx,bx                ;von size abziehen
     cmp cx,0fd00h shr 1      ;bei mehr legt sich eumel auf den bauch
     ifnc <mov cx,0fcfeh shr 1> ;dann nur soviel, wie er kann
     mov dx,cx                ;in dx melden
     mov cx,-100              ;set size
     call control32
     ret
 endif

eutext:
     db 'EUMEL'

signon:
     db booterrtext-$-1
  if pcd
     db 1bh,5bh,'H',1bh,5bh,'2J'
     db 13,10,10 
     db 'Demo - SHard f',129,'r EUMEL auf Siemens PC-D, V 2.1'
     db 13,10
     db 'Copyright (C) 1985,86 Martin Sch',148,'nbeck, Spenge'
     db 13,10
   else
     if gensys
        db 13,10,10
        db 'Setup - SHard f',129,'r EUMEL'
        db ' auf IBM PC,AT,XT und Kompatiblen V 2.7'
        db 13,10
        db 'Copyright (C) 1985,86 Martin Sch',148,'nbeck, Spenge'
        db 13,10
     else
       if at
          db 13,10,10
          db 'SHard f',129,'r EUMEL auf IBM PC/AT, V 2.7'
          db 13,10
          db 'Copyright (C) 1985,86 Martin Sch',148,'nbeck, Spenge'
          db 13,10
       else
          db 13,10,10
          db 'ModSoft - SHard f',129,'r EUMEL'
          db ' auf IBM-PC und Kompatiblen, Version 2.7'
          db 13,10
          db 'Copyright (C) 1985,86 ModSoft, Martin Sch',148,'nbeck'
          db 13,10
       endif
     endif
  endif

booterrtext:
     db archtext-$-1
     db 'Fehler beim Laden des Systems: '
     db 7
archtext:
     db hgtext-$-1
     db 'EUMEL wird vom Archiv geladen'
     db 13,10
hgtext:
     db noeutext-$-1
     db 'EUMEL wird vom Hintergrund geladen'
     db 13,10
noeutext:
     db no_eumel_partition_text-$-1
     db 'Kein EUMEL - System gefunden'
     db 13,10
     db 'Bitte einlegen und Taste dr',129,'cken! '
no_eumel_partition_text:
     db endtext-$-1
     db 'Keine EUMEL Partition auf der Platte'
     db 13,10
     db 'Bitte benutzen Sie Ihre Setup-Floppy zum Anlegen'
endtext:

lastbootbyte:
