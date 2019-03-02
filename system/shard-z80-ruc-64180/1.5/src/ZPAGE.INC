	;		05..09  		GRAFIK
basl		EQU	0A	;		DISK (HCOPY im IRQ)
bash 		EQU	0B	;		DISK (HCOPY im IRQ)

sektor		EQU	0C	;		DISK65
last_track	EQU	0D	;		DISK65
bus_locked	EQU	0E	;		DISK65	; Interrupt Flag
analogwert	EQU	0F	;		DISK65

rbuf		EQU	10	; 10 Bytes Receive-Buffer Descriptor

keyin		EQU	1A	;		DISK
keyout		EQU	1B	;		DISK

err1_bits	EQU	1C	;		DISK
err5_bits	EQU	1D	;		DISk

quotient	EQU	1E	;		GRAFIK
divmask		EQU	1F	;		GRAFIK

temporary	EQU	1E	; +1F		GRAFIK

;	Paket Variable (duerfen Global NICHT veraendert werden!)

thick		EQU	05	;		GRAFIK
colormask	EQU	06	;		GRAFIK 
bitmode		EQU	07	;		GRAFIK
savepattern	EQU	08	; +09		GRAFIK
pattern		EQU	24	; +25		GRAFIK
pagebase	EQU	2A	;		GRAFIK
xpos		EQU	2B	; +2C		GRAFIK
ypos		EQU	2D	; +2E		GRAFIK

;	Workspace

xpointer	EQU	26	;		GRAFIK
ypointer	EQU	27	;		GRAFIK

olderror	EQU	28	; +29		GRAFIK

right		EQU	3D	;		GRAFIK
up		EQU	3E	;		GRAFIK

uprighterror	EQU	3F	; +40		GRAFIK
;
ASave		equ	45	;		DISK
XSave		equ	46	;		DISK
YSave		equ	47	;		DISK

;
				; Basis-Schnittstellen:
KeyBuf		equ	0200	; Page 2 fuer KeyBuf
wrkpage		EQU	080	; 8k Workpage fuer Fill-Routine
dma_4k		EQU	0E0	;		DISK65
DBUFBEG		EQU	0D0	;Printer Spooler Grenzen (4k)
DBUFEND		EQU	0E0	;		DISK (LC00)
stack		EQU	0D000	;		GRAFIK (LC01)
SBUFBEG		EQU	0F0	;Seriell Ausgabe-Spooler Grenzen (1k)
SBUFEND		EQU	0F4	;		DISK
RBUFBEG		EQU	0F4	; Serieller Empfangspuffer (2.25k)
RBUFEND		EQU	0FD	;		DISK

				; Dummy-Block-Buffer fuer SCSI: FD00..FEFF
				; 64180-Card-Schnittstellen:
				; DBUF (Centronics): A000..AFFF
				; SCCA : B000..B7FF
				; SCCB : B800..BFFF


; 64180 interface

DMA       	equ	50	; 50..6F	DISK, DISK65	
address		equ	50	; +51		GRAFIK
dx		equ	52	; +53		GRAFIK
dy		equ	54	; +55		GRAFIK
righterror	equ	54	; +55		GRAFIK (wie dy!)
tempmode	equ	56	;		GRAFIK

sec_tble  	equ	70	; 70..7F	DISK, DISK65
areg		equ	70	; +71		GRAFIK
breg		equ	72	; +72		GRAFIK
creg		equ	74	; +75		GRAFIK
xa		equ	76	; +77		GRAFIK
xb		equ	78	; +79		GRAFIK
ya		equ	7A	; +7B		GRAFIK
yb		equ	7C	; +7D		GRAFIK
link		equ	7E	; +7F		GRAFIK

task	  	equ	80	; 80		DISK, DISK65
subtask		EQU	81	;		GRAFIK
result		EQU	81	;		GRAFIK
param	  	equ	81	;		DISK, DISK65
param1		EQU	82	; +83		GRAFIK
def_byte  	equ	82	;		DISK, DISK65
disk_no   	equ	83	;		DISK, DISK65
param2		EQU	84	; +85		GRAFIK
iob_trk   	equ	84	;		DISK, DISK65
sec_cnt   	equ	85	;		DISK, DISK65
iob_err   	equ	86	;		DISK, DISK65

; work space

wait_Cnt   	equ	87	;		DISK
user_data 	equ	89	;		DISK
dest_phase 	equ	8B	;		DISK
chk_in_hdr 	equ	8C	;		DISK
sec_in_hdr 	equ	8D	;		DISK
trk_in_hdr 	equ	8E	;		DISK
vol_in_hdr 	equ	8F	;		DISK
slot10z   	equ	90      ; slot #: s0	DISK
iob_drv   	equ	91	;		DISK
phase     	equ	92	;		DISK
iob_sec   	equ	93	;		DISK
chk_sum   	equ	94	;		DISK
temp2     	equ	95	;		DISK
head_pos  	equ	96	;		DISK
tktry_cnt 	equ	97	;		DISK
hdtry_cnt 	equ	98	;		DISK
recal_cnt 	equ	99	;		DISK
A_FLG	  	EQU	9A	; Flags fuer Ausgabeflusskontrolle
E_FLG		EQU	9B	; Flags fuer Eingabeflusskontrolle
SerFLG	  	EQU	9C	; Break/Ausgabestopflags
Wait_Flg	EQU	9D	; 64180 muss auf Update warten
IFLG		EQU	9E	; Bit 7 = 1: Keine Inputinterrupt Kanal 5
SLOT180	  	EQU	9F	; Bootslot (Kopie)
;
ilv_tble	EQU	$A0	; A0..AF	DISK, DISK65
	
;	Offset auf Buffer-Descriptor

free		equ	0	; Freiplatz in Bytes
full		equ	2	; Anzahl Zeichen im Puffer
in		equ	4	; Schreibzeiger
out		equ	6	; Lesezeiger
beg		equ	8	; Highbyte Pufferanfang
end		equ	9	; Highbyte Pufferende

pbuf		equ	0E0	; 10 Bytes Spooler Descriptor
;
; Interruptparameter zum 64180
;
INTPAR1		EQU	0EA	; Interrupt Kanalnr. und Sync.
INTPAR2		EQU	0EB	;		DISK
INTPAR3		EQU	0EC	; Fehlerbits	DISK

tbuf		EQU	0F0	; 10 Bytes Transmit-Buffer Descrptor

SLT180	  	EQU	04F8	; Bootslot	DISK

start180 	equ	0C087	;		DISK
wait180		equ	0C086	;		DISK
STOP180		equ	0C084	;		DISK
INT180		EQU	0C083	;		DISK	

