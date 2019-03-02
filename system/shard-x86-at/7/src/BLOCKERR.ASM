;****************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge ==================*
;*                                                                          *
;*   Dieses Modul enthaelt Routinen zur Uebergabe von Fehlermeldungen       *
;*   nach Blockin/Blockout                                                  *
;*                                                                          *
;*   blockerr erwartet dabei folgende codes in ah:                          *
sense_fail      equ     0ffh            ; sense operation
blnrhigh        equ     0feh            ; block number to high
write_fault     equ     0cch            ; 
not_rdy         equ     0aah            ; drive not ready
undef_err       equ     0bbf            ; undefined error occurred
time_out        equ     80h             ; attachment failed to respond
bad_seek        equ     40h             ; seek operation failed
bad_cntlr       equ     20h             ; controller has failed
data_corrected  equ     11h             ; ecc corrected data error
bad_ecc         equ     10h             ; bad ecc on disk read
bad_crc         equ     10h             ; crc error on sector
bad_track       equ     0bh             ; bad track flag detected
bad_sect        equ     0ah             ; sector marked bad
dma_boundary    equ     9               ; attempt to dma across 64k
bad_dma         equ     8               ; dma failed
init_fail       equ     7               ; drive parameter activity failed
bad_reset       equ     5               ; reset failed
record_not_fnd  equ     4               ; requested sector not found
write_protect   equ     3               ; disk write protected
bad_addr_mark   equ     2               ; address mark not found
bad_cmd         equ     1               ; bad command passed to disk i/o
;*                                                                          *
;****************************************************************************

blockerr:
     pop bp                      ;return adresse holen
     pop dx                      ;ds:bx vom stack putzen
     pop dx
     mov bx,offset messagetable  ;tabelle mit meldungen holen
     mov dh,0                    ;laengenangaben sind nur ein byte
err_loop:
     mov al,byte ptr [bx]        ;fehlerschluessel holen
     inc bx
     cmp al,ah                   ;war das der gesuchte
     jz err_found                ;ja
     inc al                      ;oder ende der tabelle
     jz err_found                ;ja
     inc bx                      ;auf laengenbyte
     mov dl,byte ptr [bx]        ;laenge holen
     add bx,dx                   ;adresse des naechsten textes
     inc bx                      ;und ueber laengenbyte rueber
     jmp err_loop

err_found:
     mov cl,byte ptr [bx]
     mov ch,0                    ;nur ein byte fehlercodes
     inc bx                      ;auf textlaenge gehen
     push cs                     ;adresse fehlermeldung drauf
     push bx
     jmp bp

highblock:
     mov ah,blnrhigh             ;meldung blocknummer zu hoch
     jmp blockerr

err_mess macro code,eucode,mess
local m_end
     db code,eucode,m_end-$-1,mess
m_end:
     endm

messagetable:
     err_mess blnrhigh,3,'blocknummer zu hoch'
     err_mess not_rdy,1,'not ready'
     err_mess bad_crc,2,'crc err'
     err_mess bad_sect,2,'bad sect'
     err_mess record_not_fnd,2,'rec not fnd'
     err_mess dma_boundary,1,'dma boundary'
     err_mess time_out,2,'timeout'
     err_mess 0ffh,2,'undef_err_code'




