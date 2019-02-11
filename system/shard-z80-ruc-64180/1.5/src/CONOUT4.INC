
;
; CONOUT4.INC
;
; Character auf BASIS 108 80-Zeichen ausgeben
;
; Copyright (c) 1985 by Joerg Stattaus
;
; Modified for psi by R. Ellerbrake
;
; C=char
;
; Version 17.09.85
;	Stand: 22.12.86, mit Zeichensatzeinstellung (M.St)
;	       31.12.86, Mod. fuer 6502-Teil > 0C00
;

crtout:	
	ld	hl,gotocnt	; GotoXY in Aktion ?
	ld	a,(hl)
	or	a
	jr	z,crt2

	dec	(hl)
	ld	a,c
	jr	z,crt1		; Get X-Value

	ld	(gotoy),a	; Y storen
	ret	

crt1:	ld	(gotox),a

	ld      b,7             ; Gotoxy is Function 7
	jr      conq

crt2:
	ld      b,a
	ld	a,c

crt3:	cp	' '
	jr      nc,conq		; normales Zeichen

crt4:	ld      hl,scrfen       ; In Tabelle nach Zeichen suchen
	ld      b,22            
crt5:	cp	(hl)          
	jr      z,crtfnd	; Sequenz erkannt

	dec     hl              
	djnz    crt5

	ret			; nicht in der Tabelle enthalten

crtfnd: ld      a,b		; Found
	cp      7
	jr      nz,conq       
;
	ld      a,2
	ld      (gotocnt),a	; next 2 Bytes sind Koordinaten
	RET

SWICUR:
	LD	B,23		; Cursor invertieren
conq:
	LD	A,I		; IEF2 retten
	PUSH	AF
	DI			; keine Interrupts zulassen
;
	in0	a,(cbar)	; Set CommonBaseAreaRegister for Video
	ld	(oldcbar),a
	ld	a,biosbank
	out0	(cbar),a
;
	IN0	A,(BBR)		; Set Bank Base Register
	LD	(OLDBBR),A
	LD	A,AR6502
	OUT0	(BBR),A
;
	LD	(STKSAV),SP	; alten SP retten (im umgeschalteten Bereich)
	LD	SP,STACK
;
	CALL	CONQ1		; Print Char. on screen
;
	LD	SP,(STKSAV)	; alten Stack zurueckholen
;
	LD	A,(OLDBBR)	; restore old BBR
	OUT0	(BBR),A
	ld	a,(oldcbar)	; and CBAR
	out0	(cbar),a
	POP	AF		; IEF2 zurueckholen
	RET	PO		; vorher kein EI ->
;
	EI			;reenable Interrupts
	RET
	
; B=Sequenz / C=Char

conq1:	ld      hl,(scradr)
	ld      de,(scrxy)
	ld      a,e
	rra

	CALL	ZGERL		; Zugriff erlaubt ?
	ld	(stram1),a	; Dyn./Static RAM
	jr	nc,conq2
	ld	(stram2),a
conq2:  
	ld	a,b
	or	a
	jr	nz,scrfkt	; Screen-Function

	ld	a,(invmod)	; schreibe Zeichen auf Bildschirm
	or	c
	ld	(hl),a
adv0:   ex	de,hl
	inc	hl
	ld	a,l
	cp	80
	jp	c,onlinc

	ld      l,0
	inc     h
	ld      a,h
	cp      24
	jp      c,calc

	; scroll noetig

	ld      l,0
scroll: dec	h
	push    hl
	ld      d,0
	call    del0		; delete Zeile 0

	pop     hl
calc:   ld      (scrxy),hl
	ld      e,l
	ld      a,h
	call    basclc
	ld      a,e     	; hl=lineadr / a=scrxyr
	srl	a

	ld      (stram1),a
	jr      nc,calc3
	ld      (stram2),a
calc3:  
	add     a,l
	ld      l,a
calc4:  ld      (scradr),hl
calc5:  ld      a,(hl)  	; get char on cursor adr
	ld      (curchr),a
	ld      a,(curinv)
	xor     (hl)
	ld      (hl),a  	; invers zurueck
	ld      (stram1),a

crtret:	ret

onlinc: ld      (scrxy),a	; normales increment des scr.poi.
	ex      de,hl           ; HL wieder = scradr
	rra

	ld      (stram2),a
	jr      c,calc5         ; selbe Adresse, 2. Seite
	ld      (stram1),a
	inc     hl
	jr      calc4

scrfkt: ld	a,(curchr)	; Restore Char on Screen
	ld	(hl),a
	ld	a,b
	ld      hl,scrtab-2
	add     a,a
	add     a,l
	ld      l,a
	LD	A,H		; cross page boundary ?
	ADC	A,0
	LD	H,A
	ld      a,(hl)
	inc     hl
	ld      h,(hl)
	ld      l,a
	jp      (hl)

; Screen-Functions

advanc: ld      hl,(scradr)
	jr      adv0

schome: ld      hl,0
	jr      tocalc

gotoxy: ld      hl,(gotox)	; H=Y / L=X
got0:   ld      a,h
	cp      24
	jr      c,got1
	
	ld      h,0
got1:   ld      a,l
	cp      80
	jr      c,tocalc

got2:   ld      l,0
	jr      tocalc

up:     ex      de,hl
	dec     h
	jr      got0

carret: ex      de,hl
	jr      got2

backsp: ex      de,hl
	dec     hl
	ld      a,l
	cp      80
	jr      c,tocalc

	ld      l,79
	jr      got0

linefd: ex      de,hl
	inc     h
	ld      a,h
	cp      24
	jr      c,tocalc

	jp      scroll

