;***************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge =================*
;*                                                                         *
;*   Pufferverwaltung fuer Stream-I/O-Kanaele                              *
;*   und allgemeine Stream-I/O-Routinen                                    *
;*                                                                         *
;***************************************************************************

;******************************************************************************
; macro zur definition der fuer 'stream' notwendigen daten im ccb
stream macro bufsiz,bufadr
ccbentry stream_stat 
;;definition der bits in stream_stat
outrestart   = 1    ;;output war fertig, muss neu gestartet werden
wasxon       = 2    ;;es wurde bereits xon empfangen
out_xon_xoff = 4    ;;ausgabeseitig findet xon/xoff handshake statt
in_xon_xoff  = 8    ;;eingabeseitig findet xon/xoff handshake statt
sendxon_xoff = 10h  ;;xon oder xoff muss gesendet werden
sendxon      = 20h  ;;xon senden (in verbindung mit sendxon_xoff verwendet)
in_xoff_send = 40h  ;;xoff wurde ausgesendet -> nur dann xon senden
     db outrestart + wasxon + in_xoff_send
ccbentry buffersize
     db bufsiz
ccbentry content
     db 0           ;;puffer ist anfangs leer
ccbentry inpointer
     db 0           ;;wir fuellen den puffer vom anfang an
ccbentry outpointer
     db 0           ;;und leeren ihn auch von da
ccbentry buffer
     dw offset bufadr      ;;pufferadresse
ccbentry andmask
     db 0ffh        ;;high bit loeschen
ccbentry xormask
     db 0           ;;keine bits kippen
ccbentry errorandmask
     db 0ffh        ;;high bit loeschen
ccbentry errorxormask
     db 0           ;;keine bits kippen
ccbentry outandmask
     db 0ffh        ;;high bit loeschen
ccbentry outxormask
     db 0           ;;keine bits kippen
ccbentry breakchar
     db '?'         ;;nach ? umsetzen
ccbentry xoffchar
     db 'S'-40h     ;;ctrl-s ist xoff
ccbentry xonchar
     db 'Q'-40h     ;;ctrl-q ist xon
ccbentry stream_icount
     dw 0
ccbentry stream_ocount
     dw 0
     endm


fillbuffer:
; di zeigt auf ccb
; das z-flag ist rueckgesetzt, wenn der output neu gestartet werden muss
     or cx,cx                      ;falls laenge null: alles uebernommen melden
     jnz fillit
     stc                           ;'alles uebernommen' setzen
     ret                           ;war null, nichts zu tun
fillit:
     push cx                       ;gewuenschte laenge merken fuer rueckmeldung
fillagain:
     mov al,shard:(di+buffersize)  ;puffergroesse holen
     sub al,shard:(di+content)     ;belegte abziehen
     jz bufferfull                 ;nichts mehr frei
     push cx                       ;noch zu uebernehmende merken
     or ch,ch                      ;nachsehen, ob laenge > 255
     ifnz <mov cl,0ffh>            ;nein, dann bis zu 255 byte uebernehmen
     cmp al,cl                     ;kleinere von freien und gewuenschten nehmen
     ifc <mov cl,al>               ;anzahl freie ist kleiner
     mov al,shard:(di+buffersize)  ;groesse holen
     sub al,shard:(di+inpointer)   ;zeiger abziehen -> abstand vom pufferende
     jnz takeminimum
     mov byte ptr shard:(di+inpointer),0 ;ist am ende, vorne anfangen
     mov al,cl                     ;von daher volle groesse
takeminimum:                       ;minimum (abstand vom ende, max moegliche) -> c
     cmp al,cl                     ;welches ist groesser
     ifc <mov cl,al>               ;a ist kleiner, nehmen wir das
     mov ch,0                      ;laenge fuer movsb
     push cx                       ;merken
     mov dx,shard:(di+buffer)
     add dl,shard:(di+inpointer)
     ifc <inc dh>                  ;zielstartadresse nach dx
