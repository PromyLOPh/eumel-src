;======= Copyright (C) 1985,86 Martin Schoenbeck, Spenge =============
;---------------------------------------------------------------------
   even

eumel0id                       db 'EUMEL           '
eumel0blocks                   dw 100
hgver                          dw 1742
cputype                        dw 3            ; 8086
urver                          dw 100
                               dw 0
shdvermin                      dw 7
shdvermax                      dw 7
                               dw 0
systemstart                    dd dummy_ret
inputinterrupt                 dd iint
timerinterrupt                 dd dummy_ret
warte                          dd dummy_ret
grab                           dd dummy_ret
free                           dd dummy_ret
shutup                         dd dummy_ret
info                           dd dummy_ret
eumel_cs_init_length equ ($-systemstart)/4
eumel_leisten_laenge equ $-eumel0id

;---------------------------------------------------------------------
;
;                  SHard-Leiste
;
;---------------------------------------------------------------------

SHard_leiste:
SHDID                          db 'SHard Schoenbeck'
SHDVER                         dw 7
 if withhd or at
MODE                           dw 0
 else
MODE                           dw 1 ;freieumel0
 endif
ID4                            dw 4711
ID5                            dw 4712
ID6                            dw 0
ID7                            dw 0
                               dw 0
                               dw 0
output label dword
                               dw offset i_output
first_shard_cs_to_alter:
                               dw 0
blockin label dword
                               dw offset i_blockin
                               dw 0
blockout label dword
                               dw offset i_blockout
                               dw 0
iocontrol label dword
                               dw offset i_iocontrol
                               dw 0
sysend label dword
                               dw offset i_sysend
                               dw 0
                               dd 0
                               dd 0
                               dd 0
shard_cs_alter_length equ ($-first_shard_cs_to_alter)/4
M0START                        dw 0
M0SIZE                         dw 0
M1START                        dw 0
M1SIZE                         dw 0
M2START                        dw 0
M2SIZE                         dw 0
M3START                        dw 0
M3SIZE                         dw 0

shdveclen equ offset shdid-offset m3size+2

dummy_ret proc far
  sti
  ret
dummy_ret endp 