erapag: push    de
	call    erap0
	pop     hl
tocalc: jp      calc

eralin: push    de
	call    eral2
	pop     hl
	jr      tocalc

insert: push    de
	ld      a,d		; korrigiert
	ld      de,SCREEN+003d0h ; Zeile 23
	cp	23
	jr      z,ins1          ; kein Verschieben

	ld      b,23
ins0:   dec     b
	call    linmov
	ld      a,(scrxy+1)	; Vertikal Adresse
	cp      b
	jr      nz,ins0

ins1:   call    blank
	pop     hl
	jr      got2

delete: push    de
	call    del0
	pop     hl
	jr      got2

normal: ld      a,80h
	jr      inv1

invers: xor     a
inv1:   ld      (invmod),a
;
inv2:   ex      de,hl
	jr      tocalc

chacur: ld      hl,curinv
	ld      a,(hl)
	xor     80h
	ld      (hl),a
	jr      inv2

clear:  call    schome
	ld      de,0
	push    de
	call    erap0
	pop     hl
	jr      tocalc

bell:   push	hl
	ld	a,(BEEPFRQ)
	ld	h,a
	ld	l,2		; task beep
	call	to6502
	pop	hl		; transport scrxy to HL
	ret

eral2:  ld      hl,(scradr)
	push    hl
	ld      (stram1),a
	ld      a,e
	srl     a
	jr      nc,eral3

	inc     a
	inc     hl
eral3:  call    erablk
	
	ld      (stram2),a
	pop     hl
	ld      a,e
	srl     a
erablk: sub     41
	cpl
	ld      b,0a0h
erabl1: or	a
	ret	z
	ld      (hl),b
	inc     hl
	dec     a
	jr      erabl1

erap0:  call    eral2
	ld      a,(scrxy+1)
erap1:  inc     a
	cp      24
	ret     nc

	push    af
	call    basclc
	
	ex      de,hl
	call    blank
	pop     af
	jr      erap1

del0:   ld      a,d
	cp      23
	ld      de,SCREEN+003d0h  ; Zeile 23
	jr      z,blank

	push    af
	call    basclc
	pop     bc              ; Vert. Adr. von D -> A -> B

	ex      de,hl
del1:   inc	b
	call    linmov
	ld      a,b
	cp      23
	jr      c,del1

blank:  ld      (stram1),a
	ld      a,' '+80h
	push    de
	call    blank1
	pop     de
	ld      (stram2),a

blank1: ld      b,40
blank2: ld      (de),a
	inc     de
	djnz    blank2

	ret

linmov: push    bc
	ld      a,b
	call    basclc
	ld      (stram1),a
	push    hl
	push    de
	ld      bc,40
	ldir                    ; eine Zeile
	pop     de
	pop     hl
	push    hl
	ld      (stram2),a
	ld      bc,40
	ldir
	pop     de              ; HL nun in DE = neues Ziel
	pop     bc
	ret

basclc: ld      c,a
	ld      l,0
	rra
	rr      l
	and     3
	add     a,HIGH SCREEN	; screen - start
	ld      h,a
	ld      a,c
	and     18h
	ld      c,a
	add     a,a
	add     a,a
	add     a,c             ; * 5 = 40
	add     a,l
	ld      l,a
	ret                     ; HL = Line adress

ger:				; German ASCII
	ld	(sw0off),a
	ld	(sw1on),a
	ld	(sw2off),a
	ret

usa:				; ASCII
	ld	(sw0off),a
	ld	(sw1off),a
	ld	(sw2on),a
	ret

apl:				; APL
	ld	(sw0off),a
	ld	(sw1on),a
	ld	(sw2on),a
	ret

uni:				; ASCII und Inv. APL
	ld	(sw0on),a
	ld	(sw1on),a
	ld	(sw2on),a
	ret

invsw:
	ld	(swinv),a
	ret

flshsw:
	ld	(swflsh),a
	ret

; Screen-Command-Definition-Table

;leadsf:db	1bh
;	db	0aah,0d9h,0d4h,0a9h,0a8h,1eh,0bdh,0bh,0ch
;	db	0ah,08h,0dh,0cch,0cdh,0dah,07h
;
;	EUMEL psi-Terminal Definition
;
	DEFB	9		;Clear Screen (bei psi undefiniert)
	DEFB	4		;Clear to End of Page
	DEFB	5		;Erase to End-of-Line
	DEFB	14		;Endmark (Normal Video)
	DEFB	15		;Beginmark (Invers Video)
	DEFB	1		;Home
	DEFB	6		;Cursor Positionierung
	DEFB	3		;Cursor 1 Zeile nach oben
	DEFB	2		;Cursor nach rechts
	DEFB	10		;Line feed
	DEFB	8		;Backspace
	DEFB	13		;Carriage Return
	DEFB	11		;Insert Line (bei psi undefiniert)
	DEFB	12		;Delete Line (bei psi undefiniert)
	DEFB	0		;NULL (nichts tun)
	DEFB	7		;BELL
	DEFB	16		;GER, Zeichensatz
	DEFB	17		;USA,     "
	DEFB	18		;APL,     "
	DEFB	19		;UNI, 	  "
	DEFB	20		;Invers > 127
	DEFB	21		;Flash > 127

scrfen	equ	$-1

scrtab: dw      clear,erapag,eralin,normal,invers,schome,gotoxy,up,advanc
	dw      linefd,backsp,carret,insert,delete,CRTRET,bell
	dw	ger,usa,apl,uni,invsw,flshsw,chacur
;
;	CRTRET anstelle von chacur

; Ende von CONOUT3.INC
