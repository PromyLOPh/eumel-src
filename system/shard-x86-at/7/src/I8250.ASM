;***************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge =================*
;*                                                                         *
;*   Routinen fuer 8250 UART im EUMEL - System                             *
;*                                                                         *
;*                                                                         *
;***************************************************************************

i8250_data equ 0
i8250_ier  equ 1                 ;interrupt enable register
i8250_iir  equ 2                 ;interrupt indicator register
i8250_lcr  equ 3                 ;line control register
i8250_mcr  equ 4                 ;modem control register
i8250_lsr  equ 5                 ;line status register
i8250_msr  equ 6                 ;modem status register

     device i8250

     dtcbroutines iocontrol
     routine 1,i8250_devicetype
     routine 2,frout
     routine 3,i8250_stop
     routine 4,i8250_weiter
     routine 5,nil_size
     routine 6,priv_op_question
     routine 8,priv_op_question
     routine 9,priv_op_question
     routine -2,frout
     routine -3,i8250_status
     routine -4,stream_in_count
     routine -5,stream_out_count
     routine -6,i8250_sendbreak
     routine -10,i8250_i_stop
     routine -11,i8250_i_weiter
     routine -1,unknowncontrol

     dtcbroutines control32
     routine 6,i8250_flow
     routine 8,i8250_baud
     routine 9,i8250_bits
     routine -2,i8250_init
     routine -3,i8250_test
     routine -1,no_channel_setup

     dtcbroutines blockin
     dtcbroutines blockout
     routine -1,unknowncontrol

     dtcbparams i8250_output,3   ;typ = nur stream io


;******************************************************************
;*   der macro i8250_ccb muss fuer jeden 8250 im system einmal
;*   aufgerufen werden
;*
;*   parameter: 

i8250_ccb macro i8250,kanal
i8250&buf db 100 DUP (0ffh)
     startccb i8250&ccb,kanal
     stream 100,i8250&buf        ;;die 8250 routinen benutzen stream routinen
ccbentry i8250_stat
     db 0
ccbentry i8250_statusandmask
     db 0                        ;;keine statusleitungen abfragen
ccbentry i8250_statusxormask
     db 0
ccbentry i8250_errmask
     db 0                        ;;keine fehler auswerten
ccbentry i8250_errflags
     db 0
ccbentry i8250_irq_line
     db i8250&irq
ccbentry i8250_base
     dw i8250&base
ccbentry i8250_next_ccb
     dw 0
ccbentry i8250_int_entry
     call i8250_interrupt
     endm

;*** bits in i8250_stat:
i8250_rtscts equ 1
i8250_exists equ 2

i8250_baud_table:
     dw 2304                     ;50 
     dw 1536                     ;75
     dw 1047                     ;110
     dw 857                      ;134.5
     dw 768                      ;150
     dw 384                      ;300
     dw 192                      ;600
     dw 96                       ;1200
     dw 64                       ;1800
     dw 48                       ;2400
     dw 32                       ;3600
     dw 24                       ;4800
     dw 16                       ;7200
     dw 12                       ;9600


i8250_devicetype:
     mov cx,0                      ;erstmal 0 setzen
     test byte ptr [di+i8250_stat],i8250_exists ;ist da einer
     ifnz <mov cl,shard:(si+devtype)>     ;type dazu
     ret




i8250_test:
     cmp bh,0                    ;abfrage
     ifnz <int 0bh>
     mov dx,(di+i8250_base)
     add dx,i8250_iir            ;auf interrupt indicator register
     in al,(dx)
     mov cl,al
     mov ch,1
     ret

i8250_init:
     mov ax,0
     mov es,ax
; pruefen, ob ueberhaupt vorhanden
     mov dx,(di+i8250_base)
     add dx,i8250_iir         ;interrupt indicate register holen
     jmp short $+2
     in al,dx
     nop                      ;der in befehl erwischt einen von diesen
     nop                      ;codes, wenn auf der adresse kein port ist
     nop
     nop
     nop
     test al,0f8h             ;alle bits weg, die nicht da sein koennen
     ifnz <ret>               ;keine schnittstelle da
     or byte ptr [di+i8250_stat],i8250_exists ;da ist einer

     mov bx,first_ictlr_int
     add bl,(di+i8250_irq_line)  ;an welchem pin des controllers haengt er
                                 ;carry kann hier nicht auftreten
     mov byte ptr i8250_initint,bl ;fuer passenden initialisierungsint basteln
     add bx,bx                   ;*2 als wortadresse
     mov dx,word ptr (i8250_i_tab-((3+first_ictlr_int)*2))[bx] ;letzten ccb holen
     mov word ptr (i8250_i_tab-((3+first_ictlr_int)*2))[bx],di ;neuen eintragen
     mov (di+i8250_next_ccb),dx  ;alten selbst merken
     add bx,bx                   ;*4
     mov word ptr es:[bx+2],cs
     mov dx,di                   ;adresse ccb holen
     add dx,i8250_int_entry      ;adresse interrupt routine errechnen
     mov word ptr es:[bx],dx     ;eintragen
     mov cl,(di+i8250_irq_line)  ;nochmal bit im controller
     inc cl                      ;mindestens einmal shiften
     stc
     mov ch,0                    ;mit nichts anfangen
     rcl ch,cl
     in al,int_ctlr+1            ;interrupt enable register holen
     or al,ch                    ;bit fuer i8250 setzen 
     xor al,ch                   ;und freigeben
     out int_ctlr+1,al
     mov dx,(di+i8250_base)
     add dx,i8250_ier            ;auf interrupt enable register
     mov al,0fh                  ;alle interrupts an
     out dx,al                   ;interrupt enable
     add dx,i8250_mcr-i8250_ier  ;auf modem control register
     mov al,0bh                  ;rts, dtr, int enable
     out dx,al
