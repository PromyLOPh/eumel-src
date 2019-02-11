
; NIBLE.INC for RUC180-Card on BASIS 108
;
; Version 08.09.85


nible2    ds    57

slot10    db     0

iob_old_S db     60
iob_old_D db     60

head_table db    0,60,60,60,60,60

slotn     db     60,50,40

time0     db     01,30,28,24,20,1E,1D,1C
time1     db     70,2C,26,22,1F,1E,1D,1C
          

step_wait:
	lda	#00		; wird gepatcht
wait
          LDX       #11
wait0     DEX
          BNE       wait0
          INC       wait_Cnt
          BNE       wait1
          INC       wait_Cnt+1
wait1     SEC
          SBC       #01
          BNE       wait
          RTS

          ds	    96-low(*-start)		

to_bits
          db                             000,004
          db     098,099,008,00C,09C,010,014,018
          db     0A0,0A1,0A2,0A3,0A4,0A5,01C,020
          db     0A8,0A9,0AA,024,028,02C,030,034
          db     0B0,0B1,038,03C,040,044,048,04C
          db     0B8,050,054,058,05C,060,064,068

         ;LDA       #xx         2
         ;JSR       wrtnibl     6   6
wrt_nibl                    ;              len=10
          CLC               ;     2
wrt_nibl1
          PHA               ;     3   3
          PLA               ;     4   4
wrt_nibl2
          STA       Q6on,X  ;     5   5
          ORA       Q6off,X ;     4   4
          RTS               ;   + 6 + 6
                            ;  ---- ---
                            ;    32  28 uS
          
          db             0CA,06C,0CC,070,074,078
          db     0D0,0D1,0D2,07C,0D4,0D5,080,084
          db     0D8,088,08C,090,094,098,09C,0A0
          db     0E0,0E1,0E2,0E3,0E4,0A4,0A8,0AC
          db     0E8,0B0,0B4,0B8,0BC,0C0,0C4,0C8
          db     0F0,0F1,0CC,0D0,0D4,0D8,0DC,0E0
          db     0F8,0E4,0E8,0EC,0F0,0F4,0F8,0FC

          if	low(*-start) ne 0 
          .printx  'Missing bytes !'
          endif

to_bytes
          db     000,000,000
to_nibble
          db                 096,002,000,000,097
          db     001,000,000,09A,003,000,000,09B
          db     000,002,000,09D,002,002,000,09E
          db     001,002,000,09F,003,002,000,0A6
          db     000,001,000,0A7,002,001,000,0AB
          db     001,001,000,0AC,003,001,000,0AD
          db     000,003,000,0AE,002,003,000,0AF
          db     001,003,000,0B2,003,003,000,0B3
          db     000,000,002,0B4,002,000,002,0B5
          db     001,000,002,0B6,003,000,002,0B7
          db     000,002,002,0B9,002,002,002,0BA
          db     001,002,002,0BB,003,002,002,0BC
          db     000,001,002,0BD,002,001,002,0BE
          db     001,001,002,0BF,003,001,002,0CB
          db     000,003,002,0CD,002,003,002,0CE
          db     001,003,002,0CF,003,003,002,0D3
          db     000,000,001,0D6,002,000,001,0D7
          db     001,000,001,0D9,003,000,001,0DA
          db     000,002,001,0DB,002,002,001,0DC
          db     001,002,001,0DD,003,002,001,0DE
          db     000,001,001,0DF,002,001,001,0E5
          db     001,001,001,0E6,003,001,001,0E7
          db     000,003,001,0E9,002,003,001,0EA
          db     001,003,001,0EB,003,003,001,0EC
          db     000,000,003,0ED,002,000,003,0EE
          db     001,000,003,0EF,003,000,003,0F2
          db     000,002,003,0F3,002,002,003,0F4
          db     001,002,003,0F5,003,002,003,0F6
          db     000,001,003,0F7,002,001,003,0F9
          db     001,001,003,0FA,003,001,003,0FB
          db     000,003,003,0FC,002,003,003,0FD
          db     001,003,003,0FE,003,003,003,0FF

          if       low (*-start) ne 0
          .printx  'Missing bytes'
          endif

; Ende von NIBLE.INC
