ADDR B1 B2 B3 B4 ASCII INSTR PARAMETER  COMMENT
0100 C3 F9 01    ...   JP    01F9       ; Init Shard + Start EUMEL0
0103 C3 8C 0B    ...   JP    0B8C       ; LIMIT
0106 C3 2A 01    .*.   JP    012A       ; OUTPUT
0109 C3 4B 01    .K.   JP    014B       ; BLOCKIN
010C C3 53 01    .S.   JP    0153       ; BLOCKOUT
010F C3 5B 01    .[.   JP    015B       ; IOCONTROL
0112 C3 AC 0B    ...   JP    0BAC       ; SYSEND
0115 C3 90 0B    ...   JP    0B90       ; SCHINF
0118 C3 94 0B    ...   JP    0B94       ; SCHACC
011B C3 89 0B    ...   JP    0B89       ; LONGMOVE
011E 06                                 ; SHDVER = 6 
011F 00 00                              ; ID 4
0121 00 00                              ; ID 5
0123 00 00                              ; ID 6
0125 00 00                              ; ID 7
0127 C3 63 01    .c.   JP    0163       ; I/O-Setzen fuer 'putboot' 
012A DD E5       ..    PUSH  IX         ; OUTPUT (Kanal A, Length BC, 
012C FD E5       ..    PUSH  IY         ;         Addr HL, Ausgegeben BC, 
012E E5          .     PUSH  HL         ;         Carry SET : Alles raus)
012F D5          .     PUSH  DE
0130 F5          .     PUSH  AF 
0131 E5          .     PUSH  HL 
0132 CD A6 01    ...   CALL  01A6       ; Zugriff auf Kanaltabelle --> IY/DE
0135 D5          .     PUSH  DE         ; DE --> IX (Addr. von Startaddr.) 
0136 DD E1       ..    POP   IX 
0138 EB          .     EX    DE,HL 
0139 5E          ^     LD    E,(HL)     ; (Startaddresse) --> DE 
013A 23          #     INC   HL 
013B 56          V     LD    D,(HL) 
013C E1          .     POP   HL         ; Textstartaddresse 
013D CD 49 01    .I.   CALL  0149       ; = JP (DE) Routine starten 
0140 D1          .     POP   DE         ; ehem. Returnaddresse loeschen
0141 7A          z     LD    A,D 
0142 D1          .     POP   DE 
0143 E1          .     POP   HL 
0144 FD E1       ..    POP   IY 
0146 DD E1       ..    POP   IX 
0148 C9          .     RET 
0149 D5          .     PUSH  DE 
014A C9          .     RET              ;----------------------------------- 
014B DD E5       ..    PUSH  IX         ; BLOCKIN 
014D DD 21 02 00 .!..  LD    IX,0002    ; Aufgabe 2
0151 18 18       ..    JR    016B       ;----------------------------------
0153 DD E5       ..    PUSH  IX         ; BLOCKOUT
0155 DD 21 03 00 .!..  LD    IX,0003    ; Aufgabe 3
0159 18 10       ..    JR    016B       ;---------------------------------- 
015B DD E5       ..    PUSH  IX         ; IOCONTROL
015D DD 21 04 00 .!..  LD    IX,0004    ; Aufgabe 4
0161 18 08       ..    JR    016B       ;---------putboot Aufg. 5---------- 
0163 DD E5       ..    PUSH  IX         ; 
0165 DD 21 05 00 .!..  LD    IX,0005    ; Aufgabe 5
0169 18 00       ..    JR    016B       ;--------------------------------- 
016B FD E5       ..    PUSH  IY         ; Je nach IX Kanal-Aufgabe (I/O)
016D D5          .     PUSH  DE 
016E E5          .     PUSH  HL 
016F CD 79 01    .y.   CALL  0179       ; Register wurden gerettet
0172 E1          .     POP   HL 
0173 D1          .     POP   DE 
0174 FD E1       ..    POP   IY 
0176 DD E1       ..    POP   IX 
0178 C9          .     RET              ;----------------------------------- 
0179 E5          .     PUSH  HL 
017A D5          .     PUSH  DE 
017B CD A6 01    ...   CALL  01A6       ; Kanaladdr --> DE, IY
017E DD 19       ..    ADD   IX,DE      ; DE = 4. + 5. Byte + Aufgabennummer
0180 DD 6E 00    .n.   LD    L,(IX+00)  ; Byte zur Aufgabe 
0183 26 FF       &.    LD    H,FF 
0185 D5          .     PUSH  DE 
0186 DD E1       ..    POP   IX         ; IX = Addresse des tabellenentries
0188 19          .     ADD   HL,DE      ; 
0189 59          Y     LD    E,C        ; BC = code1
018A 78          x     LD    A,B 
018B B7          .     OR    A 
018C 28 05       (.    JR    Z,0193     ; EUMEL-Funktion 0<=code1<256
018E 3C          <     INC   A 
018F 28 02       (.    JR    Z,0193     ; Shard-Funktion -256<=code1<0
0191 1E FF       ..    LD    E,FF       ; -1 = Illegale Funktion
0193 7E          ~     LD    A,(HL) 
0194 23          #     INC   HL 
0195 BB          .     CP    E          ; Addresse mit der Funktionsnummer 
0196 28 07       (.    JR    Z,019F     ; suchen 
0198 3C          <     INC   A          ; FF=Tabellenende 
0199 28 04       (.    JR    Z,019F 
019B 23          #     INC   HL 
019C 23          #     INC   HL 
019D 18 F4       ..    JR    0193       ; naechste Funktionsnummer 
019F 5E          ^     LD    E,(HL) 
01A0 23          #     INC   HL 
01A1 56          V     LD    D,(HL)     ; Sprung zur Addresse, die in der 
01A2 EB          .     EX    DE,HL      ; Tabelle steht 
01A3 D1          .     POP   DE         ; DE= code2 (Eingang HL)
01A4 E3          .     EX    (SP),HL 
01A5 C9          .     RET              ; --------------------------------- 
01A6 C5          .     PUSH  BC         ;   Kanalinfos aus Tabelle --> IY/DE
01A7 11 05 00    ...   LD    DE,0005    ; Entrylaenge in der Tabelle
01AA 21 12 02    !..   LD    HL,0212    ; Tabellenanfang (Kanaele)
01AD 46          F     LD    B,(HL)     ; Erstes Byte ist Tabellenlaenge
01AE 23          #     INC   HL 
01AF BE          .     CP    (HL)       ; Erstes Entrybyte ist Kanalnummer
01B0 28 03       (.    JR    Z,01B5     ; Bis Kanal gefunden
01B2 19          .     ADD   HL,DE 
01B3 10 FA       ..    DJNZ  01AF 
01B5 23          #     INC   HL         ; 2. u. 3. Byte --> DE
01B6 5E          ^     LD    E,(HL) 
01B7 23          #     INC   HL 
01B8 56          V     LD    D,(HL) 
01B9 D5          .     PUSH  DE         ; 2. u. 3. Byte --> IY 
01BA FD E1       ..    POP   IY 
01BC 23          #     INC   HL         ; 4. u. 5. Byte --> DE
01BD 5E          ^     LD    E,(HL) 
01BE 23          #     INC   HL 
01BF 56          V     LD    D,(HL) 
01C0 C1          .     POP   BC         ; gerettetes BC zurueck
01C1 C9          .     RET              ;----------------------------------
;============================= Parameterkanal ============================== 
01C2 01 5F 06                           ; 1, IOCONTROL "typ"
01C5 02 50 06                           ; 2, IOCONTROL "frout"
01C8 05 46 06                           ; 5, IOCONTROL "size"
01CB 06 ED 01                           ; 6, IOCONTROL "flow"
01CE 08 ED 01                           ; 8, IOCONTROL "baud"
01D1 09 ED 01                           ; 9, IOCONTROL "bits"
01D4 E2 ED 01                           ; -30, IOCONTROL maske f. busystatus
01D7 E1 ED 01                           ; -31, IOCONTROL maske f. strobe setz.
01DA FF 4C 06                           ; -1, IOCONTROL ill.
01DD FE 86 0B                           ; -2, Aufg. 5 : kanal init
01E0 FF 55 06                           ; -1, Aufg. 5 : BC = 1
01E3 FF 4C 06                           ; BLOCKIO ill.
01E6 59                                 ; Parameterkanal : OUTPUT: 0659 ill. 
01E7 06                                 ; 
01E8 FD                                 ; BLOCKIN : 01E3
01E9 FD                                 ; BLOCKOUT : 01E3
01EA DC                                 ; IOCONTROL : 01C2
01EB F7                                 ; Aufg. 5 : 01DD
01EC 00                                 ; Keine I/O moeglich
                                        ; ----- set "flow","bits","baud" --- 
01ED 7D          }     LD    A,L        ; Kanal = addressierter kanal
01EE 2E 00       ..    LD    L,00       ; 0 = Parameter setzen (code2) 
01F0 C3 63 01    .c.   JP    0163       ; Aufgabe 5, L = 0 
01F3 7D          }     LD    A,L        ; kanal = addressierter Kanal
01F4 2E 01       ..    LD    L,01       ; 1 = Parameter lesen (code2) 
01F6 C3 63 01    .c.   JP    0163       ; Aufgabe 5, L = 1
01F9 F3          .     DI               ;---------- Init Shard -------------
01FA 3E 00       >.    LD    A,00       ; Page 0 = Interruptvektoren
01FC ED 47       .G    LD    I,A 
01FE 31 00 B0    1..   LD    SP,B000 
0201 3E 21       >!    LD    A,21       ; Kanal 0..32 
0203 01 FE FF    ...   LD    BC,FFFE    ; Funktion -2 = Kanalinit 
0206 3D          =     DEC   A 
0207 F5          .     PUSH  AF 
0208 CD 63 01    .c.   CALL  0163       ; Kanaele initialisieren (IRQ's) 
020B F1          .     POP   AF 
020C B7          .     OR    A 
020D 20 F4        .    JR    NZ,0203 
020F C3 10 1E    ...   JP    1E10       ; Systemstart EUMEL0 bzw. 'putboot' 
     -----------------------------------  Entry : Kanal, Puffer, ROUTINETBL 
0212 0C                                 ; Tabelle mit 12 Kanaelen
0213 20 00 00 E6 01                     ; Parameterkanal, Kein Puffer 
0218 00 64 0C 0C 07                     ; Hintergrund 
021D 01 CD 0C 7B 02                     ; Kanal 1 .. 6 = seriell
0222 02 5B 0D 7B 02                     ; 
0227 03 E9 0D 7B 02 
022C 04 77 0E 7B 02
0231 05 05 0F 7B 02
0236 06 93 0F 7B 02 
023B 07 BD 0F EA 0A                     ; printer
0240 08 C3 0F EA 0A                     ; parallel 1
0245 09 C9 0F EA 0A                     ; parallel 2
024A 1F CF 0F 7D 06                     ; floppy
024F FF 00 00 3F 06                     ; illegal Kanal
;======================== Serielle Kanaele =================================
0254 01 5F 06                           ; 1, IOCONTROL "typ"
0257 02 36 05                           ; 2, IOCONTROL "frout" 
025A 05 46 06                           ; 5, IOCONTROL "size"
025D 06 F3 01                           ; 6, IOCONTROL "flow"
0260 08 F3 01                           ; 8, IOCONTROL "baud"
0263 09 F3 01                           ; 9, IOCONTROL "bits"
0266 FD D6 02                           ; -3, IOCONTROL "portinfo" 
0269 FF 4C 06                           ; -1 ill. 
026C 06 2A 03                           ; 6, Aufg .5 : "flow" setzen/info 
026F 08 F2 02                           ; 8, Aufg. 5 : "baud" setzen/info
0272 09 AA 03                           ; 9, Aufg. 5 : "bits" setzen/info 
0275 FE A2 02                           ; -2, Aufg. 5 : Kanal init
0278 FF 4C 06                           ; BLOCKIN/BLOCKOUT ill.
027B 31                                 ; Seriell : 0431 = OUTPUT 
027C 04 
027D FD                                 ; BLOCKIN : 0278
027E FD                                 ; BLOCKOUT : 0278
027F D9                                 ; IOCONTROL : 0251
0280 F1                                 ; Aufg. 5 : 026C
0281 03                                 ; Typ : Stream I/O 
    ; Baudratetabelle : 1. Byte: Bit 7+6 = Vorteiler (Register4) 
    ;                      Bit 4 = DIV 256, DIV 16,Bit 5 : Mode (CTC) 
    ;                   2. Byte: CTC-Zeitkonstante 
0282 40 9C                              ; 50 Baud 
0284 40 68                              ; 75 Baud 
0286 40 47                              ; 110 baud 
0288 E0 E8                              ; 134.5 Baud 
028A E0 D0                              ; 150 Baud 
028C A0 D0                              ; 300 Baud 
028E 60 D0                              ; 600 Baud 
0290 60 68                              ; 1200 baud 
0292 60 45                              ; 1800 Baud 
0294 60 34                              ; 2400 Baud 
0296 60 23                              ; 3600 Baud 
0298 60 1A                              ; 4800 Baud 
029A 60 11                              ; 7200 Baud 
029C 60 0D                              ; 9600 Baud 
029E 60 07                              ; 19200 Baud 
02A0 60 03                              ; 38400 Baud
02A2 FD 4E 1A    .N.   LD    C,(IY+1A)  ;------------- "kanal init" -------- 
02A5 06 0D       ..    LD    B,0D       ; Commandport in (IY+1A) 
02A7 21 C9 02    !..   LD    HL,02C9    ; 13 Bytes ausgeben 
02AA ED B3       ..    OTIR             ; An den Commandport schicken
02AC FD 5E 1D    .^.   LD    E,(IY+1D)  ; Interruptvektor des Kanals 
02AF ED 57       .W    LD    A,I        ; Vektortabellenaddresse High
02B1 57          W     LD    D,A 
02B2 ED 59       .Y    OUT   (C),E      ; Interruptvektor fuer Kanal 
02B4 0E 1E       ..    LD    C,1E       ; Serviceroutine am Pufferende 
02B6 06 00       ..    LD    B,00       ; (IY+1E)
02B8 FD E5       ..    PUSH  IY 
02BA E1          .     POP   HL 
02BB 09          .     ADD   HL,BC 
02BC 06 04       ..    LD    B,04       ; 4 Interrupt (Vector+Status) 
02BE EB          .     EX    DE,HL      ; DE= Serviceroutinenaddresse 
02BF 73          s     LD    (HL),E     ; HL = Interruptvektoraddresse 
02C0 23          #     INC   HL         ; Serviceroutine eintragen
02C1 72          r     LD    (HL),D 
02C2 23          #     INC   HL         ; Fuer alle 4 Interrupts einen 
02C3 13          .     INC   DE         ; Interrupthandler 
02C4 13          .     INC   DE 
02C5 13          .     INC   DE 
02C6 10 F7       ..    DJNZ  02BF 
02C8 C9          .     RET              ;-------- Inittabelle Serielle ----- 
02C9 14 44             ; reset ext status IRQs, Clock x16, 1 Stopbit,noparity
02CB 03 61             ; Rx 7 Bits, Autoenables (CTS), Receiver enable 
02CD 05 EA             ; Tx 8 Bits, DTR = 1, RTS = 1, Transmitter enable 
02CF 11 1F             ; kein WAIT/RDY, Vektor incl. Status, alle IRQs an 
02D1 03 C1             ; Rx 8 Bits, Keine Autoenables, Receiver enable 
02D3 11 1F             ; s.o. 
02D5 02                ; Interruptvektor folgt als naechstes Byte
02D6 FD 4E 1A    .N.   LD    C,(IY+1A)  ;------"IOCONTROL portinfo -3"------ 
02D9 06 01       ..    LD    B,01       ; ^ Status/Commandport
02DB 3E 30       >0    LD    A,30 
02DD F3          .     DI 
02DE ED 41       .A    OUT   (C),B      ; Read-Register 1 waehlen
02E0 ED 40       .@    IN    B,(C)      ; Einlesen
02E2 ED 79       .y    OUT   (C),A      ; Error Reset = 30H
02E4 ED 78       .x    IN    A,(C)      ; Statusregister (0) lesen
02E6 FB          .     EI 
02E7 E6 AC       ..    AND   AC         ; DCD,CTS,... durchlassen 
02E9 4F          O     LD    C,A        ; Lowbyte = Read-Register 1 Bits 
02EA 78          x     LD    A,B        ; Highbyte = Read-Register 0 Bits 
02EB E6 70       .p    AND   70         ; Nur Error-Bits durchlassen 
02ED DD B6 15    ...   OR    (IX+15)    ; Schon vorhandene Fehler dazu
02F0 47          G     LD    B,A 
02F1 C9          .     RET              ;----------- "baud" -------------- 
02F2 01 01 00    ...   LD    BC,0001    ; Rueckmeldung "nicht moeglich" 
02F5 CB 7C       .|    BIT   7,H        ; Keine Shard-spezifischen Baudrates 
02F7 C0          .     RET   NZ 
02F8 7C          |     LD    A,H        ; Schluessel --> A
02F9 B7          .     OR    A 
02FA C8          .     RET   Z          ; 0 ist ungueltiger Schluessel
02FB FD CB 11 4E ...N  BIT   1,(IY+11)  ; Baudrateeinstellung moeglich ? 
02FF C8          .     RET   Z          ; nein 
0300 0E 00       ..    LD    C,00       ; Rueckmeldung "ok" 
0302 CB 45       .E    BIT   0,L        ; 0 = Lesen, 1 = parameter setzen 
0304 C0          .     RET   NZ         ; Nur Information, dann fertig 
0305 11 80 02    ...   LD    DE,0280    ; Tabelle der Baudrates/Timeconsts 
0308 6C          l     LD    L,H 
0309 CB 25       .%    SLA   L 
030B 26 00       &.    LD    H,00       ; Schluessel * 2 + Tabellenanfang 
030D 19          .     ADD   HL,DE 
030E 7E          ~     LD    A,(HL)     ; Timeconst 
030F E6 C0       ..    AND   C0         ; Taktvorteiler (1,16,32,64) waehlen 
0311 4F          O     LD    C,A        ; fuer SIO/DART-Register 4
0312 3E 3F       >?    LD    A,3F       ; Nur Clock-Bits (6,7) veraendern 
0314 CD 1E 04    ...   CALL  041E       ; Clock x1, x16
0317 7E          ~     LD    A,(HL)     ; 
0318 E6 30       .0    AND   30         ; CTC Vorteiler (DIV16,DIV256) 
031A 07          .     RLCA 
031B F6 05       ..    OR    05         ; Modus = Timer, Kein IRQ, Timeconst
031D FD 4E 1C    .N.   LD    C,(IY+1C)  ; CTC-Port fuer Baudrategenerator 
0320 ED 79       .y    OUT   (C),A      ; An CTC ausgeben 
0322 23          #     INC   HL 
0323 7E          ~     LD    A,(HL)     ; Timeconst fuer CTC 
0324 ED 79       .y    OUT   (C),A 
0326 01 00 00    ...   LD    BC,0000    ; "ok"
0329 C9          .     RET              ;-------------- "flow" ------------- 
032A CB 7C       .|    BIT   7,H        ; Keine Shard-spezifischen "flow"s 
032C C2 55 06    .U.   JP    NZ,0655    ; BC = 1 liefern
032F CB 45       .E    BIT   0,L        ; NZ, wenn nur Information 
0331 C2 5B 06    .[.   JP    NZ,065B    ; "alles moeglich" melden 
0334 CD 07 06    ...   CALL  0607       ; Flowmodebits loeschen
0337 F3          .     DI 
0338 FD CB 11 86 ....  RES   0,(IY+11)  ; Kein RTS/CTS 
033C FD CB 17 AE ....  RES   5,(IY+17)  ; Autoenables (CTS) loeschen
0340 FD 36 12 04 .6..  LD    (IY+12),04 ; AND-maske Statusport Tx-Full 
0344 FD 36 13 04 .6..  LD    (IY+13),04 ; XOR-maske Statusport Tx-Full
0348 25          %     DEC   H          ; H=0, oder H>1 
0349 20 03        .    JR    NZ,034E 
034B CD FE 05    ...   CALL  05FE       ; H=1 : XON/XOFF setzen
034E 25          %     DEC   H 
034F 20 14        .    JR    NZ,0365    ; H=0 : keine Flusskontrolle
0351 FD CB 11 C6 ....  SET   0,(IY+11)  ; H=2 : RTS/CTS
0355 FD CB 17 EE ....  SET   5,(IY+17)  ; Autoenables (CTS) moeglich 
0359 FD 36 12 2C .6.,  LD    (IY+12),2C ; TxDfull, CTS on, DCD on
035D FD 36 13 2C .6.,  LD    (IY+13),2C ; Alle obigen Bits invertieren 
0361 FD 36 14 82 .6..  LD    (IY+14),82 ; ? 
0365 FD 7E 17    .~.   LD    A,(IY+17)  ; Writeregister 3
0368 06 03       ..    LD    B,03       ; Register 3
036A FD 4E 1A    .N.   LD    C,(IY+1A)  ; Commanndport
036D ED 41       .A    OUT   (C),B      ; Neuen Autoenableswert ausgeben
036F ED 79       .y    OUT   (C),A 
0371 FB          .     EI 
0372 CD 3C 04    .<.   CALL  043C       ; ggf. XON/XOFF je nach Status ausg.
0375 01 00 00    ...   LD    BC,0000    ; "ok"
0378 C9          .     RET              ;----- RTS/DTR o.XON/XOFF set/reset 
0379 CD E9 05    ...   CALL  05E9       ; testet BIT 0 (IY0+0)
037C C4 3C 04    .<.   CALL  NZ,043C    ; ggf XON/XOFF ausgeben
037F FD CB 11 46 ...F  BIT   0,(IY+11)  ; NZ, wenn RTS/CTS eingestellt 
0383 C8          .     RET   Z 
0384 F3          .     DI               ; RTS/CTS ist eingestellt 
0385 FD 7E 14    .~.   LD    A,(IY+14)  ; Bits, die bei RTS/CTS veraendert 
0388 4F          O     LD    C,A        ; werden: RTS/DTR 
0389 FD B6 19    ...   OR    (IY+19)    ; Register 5 Wert
038C A9          .     XOR   C          ; RTS/DTR ggf loeschen
038D FD 77 19    .w.   LD    (IY+19),A  ; Wieder zurueckschreiben
0390 FD 4E 1A    .N.   LD    C,(IY+1A)  ; Commandport
0393 06 05       ..    LD    B,05       ; Register 5 beschreiben 
0395 ED 41       .A    OUT   (C),B 
0397 ED 79       .y    OUT   (C),A      ; Neuen Wert laden
0399 FB          .     EI 
039A C9          .     RET              ;----------------------------------- 
039B CD D6 05    ...   CALL  05D6       ; Wenn XON/XOFF,
039E C4 3C 04    .<.   CALL  NZ,043C    ; XON oder XOFF ausgeben
03A1 F3          .     DI 
03A2 FD 7E 14    .~.   LD    A,(IY+14)  ; RTS/DTR ggf. setzen 
03A5 FD B6 19    ...   OR    (IY+19)    ; weiter wie oben
03A8 18 E3       ..    JR    038D       ;------------ "bits" -------------- 
03AA CB 7C       .|    BIT   7,H        ; Keine Shard-Spezifischen "bits" 
03AC C2 55 06    .U.   JP    NZ,0655 
03AF CB 45       .E    BIT   0,L        ; Info: "alles moeglich" melden 
03B1 C2 5B 06    .[.   JP    NZ,065B 
03B4 7C          |     LD    A,H        ; H = stop * 32 + par * 8 + (bit-1)
03B5 C6 20       .     ADD   A,20       ; Stopbits + 1 : 1..3, parity
03B7 1F          .     RRA              ; Bit 0,1 = parity
03B8 1F          .     RRA              ; Bit 2,3 = stopbits
03B9 1F          .     RRA 
03BA E6 0F       ..    AND   0F         ; restregister ausblenden 
03BC CB 4F       .O    BIT   1,A        ; 
03BE 28 02       (.    JR    Z,03C2     ; Wenn gerader Parity: 
03C0 CB C7       ..    SET   0,A        ; Parity enablen 
03C2 4F          O     LD    C,A        ; C enthaelt OR-Wert fuer Register 4
03C3 3E F0       >.    LD    A,F0       ; Nur Stopbits und Parity veraendern 
03C5 CD 1E 04    ...   CALL  041E       ; SIO-Register 4 veraendern
03C8 7C          |     LD    A,H        ; Datenbits ausblenden 
03C9 E6 07       ..    AND   07 
03CB 47          G     LD    B,A        ; + 1 = Anzahl Datenbits 
03CC 04          .     INC   B 
03CD 3E 00       >.    LD    A,00 
03CF 16 F8       ..    LD    D,F8       ; 11111000
03D1 37          7     SCF              ; Maskenbits "AND" fuer ungueltige 
03D2 17          .     RLA              ; Datenbits links reinrotieren 
03D3 CB 22       ."    SLA   D          ; Bei weniger als 5 Bits zusaetzl. 1
03D5 10 FA       ..    DJNZ  03D1 
03D7 5F          _     LD    E,A 
03D8 CD 18 06    ...   CALL  0618       ; Datenbitsmasken setzen 
03DB 16 00       ..    LD    D,00       ; Keine Bits invertieren 
03DD CD 1F 06    ...   CALL  061F       ; Datenbitmasken setzen AND/XOR
03E0 CD 26 06    .&.   CALL  0626 
03E3 06 00       ..    LD    B,00 
03E5 CB 54       .T    BIT   2,H 
03E7 28 0C       (.    JR    Z,03F5     ; 1,2,3,4,5 datenbits : 00
03E9 CB 44       .D    BIT   0,H        ; 6 datenbits : 80H
03EB 28 02       (.    JR    Z,03EF     ; 7 datenbits : 40H
03ED CB F8       ..    SET   7,B        ; 8 datenbits : C0H
03EF CB 4C       .L    BIT   1,H 
03F1 28 02       (.    JR    Z,03F5 
03F3 CB F0       ..    SET   6,B 
03F5 FD 7E 17    .~.   LD    A,(IY+17)  ; Register 3 Wert
03F8 E6 3F       .?    AND   3F         ; Bits, die nicht veraendert werden 
03FA B0          .     OR    B 
03FB FD 77 17    .w.   LD    (IY+17),A  ; Register 3 Wert setzen
03FE 16 03       ..    LD    D,03 
0400 FD 4E 1A    .N.   LD    C,(IY+1A)  ; Command-Port 
0403 F3          .     DI 
0404 ED 51       .Q    OUT   (C),D      ; Register 3 selektieren
0406 ED 79       .y    OUT   (C),A      ; Neuen Register 3 Wert
0408 CB 38       .8    SLR   B          ; Register 5 Bits "tiefer"
040A FD 7E 19    .~.   LD    A,(IY+19)  ; Alten Registerwert 
040D E6 9F       ..    AND   9F         ; unbenoetigte Bits ausblenden 
040F B0          .     OR    B 
0410 FD 77 19    .w.   LD    (IY+19),A  ; abspeichern 
0413 16 05       ..    LD    D,05       ;
0415 ED 51       .Q    OUT   (C),D      ; Register 5 selektieren
0417 ED 79       .y    OUT   (C),A      ; Wert in das Register schreiben
0419 FB          .     EI 
041A 01 00 00    ...   LD    BC,0000    ; "ok"
041D C9          .     RET              ;---------- Register 4 setzen -----
041E F3          .     DI               ; A enthaelt Maske fuer alte Bits
041F FD A6 18    ...   AND   (IY+18)    ; Register 4 Maske 
0422 B1          .     OR    C          ; Neuer Clock/Parity/Stopbit Wert
0423 FD 77 18    .w.   LD    (IY+18),A  ; In der Tabelle setzen
0426 06 04       ..    LD    B,04       ; 
0428 FD 4E 1A    .N.   LD    C,(IY+1A)  ; Am Kommandoport ausgeben
042B ED 41       .A    OUT   (C),B      ; Register 4 waehlen 
042D ED 79       .y    OUT   (C),A      ; Neuen Wert des Registers setzen
042F FB          .     EI 
0430 C9          .     RET              ; ---------------------------------- 
0431 CD CD 04    ...   CALL  04CD       ; Serieller OUTPUT:String in Puffer
0434 F5          .     PUSH  AF         ; schreiben fuer IRQ-Ausgabe
0435 C5          .     PUSH  BC 
0436 C4 3C 04    .<.   CALL  NZ,043C    ; NZ, wenn Puffer gefuellt
0439 C1          .     POP   BC 
043A F1          .     POP   AF 
043B C9          .     RET              ;--------- ggf. XON/XOFF ausgeben-- 
043C FD 4E 1A    .N.   LD    C,(IY+1A)  ; Statusportaddresse
043F F3          .     DI 
0440 ED 78       .x    IN    A,(C)      ; Statusbyte
0442 FD A6 12    ...   AND   (IY+12)    ;"Transmitter full"-Bit ausmaskieren
0445 FD AE 13    ...   XOR   (IY+13)    ; Umdrehen, falls high-Aktiv
0448 20 0A        .    JR    NZ,0454    ; NZ=Puffer noch voll
044A CD 45 05    .E.   CALL  0545       ; Flusskontrolle pruefen(XON/XOFF-->A
044D FD 4E 1B    .N.   LD    C,(IY+1B)  ; Addresse des Datenports seriell
0450 28 02       (.    JR    Z,0454     ; Nichtausgeben, weil Flusskontrolle
0452 ED 79       .y    OUT   (C),A      ; Zeichen aus Akku ausgeben
0454 FB          .     EI 
0455 C9          .     RET              ;--------Transmitbuffer empty IRQ- 
0456 FD E3       ..    EX    (SP),IY    ; Ruecksprungaddresse -31
0458 C5          .     PUSH  BC         ; = Anfang der Kanalinfotabelle 
0459 F5          .     PUSH  AF 
045A 01 DF FF    ...   LD    BC,FFDF    ; -31
045D FD 09       ..    ADD   IY,BC 
045F FD 4E 1A    .N.   LD    C,(IY+1A)  ; Kommandoport des Kanals
0462 3E 28       >(    LD    A,28       ; reset interrupt pending 
0464 ED 79       .y    OUT   (C),A      ; Kommando ausgeben 
0466 CD 3F 04    .?.   CALL  043F       ; Flusskontrolle durchfuehren
0469 18 48       .H    JR    04B3       ; Interruptende
046B FD E3       ..    EX    (SP),IY    ;------- External/Status Change IRQ 
046D C5          .     PUSH  BC 
046E F5          .     PUSH  AF 
046F 01 DC FF    ...   LD    BC,FFDC    ; IY := Kanaltabelleninfo
0472 FD 09       ..    ADD   IY,BC 
0474 FD 4E 1A    .N.   LD    C,(IY+1A)  ; Statusportaddresse 
0477 ED 78       .x    IN    A,(C)      ; Status einlesen 
0479 06 10       ..    LD    B,10       ; reset Ext/Status Interrupts 
047B ED 41       .A    OUT   (C),B 
047D FC D1 05    ...   CALL  M,05D1     ; break empfangen : bit 7 = 1
0480 CD 3C 04    .<.   CALL  043C       ; Flusskontrolle durchfuehren
0483 18 2E       ..    JR    04B3       ; interrupt ende
0485 FD E3       ..    EX    (SP),IY    ;--------special receive cond. IRQ 
0487 C5          .     PUSH  BC 
0488 F5          .     PUSH  AF 
0489 01 D6 FF    ...   LD    BC,FFD6    ; IY := Kanaltabelleninfo 
048C FD 09       ..    ADD   IY,BC 
048E FD 4E 1A    .N.   LD    C,(IY+1A)  ; Status- u. Kommandoport 
0491 3E 01       >.    LD    A,01       ; Read-Register 1
0493 06 30       .0    LD    B,30 
0495 ED 79       .y    OUT   (C),A      ; Reg.selekt
0497 ED 78       .x    IN    A,(C)      ; Status einlesen
0499 ED 41       .A    OUT   (C),B      ; Error-reset
049B 47          G     LD    B,A 
049C FD B6 15    ...   OR    (IY+15) 
049F FD 77 15    .w.   LD    (IY+15),A  ; Fehler vermerken
04A2 78          x     LD    A,B 
04A3 FD A6 16    ...   AND   (IY+16)    ; Zulaessige Fehler maskieren
04A6 28 1B       (.    JR    Z,04C3     ; keine Fehler, normale Eingabe 
04A8 FD 4E 1B    .N.   LD    C,(IY+1B)  ; Zeichen vom Datenport einlesen
04AB ED 78       .x    IN    A,(C) 
04AD CD C9 05    ...   CALL  05C9       ; Zeichen per Inputinterrupt melden 
04B0 CC 3C 04    .<.   CALL  Z,043C     ; Flusskontrolle durchfuehren
04B3 F1          .     POP   AF 
04B4 C1          .     POP   BC 
04B5 FD E1       ..    POP   IY 
04B7 FB          .     EI 
04B8 ED 4D       .M    RETI             ;-------Receive Character avil. IRQ 
04BA FD E3       ..    EX    (SP),IY 
04BC C5          .     PUSH  BC 
04BD F5          .     PUSH  AF 
04BE 01 D9 FF    ...   LD    BC,FFD9    ; IY := Pufferanfang
04C1 FD 09       ..    ADD   IY,BC 
04C3 FD 4E 1B    .N.   LD    C,(IY+1B)  ; Datenport
04C6 ED 78       .x    IN    A,(C)      ; Zeichen einlesen 
04C8 CD A9 05    ...   CALL  05A9       ; Zeichen per inputinterrupt melden 
04CB 18 E3       ..    JR    04B0       ; Interrupt mit Flusskontroller ende 
04CD 78          x     LD    A,B        ;--------String in Puffer schreiben 
04CE B1          .     OR    C          ; Nichts Auszugeben --> SCF RET
04CF 37          7     SCF 
04D0 C8          .     RET   Z 
04D1 C5          .     PUSH  BC         ; String (HL/BC) in Puffer schreiben 
04D2 FD 7E 02    .~.   LD    A,(IY+02)  ; IY - Kanaldescriptor
04D5 FD 96 03    ...   SUB   (IY+03)    ; Puffergroesse - Pufferzeigerwrite 
04D8 28 51       (Q    JR    Z,052B     ; puffer ist voll 
04DA C5          .     PUSH  BC 
04DB 5F          _     LD    E,A        ; freier Platz
04DC 78          x     LD    A,B        ; Highbyte > 0 ? Laenge 
04DD B7          .     OR    A 
04DE 28 02       (.    JR    Z,04E2 
04E0 0E FF       ..    LD    C,FF       ; Mehr als 255 Bytes Laenge
04E2 7B          {     LD    A,E        ; 
04E3 B9          .     CP    C 
04E4 30 01       0.    JR    NC,04E7    ; Nicht genuegend Platz ?
04E6 4F          O     LD    C,A 
04E7 FD 7E 02    .~.   LD    A,(IY+02)  ; Puffergroesse- Pufferreadzeiger 
04EA FD 96 04    ...   SUB   (IY+04) 
04ED 20 05        .    JR    NZ,04F4    ; Noch Platz
04EF FD 36 04 00 .6..  LD    (IY+04),00 ; Lesezeiger auf Anfang
04F3 79          y     LD    A,C 
04F4 B9          .     CP    C 
04F5 30 01       0.    JR    NC,04F8 
04F7 4F          O     LD    C,A 
04F8 06 00       ..    LD    B,00 
04FA C5          .     PUSH  BC 
04FB FD 56 07    .V.   LD    D,(IY+07)  ; Pufferanfang + Pufferzeiger
04FE FD 7E 06    .~.   LD    A,(IY+06) 
0501 FD 86 04    ...   ADD   (IY+04) 
0504 30 01       0.    JR    NC,0507 
0506 14          .     INC   D          ; -->  DE bringen
0507 5F          _     LD    E,A        ; und String von HL --> DE bringen 
0508 ED B0       ..    LDIR 
050A C1          .     POP   BC 
050B FD 7E 04    .~.   LD    A,(IY+04) 
050E 81          .     ADD   C          ; Pufferzeiger erhoehen
050F FD 77 04    .w.   LD    (IY+04),A 
0512 F3          .     DI 
0513 FD 7E 03    .~.   LD    A,(IY+03)  ; Pufferzeigerwrite erhoehen
0516 81          .     ADD   C          ; darf kein IRQ auftreten
0517 FD 77 03    .w.   LD    (IY+03),A 
051A FB          .     EI 
051B E3          .     EX    (SP),HL    ; Stringlaenge (auf Stack) --> HL
051C B7          .     OR    A 
051D ED 42       .B    SBC   HL,BC      ; Reststringlaenge
051F 44          D     LD    B,H 
0520 4D          M     LD    C,L 
0521 E1          .     POP   HL 
0522 20 AE        .    JR    NZ,04D2    ; Reststring ggf. ausgeben
0524 C1          .     POP   BC         ; Alle Zeichen uebernommen 
0525 37          7     SCF 
0526 FD CB 01 46 ...F  BIT   0,(IY+01) 
052A C9          .     RET              ;----------------------------------
052B E1          .     POP   HL 
052C B7          .     OR    A 
052D ED 42       .B    SBC   HL,BC 
052F 44          D     LD    B,H 
0530 4D          M     LD    C,L 
0531 FD CB 01 46 ...F  BIT   0,(IY+01) 
0535 C9          .     RET              ;----------- "frout" -------------- 
0536 F3          .     DI               ; keine zeichen annehmen 
0537 FD 7E 02    .~.   LD    A,(IY+02)  ; Puffergroesse - Pufferzeigerwrite 
053A 47          G     LD    B,A        ; Pufferzeiger Write = anzahl Z. 
053B FD 96 03    ...   SUB   (IY+03) 
053E FB          .     EI 
053F B8          .     CP    B          ; SCF, wenn Puffer leer
0540 3F          ?     CCF 
0541 06 00       ..    LD    B,00 
0543 4F          O     LD    C,A 
0544 C9          .     RET              ;---------------------------------- 
0545 FD CB 01 66 ...f  BIT   4,(IY+01)  ; Flusskontrolle ?
0549 20 37        7    JR    NZ,0582    ; ja 
054B FD CB 01 4E ...N  BIT   1,(IY+01) 
054F C8          .     RET   Z 
0550 FD CB 01 C6 ....  SET   0,(IY+01)  ; Zeichen aus Puffer lesen (IY+05)
0554 FD 7E 03    .~.   LD    A,(IY+03) 
0557 B7          .     OR    A          ; Writezeiger am Anfang (leer)
0558 C8          .     RET   Z          ; Zurueck
0559 FD CB 01 86 ....  RES   0,(IY+01) 
055D FD 35       .5    DEC   (IY+03)    ; Writezeiger DEC 1
055F 03          .     INC   BC 
0560 FD 46 07    .F.   LD    B,(IY+07)  ; Pufferanfang High
0563 FD 7E 05    .~.   LD    A,(IY+05) 
0566 FD BE 02    ...   CP    (IY+02) 
0569 20 02        .    JR    NZ,056D 
056B 3E 00       >.    LD    A,00 
056D 3C          <     INC   A 
056E FD 77 05    .w.   LD    (IY+05),A 
0571 3D          =     DEC   A 
0572 FD 86 06    ...   ADD   (IY+06)    ; Pufferanfang low
0575 30 01       0.    JR    NC,0578 
0577 04          .     INC   B          ; BC = Pufferzeiger
0578 4F          O     LD    C,A 
0579 0A          .     LD    A,(BC)     ; Zeichen aus Puffer (zeiger)
057A FD A6 0C    ...   AND   (IY+0C)    ; Bit 8 ggf ausblenden
057D FD AE 0D    ...   XOR   (IY+0D)    ;
0580 04          .     INC   B 
0581 C9          .     RET              ; Flusskontrolle
0582 FD CB 01 A6 ....  RES   4,(IY+01) 
0586 FD CB 01 6E ...n  BIT   5,(IY+01)  ; XON oder XOFF ?
058A 28 08       (.    JR    Z,0594 
058C FD CB 01 AE ....  RES   5,(IY+01) 
0590 FD 7E 10    .~.   LD    A,(IY+10)  ; XON (CTRL-Q) stattdessen ausgeben
0593 C9          .     RET              ;-----------------------------------
0594 F6 01       ..    OR    01 
0596 FD 7E 0F    .~.   LD    A,(IY+0F)  ; XOFF stattdessen ausgeben
0599 C9          .     RET              ;----------------------------------
059A FD CB 01 4E ...N  BIT   1,(IY+01)  ; XON empfangen
059E FD CB 01 CE ....  SET   1,(IY+01) 
05A2 C9          .     RET              ;--------------------------------- 
05A3 FD CB 01 8E ....  RES   1,(IY+01)  ; XOFF-empfangen
05A7 18 1D       ..    JR    05C6 
05A9 FD A6 08    ...   AND   (IY+08)    ;------- Zeichen per 'inputinterrupt'
05AC FD AE 09    ...   XOR   (IY+09)    ; masken fuer fehlerfreien receive 
05AF FD CB 01 56 ...V  BIT   2,(IY+01)  ; XON/XOFF ? 
05B3 28 0A       (.    JR    Z,05BF 
05B5 FD BE 10    ...   CP    (IY+10)    ; XON-Zeichen ?
05B8 28 E0       (.    JR    Z,059A 
05BA FD BE 0F    ...   CP    (IY+0F)    ; XOFF-Zeichen ?
05BD 28 E4       (.    JR    Z,05A3 
05BF 47          G     LD    B,A        ; Zeichen in B verlangt
05C0 FD 7E 00    .~.   LD    A,(IY+00)  ; Kanalnummer 
05C3 CD 13 1E    ...   CALL  1E13       ; Inputinterrupt aufrufen
05C6 F6 01       ..    OR    01 
05C8 C9          .     RET              ;-------- fehlerhafter receive
05C9 FD A6 0A    ...   AND   (IY+0A)    ; masken fuer fehlerhaften receive 
05CC FD AE 0B    ...   XOR   (IY+0B) 
05CF 18 DE       ..    JR    05AF       ; weiter wie normal 
05D1 FD 7E 0E    .~.   LD    A,(IY+0E)  ;--------- fehlerhafter receive ---- 
05D4 18 D9       ..    JR    05AF       ; '?' ausgeben 
05D6 F3          .     DI               ;---------------------------------- 
05D7 FD 7E 01    .~.   LD    A,(IY+01) 
05DA CB 5F       ._    BIT   3,A 
05DC 28 09       (.    JR    Z,05E7 
05DE F6 30       .0    OR    30         ; Bit 4 + 5 setzen (XON/XOFF) 
05E0 FD 77 01    .w.   LD    (IY+01),A 
05E3 FD CB 01 46 ...F  BIT   0,(IY+01) 
05E7 FB          .     EI 
05E8 C9          .     RET              ;---------------------------------- 
05E9 F3          .     DI               ; von RTS/DTR - XON/XOFF Routine 
05EA FD 7E 01    .~.   LD    A,(IY+01)  ; aufgerufen
05ED CB 5F       ._    BIT   3,A 
05EF 28 0B       (.    JR    Z,05FC     ; Unbekannte Flusskontrolle
05F1 F6 10       ..    OR    10 
05F3 E6 DF       ..    AND   DF 
05F5 FD 77 01    .w.   LD    (IY+01),A 
05F8 FD CB 01 46 ...F  BIT   0,(IY+01) 
05FC FB          .     EI 
05FD C9          .     RET              ;----------- XON/XOFF setzen --------
05FE FD CB 01 DE ....  SET   3,(IY+01) 
0602 FD CB 01 D6 ....  SET   2,(IY+01) 
0606 C9          .     RET              ;--------- IO-Stop d. Flow loeschen 
0607 FD CB 01 9E ....  RES   3,(IY+01)  ; XON/XOFF loeschen
060B FD CB 01 96 ....  RES   2,(IY+01) 
060F FD CB 01 4E ...N  BIT   1,(IY+01)  ; XON Modus ?
0613 FD CB 01 CE ....  SET   1,(IY+01)  ; XON-setzen
0617 C9          .     RET              ;--------- Datenbitmasken --------- 
0618 FD 73 0C    .s.   LD    (IY+0C),E  ; AND-maske fuer Datenbits setzen 
061B FD 72 0D    .r.   LD    (IY+0D),D  ; Bei weniger als 5 Bits links 1er
061E C9          .     RET              ;--------- Datenbitmasken setzen-- 
061F FD 73 08    .s.   LD    (IY+08),E  ; AND  fuer fehlerfreien reiceive
0622 FD 72 09    .r.   LD    (IY+09),D  ; XOR
0625 C9          .     RET              ;--------- Datenbitmasken setzen 
0626 FD 73 0A    .s.   LD    (IY+0A),E  ; AND fuer fehlerhaften receive
0629 FD 72 0B    .r.   LD    (IY+0B),D  ; XOR
062C C9          .     RET              ;-----------------------------------
;======================== Illegaler Kanal ================================= 
062D 01 5F 06                           ; 1, IOCONTROL "typ"
0630 02 50 06                           ; 2, IOCONTROL "frout"
0633 05 46 06                           ; 5, IOCONTROL "size"
0636 FF 4C 06                           ; -1, IOCONTROL ill.
0639 FF 55 06                           ; -1, Aufg. 5 Nicht moeglich
063C FF 4C 06                           ; -1, BLOCKIN/BLOCKOUT nicht moegl. 
063F 59 06                              ; Illegaler Kanal : OUTPUT 0659 
0641 FD                                 ; BLOCKIN : 063C
0642 FD                                 ; BLOCKOUT : 063C
0643 EE                                 ; IOCONTROL : 062D
0644 FA                                 ; Aufg. 5 : 0636
0645 00                                 ; Keine I/O moeglich
0646 3E 00       >.    LD    A,00       ; ---------- "size" --------------
0648 01 00 00    ...   LD    BC,0000    ; Null Bloecke
064B C9          .     RET              ;----------- "illegal" -1 ---------
064C 01 FF FF    ...   LD    BC,FFFF    ; Kann nicht ausgefuehrt werden
064F C9          .     RET              ;------------ "frout" -------------
0650 01 C8 00    ...   LD    BC,00C8    ; kann 200 zeichen uebernehmen 
0653 37          7     SCF              ; Puffer leer
0654 C9          .     RET              ;---------- "nicht moegl" ----------
0655 01 01 00    ...   LD    BC,0001    ; Liefert 1
0658 C9          .     RET              ;---------- "OUTPUT" --------------
0659 37          7     SCF              ; Alle Zeichen uebernommen 
065A C9          .     RET              ;------------- "ok" ---------------- 
065B 01 00 00    ...   LD    BC,0000 
065E C9          .     RET              ; -------- "typ" ------------------ 
065F 06 00       ..    LD    B,00       ; Type aus Parameterblock d. Kanals
0661 DD 4E 06    .N.   LD    C,(IX+06) 
0664 C9          .     RET              ;---------------------------------- 
;=========================== Floppykanal ================================== 
0665 05 95 06                           ; 5, IOCONTROL "size"
0668 01 5F 06                           ; 1, IOCONTROL "typ"
066B FF 4C 06                           ; -1, IOCONTROL ill.
066E FE 85 06                           ; -2, Aufg. 5 : Kanal init
0671 FF 55 06                           ; -1, Aufg. 5 : Geht nicht
0674 00 9D 06                           ; 0, BLOCKIN : 069D
0677 00 99 06                           ; 0, BLOCKOUT : 0699
067A FF 4C 06                           ; -1, BLOCKOUT ill.
067D 59 06                              ; Floppy: OUTPUT 0659 
067F F7                                 ; BLOCKIN : 0674
0680 FA                                 ; BLOCKOUT : 0677
0681 E8                                 ; IOCONTROL : 0665
0682 F1                                 ; Aufg. 5 : 066E
0683 0C                                 ; Typ : BLOCKIO ohne format
0684 04 
0685 3E 70       >p    LD    A,70       ; ----------- Floppyinit ----------- 
0687 D3 0A       ..    OUT   (0A),A     ; Interruptvektor PIOA Floppy = $70
0689 11 58 09    .X.   LD    DE,0958    ; Interruptroutine FDC
068C ED 57       .W    LD    A,I        ; In die Interruptvektortabelle 
068E 67          g     LD    H,A        ; eintragen
068F 2E 70       .p    LD    L,70 
0691 73          s     LD    (HL),E 
0692 23          #     INC   HL 
0693 72          r     LD    (HL),D 
0694 C9          .     RET              ;------------ "size" ---------------
0695 01 D0 04    ...   LD    BC,04D0    ; 1232 Bloecke = 616K
0698 C9          .     RET              ;----------- "BLOCKOUT" ----------- 
0699 3E 01       >.    LD    A,01       ; A=1 : Write
069B 18 01       ..    JR    069E       ; BLOCKIO
069D AF          .     XOR   A          ;------------ "BLOCKIN" ---------- 
069E E5          .     PUSH  HL         ; Hauptspeicheraddresse
069F 21 CF 04    !..   LD    HL,04CF    ; Mit Max. Blocknummer
06A2 B7          .     OR    A 
06A3 ED 52       .R    SBC   HL,DE 
06A5 E1          .     POP   HL 
06A6 DA C9 0B    ...   JP    C,0BC9     ; Block zu hoch = 3
06A9 E5          .     PUSH  HL 
06AA 21 11 08    !..   LD    HL,0811    ; Floppysemaphor reservieren
06AD CD 47 0C    .G.   CALL  0C47 
06B0 E1          .     POP   HL 
06B1 EB          .     EX    DE,HL      ; DE = Hauptspeicheraddresse
06B2 4F          O     LD    C,A        ; A= Read/Write,HL = Blocknummer
06B3 7D          }     LD    A,L 
06B4 E6 0F       ..    AND   0F         ; A = Sektornummer 0..15
06B6 CB 25       .%    SLA   L 
06B8 CB 14       ..    RL    H          ; HL = Tracknummer 
06BA CB 25       .%    SLA   L          ; Track = (Blocknr * 16) DIV 256
06BC CB 14       ..    RL    H          ;       = Blocknr DIV 16
06BE CB 25       .%    SLA   L 
06C0 CB 14       ..    RL    H 
06C2 CB 25       .%    SLA   L 
06C4 CB 14       ..    RL    H 
06C6 6F          o     LD    L,A        ; L = Sektor, H = Track
06C7 79          y     LD    A,C        ; A = Read/Write
06C8 B7          .     OR    A 
06C9 FD 7E 08    .~.   LD    A,(IY+08) 
06CC 28 05       (.    JR    Z,06D3     ; Z, wenn Read
06CE CD CA 09    ...   CALL  09CA       ; Write Floppy (Interrupt anstossen)
06D1 18 03       ..    JR    06D6       ; Skip
06D3 CD BE 09    ...   CALL  09BE       ; Read Floppy (Interrupt anstossen)
06D6 FD E5       ..    PUSH  IY 
06D8 CD 19 1E    ...   CALL  1E19       ; Zur Sicherheit einmal 'warte'
06DB FD E1       ..    POP   IY 
06DD FD 7E 05    .~.   LD    A,(IY+05)  ; Return von Floppy-IRQ-Routine
06E0 3C          <     INC   A 
06E1 28 F3       (.    JR    Z,06D6     ; FF = Busy, IRQ noch nicht beendet
06E3 21 11 08    !..   LD    HL,0811    ; Semaphor wieder freigeben
06E6 CD 61 0C    .a.   CALL  0C61 
06E9 3D          =     DEC   A          ; Muss = 0 sein, sonst fehler
06EA C2 AE 0B    ...   JP    NZ,0BAE    ; Fehler ggf. melden
06ED 01 00 00    ...   LD    BC,0000    ; Return: ok
06F0 C9          .     RET              ;-----------------------------------
;========================= Hintergrundkanal (Harddisk) ===================== 
06F1 05 34 07                           ; 5, IOCONTROL "size"
06F4 01 5F 06                           ; 1, IOCONTROL "typ"
06F7 FF 4C 06                           ; -1, IOCONTROL ill.
06FA FE 19 07                           ; -2, Aufg. 5 : kanal Init
06FD 9C 3C 07                           ; -100, Aufg.5:Anz.HG-Bloecke setzen
0700 FF 55 06                           ; -1, Aufg. 5 : BC = 1
0703 00 4D 07                           ; 0, BLOCKIN
0706 00 49 07                           ; 0, BLOCKOUT
0709 FF 4C 06                           ; -1, BLOCKIO illg. 
070C 59                                 ; Hintergrund : OUTPUT 0659
070D 06 
070E F7                                 ; BLOCKIN : 0703
070F FA                                 ; BLOCKOUT : 0706
0710 E5                                 ; IOCONTROL : 06F1
0711 EE                                 ; Aufg. 5 : 06FA
0712 0C                                 ; Typ : BLOCKIN/BLOCKOUT
0713 00          .     NOP 
0714 01 00 00    ...   LD    BC,0000 
0717 00          .     NOP 
0718 FF          .     RST   38         ;----------"HD-Init" --------------- 
0719 21 DA 0F    !..   LD    HL,0FDA    ; Bei Floppy (0FDA) = 46H
071C 22 0F 08    "..   LD    (080F),HL  ; Harddisktransferbufferaddresse
071F DD 7E 0A    .~.   LD    A,(IX+0A)  ; New Cylinder Number
0722 D3 22       ."    OUT   (22),A 
0724 3E 70       >p    LD    A,70       ; Interruptvektor FDC+HDC
0726 D3 0A       ..    OUT   (0A),A 
0728 11 58 09    .X.   LD    DE,0958    ; Interruptserviceroutinenaddresse
072B ED 57       .W    LD    A,I 
072D 67          g     LD    H,A 
072E 2E 70       .p    LD    L,70 
0730 73          s     LD    (HL),E 
0731 23          #     INC   HL 
0732 72          r     LD    (HL),D 
0733 C9          .     RET              ;------------ "size" --------------- 
0734 FD 4E 01    .N.   LD    C,(IY+01)  ; HG-Maxblock Low
0737 FD 46 02    .F.   LD    B,(IY+02)  ; High
073A 03          .     INC   BC         ; +1 = Anzahl Bloecke
073B C9          .     RET              ;------ Anzahl-HG-Bloecke setzen ---
073C FD 75 01    .u.   LD    (IY+01),L  ; Letzter HD-Block 
073F FD 74 02    .t.   LD    (IY+02),H 
0742 FD 73 03    .s.   LD    (IY+03),E  ; Erster HD-Block
0745 FD 72 04    .r.   LD    (IY+04),D 
0748 C9          .     RET              ;-------- Hintergrund-Write --------- 
0749 3E 01       >.    LD    A,01       ; 
074B 18 01       ..    JR    074E       ;--------- Hintergrund-Read -------- 
074D AF          .     XOR   A 
074E E5          .     PUSH  HL         ; Blocknummer in DE
074F FD 6E 01    .n.   LD    L,(IY+01)  ; Anzahl Hintergrundbloecke
0752 FD 66 02    .f.   LD    H,(IY+02) 
0755 B7          .     OR    A 
0756 ED 52       .R    SBC   HL,DE 
0758 E1          .     POP   HL 
0759 DA C9 0B    ...   JP    C,0BC9     ; Block zu hoch
075C E5          .     PUSH  HL 
075D 21 11 08    !..   LD    HL,0811    ; Harddisksemaphor reservieren
0760 CD 47 0C    .G.   CALL  0C47 
0763 FD 6E 03    .n.   LD    L,(IY+03)  ; Erster Harddiskblock
0766 FD 66 04    .f.   LD    H,(IY+04) 
0769 19          .     ADD   HL,DE      ; + Blocknummer
076A EB          .     EX    DE,HL 
076B E1          .     POP   HL         ; DE=Blocknummer neu
076C E5          .     PUSH  HL         ; HL=Hauptspeicherzieladdresse
076D F5          .     PUSH  AF         ; Wird spaeter als BC gepopt
076E B7          .     OR    A 
076F 20 03        .    JR    NZ,0774    ; NZ=Write
0771 2A 0F 08    *..   LD    HL,(080F)  ; Harddiskbufferaddresse
0774 CD A5 07    ...   CALL  07A5       ; HDC fuer Transfer anstossen
0777 DD E5       ..    PUSH  IX 
0779 CD 19 1E    ...   CALL  1E19       ; 'warte' EUMEL0 aufrufen
077C DD E1       ..    POP   IX 
077E DD 7E 07    .~.   LD    A,(IX+07)  ; Harddisk ready ?
0781 3C          <     INC   A          ; FF = not ready
0782 28 F3       (.    JR    Z,0777     ; weiter warten
0784 21 11 08    !..   LD    HL,0811    ; Semaphor freigeben
0787 CD 61 0C    .a.   CALL  0C61 
078A 3D          =     DEC   A          ; Fehlercode
078B C1          .     POP   BC 
078C E1          .     POP   HL 
078D C2 AE 0B    ...   JP    NZ,0BAE    ; Bei Fehler melden 
0790 78          x     LD    A,B        ; A=1 : Write
0791 B7          .     OR    A 
0792 20 0C        .    JR    NZ,07A0    ; Bei Write kein Transfer mehr
0794 EB          .     EX    DE,HL      ; DE = Hauptspeicherzieladdresse
0795 2A 0F 08    *..   LD    HL,(080F)  ; Hauptspeicher fuer HD-Transfer
0798 23          #     INC   HL         ; Vorweg Status etc.
0799 23          #     INC   HL 
079A 23          #     INC   HL 
079B 01 00 02    ...   LD    BC,0200    ; Vom HD-Buffer --> EUMEL-Block
079E ED B0       ..    LDIR 
07A0 01 00 00    ...   LD    BC,0000    ; "ok"
07A3 C9          .     RET              ;----------------------------------
07A4 C9          .     RET 
07A5 E5          .     PUSH  HL         ;----------- HD-Transfer anstoss. --
07A6 F5          .     PUSH  AF         ; A=1:Write,0=Read,HL=Mem.Addresse
07A7 D5          .     PUSH  DE         ; DE=Blocknummer
07A8 06 00       ..    LD    B,00       ; Cachesize = 21 max.
07AA 3A 05 00    :..   LD    A,(0005)   ; (5) = Cachegroesse
07AD B7          .     OR    A 
07AE 28 26       (&    JR    Z,07D6     ; Nicht in Cache, neu berechnen
07B0 4F          O     LD    C,A 
07B1 7A          z     LD    A,D        ; D = Blocknummer High zum suchen
07B2 21 05 00    !..   LD    HL,0005    ; Tabellenanfang = 6
07B5 09          .     ADD   HL,BC      ; + Cachegroesse
07B6 ED B9       ..    CPDR             ; Blocknummerhigh suchen 
07B8 20 1C        .    JR    NZ,07D6    ; Nicht gefunden, Tabelle durch
07BA F5          .     PUSH  AF         ; gefunden, test, ob Blocknummerlow 
07BB E5          .     PUSH  HL         ; auch stimmt
07BC 21 1A 00    !..   LD    HL,001A    ; Tabellenanfang = 27
07BF 09          .     ADD   HL,BC 
07C0 7B          {     LD    A,E        ; Blocknummer Low
07C1 BE          .     CP    (HL) 
07C2 28 07       (.    JR    Z,07CB     ; Ja, Block gefunden in Cache
07C4 E1          .     POP   HL 
07C5 F1          .     POP   AF 
07C6 EA B6 07    ...   JP    PE,07B6    ; Noch nicht die ganze Tabelle durch
07C9 18 0B       ..    JR    07D6       ; Ganz durch, neu berechnen 
07CB E1          .     POP   HL         ; Aus Cache entnehmen
07CC F1          .     POP   AF 
07CD 21 44 00    !D.   LD    HL,0044 
07D0 09          .     ADD   HL,BC 
07D1 C1          .     POP   BC 
07D2 EB          .     EX    DE,HL 
07D3 C3 A7 07    ...   JP    07A7       ;---------------------------------- 
07D6 E1          .     POP   HL 
07D7 F1          .     POP   AF 
07D8 D1          .     POP   DE 
07D9 01 40 04    .@.   LD    BC,0440    ; 1088 Bloecke subtrahieren
07DC F5          .     PUSH  AF         ; fuer Cylindernrhigh
07DD AF          .     XOR   A 
07DE ED 42       .B    SBC   HL,BC      ; 1088 = 17(sektoren)*4(heads)*16
07E0 3C          <     INC   A 
07E1 30 FB       0.    JR    NC,07DE    ; cylindernrh = blocknr DIV 1088
07E3 09          .     ADD   HL,BC 
07E4 3D          =     DEC   A          ; restbloecke in HL
07E5 07          .     RLCA             ; ins hoeherwertige Nibble bringen 
07E6 07          .     RLCA             ; (*16)
07E7 07          .     RLCA 
07E8 07          .     RLCA 
07E9 F5          .     PUSH  AF 
07EA 01 44 00    .D.   LD    BC,0044    ; Cylindernummerlow
07ED AF          .     XOR   A          ; restblocknr DIV 68 = cylindernrl
07EE ED 42       .B    SBC   HL,BC 
07F0 3C          <     INC   A 
07F1 30 FB       0.    JR    NC,07EE 
07F3 09          .     ADD   HL,BC 
07F4 3D          =     DEC   A 
07F5 67          g     LD    H,A       ; Cylinder = cylinderl*16+cylinderh
07F6 F1          .     POP   AF 
07F7 B4          .     OR    H 
07F8 67          g     LD    H,A       ; H = Cylinder
07F9 7D          }     LD    A,L       ; Head = Blocknr MOD 4
07FA E6 03       ..    AND   03 
07FC 07          .     RLCA            ; Head ins Highnibble bringen
07FD 07          .     RLCA 
07FE 07          .     RLCA 
07FF 07          .     RLCA 
0800 CB 3D       .=    SLR   L         ; Sektor = restblocknr DIV 4
0802 CB 3D       .=    SLR   L         ; 17. Sektor ist ungenutzt
0804 4F          O     LD    C,A 
0805 F1          .     POP   AF 
0806 FE 01       ..    CP    01 
0808 79          y     LD    A,C 
0809 CA 6B 08    .k.   JP    Z,086B     ; Z, wenn Write
080C C3 5C 08    .\.   JP    085C       ; Read
080F 00          .     NOP              ; HD-Transferpuffer
0810 00          .     NOP 
0811 00          .     NOP 
;=============================== Timerinterrupt ===========================
0812 11 2D 08    .-.   LD    DE,082D    ;-------- Timer Init ----------------
0815 ED 57       .W    LD    A,I 
0817 67          g     LD    H,A 
0818 2E C6       ..    LD    L,C6       ; HL = 00C6 Interruptserviceroutine 
081A 3E 33       >3    LD    A,33       ; Fuer alle Kanaele einen programm. 
081C E6 FC       ..    AND   FC         ; C0=0, C2=1, C4=2, C6=3(timer)
081E 4F          O     LD    C,A 
081F ED 69       .i    OUT   (C),L      ; Interruptvektor setzen
0821 73          s     LD    (HL),E     ; Addresse der Serviceroutine 
0822 23          #     INC   HL         ; --> (00C6) fuer CTC-Kanal 3 
0823 72          r     LD    (HL),D 
0824 3E B5       >.    LD    A,B5       ; IRQ,Timer,DIV256,pos.flanke,kein
0826 D3 33       .3    OUT   (33),A     ; externer trigger, timeconst folgt
0828 3E FA       >.    LD    A,FA       ; 250 = Zeitkonstante: 
082A D3 33       .3    OUT   (33),A     ; Hz=4000000/256/250=62.5 ^ 16ms
082C C9          .     RET              ;------ Timer-Service-IRQ --------- 
082D F5          .     PUSH  AF 
082E 3E 10       >.    LD    A,10       ; Alle 16ms Interrupt 
0830 CD 16 1E    ...   CALL  1E16       ; "timerinterrupt" 
0833 3A 5B 08    :[.   LD    A,(085B) 
0836 3C          <     INC   A 
0837 FE 3E       .>    CP    3E         ; Alle 62 Timerdurchlaeufe ~ 1s 
0839 28 07       (.    JR    Z,0842 
083B 32 5B 08    2[.   LD    (085B),A   ; Zaehler INCR 1
083E F1          .     POP   AF 
083F FB          .     EI 
0840 ED 4D       .M    RETI             ;-------------IRQ-Ende-------------- 
0842 AF          .     XOR   A          ; Sekundenzaehler auf 0
0843 32 5B 08    2[.   LD    (085B),A 
0846 DD E5       ..    PUSH  IX 
0848 FD E5       ..    PUSH  IY 
084A E5          .     PUSH  HL 
084B D5          .     PUSH  DE 
084C C5          .     PUSH  BC 
084D C3 50 08    .P.   JP    0850       ; Wird jede Sekunde aufgerufen 
0850 C1          .     POP   BC 
0851 D1          .     POP   DE 
0852 E1          .     POP   HL 
0853 FD E1       ..    POP   IY 
0855 DD E1       ..    POP   IX 
0857 F1          .     POP   AF 
0858 FB          .     EI 
0859 ED 4D       .M    RETI             ;-----------IRQ-Ende---------------- 
085B 00          .     NOP              ; Sekundenzaehler
;============================= Harddisk I/O ===============================
085C 0E 01       ..    LD    C,01       ;----------- HD-Read-Routine-------- 
085E DD 36 09 01 .6..  LD    (IX+09),01 ; Read-Kommando fuer HDC
0862 ED 53 AB 09 .S..  LD    (09AB),DE  ; Zieladdresse
0866 11 02 02    ...   LD    DE,0202    ; 515 Bytes
0869 18 0D       ..    JR    0878 
086B 0E 05       ..    LD    C,05       ;---------- HD-Write-Routine ------- 
086D DD 36 09 02 .6..  LD    (IX+09),02 ; (09BA) = Track(High),Sektor(Low)
0871 ED 53 AB 09 .S..  LD    (09AB),DE  ; Sourceaddresse, 02 = WriteCMD HDC
0875 11 FF 01    ...   LD    DE,01FF    ; 512 Bytes
0878 DD 22 BC 09 ."..  LD    (09BC),IX  ; IX retten
087C ED 53 AD 09 .S..  LD    (09AD),DE  ; Anzahl Bytes zu uebertragen
0880 DD 36 0C 05 .6..  LD    (IX+0C),05 
0884 22 BA 09    "..   LD    (09BA),HL 
0887 DD 36 07 FF .6..  LD    (IX+07),FF 
088B 2A BA 09    *..   LD    HL,(09BA) 
088E F6 01       ..    OR    01         ; HD-Drive 1 auswaehlen
0890 D3 20       .     OUT   (20),A     ; Head und Drive selektieren
0892 57          W     LD    D,A 
0893 79          y     LD    A,C 
0894 32 B7 09    2..   LD    (09B7),A   ; Read or Write 01/05
0897 DB 23       .#    IN    A,(23)     ; Status einlesen
0899 CB 77       .w    BIT   6,A 
089B 28 07       (.    JR    Z,08A4 
089D 3E 02       >.    LD    A,02       ; NZ = "write fault"
089F D3 20       .     OUT   (20),A     ; Drive 2 selektieren
08A1 7A          z     LD    A,D        ; Headnummer setzen
08A2 D3 20       .     OUT   (20),A 
08A4 7C          |     LD    A,H        ; Cylindernummer
08A5 DD BE 0A    ...   CP    (IX+0A)    ; = Alter Cylinder
08A8 CA C4 08    ...   JP    Z,08C4     ; ja, kein neuer Cylinderseek
08AB DD 7E 0A    .~.   LD    A,(IX+0A)  ; alten Cylinder holen --> HDC
08AE D3 21       .!    OUT   (21),A     ; last significant Bits of CYL
08B0 AF          .     XOR   A          ; most significant Bits of CYL = 0
08B1 D3 21       .!    OUT   (21),A 
08B3 7C          |     LD    A,H        ; Neue Cylindernummer
08B4 D3 22       ."    OUT   (22),A     ; ausgeben und 
08B6 DD 77 0A    .w.   LD    (IX+0A),A  ; vermerken
08B9 AF          .     XOR   A          ; Most significant Bits = 0
08BA D3 22       ."    OUT   (22),A 
08BC 3E 10       >.    LD    A,10       ; Seek-Kommando an HDC
08BE CD 5B 09    .[.   CALL  095B 
08C1 2A BA 09    *..   LD    HL,(09BA)  ; Sektornummer
08C4 7D          }     LD    A,L        ; ausgeben
08C5 D3 21       .!    OUT   (21),A 
08C7 21 A9 09    !..   LD    HL,09A9    ; DMA-Init-Tabelle
08CA C5          .     PUSH  BC 
08CB 01 00 11    ...   LD    BC,1100    ; DMA-Transfer vorbereiten
08CE ED B3       ..    OTIR             ; 17 Bytes an DMA-Controller
08D0 C1          .     POP   BC 
08D1 DD 7E 09    .~.   LD    A,(IX+09)  ; 01=Read, 02=Write
08D4 CD 5B 09    .[.   CALL  095B       ; An HDC-Controller schicken
08D7 DD 36 0C FF .6..  LD    (IX+0C),FF ; Status in A
08DB 21 40 09    !@.   LD    HL,0940    ; Fehlernummer (in L) --> IX+07 
08DE E5          .     PUSH  HL 
08DF 21 58 09    !X.   LD    HL,0958    ; HD-IRQ-Serviceroutine
08E2 22 70 00    "p.   LD    (0070),HL  ; in Vektortabelle eintragen
08E5 2E 00       ..    LD    L,00 
08E7 E6 5D       .]    AND   5D         ; HD-Status in A
08E9 CA 46 09    .F.   JP    Z,0946     ; "ok"
08EC CB 5F       ._    BIT   3,A        ; NZ, wenn "Record not found"
08EE C2 11 09    ...   JP    NZ,0911    ; 
08F1 CB 67       .g    BIT   4,A        ; NZ, wenn "CRC error"
08F3 28 03       (.    JR    Z,08F8 
08F5 2E 02       ..    LD    L,02       ; 2 = "crc err"
08F7 C9          .     RET              ;------------------------------- 
08F8 CB 57       .W    BIT   2,A        ; NZ, wenn "bad sector"
08FA 28 03       (.    JR    Z,08FF 
08FC 2E 03       ..    LD    L,03       ; "bad sect"
08FE C9          .     RET              ;-------------------------------
08FF CB 77       .w    BIT   6,A        ; NZ, wenn "write fault"
0901 28 0B       (.    JR    Z,090E 
0903 2E 04       ..    LD    L,04       ; "write fault"
0905 3E 02       >.    LD    A,02       ; Drive 2 selektieren
0907 D3 20       .     OUT   (20),A 
0909 E6 3F       .?    AND   3F 
090B D3 20       .     OUT   (20),A     ; Heads 4..15 gibt es nicht
090D C9          .     RET              ;-------------------------------
090E 2E 05       ..    LD    L,05       ; "write fault" 
0910 C9          .     RET              ;------------------------------ 
0911 2E 07       ..    LD    L,07       ; "rec not fnd"
0913 DD 35       .5    DEC   (IX+08)    ; Noch einmal
0915 08          .     EX    AF,AF' 
0916 C0          .     RET   NZ         ; Nach 8 Versuchen:
0917 E1          .     POP   HL 
0918 DD 36 0B 07 .6..  LD    (IX+0B),07 ; Register fuer Cylinderpos etc. 
091C DD 36 08 08 .6..  LD    (IX+08),08 
0920 DD 36 07 FF .6..  LD    (IX+07),FF 
0924 DD 36 0C FF .6..  LD    (IX+0C),FF 
0928 DD 36 0A 00 .6..  LD    (IX+0A),00 
092C 3E 20       >     LD    A,20       ; Recalibrate Head
092E CD 5B 09    .[.   CALL  095B       ; Kommando ausgeben
0931 DD 7E 0B    .~.   LD    A,(IX+0B) 
0934 DD 77 07    .w.   LD    (IX+07),A 
0937 21 58 09    !X.   LD    HL,0958    ; Dummy-IRQ-Vektor (EI, RETI)
093A 22 70 00    "p.   LD    (0070),HL 
093D C3 A4 07    ...   JP    07A4       ; RET
0940 DD 75 07    .u.   LD    (IX+07),L 
0943 C3 A4 07    ...   JP    07A4       ; NOP oder RET (i.d.R RET)
0946 3E BB       >.    LD    A,BB       ; Lesemaske setzen 
0948 D3 00       ..    OUT   (00),A     ; DMA-Kommando
094A 3E 01       >.    LD    A,01       ; BIT0 = Register 0 wird gelesen
094C D3 00       ..    OUT   (00),A     ; Register 0 ist Statusregister
094E DB 00       ..    IN    A,(00)     ; DMA-Status einlesen (Readregister0)
0950 E6 21       .!    AND   21         ; Test, ob DMA laeuft
0952 EE 01       ..    XOR   01         ; Kein Blockende und DMA erhielt BCK
0954 C8          .     RET   Z          ; DMA- angestossen = 0
0955 36 06       6.    LD    (HL),06    ; DMA-failed
0957 C9          .     RET 
0958 FB          .     EI 
0959 ED 4D       .M    RETI             ;--------- Kommando an HDC -------- 
095B E1          .     POP   HL         ; in A
095C 22 7F 09    "..   LD    (097F),HL  ; Returnaddresse --> CALL Fehler 
095F 21 68 09    !h.   LD    HL,0968    ; Interruptserviceroutine
0962 22 70 00    "p.   LD    (0070),HL 
0965 D3 23       .#    OUT   (23),A     ; Kommando ausgeben
0967 C9          .     RET              ;-------- IRQ-Serviceroutine HDC-----
0968 F5          .     PUSH  AF 
0969 DD E5       ..    PUSH  IX 
096B DD 2A BC 09 .*..  LD    IX,(09BC) 
096F E5          .     PUSH  HL 
0970 DB 08       ..    IN    A,(08)     ; HDC-IRQ ?
0972 CB 7F       ..    BIT   7,A 
0974 F5          .     PUSH  AF 
0975 DB 23       .#    IN    A,(23)     ; Status lesen (wird geloescht)
0977 67          g     LD    H,A 
0978 3E 00       >.    LD    A,00 
097A D3 23       .#    OUT   (23),A     ; Null (quiescent state) Kommando
097C F1          .     POP   AF 
097D 7C          |     LD    A,H 
097E C4 67 09    .g.   CALL  NZ,0967   ; Fehler --> L bringen
0981 DB 04       ..    IN    A,(04)    ; Drive/Controller Status FDC 
0983 E1          .     POP   HL 
0984 DD E1       ..    POP   IX 
0986 F1          .     POP   AF 
0987 FB          .     EI 
0988 ED 4D       .M    RETI             ;----------------------------------- 
098A F5          .     PUSH  AF 
098B E5          .     PUSH  HL 
098C DD E5       ..    PUSH  IX 
098E DB 23       .#    IN    A,(23)     ; Status einlesen (dummy)
0990 DD 2A BC 09 .*..  LD    IX,(09BC) 
0994 3E 40       >@    LD    A,40       ; Welches Kommando ist das ???!!!
0996 D3 23       .#    OUT   (23),A 
0998 DB 04       ..    IN    A,(04)     ; FDC-Status einlesen
099A DD 36 07 08 .6..  LD    (IX+07),08 
099E 21 58 09    !X.   LD    HL,0958    ; Dummy-IRQ-Vektor
09A1 22 70 00    "p.   LD    (0070),HL 
09A4 DD E1       ..    POP   IX 
09A6 E1          .     POP   HL 
09A7 F1          .     POP   AF 
09A8 C9          .     RET              ; DMA-Initialisierungstabelle -HDC-
                            ;-DMA-Register 6 (Kommandoregister) "RESET"
09A9 C3                                 ; Softreset an DMA-Controller
                            ;-DMA-Register 0 (Port A Addressregister) 
09AA 7D                                 ; A --> B uebertragen, BL & Adr folgt
09AB 00 00                              ; Startaddresse Port A 
09AD FF 01                              ; Anzahl Bytes -1 (Bytecount) 
                            ;-DMA-Register 1 (Port A Modus)
09AF 14                                 ; Port A ist Speicher, INCR Adress
                            ;-DMA-Register 2 (Port B Modus) 
09B0 28                                 ; Port B ist IO-Port, Adr. konstant 
                            ;-DMA-Register 4 (Betriebsart & Port B Adr.reg.)
09B1 A5                                 ; Blockmodus, IO-Port B folgt 
09B2 21                                 ; 21 = Data I/O-Port fuer HDC
                            ;-DMA-Register 5 (Pin-Control)
09B3 8A                                 ; Stop am Blockende,Pin16=-CE,RDYakt1
                            ;-DMA-Register 6 (Kommando) "LOAD"
09B4 CF                                 ; Adresse & BL aus WR0/WR4 laden 
09B5 01                                 ; Wegen Maskenfehler: Direction umk. 
09B6 CF                                 ;        "         Kommando "LOAD"
09B7 01                                 ; 01 : B-->A, 05 : A-->B
09B8 CF                                 ; Kommando : "LOAD"
09B9 87                                 ; DMA-Freigabe       ------ bis hier
09BA 00          .     NOP              ; Bereich fuer IX (retten) 
09BB 00          .     NOP 
09BC 00          .     NOP              ; Sektornummer, 09BD = Tracknummer 
09BD 00          .     NOP              ;------- Floppy-Read anstoss.------ 
;============================= Floppy I/O ==================================
09BE FD 36 01 9F .6..  LD    (IY+01),9F ; AND-Maske fuer FDC-Status-ready
09C2 0E 01       ..    LD    C,01       ; DMA-Read-Kommando
09C4 FD 36 02 88 .6..  LD    (IY+02),88 ; FDC-Kommando read
09C8 18 0A       ..    JR    09D4 
09CA FD 36 01 FF .6..  LD    (IY+01),FF ;------- Floppy-Write anstoss.------ 
09CE 0E 05       ..    LD    C,05       ; AND-Maske fuer FDC-Status-ready
09D0 FD 36 02 A8 .6..  LD    (IY+02),A8 ; ^ DMA-Write-Kommando,FDC-Kommandowrite 
09D4 FD 22 B1 0A ."..  LD    (0AB1),IY  ; IY retten
09D8 FB          .     EI 
09D9 E5          .     PUSH  HL 
09DA 21 C1 0A    !..   LD    HL,0AC1    ; DMA-Direction-Byte
09DD 71          q     LD    (HL),C 
09DE E1          .     POP   HL 
09DF FD 36 0A 46 .6.F  LD    (IY+0A),46 
09E3 ED 53 B5 0A .S..  LD    (0AB5),DE  ; Zieladdresse fuer DMA 
09E7 FD 36 05 FF .6..  LD    (IY+05),FF 
09EB CB BF       ..    RES   7,A 
09ED DD BE 07    ...   CP    (IX+07) 
09F0 28 1C       (.    JR    Z,0A0E 
09F2 DD 77 07    .w.   LD    (IX+07),A 
09F5 22 C4 0A    "..   LD    (0AC4),HL  ; track/sektor retten
09F8 FD 7E 06    .~.   LD    A,(IY+06) 
09FB D3 05       ..    OUT   (05),A     ;  Tracknummer
09FD D3 07       ..    OUT   (07),A     ;  Output to FDC
09FF 3E 12       >.    LD    A,12       ; FDC-Kommando
0A01 CD 76 0A    .v.   CALL  0A76 
0A04 FD 7E 09    .~.   LD    A,(IY+09)  ; Floppydrive (Headselect)
0A07 CB C7       ..    SET   0,A        ; Single Density
0A09 D3 08       ..    OUT   (08),A     ; Floppy Format + Headselect
0A0B 2A C4 0A    *..   LD    HL,(0AC4)  ; geretteter Sektor 
0A0E 7D          }     LD    A,L        ; Sektornumber
0A0F D3 06       ..    OUT   (06),A 
0A11 7C          |     LD    A,H        ; Tracknummer
0A12 FD BE 06    ...   CP    (IY+06) 
0A15 28 0A       (.    JR    Z,0A21 
0A17 FD 77 06    .w.   LD    (IY+06),A 
0A1A D3 07       ..    OUT   (07),A     ; Outputdatabyte Track setzen
0A1C 3E 1A       >.    LD    A,1A       ; FDC-Kommando
0A1E CD 76 0A    .v.   CALL  0A76 
0A21 DB 08       ..    IN    A,(08)     ; Headloadinput testen
0A23 CB 4F       .O    BIT   1,A 
0A25 FD 7E 02    .~.   LD    A,(IY+02)  ; Read/Write-Kommando an FDC
0A28 20 02        .    JR    NZ,0A2C    ; Head ist auf der Floppy
0A2A CB D7       ..    SET   2,A        ; Head muss noch auf Floppy
0A2C 21 B3 0A    !..   LD    HL,0AB3    ; DMA-Tabelle 
0A2F 01 00 11    ...   LD    BC,1100    ; 17 Bytes in DMA schreiben
0A32 ED B3       ..    OTIR 
0A34 CD 76 0A    .v.   CALL  0A76       ; FDC-Kommando ausgeben (starten)
0A37 FD 36 0A FF .6..  LD    (IY+0A),FF 
0A3B 21 AE 0A    !..   LD    HL,0AAE 
0A3E 22 70 00    "p.   LD    (0070),HL 
0A41 DB 04       ..    IN    A,(04)     ; FDC - Status
0A43 FD A6 01    ...   AND   (IY+01)    ; maske fuer 'fehler'
0A46 CB 7F       ..    BIT   7,A 
0A48 20 11        .    JR    NZ,0A5B    ; ist noch busy
0A4A B7          .     OR    A          ; Irgendwelche Fehler ?
0A4B 20 05        .    JR    NZ,0A52 
0A4D FD 36 05 00 .6..  LD    (IY+05),00 ; Kein Fehler, "ok"
0A51 C9          .     RET 
0A52 CB 67       .g    BIT   4,A        ; CRC ?
0A54 20 0A        .    JR    NZ,0A60 
0A56 FD 36 05 02 .6..  LD    (IY+05),02 ; Fehler "crc err"
0A5A C9          .     RET 
0A5B FD 36 05 01 .6..  LD    (IY+05),01 ; Fehler 1 : "busy"
0A5F C9          .     RET 
0A60 FD 36 05 FF .6..  LD    (IY+05),FF ; Interrupt noch nicht beendet setz.
0A64 3E 0A       >.    LD    A,0A       ; Kommando 10 an FDC
0A66 CD 76 0A    .v.   CALL  0A76 
0A69 FD 36 05 02 .6..  LD    (IY+05),02 ; Fehler 2 : "crc err"
0A6D DB 04       ..    IN    A,(04)     ; FDC-Status
0A6F 21 AE 0A    !..   LD    HL,0AAE    ; Dummy-IRQ Vektor (EI, RETI)
0A72 22 70 00    "p.   LD    (0070),HL  ; eintragen
0A75 C9          .     RET              ;----------FDC Kommandoausgeben----
0A76 E1          .     POP   HL         ; Returnaddresse = Fehlernr.laden
0A77 22 A5 0A    "..   LD    (0AA5),HL 
0A7A 21 96 0A    !..   LD    HL,0A96 
0A7D 22 70 00    "p.   LD    (0070),HL  ; Floppy IRQ-Vektor setzen
0A80 D3 04       ..    OUT   (04),A     ; 1797 FDC Command
0A82 C9          .     RET              ;----------------------------------
0A83 F5          .     PUSH  AF 
0A84 FD 2A B1 0A .*..  LD    IY,(0AB1)  ; geretteter IY
0A88 FD 36 05 02 .6..  LD    (IY+05),02 ; "crc err"
0A8C E5          .     PUSH  HL 
0A8D 21 AE 0A    !..   LD    HL,0AAE    ; Dummy-Interrupt-Vektor
0A90 22 70 00    "p.   LD    (0070),HL 
0A93 E1          .     POP   HL 
0A94 F1          .     POP   AF 
0A95 C9          .     RET              ;----- IRQ-Service-Routine ---------
0A96 FB          .     EI               ; 
0A97 FD E5       ..    PUSH  IY 
0A99 E5          .     PUSH  HL 
0A9A C5          .     PUSH  BC 
0A9B F5          .     PUSH  AF 
0A9C FD 2A B1 0A .*..  LD    IY,(0AB1)  ; geretteter IY
0AA0 DB 08       ..    IN    A,(08)     ; IRQ-Anford.Register
0AA2 CB 77       .w    BIT   6,A        ; BIT6=FDC IRQ aufgetreten
0AA4 C4 82 0A    ...   CALL  NZ,0A82    ; Returnaddresse in CALL-Addresse
0AA7 DB 23       .#    IN    A,(23)     ; Statusbyte Harddisk loeschen
0AA9 F1          .     POP   AF 
0AAA C1          .     POP   BC 
0AAB E1          .     POP   HL 
0AAC FD E1       ..    POP   IY 
0AAE FB          .     EI 
0AAF ED 4D       .M    RETI             ;-----------------------------------
0AB1 00          .     NOP              ; Platz zum retten von IY 
0AB2 00          .     NOP              ;- DMA-Initialisierung fuer FDC --- 
0AB3 C3                                 ; Softreset an DMA-Controller
                            ;-DMA-Register 0 (Port A Addressregister) 
0AB4 7D                                 ; A --> B uebertragen, BL & Adr folgt
0AB5 00 00                              ; Startaddresse Port A 
0AB7 FF 01                              ; Anzahl Bytes -1 (Bytecount) 
                            ;-DMA-Register 1 (Port A Modus)
0AB9 14                                 ; Port A ist Speicher, INCR Adress
                            ;-DMA-Register 2 (Port B Modus) 
0ABA 28                                 ; Port B ist IO-Port, Adr. konstant 
                            ;-DMA-Register 4 (Betriebsart & Port B Adr.reg.)
0ABB 85                                 ; Einzelbytemodus(!) IO-Port B folgt 
0ABC 07                                 ; 01 = Data I/O-Port fuer FDC
                            ;-DMA-Register 5 (Pin-Control)
0ABD 8A                                 ; Stop am Blockende,Pin16=-CE,RDYakt1
                            ;-DMA-Register 6 (Kommando) "LOAD"
0ABE CF                                 ; Adresse & BL aus WR0/WR4 laden 
0ABF 01                                 ; Wegen Maskenfehler: Direction umk. 
0AC0 CF                                 ;        "         Kommando "LOAD"
0AC1 01                                 ; 01 : B-->A, 05 : A-->B
0AC2 CF                                 ; Kommando : "LOAD"
0AC3 87                                 ; DMA-Freigabe       ------ bis hier
0AC4 00 00                              ;---------------------------------- 
;=========================== Parallel Kanaele =============================
0AC6 01 5F 06                           ; 1 IOCONTROL "typ"
0AC9 02 7B 0B                           ; 2 IOCONTROL "frout"
0ACC 05 46 06                           ; 5 IOCONTROL "size"
0ACF FD 07 0B                           ; -3 IOCONTROL "Printerstat --> BC" 
0AD2 FC FF 0A                           ; -4 IOCONTROL"code2 --> Printerport" 
0AD5 FB 03 0B                           ; -5 IOCONTROL"code2 --> Pstatusport"
0AD8 FF 4C 06                           ; -1 IOCONTROL ill.
0ADB E2 0D 0B                           ; -30 Aufg. 5, Maske fuer Busy-Status
0ADE E1 14 0B                           ; -31 Aufg. 5, Maske fuer Printerstb.
0AE1 FE F1 0A                           ; -2  Aufg. 5 = Kanal init
0AE4 FF 55 06                           ; -1, Aufg. 5 --> BC = 1 
0AE7 FF 4C 06                           ; -1, BLOCKIN, BLOCKOUT ill.
0AEA 1E                                 ; Parallel 0B1E = OUTPUT
0AEB 0B          .     DEC   BC 
0AEC FD          .                      ; BLOCKIN : 0AE7
0AED FD          .                      ; BLOCKOUT : 0AE7
0AEE DC                                 ; IOCONTROL : 0AC6
0AEF F1                                 ; Aufg. 5 : 0ADB
0AF0 03                                 ; Typ : Input/Ouput (Stream)
0AF1 DB 10       ..    IN    A,(10)     ;-------- Kanal Init --------------- 
0AF3 FD A6 03    ...   AND   (IY+03)    ; Printer selektieren
0AF6 FD AE 04    ...   XOR   (IY+04) 
0AF9 FD AE 05    ...   XOR   (IY+05) 
0AFC D3 10       ..    OUT   (10),A     ; Ausgabe an Printerstatusport
0AFE C9          .     RET              ;----------- "IOCONTROL -4" --------
0AFF 7B          {     LD    A,E        ; Printerdata direkt ausgeben 
0B00 D3 11       ..    OUT   (11),A 
0B02 C9          .     RET              ;---------- "IOCONTROL -5"- --------
0B03 7B          {     LD    A,E        ; datastrobe, input prime, control 
0B04 D3 10       ..    OUT   (10),A     ; An Statusport (printer) ausgeben 
0B06 C9          .     RET              ;-------- "IOCONTROL -3" -----------
0B07 DB 10       ..    IN    A,(10)     ; Liest der Printerstatus ein 
0B09 4F          O     LD    C,A 
0B0A 06 00       ..    LD    B,00 
0B0C C9          .     RET              ;----- Aufg. 5, "-14" -------------- 
0B0D FD 73 01    .s.   LD    (IY+01),E  ; code2 --> AND/XOR Masken "Busy"
0B10 FD 72 02    .r.   LD    (IY+02),D 
0B13 C9          .     RET              ;----- Aufg. 5, "-15" ------------- 
0B14 FD 73 03    .s.   LD    (IY+03),E  ; code2, code3 --> Maske "selekt" 
0B17 FD 72 04    .r.   LD    (IY+04),D 
0B1A FD 74 05    .t.   LD    (IY+05),H 
0B1D C9          .     RET              ;--------- "OUTPUT" --------------- 
0B1E 78          x     LD    A,B        ; Nichts auszugeben ? 
0B1F B1          .     OR    C 
0B20 37          7     SCF 
0B21 C8          .     RET   Z 
0B22 C5          .     PUSH  BC 
0B23 DB 10       ..    IN    A,(10)     ; Status einelsen
0B25 FD A6 03    ...   AND   (IY+03)    ; Printerselekt.
0B28 FD AE 04    ...   XOR   (IY+04) 
0B2B 57          W     LD    D,A 
0B2C FD AE 05    ...   XOR   (IY+05) 
0B2F 5F          _     LD    E,A 
0B30 E5          .     PUSH  HL 
0B31 09          .     ADD   HL,BC      ; Ende des Textes
0B32 E3          .     EX    (SP),HL 
0B33 41          A     LD    B,C        ; Textlaenge Low (Pbuffersize < 256)
0B34 0E 11       ..    LD    C,11       ; Dataport = 11H
0B36 DB 10       ..    IN    A,(10)     ; Printer busy ?
0B38 FD A6 01    ...   AND   (IY+01) 
0B3B FD AE 02    ...   XOR   (IY+02) 
0B3E 20 1B        .    JR    NZ,0B5B    ; testen, ob printer da
0B40 ED A3       ..    OUTI             ; Ein Zeichen ausgeben
0B42 7A          z     LD    A,D 
0B43 D3 10       ..    OUT   (10),A     ; Printer Strobe an
0B45 7B          {     LD    A,E 
0B46 D3 10       ..    OUT   (10),A     ; printer Strobe aus
0B48 20 EC        .    JR    NZ,0B36    ; Naechstes Zeichen
0B4A 44          D     LD    B,H 
0B4B 4D          M     LD    C,L 
0B4C E1          .     POP   HL 
0B4D E5          .     PUSH  HL 
0B4E B7          .     OR    A          ; Anzahl Restzeichen --> BC
0B4F ED 42       .B    SBC   HL,BC 
0B51 E5          .     PUSH  HL 
0B52 C5          .     PUSH  BC 
0B53 E1          .     POP   HL 
0B54 C1          .     POP   BC 
0B55 20 DC        .    JR    NZ,0B33    ; Nochmal mit dem rest aufrufen
0B57 E1          .     POP   HL 
0B58 C1          .     POP   BC 
0B59 37          7     SCF              ; Alles uebernommen 
0B5A C9          .     RET              ;----------
0B5B CD 72 0B    .r.   CALL  0B72       ; test,. ob printer bereit
0B5E 28 E0       (.    JR    Z,0B40 
0B60 CD 72 0B    .r.   CALL  0B72 
0B63 28 DB       (.    JR    Z,0B40     
0B65 54          T     LD    D,H 
0B66 5D          ]     LD    E,L        
0B67 E1          .     POP   HL 
0B68 B7          .     OR    A 
0B69 ED 52       .R    SBC   HL,DE 
0B6B EB          .     EX    DE,HL 
0B6C E1          .     POP   HL         
0B6D ED 52       .R    SBC   HL,DE      ; Nicht alles uebernommen
0B6F 44          D     LD    B,H 
0B70 4D          M     LD    C,L 
0B71 C9          .     RET              ; ----------- "printerstatus" ----- 
0B72 DB 10       ..    IN    A,(10)     ; Status einlesen
0B74 FD A6 01    ...   AND   (IY+01)    ; Maskieren 
0B77 FD AE 02    ...   XOR   (IY+02)    ; Kanal 7..9 selektieren 
0B7A C9          .     RET              ;-------------- "frout" ------------ 
0B7B CD 72 0B    .r.   CALL  0B72       ; Puffer voll ?
0B7E CA 50 06    .P.   JP    Z,0650     ; Nein, kann 200 Zeichen uebernehmen 
0B81 B7          .     OR    A 
0B82 01 00 00    ...   LD    BC,0000    ; Druckerpuffer voll --> 0 Zeichen 
0B85 C9          .     RET              ;--------- Aufg. 5 -2 ------------- 
;================== Sonstige Shard-Routinen (Non I/O) =====================
0B86 C3 12 08    ...   JP    0812       ; Init Parameterkanal = Timerinit 
0B89 ED B0       ..    LDIR             ;------------ "LONGMOVE" ----------- 
0B8B C9          .     RET              ;------------- "LIMIT" ------------- 
0B8C 11 FF FF    ...   LD    DE,FFFF    ; Geht bis zum RAM-Ende
0B8F C9          .     RET              ;------------ "SCHINF" ------------- 
0B90 01 00 00    ...   LD    BC,0000    ; Kein Schattenspeicher vorhanden ? 
0B93 C9          .     RET              ;------------ "SCHACC" --------------
0B94 F5          .     PUSH  AF 
0B95 E5          .     PUSH  HL 
0B96 CB 2C       .,    SRA   H 
0B98 CB 1D       ..    RR    L 
0B9A 7D          }     LD    A,L 
0B9B CD AD 0B    ...   CALL  0BAD 
0B9E E1          .     POP   HL                           ?
0B9F 7D          }     LD    A,L 
0BA0 21 00 FC    !..   LD    HL,FC00 
0BA3 CB 47       .G    BIT   0,A 
0BA5 28 03       (.    JR    Z,0BAA 
0BA7 21 00 FE    !..   LD    HL,FE00 
0BAA F1          .     POP   AF 
0BAB C9          .     RET 
0BAC C9          .     RET              ; -----------"SYSEND"-------------- 
0BAD C9          .     RET              ; ----- SHARD-fehler melden ------ 
0BAE E1          .     POP   HL         ; Ruecksprungaddresse 
0BAF E3          .     EX    (SP),HL 
0BB0 21 CD 0B    !..   LD    HL,0BCD    ; Tabellenanfang Fehlernummer + text
0BB3 16 00       ..    LD    D,00 
0BB5 4E          N     LD    C,(HL)     ; Textnummer aus Tabelle 
0BB6 23          #     INC   HL 
0BB7 B9          .     CP    C          ; gesucht und gefunden ?
0BB8 28 09       (.    JR    Z,0BC3     ; Ja, gefunden. Nummer melden
0BBA 0C          .     INC   C          ; Naechste Fehlernummer
0BBB 28 06       (.    JR    Z,0BC3 
0BBD 23          #     INC   HL 
0BBE 5E          ^     LD    E,(HL) 
0BBF 23          #     INC   HL 
0BC0 19          .     ADD   HL,DE 
0BC1 18 F2       ..    JR    0BB5       ; Naechsten nehmen
0BC3 4E          N     LD    C,(HL)     ; Fehlernummer in BC
0BC4 06 00       ..    LD    B,00 
0BC6 23          #     INC   HL 
0BC7 E3          .     EX    (SP),HL    ; Zur Rueckspungaddresse
0BC8 E9          .     JP    (HL) 
0BC9 3E 09       >.    LD    A,09       ; Block zu hoch
0BCB 18 E1       ..    JR    0BAE       ; melden ------------------------
0BCD 01 01 09    ...   LD    BC,0901    ; #1 : "not ready", Typ 1
0BD0 6E          n     LD    L,(HL) 
0BD1 6F          o     LD    L,A 
0BD2 74          t     LD    (HL),H 
0BD3 20 72        r    JR    NZ,0C47 
0BD5 65          e     LD    H,L 
0BD6 61          a     LD    H,C        
0BD7 64          d     LD    H,H 
0BD8 79          y     LD    A,C 
0BD9 02          .     LD    (BC),A     ; #2 : "crc err". Typ 2
0BDA 02          .     LD    (BC),A 
0BDB 07          .     RLCA 
0BDC 63          c     LD    H,E 
0BDD 72          r     LD    (HL),D 
0BDE 63          c     LD    H,E        
0BDF 20 65        e    JR    NZ,0C46 
0BE1 72          r     LD    (HL),D     
0BE2 72          r     LD    (HL),D 
0BE3 03          .     INC   BC         ; #3 : "bad sect". Typ 2
0BE4 02          .     LD    (BC),A 
0BE5 08          .     EX    AF,AF' 
0BE6 62          b     LD    H,D 
0BE7 61          a     LD    H,C 
0BE8 64          d     LD    H,H 
0BE9 20 73        s    JR    NZ,0C5E 
0BEB 65          e     LD    H,L 
0BEC 63          c     LD    H,E 
0BED 74          t     LD    (HL),H 
0BEE 04          .     INC   B          ; #4 : "write fault". Typ 2
0BEF 02          .     LD    (BC),A 
0BF0 0B          .     DEC   BC 
0BF1 77          w     LD    (HL),A 
0BF2 72          r     LD    (HL),D 
0BF3 69          i     LD    L,C 
0BF4 74          t     LD    (HL),H 
0BF5 65          e     LD    H,L 
0BF6 20 66        f    JR    NZ,0C5E    
0BF8 61          a     LD    H,C 
0BF9 75          u     LD    (HL),L 
0BFA 6C          l     LD    L,H 
0BFB 74          t     LD    (HL),H 
0BFC 05          .     DEC   B          ; #5 : "busy". Typ 2
0BFD 02          .     LD    (BC),A 
0BFE 04          .     INC   B 
0BFF 62          b     LD    H,D        
0C00 75          u     LD    (HL),L 
0C01 73          s     LD    (HL),E     
0C02 79          y     LD    A,C        
0C03 06 02       ..    LD    B,02       ; #6 : "dma failed". Typ 2
0C05 0A          .     LD    A,(BC) 
0C06 64          d     LD    H,H 
0C07 6D          m     LD    L,L 
0C08 61          a     LD    H,C        
0C09 20 66        f    JR    NZ,0C71 
0C0B 61          a     LD    H,C        
0C0C 69          i     LD    L,C 
0C0D 6C          l     LD    L,H 
0C0E 65          e     LD    H,L 
0C0F 64          d     LD    H,H 
0C10 07          .     RLCA             ; #7 : "rec not fnd". Typ 2
0C11 02          .     LD    (BC),A 
0C12 0B          .     DEC   BC 
0C13 72          r     LD    (HL),D     
0C14 65          e     LD    H,L 
0C15 63          c     LD    H,E 
0C16 20 6E        n    JR    NZ,0C86 
0C18 6F          o     LD    L,A 
0C19 74          t     LD    (HL),H     
0C1A 20 66        f    JR    NZ,0C82 
0C1C 6E          n     LD    L,(HL) 
0C1D 64          d     LD    H,H 
0C1E 08          .     EX    AF,AF'     ; #8 : "timeout". Typ 2
0C1F 02          .     LD    (BC),A 
0C20 07          .     RLCA 
0C21 74          t     LD    (HL),H 
0C22 69          i     LD    L,C 
0C23 6D          m     LD    L,L        
0C24 65          e     LD    H,L 
0C25 6F          o     LD    L,A 
0C26 75          u     LD    (HL),L 
0C27 74          t     LD    (HL),H 
0C28 09          .     ADD   HL,BC      ; #9 : "block zu hoch". Typ 3
0C29 03          .     INC   BC 
0C2A 0D          .     DEC   C 
0C2B 62          b     LD    H,D 
0C2C 6C          l     LD    L,H 
0C2D 6F          o     LD    L,A 
0C2E 63          c     LD    H,E 
0C2F 6B          k     LD    L,E 
0C30 20 7A        z    JR    NZ,0CAC 
0C32 75          u     LD    (HL),L 
0C33 20 68        h    JR    NZ,0C9D 
0C35 6F          o     LD    L,A        
0C36 63          c     LD    H,E 
0C37 68          h     LD    L,B 
0C38 FF          .     RST   38         ; #255 : "wrg err code". Typ 1 
0C39 01 0C 77    ..w   LD    BC,770C 
0C3C 72          r     LD    (HL),D 
0C3D 67          g     LD    H,A 
0C3E 20 65        e    JR    NZ,0CA5 
0C40 72          r     LD    (HL),D 
0C41 72          r     LD    (HL),D 
0C42 20 63        c    JR    NZ,0CA7 
0C44 6F          o     LD    L,A 
0C45 64          d     LD    H,H 
0C46 65          e     LD    H,L 
;=============================== Semaphorhandler =========================== 
0C47 35          5     DEC   (HL)       ; --- Semaphor (HL) testen, warte -- 
0C48 34          4     INC   (HL) 
0C49 36 01       6.    LD    (HL),01    ; Semaphor belegen 
0C4B C8          .     RET   Z          ; unbeleget, return
0C4C E5          .     PUSH  HL         ; Register fuer 'warte' retten
0C4D DD E5       ..    PUSH  IX 
0C4F FD E5       ..    PUSH  IY 
0C51 C5          .     PUSH  BC 
0C52 D5          .     PUSH  DE 
0C53 F5          .     PUSH  AF 
0C54 CD 19 1E    ...   CALL  1E19       ; "warte" bis Semaphor frei
0C57 F1          .     POP   AF 
0C58 D1          .     POP   DE 
0C59 C1          .     POP   BC 
0C5A FD E1       ..    POP   IY 
0C5C DD E1       ..    POP   IX 
0C5E E1          .     POP   HL 
0C5F 18 E6       ..    JR    0C47      ; Semaphor jetzt frei ? 
0C61 36 00       6.    LD    (HL),00    ; -------- Sempahor freigeben ------ 
0C63 C9          .     RET 
;=========================== Kanalpuffer + Kanalstatusbytes ================ 
 
;----------------------------- Hintergrund Kanal 0 ------------------------
0C64 00                                 ; Hintergrund 
0C65 FF 43                              ; letzter EUMEL-Block (8,5MB)
0C67 00 00                              ; erster EUMEL-Block
 
;----------------------------- Serieller Kanal 1 ------------------------- 
0C69 FF                                 ; 100 Bytes Puffer fuer Kanal 1
     ... 
0CCC FF 
0CCD 01                           IY+00 ; Kanal 1 
0CCE 03                              01 ; Flusskontrollen Bits 
                                          BIT 0 : 
                                          BIT 1 : 0 = XOFF-Status, 1=XON
                                          BIT 2 : XON/XOFF bei receive
                                          BIT 3 : XON/XOFF bei transmit
0CCF 64                              02 ; Puffergroesse = 100 
0CD0 00                              03 ; Pufferzeiger Write
0CD1 00                              04 ; Pufferzeiger Read 
0CD2 00                              05 ; 
0CD3 69 0C                           06 ; 0C69 = Pufferanfang 
0CD5 7F                              08 ; AND-maske f. fehlerfreien receive 
0CD6 00                              09 ; Datenbitmaske XOR   "
0CD7 7F                              0A ; AND-maske f. fehlerhaften reiceive 
0CD8 00                              0B ; Datenbitmaske XOR  "
0CD9 7F                              0C ; Maske fuer Read aus Puffer AND
0CDA 00                              0D ;    "                       XOR
0CDB 3F        ?                     0E ; Zeichen fuer Fehlerhaften Receive 
0CDC 13                              0F ; 19 = Stop (XOFF)
0CDD 11                              10 ; 17 = Weiter (XON)
0CDE 02                              11 ; BIT 1 = 1 : Baudrateeinst. moegl. 
                                        ; BIT 0 = 1 : RTS/CTS 
0CDF 04                              12 ; AND-Maske Test Statusport (TxDfull)
0CE0 04                              13 ; XOR-Maske f. TxDfull (ggf invert.)
0CE1 00                              14 ; DTR/RTS - Bits im Register 5 (82H)
0CE2 00                              15 ; OR-Register fuer V24-Errors
0CE3 00                              16 ; AND-Maske fuer zulaessige Fehler
0CE4 C1                              17 ; Register 3 (Rxbits, Autoenables) 
0CE5 44                              18 ; Register 4 (Stopb., Clock, parity) 
0CE6 EA                              19 ; Register 5 (Txbits, RTS, DTR)
0CE7 1D                              1A ; Port Kanal 1 Status/Command
0CE8 1C                              1B ; Datenport Kanal 1 : DART Channel A
0CE9 0C                              1C ; BR-Generatorport: CTC1 - Kanal 0
0CEA 88                              1D ; Interruptvektor Kanal 1 
0CEB CD 56 04          CALL  0456       ; Transmitbuffer empty IRQ 
0CEE CD 6B 04          CALL  046B       ; External/Status Change IRQ 
0CF1 CD BA 04          CALL  04BA       ; Receive Character available IRQ 
0CF4 CD 85 04          CALL  0485       ; Special Receive condition IRQ
 
;----------------------------- Serieller Kanal 2 -------------------------- 
0CF7 FF                                 ; 100 Bytes Puffer Kanal 2 
     ...
0D5A FF 
0D5B 02                                 ; Kanal 2 
0D5C 03                                 ; Flusskontrollenbits
0D5D 64                                 ; 100 = Puffergroesse
0D5E 00 00 00                           ; Pufferzeiger
0D61 F7 0C                              ; 0CF7 = Pufferanfang Kanal 2
0D63 7F 00                              ; Masken fuer fehlerfreiene Receive
0D65 7F 00                              ;          "  fehlerhaften Receive 
0D67 7F 00                              ; Masken fuer read aus Puffer 
0D69 3F          ?                      ; Zeichen fuer fehlerhaften receive 
0D6A 13 11                              ; XOFF/XON Zeichen 
0D6C 02                                 ; Baudrateeinstellung moeglich 
0D6D 04 04                              ; Masken fuer Test Statusport:TxDfull
0D6F 00                                 ; DTR/RTS Bits in Register 5
0D70 00 00                              ; Masken fuer zulaessige Fehler 
0D72 C1 44 EA                           ; Register 3, 4, 5 Werte
0D75 1F                                 ; Port Kanal 2 Status / Command 
0D76 1E                                 ; Datenport Kanal 2 : DART Channel B 
0D77 0E                                 ; BR-Generatorport: CTC1 - Kanal 1
0D78 80                                 ; Interruptvektor Kanal 2
0D79 CD 56 04          CALL  0456       ; Interruptroutinen
0D7C CD 6B 04          CALL  046B 
0D7F CD BA 04          CALL  04BA 
0D82 CD 85 04          CALL  0485 
 
;------------------------------ Serieller kanal 3 -------------------------
0D85 FF                                 ; 100 Byte Datenpuffer (Senden)
     ... 
0DE8 FF 
0DE9 03                                 ; Kanal 3 
0DEA 03                                 ; Flusskontrollenbits 
0DEB 64                                 ; Puffergroesse 
0DEC 00 00 00                           ; Pufferzeiger
0DEF 85 0D                              ; Pufferanfang Kanal 3 : 0D85 
0DF1 7F 00                              ; Datenbitsmasken s.o
0DF3 7F 00                              ;   "
0DF5 7F 00                              ;   "
0DF7 3F        ?                        ; Zeichen bei fehlerhaftem Receive
0DF8 13 11                              ; XOFF/XON Zeichen 
0DFA 02                                 ; Baudrateeinstellung moeglich 
0DFB 04 04                              ; Masken fuer Test Statusport:TxDfull 
0DFD 00                                 ; DTR/RTS Bits in register 5 (82H) 
0DFE 00 00                              ; Masken fuer zulaessige Fehler 
0E00 C1 44 EA                           ; Register 3, 4, 5 Werte 
0E03 29                                 ; Port Kanal 3 Status / Command 
0E04 28                                 ; Datenport Kanal 3 : SIO 1 Channel A
0E05 32                                 ; BR-generatorport: CTC2 - Kanal 2 
0E06 98                                 ; Interruptvektor Kanal 3
0E07 CD 56 04          CALL  0456       ; Interruptroutinen
0E0A CD 6B 04          CALL  046B 
0E0D CD BA 04          CALL  04BA 
0E10 CD 85 04          CALL  0485 
 
;--------------------------------- Serieller Kanal 4 ----------------------- 
0E13 FF                                 ; 100 Bytes Kanalpuffer 
     ... 
0E76 FF 
0E77 04                                 ; Kanal 4 
0E78 03                                 ; Flusskontrollenbits 
0E79 64                                 ; Puffergroesse 
0E7A 00 00 00                           ; Pufferzeiger 
0E7D 13 0E                              ; Pufferanfang Kanal 4 : 0E13
0E7F 7F 00                              ; Datenbitmasken s.o. 
0E81 7F 00 
0E83 7F 00 
0E85 3F          ?                      ; Zeichen bei fehlerhaften Receive 
0E86 13 11                              ; XOFF/XON Zeichen 
0E88 02                                 ; Baudrateeinstellung moeglich 
0E89 04 04                              ; Masken fuer TxDfull Status 
0E8B 00                                 ; RTS/DTR Bits (82H) 
0E8C 00 00                              ; Masken fuer zulaessige Fehler 
0E8E C1 44 EA                           ; Register 3, 4, 5 Werter 
0E91 2B                                 ; Port Kanal 4 Status/Command 
0E92 2A                                 ; Datenport kanal 4 : SIO 1 Channel B
0E93 31                                 ; BR-Generatorport: CTC2 - Kanal 1
0E94 90                                 ; Interruptvektor Kanal 4
0E95 CD 56 04          CALL  0456       ; Interruptroutinen 
0E98 CD 6B 04          CALL  046B 
0E9B CD BA 04          CALL  04BA 
0E9E CD 85 04          CALL  0485 
 
;-------------------------------- Serieller Kanal 5 -----------------------
0EA1 FF                                 ; 100 Bytes Ausgabepuffer
     ... 
0F04 FF 
0F05 05                                 ; Kanal 5 
0F06 03                                 ; Flusskontrollenbits 
0F07 64                                 ; Puffergroesse 
0F08 00 00 00                           ; Pufferzeiger 
0F0B A1 0E                              ; Pufferanfang : 0EA1 
0F0D 7F 00                              ; Datenbitmasken s.o. 
0F0F 7F 00                              ;   "
0F11 7F 00                              ;   " 
0F13 3F          ?                      ; Zeichen fuer fehlerhaften Receive
0F14 13 11                              ; XOFF/XON Zeichen 
0F16 02                                 ; Baudrateeinstellung moeglich 
0F17 04 04                              ; Maskenbits fuer Status TxDfull
0F19 00                                 ; RTS/DTR Bits (82H) 
0F1A 00 00                              ; Masken fuer zulaessige fehler 
0F1C C1 44 EA                           ; Register 3, 4, 5 Werte 
0F1F 2D                                 ; Port Kanal 5 Status / Command 
0F20 2C                                 ; Datenport kanal 5 : SIO 2 Channel A
0F21 30                                 ; BR-Generatorport: CTC2 - Kanal 0
0F22 A8                                 ; Interruptvektor Kanal 5 
0F23 CD 56 04          CALL  0456       ; Interruptroutinen
0F26 CD 6B 04          CALL  046B 
0F29 CD BA 04          CALL  04BA 
0F2C CD 85 04          CALL  0485 
 
;--------------------------- Serieller kanal 6 ---------------------------- 
0F2F FF                                 ; 100 Bytes ausgabepuffer 
     ... 
0F92 FF 
0F93 06                                 ; Kanal 6 
0F94 03                                 ; Flusskontrollenbits
0F95 64                                 ; Puffergroesse
0F96 00 00 00                           ; Pufferzeiger 
0F99 2F 0F                              ; Pufferanfang Kanal 6 : 0F2F 
0F9B 7F 00                              ; Datenbitmasken s.o. 
0F9D 7F 00                              ;      " 
0F9F 7F 00                              ;      " 
0FA1 3F          ?                      ; Zeichen fuer fehlerhaften Receive
0FA2 13 11                              ; XOFF/XON Zeichen 
0FA4 02                                 ; Baudrateeinstellung moeglich 
0FA5 04 04                              ; Maskenbits Status TxDfull 
0FA7 00                                 ; RTS/DTR Bits in Register 5 
0FA8 00 00                              ; Masken fuer zulaessige Fehler 
0FAA C1 44 EA                           ; Register 3, 4, 5 Werte 
0FAD 2F                                 ; Port Kanal 6 : Status / Command 
0FAE 2E                                 ; Datenport kanal 6 : SIO 2 Channel B
0FAF 31                                 ; BR-Generatorport : CTC2 - Kanal 1 
0FB0 A0                                 ; Interruptvektor kanal 6 
0FB1 CD 56 04          CALL  0456       ; Interruptroutinen
0FB4 CD 6B 04          CALL  046B 
0FB7 CD BA 04          CALL  04BA 
0FBA CD 85 04          CALL  0485 
 
;------------------------------- Parallelkanal 7 --------------------------
0FBD 07                                 ; Kanal 7 
0FBE 20                                 ; AND-Maske fuer Printerbusy
0FBF 00                                 ; XOR-Maske f. Printer 0 busy
0FC0 FE                                 ; AND-Maske fuer Printerstrobe
0FC1 00                                 ; XOR-Maske1 fuer Printerstrobe an
0FC2 01                                 ; XOR-Maske2 fuer Printerstrobe aus
 
;------------------------------- Parallel Kanal 8 ------------------------- 
0FC3 08                                 ; Kanal 8 
0FC4 40                                 ; AND-Maske fuer Printerbusy
0FC5 00                                 ; XOR-Maske fuer Printer 1 busy
0FC6 FD                                 ; AND-Maske fuer Printerstrobe
0FC7 00                                 ; XOR-Maske1 fuer Printerstrobe an
0FC8 02                                 ; XOR-Maske2 fuer Printerstrobe aus
 
;------------------------------ Parallel kanal 9 -------------------------- 
0FC9 09                                 ; Kanal 9 
0FCA 80                                 ; AND-Maske f. Printerbusy
0FCB 00                                 ; XOR-Maske f. Printer 2 busy
0FCC FB                                 ; AND-Maske fuer Printerstrobe
0FCD 00                                 ; XOR-Maske1 fuer Printerstrobe an
0FCE 04                                 ; XOR-maske2 fuer Printerstrobe aus
 
;----------------------------- Floppy Kanal 31 ---------------------------- 
0FCF 1F                                 ; Kanal 31 
0FD0 00                                 ; IY+00
0FD1 00                                 ; IY+01 FDC-AND-Maske Status-ready
0FD2 00                                 ; 02 FDC-Kommando Read/Write
0FD3 00                                 ; 03
0FD4 00                                 ; 04 
0FD5 00                                 ; 05 : Returncode aus Floppy-IRQ
0FD6 00                                 ; 06 : Alter Sektor 
0FD7 00                                 ; 07
0FD8 04                                 ; 08
0FD9 FF                                 ; 09 Floppydrive (f. Headselect)
0FDA 00                                 ; 0A  - 46H = "F"
;============================== SHARD ENDE ================================= 
