  page 80,132
title AT-SHard, Copyright (C) 1985, 86 Martin Schoenbeck, Spenge  
;******************************************************************************
;*                                                                            *
;*       S H A R D   -   M O D U L                                            *
;*                                                                            *
;*       fuer EUMEL auf 80286 Systemen                                        *
;*                                                                            *
;*       SHard Version 7-PC/AT                                                *
;*                                                                            *
;*       Copyright (C) 1985, 86 Martin Schoenbeck, Spenge                     *
;*                                                                            *
;******************************************************************************

at equ 1
gensys equ 0
ramsys equ 0
pcxt equ 0
pcd equ 0
kompatible equ 0
romharddisk equ 0
romfloppy equ 0
limited_to_360 equ 0
boot_size equ 0

hdsystem equ 1
withhd equ 1

setup_channel equ 28
dos_channel equ 29

shard group code
code segment word public 'code'
 assume cs:shard, ds:shard, es:nothing, ss:nothing

shstart:
     jmp los_gehts

     even

     include MACROS.ASM
     include MAC286.ASM
     include DEVICE.ASM
     include EUCONECT.ASM
     org 0a0h			;bei wort 80 beginnen
     include PATCHARE.ASM

     include SHMAIN.ASM

IBMat equ 0fch
com1base equ 03f8h
com1irq  equ 4
com2base equ 02f8h
com2irq  equ 3
com3base equ 03e8h
com3irq  equ 3
com4base equ 82f8h
com4irq  equ 7
com4_1base equ 02c0h
com4_1irq  equ 3
com4_2base equ 02c8h
com4_2irq  equ 3Šcom4_3base equ 02d0h
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
para1base equ 3bch
para1irq equ 7

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
     channel 0,fixdisk,hgccb0
alterable_channels:
     channel 1,pc,0 
     channel 2,i8250,com1ccb
     channel 3,i8250,com2ccb
     channel 4,i8250,com4_1ccb
     channel 5,i8250,com4_2ccb
     channel 6,i8250,com4_3ccb
     channel 7,i8250,com4_4ccb
     channel 8,i8250,com8_1ccb
     channel 9,i8250,com8_2ccb
     channel 10,i8250,com8_3ccb
     channel 12,parallel,para1ccb
     channel 28,fixdisk,hgccb1
     channel 29,fixdisk,hgccb2
     channel 31,archive,archive_0
     channel 30,archive,archive_1
     channel -1,nilchannel,0
 Š     include I8250.ASM
     include PCPAR.ASM
     include STREAM.ASM
     include NILCHAN.ASM
     include PCSCREEN.ASM
     include PCPLOT.ASM
     include PCSYS.ASM
     include FIXDISK.ASM
     include FLOPPY.ASM
     include CLOCK.ASM
     include WAIT.ASM
     include HARDWARE.ASM
     include BLOCKERR.ASM
 
     i8250_ccb com1,2
     i8250_ccb com2,3
     i8250_ccb com4_1,4
     i8250_ccb com4_2,5
     i8250_ccb com4_3,6
     i8250_ccb com4_4,7
     i8250_ccb com8_1,8
     i8250_ccb com8_2,9
     i8250_ccb com8_3,10
     para_ccb para1,12
 ;erlaubt drivetypen: highdensity, drive720
     archive_ccb 0,highdensity
     archive_ccb 1,0
     fix_ccb 0
     fix_ccb 1
     fix_ccb 2

sysmove:
     rep movsw
     jmp systemstart

     include BOOT.ASM

code ends

     end los_gehts



