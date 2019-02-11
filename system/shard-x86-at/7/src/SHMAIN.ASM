;****************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge ==================*
;*                                                                          *
;*   Routinen zur Verteilung der Auftraege auf verschiedene Kanaele         *
;*   und Kanal 32                                                           *
;*                                                                          *
;****************************************************************************

;******************************************************************************
; routinen, die das restsystem vom SHard erwartet
;******************************************************************************
; routinen im restsystem, die SHard benutzen kann
;systemstart    = cs:1e10h
;inputinterrupt = cs:1e13h
;timerinterrupt = cs:1e16h
;warte          = cs:1e19h
;freieumel0     = cs:1e1ch
;info           = cs:1e1fh
;
;******************************************************************************
;******************************************************************************
; kanalspezifische funktionen
i_output proc far
     push bp
     push si
     push di
     push bx
     push dx
     push ax
     push es
     push ds                  ;bis hierhin nach funktion restaurieren
     mov si,ds                ;wir brauchen den alten wert von ds in es
     mov es,si
     mov si,cs                ;wir brauchen ds = cs
     mov ds,si
     push bx             ;fuer versorgung der funktion sichern
     call select
     pop bx
     call shard:[si]     ;routine anspringen
     pop ds                   ;register wieder herstellen
     pop es
     pop ax
     pop dx
     pop bx
     pop di
     pop si
     pop bp
     ret
i_output endp

i_blockin label far
     push bp
     mov bp,2            ;kennung blockin
     jmp short dispatch

i_blockout label far
     push bp
     mov bp,3            ;kennung blockout
     jmp short dispatch

i_iocontrol label far
     push bp
     mov bp,4            ;kennung iocontrol
     jmp short dispatch

control32:               ;spezialaufrufe indirekt ueber kanal 32 gekommen
     push cs
     call i_control32
     ret

i_control32:
     push bp
     mov bp,5            ;kennung control32
     jmp short dispatch

;******************************************************************************
; dispatch routine um aufrufe auf die kanalspezifischen treiber zu verteilen
;
; in: al = kanal
;     bp auf dem stack
;     bp = 2 bei blockin
;          3 bei blockout
;          4 bei iocontrol
;          5 bei control ueber kanal 32
;     aufruf mit jmp dispatch
;
; funktion: aufruf der entsprechenden funktion des kanaltreibers mit
;      si = devicetypecontrolblock
;      di = channelcontrolblock
;      auf dem stack: bp, si, di, dx, es, ds, bx, returnadresse
;
;      die routinen muessen deshalb keine register sichern.
;      soll in ds:bx etwas zurueckgeliefert werden, so ist dies ueber den
;      stack zu tun.
;
; out: die gewuenschte funktion wurde ausgefuehrt
;      bp, si, di, dx, bx unveraendert, ausnahme: bx in bestimmten faellen wo dies
;      ausdruecklich verlangt wird. flags, cx (ggf. bx) wie von der funktion geliefert.
dispatch proc far
     push si                  ;register sichern um sie nach ende der Funktion
     push di
     push dx                  ;zu restaurieren
     push es
     push ds
     push bx
     mov si,ds                ;wir brauchen den alten wert von ds in es
     mov es,si
     mov si,cs                ;wir brauchen ds = cs
     mov ds,si
     call dispexecute         ;fuehre dispatch aus
     pop bx                   ;register wieder herstellen
     pop ds
     pop es
     pop dx
     pop di
     pop si
     pop bp
     ret                      ;fertig, funktion ausgefuehrt
dispatch endp

dispexecute:
     push bx                  ;sichern, um versorgung der funktion durchfuehren
     push dx                  ;zu koennen
     call select         ;adressen fuer diesen kanal laden 
     add bp,si           ;adresse fuer offset der funktionstabelle in dtcb ausrechnen
     mov bl,shard:[bp]        ;offset nach bl
     mov bh,0ffh              ;maximal 255 byte grosse tabelle
