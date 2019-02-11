;shard  segment
;       assume cs: shard
;       assume ds: shard, es:nothing, ss:nothing

;================================================================
;       modul hdisk.asm
;       hard - disk - treiber
;
;  Status:
;       0.0     13.11.84        erste Testversion
;================================================================

TIMEOUT1        equ     20h             ; warten auf Disk-Interrupt
                                        ; (20.0000h  Tests)

;-------------------------------------------------------;
;       Fehlercodes
;       Bem: 11h ist eigentlich  k e i n  Fehler !
;-------------------------------------------------------;

;sense_fail      equ     0ffh            ; sense operation
;undef_err       equ     0bbf            ; undefined error occurred
;time_out        equ     80h             ; attachment failed to respond
;bad_seek        equ     40h             ; seek operation failed
;bad_cntlr       equ     20h             ; controller has failed
;data_corrected  equ     11h             ; ecc corrected data error
;bad_ecc         equ     10h             ; bad ecc on disk read
;bad_track       equ     0bh             ; bad track flag detected
;dma_boundary    equ     9               ; attempt to dma across 64k
;init_fail       equ     7               ; drive parameter activity failed
;bad_reset       equ     5               ; reset failed
;record_not_fnd  equ     4               ; requested sector not found
;bad_addr_mark   equ     2               ; address mark not found
;bad_cmd         equ     1               ; bad command passed to disk i/o

;-------------------------------------------------------;
;       interrrupt and status area                      ;
;-------------------------------------------------------;

dummy           segment at 0

                org 0dh *4
hdisk_int       label dword
                
                org 13h * 4
org_vector      label dword
                org 19h *4
hf_tbl_vec      label dword
dummy           ends

;-----------------------------------------------------------------------;
;       cmd_block
;
;  +0   Kommando
;  +1   Kopfnummer                              Aufrufparameter 1
;  +2   2-Bit Zylinder  & Rest Sektor           Aufrufparameter 2
;  +3   Zylinder                                Aufrufparameter 3
;  +4   Block - Count   (ist immer 1 )
;  +5   Control-Byte (Step - Option)
;-----------------------------------------------------------------------;

cmd_block       label byte
hd_error        db 7 dup(?)
disk_status     db ?