;es:bx enthaelt quellenstart
;ds:dx enthaelt zieladresse
     push es
     push ds
     pop es                        ;es / ds vertauschen
     pop ds
     xchg bx,si                    ;bx als source
     xchg dx,di                    ;dx als destination
     cld
     rep movsb                     ;uebertragen
     xchg bx,si                    ;register zuruecktauschen
     xchg dx,di
     push es
     push ds
     pop es
     pop ds
     pop cx                        ;uebernommene laenge nach cx
     add shard:(di+inpointer),cl   ;neuen inpointer errechnen
     add shard:(di+content),cl     ;neuen inhalt
     pop bp                        ;gewuenschte laenge nach bp
     sub bp,cx                     ;restlaenge ausrechnen
     mov cx,bp                     ;restlaenge nach cx
     jnz fillagain                 ;ok, fertig
     pop cx                        ;alles uebernommen
     test byte ptr shard:(di+stream_stat),outrestart ;output neu starten? 
     stc                           ;carry setzen
     ret

bufferfull:                        ;nicht alles uebernommen
     pop bx                        ;gewuenschte laenge vom stack holen
     sub bx,cx                     ;uebernommene laenge errechnen
     mov cx,bx                     ;uebernommene nach bc
     test byte ptr shard:(di+stream_stat),outrestart ;output neu starten? 
     ret                           ;carry ist geloescht

frout:
;* meldet anzahl freie im puffer und carry, wenn puffer leer
     mov al,shard:(di+buffersize)  ;groesse
     mov ch,al                     ;merken
     sub al,shard:(di+content)     ;minus inhalt gibt freie
     cmp al,ch                     ;volle puffergroesse?
     cmc                           ;carry ist genau dann gesetzt, wenn bl>al
     mov ch,0 
     mov cl,al                     ;laenge melden
     ret

getnextchar:
;* diese routine muss im disable interrupt aufgerufen werden und wird so verlassen
;* z-flag -> kein zeichen mehr gefunden
;* dx,ax,f werden zerstoert
     test byte ptr (di+stream_stat),sendxon_xoff ;muessen wir xon/xoff senden
     jnz getxon_xoff
     test byte ptr shard:(di+stream_stat),wasxon ;war schon xon
     jz getret                     ;nein, z sagt: kein zeichen mehr da
     or byte ptr shard:(di+stream_stat),outrestart ;puffer leer, neustart erforderlich
     cmp byte ptr shard:(di+content),0      ;noch was im puffer
     jz getret                     ;ja
     and byte ptr shard:(di+stream_stat),not outrestart ;kein neustart erforderlich
     dec byte ptr shard:(di+content) ;einen vom inhalt abziehen
     mov dx,shard:(di+buffer)      ;buffer adresse + outpointer nach cx
     mov al,shard:(di+outpointer)
     cmp al,shard:(di+buffersize)  ;sind wir am ende angelangt
     ifz <mov al,0>                ;ja, dann auf den anfang setzen
     inc al                        ;auf naechstes zeigen
     mov shard:(di+outpointer),al  ;neuen outpointer setzen
     dec al                        ;alten outpointer wiederherstellen
     xor ah,ah                     ;ah loeschen
     add dx,ax                     ;byte im puffer errechnen
     xchg bx,dx
     mov al,shard:[bx]             ;zeichen holen
     xchg bx,dx
     and al,(di+outandmask)        ;unerwuenschte bits blenden
     xor al,(di+outxormask)        ;andere evtl. kippen
     inc word ptr (di+stream_ocount) ;zeichen zaehlen
     inc dx                        ;puffer steht nie auf 0
                                   ;nz => zeigt an, dass zeichen da
getret:
     ret

getxon_xoff:
     and byte ptr (di+stream_stat),not sendxon_xoff ;jetzt senden wirs
     test byte ptr (di+stream_stat),sendxon ;sollen wir xon senden
     jz getxoff                    ;nein, dann wars xoff
     and byte ptr (di+stream_stat),not sendxon ;muss jetzt auch weg
     or al,1                       ;nz => zeichen da
     mov al,(di+xonchar)           ;xon holen
     ret 

