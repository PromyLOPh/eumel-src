;***************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge =================*
;*                                                                         *
;*   Macros zur Definition von devicetypecontrolblocks und                 *
;*   bestimmten channelcontrolblock Eintraegen                             *
;*                                                                         *
;***************************************************************************
 .xlist

actualdevice = 0

device macro type
     if1
     ifdef type
     .printx * device type doppelt definiert *
     endif
     endif
actualdevice = actualdevice+1
type = actualdevice
 
     endm

routine macro code,execut
     db code
     dw offset execut
     endm

dtcbroutines macro type
     ifidn <type>,<blockin>
      buildlabel blockin_,%actualdevice
     else
     ifidn <type>,<blockout>
      buildlabel blockout_,%actualdevice
     else
     ifidn <type>,<iocontrol>
      buildlabel iocontrol_,%actualdevice
     else
     ifidn <type>,<control32>
      buildlabel control32_,%actualdevice
     else
      .printx * unbekannter routinentyp: '&type' in dctbroutine *
     endif
     endif
     endif
     endif
     endm

dtcbparams macro output,typ
     buildlabel paramstart_,%actualdevice
     dw offset output
     dbbp blockin_,%actualdevice
     dbbp blockout_,%actualdevice
     dbbp iocontrol_,%actualdevice
     dbbp control32_,%actualdevice
dtcbentry devtype
     db typ
     endm

dtcbentry macro entry
     xequat entry,%actualdevice
     endm

dwb macro first,second
     dw offset first&second
     endm

dbbp macro first,second
     db first&second-paramstart_&second
     endm

xequat macro entry,dev
entry = $-paramstart_&dev
     endm

buildlabel macro first,second
first&second:
     endm

startccb macro name,kanal
name:
actccb = $
ccbentry channel_no
     db kanal
     endm

ccbentry macro entry
entry = $-actccb
     endm

 .list