;-------------------------------------------------------;
;       hardware specific values                        ;
;                                                       ;
; - Controller i/o port                                 ;
;   > when ready from:                                  ;
;       hf_port+0 - read data (from controller to cpu   ;
;       hf_port+1 - read controller hardware status     ;
;               (controller to cpu)                     ;
;       hf_port+2 - read configuration switches         ;
;       hf_port+3 - not used                            ;
;  < when written to:                                   ;
;       hf_port+0 - write data (from cpu to controller) ;
;       hf_port+1 - controller reset                    ;
;       hf_port+2 - generate controller select pulse    ;
;       hf_port+3 - write pattern to dma and interrupt  ;
;                   mask register                       ;
;-------------------------------------------------------;

hf_port         equ     320h            ; disk port
r1_busy         equ     00001000b       ; disk port 1 busy bit
r1_bus          equ     00000100b       ;       command/data bit
r1_iomode       equ     00000010b       ;       mode bit
r1_req          equ     00000001b       ;       request bit

dma_read        equ     01000111b       ; channel 3 (47h)
dma_write       equ     01001011b       ; channel 3 (4bh)
dma             equ     0               ; dma address
dma_high        equ     82h             ; port for high 4 bits of dma

tst_rdy_cmd     equ     0               ; cntrl ready (00h)
recal_cmd       equ     00000001b       ;       recal (01h)
sense_cmd       equ     00000011b       ;       sense (03h)
fmtdrv_cmd      equ     00000100b       ;       drive (04h)
chk_trk_cmd     equ     00000101b       ;       t chk (05h)
fmttrk_cmd      equ     00000110b       ;       track (06h)
fmtbad_cmd      equ     00000111b       ;       bad   (07h)
read_cmd        equ     00001000b       ;       read  (08h)
write_cmd       equ     00001010b       ;       write (0ah)
seek_cmd        equ     00001011b       ;       seek  (0bh)
init_drv_cmd    equ     00001100b       ;       init  (0ch)
rd_ecc_cmd      equ     00001101b       ;       burst (00h)
rd_buff_cmd     equ     00001110b       ;       buffr (0eh)
wr_buff_cmd     equ     00001111b       ;       buffr (0fh)
ram_diag_cmd    equ     11100000b       ;       ram   (e0h)
chk_drv_cmd     equ     11100011b       ;       drv   (e3h)
cntrl_diag_cmd  equ     11100100b       ;       cntlr (e4h)
rd_long_cmd     equ     11100101b       ;       rlong (e5h)
wr_long_cmd     equ     11100110b       ;       wlong (e6h)

int_ctl_port    equ     20h             ; 8259 control port
eoi             equ     20h             ; end of interrupt command

        page

;===============================================================;
;       MAIN - Routine
; Input:
;       ah      -       0 write disk
;               -       1 read disk
;       (es:bx) -       Datenadresse
;       cmd_block
; Output:
;       disk_status     0 - alles OK
;===============================================================;

hard_dsk        proc
;       mov     ax,0                    ; interrupt initiieren
;       mov     es,ax
;       mov     word ptr es:[hdisk_int+2],cs
;       mov     word ptr es:[hdisk_int],offset hd_int

        sti                             ; enable interrupts
        mov     disk_status,0           ; noch alles ok !
        mov     cmd_block+5,5           ; 70 ysec steprate
        cmp     ah,0                    ; ah = 0  --> write disk
        jz      a4                      ; ah <> 0 --> read disk
        call    disk_read
        jmp     short   dsbl
a4:     call    disk_write

;-------------------------------------------------------;
;       dsbl
;       make shure that all housekeeping is done
;       before exit
;-------------------------------------------------------;

dsbl:
        mov     dx,hf_port+3
        sub     al,al
        out     dx,al                   ; reset int/dma mask
        mov     al,7
        out     dma+10,al               ; set dma - mode to disable
        cli                             ; disable interrupts
        in      al,21h
        or      al,20h
        out     21h,al                  ; disable interrupt 5
        sti                             ; enable interrupts
        ret

hard_dsk        endp

;========================================================
;       disk read routine
; Input:
;       (es:bx) -       Datenadresse
;       cmd_block
;========================================================

disk_read       proc    near
        mov     al,dma_read             ; mode byte for dma read
        mov     cmd_block+0,read_cmd
        jmp     do_io
disk_read       endp

;========================================================
;       disk write routine
; Input:
;       (es:bx) -       Datenadresse
;       cmd_block
;========================================================

disk_write      proc    near
        mov     al,dma_write            ; mode byte for dma write
        mov     cmd_block+0, write_cmd
        jmp     do_io
disk_write      endp
        page
;========================================================
;       do_io
;       gemeinsame Routine fuer alle Kommandos
; Input:
;       (es:bx) -       Datenadresse
;       al      -       mode (dma_read/dma_write)
;       cmd_block
;========================================================

do_io   proc near

        mov     cmd_block+4,1           ; Blockzahl immer 1

;-------------------------------------------------------;
;       DMA_SETUP
;       diese Routine dressiert den DMA
;-------------------------------------------------------;

        cli                             ; keine Interrupts mehr
        out     dma+12,al               ; first/last ff setzen
        push    ax                      ; warten ?
        pop     ax
        out     dma+11,al               ; mode setzen

;-----phys. Adresse zum DMA ausgeben:

        mov     ax,es
        mov     cl,4
        rol     ax,cl                   ; h - nibble von es nach al
        mov     ch,al
        and     al,0f0h
        add     ax,bx
        jnc     j33
        inc     ch                      ; Uebertrag notieren
j33:    out     dma+6,al                ; a0 - a7 ausgeben
        push    ax                      ; fuer Ueberlauftest merken
        mov     al,ah
        out     dma+6,al                ; a8 - a15 ausgeben
        mov     al,ch
        and     al,0fh
        out     dma_high,al             ; a16 - a19 ausgeben

;-----Blocklaenge zum DMA ausgeben:

        mov     ax,511                  ; Blocklaenge
        out     dma+7,al                ; Blocklaenge ausgeben
        mov     al,ah
        out     dma+7,al
        sti                             ; Interrupts scharfmachen
        pop     ax
        add     ax,511                  ; 64k Overflow testen
        jnc     gx                      ; wenn kein Overflow
        mov     disk_status, dma_boundary
        ret

gx:     call command
        jc      error_chk               ; wenn was schiefgelaufen ist

        mov     al,3                    ; controller dma/interrupt register mask
        out     dma+10,al               ; initialize the disk channel
g3:
        in      al,21h
        and     al,0dfh
        out     21h,al

;-------------------------------------------------------;
;       wait_int
;       this routine waits for the fixed disk
;       controller to signal, that an interrupt
;       has occured
;-------------------------------------------------------;

        sti                             ; muss das nochmal sein ???
        push    es
        push    si

;----- set timeout values
        sub     bh,bh
        mov     bl,TIMEOUT1             ; timout Zaehler setzen (high word)
        sub     cx,cx

;----- wait for interrupt
w1:
        push    ds
        push    bx
        push    cx
        call    cs:warte                   ; nicht dumm rumloopen, sondern
        pop     cx                      ;    arbeiten !!
        pop     bx
        pop     ds

        mov     dx,hf_port+1
        in      al,dx
        and     al,20h
        cmp     al,20h
        jz      w2
        loop    w1
        dec     bx
        jnz     w1
        mov     disk_status,time_out

w2:     mov     dx, hf_port
        in      al,dx
        and     al,2
        or      disk_status,al          ; Fehler merken
        mov     dx,hf_port+3
        xor     al,al
        out     dx,al
        pop     si
        pop     es

;-----------------------------------------------;
;       error_chk                               ;
;-----------------------------------------------;

error_chk:
        ret                             ; zunaechst keine Fehler- Auswertung
        mov     al,disk_status
        or      al,al
        jnz     g21
        ret

;-----perform sense status

g21:    mov     ax, shard
        mov     es,ax
        sub     ax,ax
        mov     di,ax
        mov     cmd_block+0, sense_cmd
        sub     al,al
        call    command
        jc      sense_abort
        mov     cx,4
g22:
        call    hd_wait_req
        jc      g24
        mov     dx,hf_port
        in      al,dx
        mov     hd_error[di],al
        inc     di
        mov     dx,hf_port+1
        loop    g22
        call    hd_wait_req
        jc      g24
        mov     dx,hf_port
        in      al,dx
        test    al,2
        jz      stat_err
sense_abort:
        mov     disk_status, sense_fail
g24:
        stc
        ret
do_io   endp

;========================================================
;       command
;       erklaert dem controller, was zu tun ist
;   input
;       cmd_block
;========================================================

command proc    near

        mov     dx,hf_port+2
        out     dx,al                   ; controller select pulse ausgeben
        mov     dx,hf_port+3
        mov     al,3            ; controller dma/interrupt register mask
        out     dx,al                   ; DMA und Interrupt-Maske setzen

; eigentlich ist es nicht normal, wenn der Controller an dieser
; Stelle beschaeftigt ist, aber wer weiss ...

        sub     cx,cx                   ; timeout - Zaehler setzen
        mov     dx,hf_port+1
wait_busy:
        in      al,dx                   ; status lesen
        and     al,0fh
        cmp     al,r1_busy or r1_bus or r1_req
        je      weiter_gehts            ; weiter, wenn controller frei
        loop    wait_busy               ; warten...
        mov     disk_status, time_out   ; is nix
        stc
        ret

weiter_gehts:
        cld                             ; clear direction flag
        mov     cx,6                    ; Blocklaenge fuer move
        mov     si, offset cmd_block

cm3:    mov     dx,hf_port              ; Command-Block ausgeben
        lodsb                           ; 
        out     dx,al
        loop    cm3

        inc     dx                      ; weiter nach hf_port+1
        in      al,dx                   ; status lesen
        test    al,r1_req
        jz      cm7                     ; wenn alles ok
        mov     disk_status, bad_cntlr  ; war nix
        stc
cm7:
        ret
command endp


;================================================================
;       hd_int
;================================================================

hd_int  proc    near
        push    ax
        mov     al,eoi                  ; end of interrupt
        out     int_ctl_port,al
        mov     al,7                    ; set dma mode to disable
        out     dma+10,al
        in      al,21h
        or      al,20h
        out     21h,al
        pop     ax
        iret
hd_int  endp


t_0     dw      type_0
t_1     dw      type_1
t_2     dw      type_2
t_3     dw      type_3


stat_err:
        mov     bl,es:hd_error          ; get error byte
        mov     al,bl
        and     al,0fh
        and     bl,00110000b
        sub     bh,bh
        mov     cl,3
        shr     bx,cl
        jmp     word ptr cs:[bx + offset t_0]

type0_table     label byte
        db      0, bad_cntlr, bad_seek, bad_cntlr, time_out, 0, bad_cntlr
        db      0, bad_seek
type0_len       equ     $-type0_table

type1_table     label   byte
        db      bad_ecc, bad_ecc, bad_addr_mark, 0, record_not_fnd
        db      bad_seek, 0, 0, data_corrected, bad_track
type1_len       equ     $-type1_table

type2_table     label byte
        db      bad_cmd, bad_addr_mark
type2_len       equ     $-type2_table

type3_table     label   byte
        db      bad_cntlr, bad_cntlr, bad_ecc
type3_len       equ     $-type3_table

type_0:
                ret
type_1:
                ret
type_2:
                ret
type_3:
                ret

;================================================================
;       hd_wait_req
;================================================================

hd_wait_req     proc near
        push    cx
        sub     cx,cx                   ; timeout - Zaehler setzen
        mov     dx,hf_port + 1
l1:
        in      al,dx
        test    al,r1_req
        jnz     l2                      ; wenn ok
        loop    l1
        mov     disk_status, time_out
        stc
l2:
        pop     cx
        ret
hd_wait_req     endp


;       end