;bx enthaelt jetzt negativen offset
     add bx,si           ;start der tabelle fuer funktionswerte ausrechnen
;
; als funktionswert wird derzeit nur der bereich von -128 bis +127 akzeptiert.
; -1 dient dabei als tabellenendekennzeichnung und wird fuer alle undefinierten 
; funktionswerte aufgerufen
; 
; die tabelle besteht aus jeweils einem byte funktionsschluessel
; im bereich -128 - +127 und zwei byte funktionsadresse. 
     mov dl,cl                ;niederwertigen teil nach dl
     mov al,ch                ;hoeheren bits von cx muessen 0 oder 0ffh sein
     or al,al                 ;ist es 0
     jz dispfunctloop         ;ja, ok
     inc al                   ;oder -1
     ifnz <mov dl,0ffh>       ;nein, dann -1 als funktionswert
dispfunctloop:
     mov al,shard:[bx]        ;aktuellen tabelleneintrag suchen
     inc bx                   ;und auf dazugehoerige adresse
     cmp al,dl                ;gefunden
     jz dispfuncfound         ;ja
     inc al                   ;oder -1
     jz dispfuncfound
     inc bx              ;adresse ueberspringen
     inc bx
     jmp dispfunctloop
dispfuncfound:
     mov bp,bx           ;adresse der routine nach bp
     pop dx              ;dx wieder herstellen
     pop bx              ;bx wiederherstellen
     jmp shard:[bp]      ;jmp funktion

;***************************************************************************
; select routine, um die tabellen eines bestimmten kanals zu adressieren
;
; in:  al  = kanalnummer
;
; out: si = dtcb adresse
;      di = ccb adresse
;      bx, dx zerstoert
select:
     push cx
     mov dx,offset selectentry ;laenge eines eintrags in selecttabelle
     mov bx,offset selecttable
     mov cl,shard:[bx]        ;anzahl kanaele laden
     mov ch,0
     inc bx                   ;auf eigentliche tabelle
selectloop:
     cmp al,shard:[bx]        ;kanal gefunden
     jz selectfound
     add bx,dx                ;auf naechsten kanal
     loop selectloop
; hier haben wir einen unbekannten kanal
; bx zeigt jetzt auf den 'nilkanal'
selectfound:
; hier wurde der passende kanal gefunden
     mov di,shard:[bx]+1      ;adresse channelcontrolblock
     mov si,shard:[bx]+3      ;adresse devicetypecontrolblock
     pop cx
     ret

;********************************************************************************
;* definition des typs 'shardkanal' fuer operation ueber kanal 32
     device shardchannel

     dtcbroutines iocontrol
          routine 1,devicetype
          routine 2,frout_ok
          routine 5,nil_size
          routine 6,priv_operation
          routine 8,priv_operation
          routine 9,priv_operation
          routine -3,priv_operation
          routine -4,priv_operation
          routine -5,reboot_request
          routine -1,unknowncontrol
     dtcbroutines control32
          routine -2,timer_init
          routine -1,no_channel_setup
     dtcbroutines blockin
          routine -4,clockread
     dtcbroutines blockout
          routine -4,clockwrite
          routine -1,no_blockinout
     dtcbparams nil_output,0            ;output,no in_out

priv_operation:
     mov al,bl                ;kanalnummer nach al
     mov bl,0                 ;vermerken: privilegiert
     jmp control32

priv_op_question:
     mov al,bl                ;kanalnummer nach al
     mov bl,1                 ;vermerken: abfrage
     jmp control32

reboot_request:
     mov byte ptr reboot_byte,1
     ret

reboot_byte db 0

longmove:
     rep movsw
     ret

i_sysend proc far
     cmp byte ptr cs:reboot_byte,1
     ifz <jmp reboot>
     mov al,0
     mov cx,-102
     call control32           ;laufwerk parken, wenn implementiert
     ret
i_sysend endp