getxoff:
     or al,1                       ;nz => zeichen
     mov al,(di+xoffchar)          ;xoff holen
     ret

xonfound:
     test byte ptr shard:(di+stream_stat),wasxon ;warten wir auf xon
     lahf
     or byte ptr shard:(di+stream_stat),wasxon ;jetzt war auf jeden fall eins da
     sahf
     ret                                ;z => output wieder starten

xofffound:
     and byte ptr shard:(di+stream_stat),not wasxon  ;ab sofort auf xon warten
     ret                                ;nz => output nicht wieder starten

input:
     and al,shard:(di+andmask)          ;evtl. bits ausblenden
     xor al,shard:(di+xormask)          ;oder kippen
allinput:
     test byte ptr shard:(di+stream_stat),out_xon_xoff
     jz directinput
     cmp al,shard:(di+xonchar)
     jz xonfound
     cmp al,shard:(di+xoffchar)
     jz xofffound
directinput:                       ;input ohne xon/xoff
     mov ch,al                     ;zeichen nach ch
     mov al,shard:(di+channel_no)  ;kanal nach al
     inc word ptr shard:(di+stream_icount) ;zeichen zaehlen
     call inputinterrupt
     or al,1                       ;nz => kein output restart
     ret

errorinput:
     and al,shard:(di+errorandmask) ;evtl. bits ausblenden
     xor al,shard:(di+errorxormask) ;oder kippen
     jmp allinput

breakinput:
     mov al,shard:(di+breakchar)
     jmp allinput

stream_weiter:
   cli
     mov al,(di+stream_stat)       ;aktuellen status holen
     test al,in_xon_xoff           ;ueberhaupt xon_xoff handshake
     jz stream_weiter_end          ;nein, ei und zurueck
     test al,in_xoff_send          ;habe ich ein xoff gesendet
     jz stream_weiter_end          ;nichts liefern 
     or al,sendxon+sendxon_xoff    ;bitte schick ein xon
     and al,0ffh-in_xoff_send      ;das xoff ist erledigt
     mov (di+stream_stat),al       ;neuen status setzen
     test byte ptr (di+stream_stat),outrestart ;nz => output neu starten
stream_weiter_end:
   sti
     ret

stream_stop:
   cli
     mov al,(di+stream_stat)       ;aktuellen status holen
     test al,in_xon_xoff           ;ueberhaupt xon_xoff handshake
     jz stream_stop_end            ;nein, ei und zurueck
     or al,in_xoff_send+sendxon_xoff    ;bitte schick ein xoff und merk dirs
     and al,0ffh-sendxon           ;auf keinen fall mehr xon schicken
     mov (di+stream_stat),al       ;neuen status setzen
     test byte ptr (di+stream_stat),outrestart ;nz => output neu starten
stream_stop_end:
   sti
     ret

enablexon:
     or byte ptr shard:(di+stream_stat),in_xon_xoff ;ab sofort xon/xoff handshake
enableoutxon:
     or byte ptr (di+stream_stat),out_xon_xoff ;auch ausgabe seitig
     ret


disablexon:
     and byte ptr (di+stream_stat),not in_xon_xoff ;ab sofort eingabe und
disablexoff:
     and byte ptr (di+stream_stat),not out_xon_xoff ;ausgabe wieder ohne xon/xoff
     test byte ptr shard:(di+stream_stat),wasxon   ;warten wir noch auf xon
     lahf 
     or byte ptr shard:(di+stream_stat),wasxon     ;dann haben wir jetzt eins
     sahf
     ret                                           ;z => outputrestart

set_out_mask:
     mov (di+outandmask),dx
     ret

set_inp_mask:
     mov (di+andmask),dx
     ret

set_inp_errmask:
     mov (di+errorandmask),dx
     ret

stream_in_count:
   cli
     mov cx,(di+stream_icount)
     mov word ptr (di+stream_icount),0
   sti
     ret

stream_out_count:
   cli
     mov cx,(di+stream_ocount)
     mov word ptr (di+stream_ocount),0
   sti
     ret

