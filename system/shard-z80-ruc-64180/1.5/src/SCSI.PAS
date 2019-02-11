{---------------------- Include File fuer SCSI-Routinen ---------------------
  Michael Staubermann, 27.06.86, Version 1.1, ohne DMA

  Die CIO (Kanal A) muss fuer SCSI initialiert worden sein (BIOS macht das)

  Prozeduren/Funktionen :

  FUNCTION port0 (portnr : INTEGER) : BYTE ;
    Liest des Port mit Addressbits A8..A15 = 0

  PROCEDURE port0out (portnr, wert : INTEGER) ;
   Schreibt den 'wert' in den Port mit A8..A15 = 0

  PROCEDURE scsiio (VAR datenbereich ; kommando : KOMMANDOTYPE ;
                    datenlaenge : INTEGER) ;
   SCSI-Controller fuehrt das Kommando aus, Je nach Eingabe oder Ausgabe
   wird der Datenbereich gelesen oder beschrieben. Es ist sichergestellt,
   das nicht mehr als 'datenlaenge' Bytes in 'datenbereich' geschrieben
   werden.

 PROCEDURE floppy_init ;
  Initialisiert den Controller fuer 512 Byte/Sektor, 9 Sektoren, 2*80 Track
  Floppy-Format (720K, grosses IBM-Format)

 PROCEDURE fd_read (VAR datenbereich ; blocknummer, sektoren : INTEGER) ;
  Liest mehrere ('sektoren') 512-Byte Sektoren ab der (SCSI-) Blocknummer
  von der Floppy. Der 'datenbereich' muss 512 * 'sektoren' Bytes fassen koennen.

 PROCEDURE fd_write (VAR datenbereich ; blocknummer, sektoren : INTEGER) ;
  Wie fd_read, schreibt aber auf die Floppy.

 PROCEDURE hd_read (VAR datenbereich ; blocknummer, sektoren : INTEGER) ;
  Wie fd_read, liest aber 256-Byte Sektoren von der Harddisk. Der
  'datenbereich' muss 256 * 'sektoren' Bytes fassen koennen.

 PROCEDURE hd_write (VAR datenbereich ; blocknummer, sektoren : INTEGER) ;
  Wie hd_read, schreibt aber auf die Harddisk.

 FUNCTION scsi_blocknummer (eumel_blocknummer : INTEGER) : INTEGER ;
  Aus der EUMEL-Blocknummer wird die SCSI-Blocknummer berechnet. EUMEL
  behandelt im Gegensatz zum SCSI-Controller, erst die Oberseite und dann
  die Unterseite der Floppy. Da die EUMEL-Sektoren nicht SCSI-physisch
  hintereinander zu liegen brauchen, sollte man mehrere Sektoren nicht
  mit einer 'sektoren'-Angabe groesser '1' lesen, sondern in einer Schleife
  jede Blocknummer neu berechnen und dann einlesen.


-----------------------------------------------------------------------------}


TYPE KOMMANDOTYPE = ARRAY[1..6] OF BYTE ;
     STRING77 = STRING[77] ;

FUNCTION port0 (portnr : INTEGER) : BYTE ;
 BEGIN
  INLINE (6/0) ; { B-Register 0 }
  port0 := port[portnr]
 END ;


PROCEDURE port0out (portnr, wert : INTEGER) ;
 BEGIN
  INLINE (6/0) ;
  port[portnr] := wert
 END ;


PROCEDURE scsiio (VAR datenbereich ; kommandobereich : KOMMANDOTYPE ;
                  datenlaenge : INTEGER) ;
 VAR i, status : INTEGER ;
     statusbereich : ARRAY[1..4] OF BYTE ;
     request_status : KOMMANDOTYPE ;


PROCEDURE fehler (meldung : STRING77) ;
 BEGIN
  writeln ('SCSI-Fehler: ', meldung) ;
  halt
 END ;


procedure writehex(b:byte);
var b1:byte;
procedure writenibble(b:byte);
   begin
     b:=b+$30;
     if(b>$39) then b:=b+7;
     write(chr(b))
   end;
begin
  b1:=b shr 4;  writenibble(b1);
  b1:=b and $0f;writenibble(b1);
end;

FUNCTION scsi2 (VAR datenbereich ; kommandobereich : KOMMANDOTYPE ;
                 datenlaenge : INTEGER) : INTEGER ;
CONST scsiport = $80 ;
      cioad    = $52 ;
      dstat    = $30 ;

VAR addresse, ciowert : INTEGER ;


 PROCEDURE check_request ; { Auf Busyende warten }
  BEGIN
   REPEAT
    ciowert := port0 (cioad) ;
{    IF (ciowert AND 8) = 0
      THEN fehler ('vorzeitiges Ende') }
   UNTIL (ciowert AND $80) = $80 ;
   ciowert := ciowert AND $34
  END ;


