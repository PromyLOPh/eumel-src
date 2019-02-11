;-----------------------------------------------------------------------
;       Disketten I/O                                           
;       Input:
;       (ah)=0  Reset Diskette System
;               hard reset to nec, prepare command, recal rquired
;               on all drives
;       (ah)=1  read the status of the system into (al)
;               diskette_status from last operation is used
;
;       Registers for read/write/verify/format
;       (dl)    drive number (0-3 allowed, vlue checked)
;       (dh)    head number (0-1 allowed, not value checked)
;       (ch)    track number (0-39, not value checked)
;       (cl)    sektor number (1-8, not value checked,
;                       not used for format)
;       (al)    number of sektors ( max = 8, not value checked,
;                       not used for format
;       (es:bx) address of buffer (not required for verify)
;       (ah)=2  read the desired sektors into memory
;                       =3      write
;                       =4      verify
;                       =5      format
;               for the format operation, the buffer pointer (es,bx)
;               must point to the collektion of desired address fields
;               for the track. Each field is composed of 4 Bytes,
;               (c,h,r,n) where c = track number, h=head number,
;               r = sektor number, n = number of bytes per sektor
;               (00=128, 01=256, 02=512, 03=1024). There must be one
;               entry for every sektor on the track. This information
;               is used to find the requested sektor during read/write
;               access.
;
;       Data Variable -- disk_pointer
;       double word pointer to the current set of diskette parameters
;       Output
;       ah = status of Operation
;               Status bits are defined in the equates for
;               Diskette_status variable in the data segment of this
;               module.
;       cy = 0  successful operation (ah = 0 on return)
;       cy = 1  failed operation (ah has error reason)
;       for read/write/verify
;               ds,bx,dx,ch,cl  reserved
;               al = number of sektors actually read
;               ***** al may not be correkt if time out error occurs
;       note:   if an error is reported by the diskette code, the
;               appropriate action is to reset the diskette, then retry
;               the operation, on read access, no motor start delay
;               is taken, so that three retries are required on reads
;               to ensure that the problem is not due to motor
;               start-up.
;-----------------------------------------------------------------------

        data segment at 40h
        org 3eh
seek_status     db ?
int_flag        equ 80h
motor_status    db ?
motor_count     db ?
motor_wait      equ 37
diskette_status db ?
nec_status      db 7 dup(?)

        data ends

        assume ds:data

 ife withhd
dma             equ     0               ; dma address
dma_high        equ     82h             ; port for high 4 bits of dma
 endif


diskette_io     proc near
        sti
        push    bx
        push    cx
        push    ds
        push    si
        push    di
        push    bp
        push    dx
        mov     bp,sp                   ; set up pointer to head parm
        mov     si,data
        mov     ds,si
        call    j1                      ; call the rest to ensure ds restored
        mov     bx,4                    ; get the motor wait parameter
        call    get_parm 
        mov     motor_count,ah          ; set the timer count for the motor
        mov     ah,diskette_status      ; get status of operation
        cmp     ah,1                    ; set the carry flag to indicate
        cmc                             ;        success or failure
        pop     dx
        pop     bp
        pop     di
        pop     si
        pop     ds
        pop     cx
        pop     bx
        ret
diskette_io     endp

j1      proc near
        mov     dh,al
        and     motor_status,07fh
        or      ah,ah
        jz      disk_reset
        dec     ah
        jz      fdisk_status
        mov     diskette_status,0
        cmp     dl,4
        jae     j3
        dec     ah
        jz      fdisk_read
        dec     ah
        jnz     j2
        jmp     fdisk_write
j2:
        dec     ah
        jz      disk_verf
        dec     ah
        jz      disk_format
j3:
        mov     diskette_status,bad_cmd
        ret
j1      endp

;----- reset the diskette system

disk_reset      proc near
        mov     dx,03f2h
        cli
        mov     al,motor_status
        mov     cl,4
        sal     al,cl
        test    al,20h
        jnz     j5
        test    al,40h
        jnz     j4
        test    al,80h
        jz      j6
        inc     al
j4:
        inc     al
j5:
        inc     al
j6:
        or      al,8
        out     dx,al
        mov     seek_status,0
        mov     diskette_status,0
        or      al,4
        out     dx,al
        sti
        call    chk_stat_2

        mov     al,nec_status
        cmp     al,0c0h
        jz      j7
        or      diskette_status,bad_cntlr
        ret

;----- send specific command to nec

j7:
        mov     ah,3
        call    nec_output
        mov     bx,1
        call    get_parm
        mov     bx,3
        call    get_parm
j8:
        ret
disk_reset      endp


;-----diskette status routine

fdisk_status    proc near
        mov     al,diskette_status
        ret
fdisk_status    endp


;-----diskette read

fdisk_read      proc near
        mov     al,046h
j9:
        call    dma_setup
        mov     ah,0e6h
        jmp     short rw_opn
fdisk_read      endp


;----- diskette verify

disk_verf       proc near
        mov     al,042h
        jmp     j9
disk_verf       endp


;----- diskette format

disk_format     proc near
        or      motor_status,80h
        mov     al,04ah
        call    dma_setup
        mov     ah,04dh
        jmp     short rw_opn
j10:
        mov     bx,7
        call    get_parm
        mov     bx,9
        call    get_parm
        mov     bx,15
        call    get_parm
        mov     bx,17
        jmp     j16
disk_format     endp


;-----diskette write routine

fdisk_write     proc near
        or      motor_status,80h
        mov     al,04ah
        call    dma_setup
        mov     ah,0c5h
fdisk_write     endp

;-----allow write routine to fall into rw_opn

;-----------------------------------------------------------------------
; rw_opn
;       this routine performs the read/write/verify operation
;-----------------------------------------------------------------------

rw_opn  proc    near
        jnc     j11
        mov     diskette_status,dma_boundary
        mov     al,0
        ret
j11:
        push    ax

;----- turn on the motor and select the drive

        push    cx
        mov     cl,dl
        mov     al,1
        sal     al,cl
        cli

        mov     motor_count,0ffh
        test    al,motor_status
        jnz     j14
        and     motor_status,0f0h
        or      motor_status,al
        sti
        mov     al,10h
        sal     al,cl
        or      al,dl
        or      al,0ch
        push    dx
        mov     dx,03f2h
        out     dx,al
        pop     dx

;----- wait for motor if write operation

        test    motor_status,80h
        jz      j14

        clc
        mov     ax,090fdh
        int     15h
        jc      j14


        mov     bx,20
        call    get_parm
        or      ah,ah
j12:
        jz      j14
        sub     cx,cx
j13:
        loop    j13
        dec     ah
        jmp     j12
j14:
        sti
        pop     cx

;----- do the seek operation

        call    seek
        pop     ax
        mov     bh,ah
        mov     dh,0
        jc      j17
        mov     si,offset j17
        push    si

;----- send out the parameters to the controller

        call    nec_output
        mov     ah,[bp+1]
        sal     ah,1
        sal     ah,1
        and     ah,4
        or      ah,dl
        call    nec_output

;----- test for format command

        cmp     bh,04dh
        jne     j15
        jmp     j10
j15:
        mov     ah,ch
        call    nec_output
        mov     ah,[bp+1]
        call    nec_output
        mov     ah,cl
        call    nec_output
        mov     bx,7
        call    get_parm
        mov     bx,9
        call    get_parm
        mov     bx,11
        call    get_parm
        mov     bx,13
j16:
        call    get_parm
        pop     si

;----- let the operation happen

        call    wait_int
j17:
        jc      j21
        call    results
        jc      j20

;----- check the results returned by the controller

        cld
        mov     si,offset nec_status
        lods    nec_status
        and     al,0c0h
        jz      j22
        cmp     al,040h
        jnz     j18

;----- abnormal termination, find out wy

        lods    nec_status
        sal     al,1
        mov     ah,record_not_fnd
        jc      j19
        sal     al,1
        sal     al,1
        mov     ah,bad_crc
        jc      j19
        sal     al,1
        mov     ah,bad_dma
        jc      j19
        sal     al,1
        sal     al,1
        mov     ah,record_not_fnd
        jc      j19
        sal     al,1
        mov     ah,write_protect
        jc      j19
        sal     al,1
        mov     ah,bad_addr_mark
        jc      j19

;----- nec must have failed

j18:
        mov     ah,bad_cntlr
j19:
        or      diskette_status,ah
        call    num_trans               ; how many were really transferred
j20:
        ret
j21:
        call    results
        ret

;----- operation was successfull

j22:
        call    num_trans
        xor     ah,ah
        ret
rw_opn  endp

;-----------------------------------------------------------------------
;       nec_output
;       This routine sends a byte to the nec controller after testing
;       for correct direction and controller ready. This routine will
;       time out if the byte is not accepted within a reasonable
;       amount of time, setting the diskette status on completion.
; Input
;       (ah)    byte to be output
; Output
;       cy=0    success
;       cy=1    failure -- diskette status updated
;               If a failure has occured, the return is made one level
;               higher than the caller of nec_output. (!Schweinkram)
;               This removes the requirement of testing after every
;               call of nec_output
;       (al)    destroyed
;-----------------------------------------------------------------------

nec_output      proc near
        push    dx
        push    cx
        mov     dx,03f4h
        xor     cx,cx
j23:
        in      al,dx
        test    al,040h
        jz      j25
        loop    j23
j24:
        or      diskette_status,time_out
        pop     cx
        pop     dx
        pop     ax              ; discard the return address
        stc
        ret
j25:
        xor     cx,cx
j26:
        in      al,dx
        test    al,080h
        jnz     j27
        loop    j26
        jmp     j24
j27:
        mov     al,ah
        mov     dl,0f5h
        out     dx,al
        pop     cx
        pop     dx
        ret
nec_output      endp

;-----------------------------------------------------------------------
; get_parm
;       This routine fetches the indext pointer from the disk_bas
;       block pointed at by the data variable disk_pointer. A byte from
;       that table is then moved into ah, the index of that byte being
;       the parm in bx
; Input:
;       bx      index of byte to be fetched *2
;               if the low bit of bx is on, the byte is immediately output
;               to the nec controller
; Exit
;       am      that byte from block
;-----------------------------------------------------------------------

disk_pointer    equ 1eh * 4

get_parm        proc near
        push    ds
        push    si
        sub     ax,ax
        mov     ds,ax

        lds     si,dword ptr ds:disk_pointer
        shr     bx,1

        mov     ah,[si+bx]
        pop     si
        pop     ds
        jc      nec_output
        ret
get_parm        endp

;-----------------------------------------------------------------------
; seek
;       Thi routine will move the head on the named drive to the
;       named track. If the drive has not been accessed since the
;       drive reset command was issued, the drive will be recalibrated.
; Input:
;       (dl) = Drive to seek on
;       (ch) = track t seek to
; Output:
;       cy = 0 success
;       cy = 1 failure -- diskette_status set accordingly
;       (ax) destroyed
;-----------------------------------------------------------------------

seek    proc near
        mov     al,1
        push    cx
        mov     cl,dl
        rol     al,cl
        pop     cx
        test    al,seek_status
        jnz     j28
        or      seek_status,al
        mov     ah,07h
        call    nec_output
        mov     ah,dl
        call    nec_output
        call    chk_stat_2
        jc      j32

;----- drive is in synch with controller, seek to track

j28:
        mov     ah,0fh
        call    nec_output
        mov     ah,dl
        call    nec_output
        mov     ah,ch
        call    nec_output
        call    chk_stat_2

;----- wait for head settle

        pushf
        mov     bx,18
        call    get_parm
        push    cx
j29:
        mov     cx,550
        or      ah,ah
        jz      j31
j30:
        loop    j30
        dec     ah
        jmp     j29
j31:
        pop     cx
        popf
j32:
        ret
seek    endp

;-----------------------------------------------------------------------
; dma_setup
;       this routine sets up the dma for read/write/verify operations
; input:
;       (al) = mode byte for the dma
;       (es:bx) - address to read/write the data
; output:
;       (ax) destroyed
;-----------------------------------------------------------------------

dma_setup       proc near
        push    cx
        cli
        out     dma+12,al
        push    ax
        pop     ax
        out     dma+11,al
        mov     ax,es
        mov     cl,4
        rol     ax,cl
        mov     ch,al
        and     al,0f0h
        add     ax,bx
        jnc     jj33
        inc     ch
jj33:
        push    ax
        out     dma+4,al
        mov     al,ah
        out     dma+4,al
        mov     al,ch
        and     al,0fh
        out     081h,al

;----- determine count

        mov     ah,dh
        sub     al,al
        shr     ax,1
        push    ax
        mov     bx,6
        call    get_parm
        mov     cl,ah
        pop     ax
        shl     ax,cl
        dec     ax
        push    ax
        out     dma+5,al
        mov     al,ah
        out     dma+5,al
        sti
        pop     cx
        pop     ax
        add     ax,cx
        pop     cx
        mov     al,2
        out     dma+10,al
        ret
dma_setup       endp

;-----------------------------------------------------------------------
; chk_stat_2
;       This routine handles the interrupt received after a
;       recalibrate, seek, or reset to the adapter.
;       The interrupt is waited for, the interrupt sensed,
;       and the result returned to the caller.
; input:
;       none
; output:
;       cy = 0  success
;       cy = 1  failure -- error is in diskette_status
;       (ax)            destroyed
;-----------------------------------------------------------------------

chk_stat_2      proc near
        call    wait_int
        jc      j34
        mov     ah,08h
        call    nec_output
        call    results
        jc      j34
        mov     al,nec_status
        and     al,060h
        cmp     al,060h
        jz      j35
        clc
j34:
        ret
j35:
        or      diskette_status,bad_seek
        stc
        ret
chk_stat_2      endp

;-----------------------------------------------------------------------
; wait_int
;       This routine waits for an interrupt to occur. A time out
;       routine takes place during the wait, so that an error may be
;       returned if the drive is not ready.
; input:
;       none
; output:
;       cy = 0 success
;       cy = 1 failure -- diskette_status is set accordingly
;       (ax) destroyed
;-----------------------------------------------------------------------

wait_int        proc near
        sti
        push    ax
        push    bx
        push    cx
        clc
        mov     ax,09001h
        int     15h
        sti
        jc      j36a
;
        mov     bl,2
        xor     cx,cx
j36:
        test    seek_status,int_flag
        jnz     j37
;       push cx
;       push bx
;       push ds
;       push es
;       push ax
;       push dx
;       push si
;       push di
;       push bp
;       call cs:warte
;       pop bp
;       pop di
;       pop si
;       pop dx
;       pop ax
;       pop es
;       pop ds
;       pop bx
;       pop cx
        loop    j36
        dec     bl
        jnz     j36

j36a:   or      diskette_status, time_out
        stc
j37:
        pushf
        and     seek_status, not int_flag
        popf
        pop     cx
        pop     bx
        pop     ax
        ret
wait_int        endp

;-----------------------------------------------------------------------
; disk_int
;       This routine handles the diskette interrupt
; Input
;       none
; output:
;       The interrupt flag is set is seek_status
;-----------------------------------------------------------------------

;**************
;org    0ef57h
;**************
disk_int        proc far
        sti
        push    ds
        push    ax
        push si
        mov     si,data
        mov     ds,si
        or      seek_status, int_flag
        mov     al,20h
        out     20h,al
        mov     ax,09101h
        int     15h
        pop si
        pop     ax
        pop     ds
        iret
disk_int        endp

;-----------------------------------------------------------------------
; results
;       This routine will read anything that the nec controller has
;       to say following an interrupt.
; input:
;       none
; output:
;       cy = 0  successful transfer
;       cy = 1  failure -- time out in waiting for status
;       nec_status area has status byte loaded into it
;       (ah) destroyed
;-----------------------------------------------------------------------

results proc near
        cld
        mov     di,offset nec_status
        push    cx
        push    dx
        push    bx
        mov     bl,7

;-----wait for request for master

j38:
        xor     cx,cx
        mov     dx,03f4h
j39:
        in      al,dx
        test    al,80h
        jnz     j40a
        loop    j39
        or      diskette_status, time_out
j40:
        stc
        pop     bx
        pop     dx
        pop     cx
        ret

;----- test the direction bit

j40a:
        in      al,dx
        test    al,40h
        jnz     j42
j41:
        or      diskette_status,bad_cntlr
        jmp     j40

;-----read in the status

j42:
        inc     dx
        in      al,dx
        mov     [di],al
        inc     di
        mov     cx,10
j43:    loop    j43
        dec     dx
        in      al,dx
        test    al,10h
        jz      j44
        dec     bl
        jnz     j38
        jmp     j41

;----- result operation is done

j44:
        pop     bx
        pop     dx
        pop     cx
        ret

;-----------------------------------------------------------------------
; num_trans
;       This routine calculates the number of sectors that were
;       actually transferred to/from the diskette
; input
;       (ch) = cylinder of operation
;       (cl) = start sector of operation
; output
;       (al) = number actually transferred
;       no other registers modified
;-----------------------------------------------------------------------

num_trans       proc near
        mov     al,nec_status+3
        cmp     al,ch
        mov     al,nec_status+5
        jz      j45
        mov     bx,8
        call    get_parm
        mov     al,ah
        inc     al
j45:
        sub     al,cl
        ret
num_trans       endp
results         endp

        assume ds:shard

