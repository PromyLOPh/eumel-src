
;
;****************************************************************
;
;	EUMEL Initialisierung fuer 6502 Teil
;
;	Version 0.4 vom 25. 11. 1985
;	Version	0.5 vom 24.12.86
;	Version	0.6 vom 14.01.87
;
;****************************************************************
;
	  .6502

          .radix    16

main_ROM  equ      0C082
lc_RAM    equ	   0C083
lc_lock	  equ	   0C00F

RESET	EQU	$FA62
BREAK	EQU	$FA4C
VECTBL	EQU	$FFFA

;................................................................
;
init65:
	sei
	lda	lc_RAM
	lda	lc_RAM		; LC-RAM write enable
	lda	lc_lock		; verriegeln

;
	ldx	#0		; pointer initialisieren
	stx	task
	stx	INTPAR1	
	stx	IFLG		; "Weiter" Kanal 5 Receiveinterrupt
	stx	E_FLG		; Keine Eingabeflusskontrolle
	stx	A_FLG		; Keine Ausgabeflusskontrolle
	stx	SerFlg		; Kein Ausgabestop
	stx	Wait_flg	; 64180 darf auf Pufferdescriptor zugreifen
	stx	bus_locked	; Inteerupt an 64180 erlaubt, da kein Bus-Lock
	stx	err1_bits
	stx	err5_bits	; Keine Uebertragungs-Fehler aufgetreten
	stx	KeyIn		; Tastaturpuffer leer
	stx	KeyOut
	stx	param1+1

	dex			; X := FF
	stx	param2
	stx	param2+1
	stx	last_track

		lda	#0		; Physische Addresse der Sektoren
		tax			; bestimmen (ueber Interleave)
interlv_1:	
		sta	ilv_tble,x
		inx
		clc
		adc	#3		; interleave
		and	#0F		; MOD 16
		cpx	#10
		bne	interlv_1

	ldx	#80
	stx	param1
	jsr	GCTRL		; Grafik initialisieren

	jsr	init_pbuf

	ldx	#initab_len
rloop:	lda	rbuf_ini,x
	sta	rbuf,x
	dex
	bpl	rloop

	ldx	#initab_len
tloop:	lda	tbuf_ini,x
	sta	tbuf,x
	dex
	bpl	tloop

	ldx	#6
vecloop:
	lda	vector,x
	sta	vectbl,x	; Vektoren ins RAM kopieren
	dex
	bne	vecloop

	sta	KeyStr		; Tastatur ruecksetzen
	sta	0C009		;   auf Interrupt schalten

;	serielle Schnittstelle initialisieren
;
	lda	#1E		; 9600 Bd, 8 Bits/Char., 1 Stopbit
	sta	SER_CTR
	lda	#09		; no parity, rx/tx irq's enabled
	sta	SER_COM

	ldx	SLT180
	stx	SLOT180
	cli			; Interrupt enable

	jmp	task_loop	; Jump in die Task_Loop_Routine

vector:	
	dw	resvec		; NMI
	dw	resvec		; RESET
	dw	irqvec		; IRQ & BRK

tbuf_ini:
	DW	(SBUFEND - SBUFBEG) * 100H, 0
	DW	SBUFBEG * 100H, SBUFBEG * 100H
	DB	SBUFBEG, SBUFEND

rbuf_ini:
	DW	(RBUFEND - RBUFBEG) * 100H, 0
	DW	RBUFBEG * 100H, RBUFBEG * 100H
	DB	RBUFBEG, RBUFEND
	
	ds	$100-(*-start)