;    ret
i8250_initint = $+1
     int 12
     ret

i8250_i_tab:
     dw 0                        ;int 3
     dw 0                        ;int 4
     dw 0                        ;int 5
     dw 0                        ;int 6
     dw 0                        ;int 7

i8250_interrupt:
     push ds
     push cx
     push di
     push bx
     push dx
     push ax
     mov ax,cs
     mov ds,ax                   ;ds = cs setzen
     mov bx,sp                   ;auf stack zeigen
     mov di,ss:[bx+12]           ;return adresse im ccb holen
     sub di,i8250_int_entry+3    ;auf anfang ccb rechnen
i8250_to_first_ccb:
     push di                     ;ersten ccb merken
     mov ah,1                    ;bis jetzt keinen port gefunden
i8250_check_same_int:
     mov dx,(di+i8250_base)
     add dx,i8250_iir            ;interrupt indicate register lesen
     in al,(dx)
     test al,1                   ;war interrupt auf diesem kanal
     jnz i8250_int_end
     mov ah,0                    ;ax als index, gleichzeitig ah loeschen
     push ax
     mov bx,ax
     call word ptr i8250_int_table[bx]    ;passende service routine aufrufen
     pop ax
     jmp i8250_check_same_int

i8250_int_end:
     mov di,(di+i8250_next_ccb)  ;naechsten port fuer diesen vektor holen
     or di,di                    ;ende eintrag?
     jnz i8250_check_same_int
     pop di                      ;ersten ccb holen
     or ah,ah                    ;haben wir im letzten durchlauf einen gefunden
     jz i8250_to_first_ccb       ;ja, dann weiter suchen
     mov al,20h                  ;end of interrupt
     out int_ctlr,al
     pop ax
     pop dx
     pop bx
     pop di
     pop cx
     pop ds
     pop cs:[i8250_ret_dummy]    ;return adresse im ccb vergessen
     iret                        ;fertig

i8250_ret_dummy dw 0

i8250_int_table:
     dw offset i8250_out_restart ;bei ext. status wechsel oder bei tx empty
     dw offset i8250_out_restart ;nur output ggf. neu starten
     dw offset i8250_rec_int
     dw offset i8250_error_int


i8250_baud:
     cmp bh,15                   ;negativer wert oder > 15
     jnc i8250_not_ok
     cmp bh,0
     jz i8250_not_ok
     test bl,1                   ;abfage?
     jnz i8250_ok                ;ja, wir koennen alles
     mov dx,(di+i8250_base)
     add dx,i8250_lcr            ;line control register
     cli                         ;nichts dazwischen lassen
     in al,dx                    ;alten wert holen
     push ax
     mov al,80h
     out dx,al                   ;auf baudrate register schalten
     sub dx,i8250_lcr            ;wieder auf base
     mov bl,bh                   ;baudrate schluessel nach bx ausdehnen
     mov bh,0
     sal bx,1                    ;ein baudrate eintrag ist zwei byte
     mov ax,word ptr i8250_baud_table-2[bx] ;passenden baudrate eintrag holen
     out dx,al                   ;low byte raus
     mov al,ah
     inc dx
     out dx,al                   ;high byte raus
     pop ax
     add dx,i8250_lcr-1          ;wieder auf lcr
     out dx,al                   ;alte lcr wieder setzen
     sti                         ;jetzt darf er wieder
     jmp short i8250_ok          ;alles klar
     ret

i8250_bits:
     test bh,0a0h                ;negativer wert oder 1.5 Stopbits
     jnz i8250_not_ok
     test bh,4                   ;bitzahl >= 5
     jz i8250_not_ok             ;nein, muss aber
     test bl,1                   ;abfrage
     jnz i8250_ok
     mov al,bh                   ;anfoderung nach al
     test al,10h                 ;gerade paritaet?
     jz i8250_not_even
     or al,8                     ;dann paritaet auch enablen
i8250_not_even:
     test al,40h                 ;2 stopbits
     jnz i8250_not_two           ;nein, das bit steht schon
     and al,0ffh-4               ;bit ausknipsen
