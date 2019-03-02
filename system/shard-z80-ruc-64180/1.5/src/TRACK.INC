
; TRACK.INC for RUC180 CP/M 3.0
;
; Version 13.09.85
; Stand: 13.01.87, Retries fuer EUMEL entschaerft (ca. 1/8 der alten Zeit)

	  .printx 'TRACK.INC'

track_RW
          ldy       #1			; 13.01.87, Michael
          sty       recal_cnt
          ldy       #02			; 13.01.87
          sty       tktry_cnt
          ldx       iob_old_S
          cpx       slot10z
          beq       sameSLt
track0
          JSR       moving
          BNE       track0
          LDX       slot10z
          STX       iob_old_S
sameSlt
          JSR       moving
          PHP
          LDA       mtron,X
          ldy       iob_drv
          cpy       iob_old_D
          BEQ       sameDrv
          sty       iob_old_D
          PLP
          lda       #0
          PHP
sameDrv
          CMP       drive0,Y
          LDA       #0EF
          STA       wait_cnt
          LDA       #0D8
          STA       wait_cnt+1
          PLP
          PHP
          BNE       track2
          LDY       #8
track1    JSR       wait
          DEY
          BNE       track1

          LDX       slot10z
track2    JSR       seekT		; Step to Track

          PLP
          BNE       rotating
;         bit       param		; wg. bescheuerten Philips-Drives
;         bmi       no_wait           	; branch if read

track3    LDY       #12
track4    DEY
          BNE       track4
          INC       wait_cnt
          BNE       track3
          INC       wait_cnt+1
          BNE       track3
;no_wait
          JSR       moving
          BEQ       drive_err
rotating
          LDA       #0FF
          STA       iob_sec
search_hdr
          LDY       #10			; 13.01.87
          STY       hdtry_cnt
nxt_sec
          cli
          dec       hdtry_cnt
          BMI       no_sec

          LDX       slot10z
          JSR       read_hdr
          BCS       nxt_sec
          LDA       trk_in_hdr
          CMP       iob_trk
          BEQ       found_trk
          cli
	  jsr	    trk_to_ph		; Translate Track to Phase
          LDY       disk_no
          STA       head_table,Y	; Store it in Table
          DEC       tktry_cnt
          BNE       try_seek
no_sec
          DEC       recal_cnt
          BEQ       drive_err
          LDA       #02			; 13.01.87
          STA       tktry_cnt
	  lda	    #56
	  bit	    def_byte
	  bmi	    no_sec2		; Ehring-Controller ?

	  asl	    a			; Ehring: *2
no_sec2:  LDY       disk_no
          STA       head_table,Y
          LDA       #0
          JSR       seekL		; Step von hinten bis 0
try_seek
          JSR       seekT
          JMP       search_hdr
drive_err
          LDA       #1
          JMP       track_fail

found_trk
          bit       param
          bmi       found2
          LDA       sec_in_hdr
          CMP       iob_sec
          BEQ       write_it
          CLC                     ; next sector for write!
          ADC       #01
          AND       #0F
          CMP       iob_sec
          BEQ       nxt_sec
          STA       sec_in_hdr
found2
          LDY       sec_in_hdr   ; if sec_in_hdr>=10 then crash...
          LDA       sec_tble,Y
          bne       nxt_sec
;need_sec
          TYA               	  ; physical sector #
          ASL       A       	  ;
          TAY
          lda       DMA,y
          sta       user_data
          lda       DMA+1,y
          STA       user_data+1    ; pointer to user's buffer
          bit       param
          bmi       read_it
          JSR       make_nibl 
          LDX       slot10z
          LDA       sec_in_hdr
          STA       iob_sec
j_nxt_sec
          JMP       nxt_sec
read_it
          JSR       read_data
          BCS       j_nxt_sec
mark_sec
          LDY       sec_in_hdr
          LDA       #0FF
          STA       sec_tble,Y
          STA       iob_sec
          DEC       sec_cnt
          BNE       j_nxt_sec
;track_ok
          lda       #0
track_fail
          sta       iob_err
          lda       mtroff,X
          cli
          rts
write_it
          JSR       write_data
          BCC       mark_sec
          LDA       #2              ; write protected !
          BCS       track_fail      ; bra

	  .printx   'Ende'

; Ende von NIBLE.INC