PROCEDURE scsitrans (address,  datenlaenge : INTEGER) ;
 BEGIN
  INLINE($ED/$4B/datenlaenge/      { LD BC,(datenlaenge) }
         $ED/$6B/address/          { LD HL,(address)     }
         $ED/$38/$52/              { IN0 A,(CIOAD)       }
         $CB/$7F/                  { BIT 7,A             }
         $28/$F9/                  { JR Z,F9H            }
         $E6/$34/                  { AND 34H             }
         $CB/$6F/                  { BIT 5,A             }
         $C0/                      { RET NZ              }
         $CB/$57/                  { BIT 2,A             }
         $20/$06/                  { JR NZ,rdscsi        }
         $7E/                      { LD A,(HL)           }
         $ED/$39/$80/              { OUT0 (SCSIP),A      }
         $18/$04/                  { JR cmdio            }
         $ED/$38/$80/              { rdscsi:IN0 A,(SCSIP)}
         $77/                      { LD (HL),A           }
         $ED/$A1/                  { cmdio: CPI   = DEC BC, INC HL PE:BC=0 }
         $EA/*-$1D)                { JP PE,*-   }
                                   { nodat: RET }
 END { scsitrans } ;


BEGIN { scsi2 }

 { Controller selektieren }
 ciowert := port0 (cioad) ;
 port0out (cioad, ciowert OR 2) ;
 port0out (cioad, ciowert AND $FB) ;

 { Auf Kommandoanforderung warten }
 WHILE (port0 (cioad) AND $B4) <> $A0 DO ; { warten, ggf Timeout testen }

 { Kommando ausgeben }
 FOR i := 1 TO 6 DO
  BEGIN
   check_request ;
   port0out (scsiport, kommandobereich[i])
  END ;

 { Datenphase ohne DMA }
 scsitrans (addr (datenbereich), datenlaenge) ;

 { Status abholen }
 check_request ;
 IF ciowert <> $24
    THEN BEGIN
     REPEAT
      ciowert := port0 (scsiport) ;
      check_request ;
     UNTIL ciowert <> $04 ;
     scsi2 := $FF ; { SCSI-Fehler }
     END
    ELSE scsi2 := port0 (scsiport) ; { Status }
 check_request ;
 i := port0 (scsiport) ; { zweites Statusbyte immer 00 }

END { scsi2 } ;


 BEGIN { scsiio }
  status := scsi2 (datenbereich, kommandobereich, datenlaenge) ;
  IF (status AND $9F) = $02
     THEN BEGIN
      fillchar (request_status, sizeof(request_status), 0) ;
      request_status [1] := 3 ;
      request_status [2] := status AND $60 ;
      status := scsi2 (statusbereich, request_status, sizeof (statusbereich)) ;
      write ('SCSI-Fehler: ') ;
      FOR i := 1 TO sizeof (statusbereich) DO
       BEGIN
        writehex (statusbereich[i]) ;
        write (' ')
       END ;
      halt
      END
     ELSE IF (status AND $9F) <> 0
           THEN fehler ('Daten nicht ganz uebertragen')
 END ;


TYPE INITDATATYPE = ARRAY[1..10] OF BYTE ;
CONST floppy_write  : KOMMANDOTYPE = ($0A, $40, 0, 0, 0, 0) ;
      floppy_read   : KOMMANDOTYPE = ($08, $40, 0, 0, 0, 0) ;
      harddisk_write: KOMMANDOTYPE = ($0A, $00, 0, 0, 0, 0) ;
      harddisk_read : KOMMANDOTYPE = ($08, $00, 0, 0, 0, 0) ;
      fd_initialize : KOMMANDOTYPE = ($0B, $40, 0, 0, 0, 0) ;

      floppy_daten :  INITDATATYPE = (0, 80, 2, $13, 3, 30, 50, 23, 50, 1) ;
                      { 9 Sektoren/Track, 80 Tracks, 512 Byte/Sektor }

PROCEDURE floppy_init ;
 VAR init_daten : INITDATATYPE ;
 BEGIN
  init_daten := floppy_daten ;
  scsiio (init_daten, fd_initialize, sizeof (init_daten))
 END ;


PROCEDURE fd_write (VAR datenbereich ; blocknummer, sektoren : INTEGER) ;
 VAR command : KOMMANDOTYPE ;
 BEGIN
  command := floppy_write ;
  command[3] := hi (blocknummer) ;
  command[4] := lo (blocknummer) ;
  command[5] := sektoren ;
  scsiio (datenbereich, command, sektoren * 512) ;
 END ;


PROCEDURE hd_write (VAR datenbereich ; blocknummer, sektoren : INTEGER) ;
 VAR command : KOMMANDOTYPE ;
 BEGIN
  command := harddisk_write ;
  command[3] := hi (blocknummer) ;
  command[4] := lo (blocknummer) ;
  command[5] := sektoren ;
  scsiio (datenbereich, command, sektoren * 256) ;
 END ;


PROCEDURE fd_read (VAR datenbereich ; blocknummer, sektoren : INTEGER) ;
 VAR command : KOMMANDOTYPE ;
 BEGIN
  command := floppy_read ;
  command[3] := hi (blocknummer) ;
  command[4] := lo (blocknummer) ;
  command[5] := sektoren ;
  scsiio (datenbereich, command, sektoren * 512)
 END ;


PROCEDURE hd_read (VAR datenbereich ; blocknummer, sektoren : INTEGER) ;
 VAR command : KOMMANDOTYPE ;
 BEGIN
  command := harddisk_read ;
  command[3] := hi (blocknummer) ;
  command[4] := lo (blocknummer) ;
  command[5] := sektoren ;
  scsiio (datenbereich, command, sektoren * 256)
 END ;


FUNCTION floppy_blocknummer (eumel_blocknummer : INTEGER) : INTEGER ;
 VAR track, sektor : INTEGER ;
 BEGIN
  track := eumel_blocknummer DIV 9 ;
  sektor := eumel_blocknummer MOD 9 ;
  IF track >= 80 { Rueckseite }
   THEN BEGIN
    track := track - 80 ;
    sektor := sektor + 9
   END ;
  floppy_blocknummer := track * 18 + sektor
 END ;