i8250_not_two:
     and al,1fh                  ;alle unbenutzten loeschen
     mov dx,(di+i8250_base)
     add dx,i8250_lcr            ;auf line control register
     out dx,al
     mov cl,bh                   ;anzahl bits nach cl
     and cl,7                    ;ausblenden
     inc cl                      ;aus 0-7 1-8 machen
     mov dx,0ffh                 ;von 0 bits ausgehen
     shl dl,cl                   ;bits anzahl nullen reinziehen
     xor dl,0ffh                 ;und 1 und 0 tauschen
     call set_out_mask
     call set_inp_mask
     call set_inp_errmask
i8250_ok:
     mov cx,0
     ret

i8250_not_ok:
     mov cx,1
     ret

i8250_flow:
     test bh,80h                 ;negativer wert?
     jnz i8250_not_ok
     cmp bh,3
     jnc i8250_not_ok            ;oder > 2
     test bl,1                   ;abfrage
     jnz i8250_ok                ;ja
   cli
     mov byte ptr (di+i8250_statusxormask),0 ;beim status nichts abfragen
     mov byte ptr (di+i8250_statusandmask),0
     and byte ptr (di+i8250_stat),0ffh-i8250_rtscts ;handshake ausschalten
     dec bh
     jnz i8250_not_xonxoff
     call enablexon
     jmp i8250_flow_end
i8250_not_xonxoff:
     call disablexon
     dec bh
     jnz i8250_flow_end
     mov byte ptr (di+i8250_statusandmask),10h ;cts abfragen
     mov byte ptr (di+i8250_statusxormask),10h ;auf gesetzt
     or byte ptr (di+i8250_stat),i8250_rtscts
i8250_flow_end:
     call i8250_out_restart      ;immer probieren, ob jetzt output moeglich
     sti
     jmp i8250_ok

i8250_output:
     call fillbuffer
     pushf
     jz i8250_no_orest
     call i8250_out_restart
i8250_no_orest:
     popf
     ret

;* out_restart kann jederzeit aufgerufen werden, da der status jedesmal
;* abgefragt wird
i8250_out_restart:
     mov dx,(di+i8250_base)      ;commandport laden
     add dx,i8250_lsr            ;adresse line status register
    cli
     in al,(dx)                  ;status holen
     test al,20h                 ;tx buffer empty
     lahf                        ;modem status register immer lesen
     inc dx                      ;auf modem status register
     in al,(dx)                  ;holen
     sahf
     jz i8250_stiret             ;nein, sti und zurueck
     and al,(di+i8250_statusandmask) ;gewuenschte bits ausblenden
     xor al,(di+i8250_statusxormask)
     jnz i8250_stiret
     call getnextchar            ;zeichen holen, xon/xoff etc. abhandeln
     mov dx,(di+i8250_base)      ;port holen
     ifnz <out (dx),al>          ;wenn was da, ausgeben
i8250_stiret:
    sti
     ret                         ;fertig

i8250_rec_int:
     mov dx,(di+i8250_base)
     in al,(dx)                  ;zeichen holen
     call input                  ;zeichen uebergeben, xon/xoff etc. abhandeln
     jz i8250_out_restart        ;ggf. output neu starten
     ret

i8250_error_int:
     mov dx,(di+i8250_base)
     add dx,i8250_lsr            ;line status register holen
     in al,(dx)
     or (di+i8250_errflags),al   ;alte errorflags dazu
     test al,10h                 ;break detected
     jnz i8250_break
     and al,(di+i8250_errmask)   ;welche fehlerbits sollen behandelt werden
     jz i8250_rec_int            ;keine, normal einlesen
     mov dx,(di+i8250_base)
     in al,(dx)                  ;zeichen holen
     call errorinput             ;uebergeben
     jz i8250_out_restart
     ret

i8250_break:
     call breakinput             ;break zeichen uebergeben
     jz i8250_out_restart
     ret

i8250_stop:
     call stream_stop
     ifnz <call i8250_out_restart> ;output ggf neu starten
     test byte ptr (di+i8250_stat),i8250_rtscts
     jz i8250_stop_end
i8250_i_stop:
     mov dx,(di+i8250_base)
     add dx,i8250_mcr            ;auf modem control register
     mov al,9                    ;rts wegnehmen
     out (dx),al
i8250_stop_end:
     ret

i8250_weiter:
     call stream_weiter
     ifnz <call i8250_out_restart> ;output ggf. neu starten
     test byte ptr (di+i8250_stat),i8250_rtscts
     jz i8250_stop_end
i8250_i_weiter:
     mov dx,(di+i8250_base)
     add dx,i8250_mcr            ;auf modem control register
     mov al,0bh                  ;rts wieder setzen
     out (dx),al
     ret

i8250_status:
     cli
     mov cl,(di+i8250_errflags)    ;fehler holen
     mov byte ptr (di+i8250_errflags),0 ;loeschen
     mov dx,(di+i8250_base)
     add dx,i8250_lsr
     in al,dx
     mov ch,al
     sti
     ret

i8250_sendbreak:
     cli
     mov dx,(di+i8250_base)
     add dx,i8250_lcr
     in al,dx
     and al,10111111b            ;switch breakbit off
     and bl,1                    ;nur ein bit behalten
     ror bl,1
     ror bl,1                    ;auf bit 6 position
     or al,bl                    ;send break or not
     out dx,al
     sti
     ret
