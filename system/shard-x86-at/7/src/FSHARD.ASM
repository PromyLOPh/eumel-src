  page 80,132
;******************************************************************************
;*                                                                            *
;*       S H A R D   -   M O D U L                                            *
;*                                                                            *
;*       fuer EUMEL auf 8086/8088 Systemen                                    *
;*                                                                            *
;*       SHard Version 6-PC/Floppy                                            *
;*                                                                            *
;*       Copyright (C) Martin Schoenbeck, Spenge                              *
;*                                                                            *
;******************************************************************************

com2wrongirq equ 0
add4 equ 0
ast equ 0

at equ 0 
pcxt equ 1
pcd equ 0
romfloppy equ 0
ramsys equ 0
limited_to_360 equ 0
mit_msdos equ 0
withhd equ 0
hdsystem equ 0
boot_size equ 0
gensys equ 0

shard group code
code segment word public 'code'
 assume cs:shard, ds:shard, es:nothing, ss:nothing
     org 100h
shstart:
     jmp los_gehts

     include MACROS.ASM
     include MAC286.ASM
     include DEVICE.ASM
     include EUCONECT.ASM
     include SHMAIN.ASM

IBMat equ 0fch
com1base equ 03f8h
com1irq  equ 4
com2base equ 02f8h
 if com2wrongirq
   com2irq equ 5
 else
   com2irq  equ 3
 endif
 if add4
com4_1base equ 03e8h
com4_1irq  equ 3
com4_2base equ 03e0h
com4_2irq  equ 3
com4_3base equ 02f0h
com4_3irq  equ 3
com4_4base equ 02e8h
com4_4irq  equ 3
com8_1base equ 02e0h
com8_1irq  equ 3
com8_2base equ 0260h
com8_2irq  equ 3
com8_3base equ 02d8h
com8_3irq  equ 3
 else
com4_1base equ 02c0h
com4_1irq  equ 3
com4_2base equ 02c8h
com4_2irq  equ 3
com4_3base equ 02d0h
com4_3irq  equ 3
com4_4base equ 02d8h
com4_4irq  equ 3
com8_1base equ 02e0h
com8_1irq  equ 3
com8_2base equ 02e8h
com8_2irq  equ 3
com8_3base equ 02f0h
com8_3irq  equ 3
com8_4base equ 02f8h
com8_4irq  equ 3
add4_3base equ 03e8h
add4_3irq  equ 3
add4_4base equ 03e0h
add4_4irq  equ 3
add4_8base equ 0260h
add4_8irq  equ 3
 endif
ast0_1base equ 01a0h
ast0_1irq  equ 5
ast0_2base equ 01a8h
ast0_2irq  equ 5
ast0_3base equ 01b0h
ast0_3irq  equ 5
ast0_4base equ 01b8h
ast0_4irq  equ 5
ast1_1base equ 02a0h
ast1_1irq  equ 5
ast1_2base equ 02a8h
ast1_2irq  equ 5
ast1_3base equ 02b0h
ast1_3irq  equ 5
ast1_4base equ 02b8h
ast1_4irq  equ 5


int_ctlr equ 20h
first_ictlr_int equ 8
 
channel macro number,dev,ccb
channels = channels+1
selectentry = 5
     db number
     dw offset ccb
     if2
     dwb paramstart_,%&dev
     else
     dw 0                ;;weil in pass eins device evtl. unbekannt
     endif 
     endm

selecttable:
     db channels       ;anzahl kanaele hier setzen
channels = -1         ;nilchannel vorab abziehen
     channel 32,shardchannel,0
   if at
     channel 0,archive,archive_0
   else
     channel 0,archive,archive_1
   endif
alterable_channels:
     channel 1,pc,0 
     channel 2,i8250,com1ccb
     channel 3,i8250,com2ccb
    if ast
     channel 4,i8250,ast0_1ccb
     channel 5,i8250,ast0_2ccb
     channel 6,i8250,ast0_3ccb
     channel 7,i8250,ast0_4ccb
     channel 8,i8250,ast1_1ccb
     channel 9,i8250,ast1_2ccb
     channel 10,i8250,ast1_3ccb
     channel 11,i8250,ast1_4ccb
    else
     channel 4,i8250,com4_1ccb
     channel 5,i8250,com4_2ccb
     channel 6,i8250,com4_3ccb
     channel 7,i8250,com4_4ccb
     channel 8,i8250,com8_1ccb
     channel 9,i8250,com8_2ccb
     channel 10,i8250,com8_3ccb
     ife add4  ;wenn nicht extra fuer add4, trotzdem vorsehen
     channel 11,i8250,add4_3ccb
     channel 12,i8250,add4_4ccb
     channel 13,i8250,add4_8ccb
     endif
    endif
     channel 15,parallel,para0ccb
     channel 14,parallel,para1ccb
     channel 16,parallel,para2ccb
   if at and not ramsys
     channel 31,archive,archive_1
   else
     channel 31,archive,archive_0
   endif
     channel -1,nilchannel,0
 

     include I8250.ASM
     include PCPAR.ASM
     include STREAM.ASM
     include NILCHAN.ASM
     include PCSCREEN.ASM
     include PCPLOT.ASM
     include PCSYS.ASM
;    include FIXDISK.ASM
     include FLOPPY.ASM
     include CLOCK.ASM
     include WAIT.ASM
     include HARDWARE.ASM
     include BLOCKERR.ASM
 
     i8250_ccb com1,2
     i8250_ccb com2,3
    if ast
     i8250_ccb ast0_1,4
     i8250_ccb ast0_2,5
     i8250_ccb ast0_3,6
     i8250_ccb ast0_4,7
     i8250_ccb ast1_1,8
     i8250_ccb ast1_2,9
     i8250_ccb ast1_3,10
     i8250_ccb ast1_4,11
    else
     i8250_ccb com4_1,4
     i8250_ccb com4_2,5
     i8250_ccb com4_3,6
     i8250_ccb com4_4,7
     i8250_ccb com8_1,8
     i8250_ccb com8_2,9
     i8250_ccb com8_3,10
     ife add4  ;wenn nicht extra fuer add4, trotzdem vorsehen
     i8250_ccb add4_3,11
     i8250_ccb add4_4,12
     i8250_ccb add4_8,13
     endif
    endif
     para_ccb 0,15
     para_ccb 1,14
     para_ccb 2,16
     archive_ccb 0,0
     archive_ccb 1,0
sysmove:
     rep movsw
     jmp systemstart

     include BOOT.ASM

code ends

     end los_gehts


