;*************************************************************************
;*======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge ===============*
;*                                                                       *
;*         M A C R O s   fuer   E U M E L   -   U R L A D E R            *
;*                                                                       *
;*************************************************************************

   .XLIST
on  equ  0ffh
off  equ  0

test  equ  off

deft macro text 
local textend
 db (textend-$-1)
 db &text
textend label byte
 endm

ke  macro text
  local teend
  call info
  jmp teend
  db '&text'
teend:
  endm

trcpas  macro  name
  local trcfield,endtrc
  if trcswitch
  push hl
  ld hl,(trcfield)
  inc hl
  ld (trcfield),hl
  pop hl
  jr endtrc
  db '&name'
trcfield:
  dw 0
endtrc:
  endif
  endm


ifz macro op
local false
     jnz false
     op
false:
     endm

ifnz macro op
local false
     jz false
     op
false:
     endm

ifc macro op
local false
     jnc false
     op
false:
     endm

ifnc macro op
local false
     jc false
     op
false:
     endm

popff macro
     push cs
     call x_iret
     endm

  .LIST
