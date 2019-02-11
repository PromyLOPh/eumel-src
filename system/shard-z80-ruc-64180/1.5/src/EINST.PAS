PROGRAM installieren_des_eumel_shards ;
{$U-}

CONST vers        = '2.1 vom 22.01.87' ;
      shard_file  = 'EUMEL.COM' ;
      floppy_boot_file = 'FBOOT.COM' ;
      conf_offset = $37 ;  { Anfang ohne LOAD-Modul (phys.-Adr $00000) }

{ 2.1: 22.01.87 mit Pascal SCSI-Routinen & Konfiguration }

{$I SCSI.PAS}

TYPE SECTOR   = ARRAY[0..255] OF BYTE ;

     FLAGTYPE = SET OF (x0, x1, x2, x3, autoboot, curvol, b64180, b6502) ;

     IDTYPE   = (free, ucsd, dos, cpm, prodos, id5, eumel, id7,
                 id8, id9, id10, id11, id12, id13, id14, spare) ;

     STRING15 = STRING[15] ;

     LUN      = RECORD
                 drive, high, low : BYTE
                END ;

     DISKENTRYTYPE = RECORD
               entrylength : BYTE ;
               first_block : LUN ;
               reserved    : BYTE ;
               last_block  : LUN ;  { exclusiv }
               params      : ARRAY [0..7] OF BYTE ;
               name        : STRING15 ;
               volumes     : BYTE ; { Anzahl Volumes }
               autoboot    : CHAR ; { Volumekennzeichen fuer Autoboot }
               waittime    : INTEGER ; { Wartezeit vor Autoboot in 1.46ms }
              END ;

     VOLUMEENTRYTYPE = RECORD
               flags : FLAGTYPE ;
               first : LUN ;
               kz    : CHAR ; { Kennzeichen in der VOLTAB }
               last  : LUN ; { Letzer Block exclusiv }
               params: ARRAY[0..7] OF BYTE ;
               name  : STRING15 ;
               loadpage : BYTE ; { Highbyte Ladeadresse im 6502-Memory }
               jumppage : BYTE ; { Highbyte Startadresse im 6502-Memory }
               pages : BYTE ; { Anzahl zu ladender Seiten }
               volid : IDTYPE ;
              END ;

VAR f          : FILE ;
    floppy_version : BOOLEAN ;
    shard_size, volume : INTEGER ;
    volume_name, scsi_floppy : STRING15 ;
    buffer     : ARRAY[0..$3F] OF SECTOR ;
    boot_buffer: ARRAY[0..15] OF SECTOR ;
    conf       : RECORD
                  offset  : ARRAY[1..conf_offset] OF BYTE ;
                  umsch   : ARRAY[1..8] OF BYTE ;
                  blinkp  : BYTE ;    { Cursor Blinkfrequenz in 50ms }
                  beepfreq: BYTE ;    { Kanal 1: Beepfrequenz }
                  arc31   : LUN ;     { SCSI-Floppy LUN }
                  mode    : INTEGER ; { EUMEL-MODE-Word }
                  id4     : INTEGER ; { Lizenznummer des SHards }
                  id5     : INTEGER ; { Installationsnummer des SHards }
                  id6     : INTEGER ; { Reserviert fuer SHard }
                  urlk1   : BYTE ;    { Primaerer Urladerkanal }
                  urlk2   : BYTE ;    { Sekundaerer Urladerkanal }
                  free    : BYTE ;
                  irqvecs : ARRAY[1..$40] OF BYTE ; { Interruptvektoren }
                  ikantab : ARRAY[0..7] OF BYTE ;   { phys. --> log. Kanalnr. }
                  kantab  : ARRAY[0..32] OF BYTE ;  { log. --> phys. Kanalnr. }
                  ioftb   : ARRAY[0..31] OF BYTE ;  { 'typ'-Bits der Kanaele }
                  cpmofs  : LUN ; { LUN & Anfangs-Adr. eines CP/M-Volumes }
                  cpmlast : LUN ; { LUN & Endadr. (excl.) eines CP/M-Volumes }
                 END ABSOLUTE buffer ;

    superdirectory :
                 RECORD
                  diskentry   : DISKENTRYTYPE ;
                  volumeentry : ARRAY[1..26] OF VOLUMEENTRYTYPE ;
                 END ;



PROCEDURE errorstop (message : STRING77) ;
 BEGIN
  writeln ;
  writeln (#7, 'FEHLER: ', message) ;
  halt
 END { errorstop } ;


FUNCTION yes (question : STRING77) : BOOLEAN ;
 VAR zeichen : CHAR ;
 CONST answer : SET OF CHAR = ['y', 'Y', 'n', 'N', 'j', 'J'] ;
 BEGIN
  WHILE keypressed DO read (KBD, zeichen) ; { empty buffer }
  write (question, ' (j/n) ? ') ;
  REPEAT
   read (KBD, zeichen) ;
   IF zeichen = #27 THEN errorstop ('Abbruch mit ESC') ;
   IF NOT (zeichen IN answer)
      THEN write (#7)
      ELSE writeln (zeichen)
  UNTIL zeichen IN answer ;
  yes := zeichen IN ['y', 'Y', 'j', 'J']
 END { yes } ;


FUNCTION txt (nr : INTEGER) : STRING15 ;
 VAR result : STRING15 ;
 BEGIN
  str (nr, result) ;
  txt := result
 END { txt } ;


PROCEDURE shard_lesen ;
 BEGIN
  fillchar (buffer, sizeof (buffer), 0) ;
  assign (f, shard_file) ;
  reset (f) ;
  shard_size := filesize (f) ;
  blockread (f, buffer, shard_size) ;
  close (f) ;
  IF (shard_size < 3) OR (shard_size > 2 * $3F)
     THEN errorstop ('Die Datei ' + shard_file + ' ist inkonsistent!')
 END { shard_lesen } ;


PROCEDURE shard_schreiben ;
 VAR eumel_track : INTEGER ;
 BEGIN
  WITH superdirectory.volumeentry[volume].first DO BEGIN
   eumel_track := low DIV 32 + high * 8 + (drive AND $3F) * 2048
  END ;
  hd_write (buffer, eumel_track * 32, 32) ;
  hd_write (buffer[32], succ (eumel_track) * 32, 32)
 END { shard_schreiben } ;


PROCEDURE eumel_volume_suchen ;
 VAR name : STRING[255] ;
 BEGIN
  volume := 1 ;
  WITH superdirectory DO BEGIN

    WHILE volume <= diskentry.volumes DO BEGIN
      IF volumeentry[volume].volid = eumel
         THEN IF yes ('SHard auf Volume "' + volumeentry[volume].name +
                      '" installieren')
                 THEN exit ;
      volume := succ (volume) ;
    END { WHILE } ;
    writeln ('Kein (weiteres) EUMEL-Volume gefunden.') ;

    IF yes ('Soll ein anderes Volume zu einem EUMEL-Volume werden')
       THEN BEGIN
         volume := 1 ;
         WHILE volume <= diskentry.volumes DO BEGIN
           IF volumeentry[volume].volid <> spare
              THEN IF yes ('SHard auf Volume "' + volumeentry[volume].name +
                           '" installieren')
                      THEN BEGIN
                        IF yes ('Volumename aendern')
                           THEN BEGIN
                             write ('Neuer Volumename: ') ;
                             REPEAT
                               readln (name) ;
                               IF length (name) > 15
                                  THEN writeln ('Zu lang!')
                             UNTIL (name <> '') AND (length (name) < 16) ;
                             volumeentry[volume].name := name ;
                        END ;
                        exit ;
                   END ;
           volume := succ (volume)
         END { WHILE } ;
         writeln ('Kein (weiteres) Volume gefunden.') ;
    END { IF } ;
    writeln ('Installation abgebrochen.') ;
    halt

  END { WITH }
 END { eumel_volume_suchen } ;


PROCEDURE superdirectory_lesen ;
 BEGIN
  hd_read (superdirectory, 2, 4) ;
 END { superdirectory_lesen } ;


PROCEDURE superdirectory_schreiben ;
 BEGIN
  WITH superdirectory.volumeentry[volume] DO BEGIN
   flags := [b64180] ; (* Boot in 64180-Code geschrieben *)
   loadpage := $10 ;
   jumppage := loadpage ;
   pages    := $3F ; (* Da $40 nicht geht (Timeout auf Cylindergrenze) *)
   volid    := eumel ;
  END ;

  hd_write (superdirectory, 2, 4)
 END { superdirectory_schreiben } ;


FUNCTION sector_write (trk, sec, adr : INTEGER) : BOOLEAN ;
BEGIN
  bios (9, trk) ;
  bios (10, sec) ;
  bios (11, adr) ;
  sector_write := (bios (13, 0) = 0) ;
END ;


PROCEDURE shard_auf_floppy_schreiben ;
 VAR trk, sec, curdrv, drive : INTEGER ;
     zeichen : CHAR ;
 BEGIN
  fillchar (boot_buffer, sizeof (boot_buffer), 0) ;
  assign (f, floppy_boot_file) ;
  reset (f) ;
  blockread (f, boot_buffer, filesize (f)) ; { max. 4k Boot }
  close (f) ;

  boot_buffer[0][$FF] := 0 ;
  WHILE boot_buffer[0][$FF] = 0 DO BEGIN
        IF yes ('2 * 80 Track (Erphi) Format') THEN boot_buffer[0][$FF] := $E0
   ELSE IF yes ('1 * 35 Track (Apple) Format') THEN boot_buffer[0][$FF] := $81
   ELSE IF yes ('2 * 80 Track (Ehring) Format')THEN boot_buffer[0][$FF] := $A0 ;
  END ;

  curdrv := bdos (25, 0) ; { current_drive }
  drive := curdrv ;

  write ('Floppy-Drive (Abbruch mit ESC): ', chr (drive + 65), #8) ;
  REPEAT
   read (KBD, zeichen) ;
   IF zeichen = #27
      THEN errorstop ('Abbruch mit ESC') ;
   zeichen := upcase (zeichen) ;
   IF NOT (zeichen IN ['A'..'P'])
      THEN write (#7)
      ELSE writeln (zeichen)
  UNTIL zeichen IN ['A'..'P'] ;
  drive := ord (zeichen) - 65 ;

  IF drive = curdrv
     THEN REPEAT UNTIL yes ('(Leere) Destinationdiskette eingelegt') ;

  writeln ;
  bios (8, drive) ; { Select Floppy Drive }

  FOR sec := 0 TO 15 DO  { Floppy-Boot/Taskloop schreiben }
   IF NOT sector_write (0, sec, addr (boot_buffer [sec]))
      THEN BEGIN
            bios (8, curdrv) ;
            errorstop ('Schreibfehler auf Drive ' + zeichen +
                       ':, Track 0, Sektor ' + txt (sec))
           END ;
  FOR trk := 1 TO 4 DO  { SHard schreiben }
   FOR sec := 0 TO 15 DO
    IF NOT sector_write (trk, sec, addr (buffer [sec + pred(trk) * 16]))
       THEN BEGIN
             bios (8, curdrv) ;
             errorstop ('Schreibfehler auf Drive ' + zeichen + ':, Track ' +
                        txt (trk) + ', Sektor ' + txt (sec))
            END ;

  bios (8, curdrv) ; { Select previous Drive }

 END ;


PROCEDURE cpm_volume_suchen ;
 BEGIN
  WITH superdirectory DO BEGIN
   REPEAT
    volume := 1 ;
    WHILE volume < diskentry.volumes DO BEGIN
     IF volumeentry[volume].volid = cpm
        THEN IF yes (volumeentry[volume].name)
                THEN exit ;
     volume := succ (volume) ;
    END
   UNTIL yes ('Kein (weiteres) Volume gefunden, erstes Volume nehmen') ;
   volume := 1 ;
   writeln ('Volume "', volumeentry[volume].name, '" wird angenommen.') ;
  END
END { cpm_volume_suchen } ;


PROCEDURE kanalzuordnungen ;
 VAR i, j, channel : INTEGER ;
     ok : BOOLEAN ;

FUNCTION kanal_erfragen (log : INTEGER) : INTEGER ;
 VAR channel : INTEGER ;
 BEGIN
  REPEAT
   channel := 255 ;
   write (' ':77, #13) ;
   write ('Logischer Kanal ', log:2, ' ---> physischer Kanal: -'#8) ;
   buflen := 2 ;
   read (channel) ;
   write (#13) ;
  UNTIL ((channel >= 0) AND (channel < 7)) OR
        ((channel >= 28) AND (channel < 32)) OR
        (channel = 255) ;
  kanal_erfragen := channel
 END ;

PROCEDURE message (msg : STRING77) ;
 VAR zeichen : CHAR ;
 BEGIN
  write (#13, ' ', msg, ' - Taste -'#13) ;
  read (KBD, zeichen)
 END { message } ;

 BEGIN { kanalzuordnungen }
  REPEAT
  clrscr ;
  writeln ('--- Zuordnung der logischen/physischen Kanaele ---') ;
  writeln ;
  writeln ('Den logischen Kanaelen werden physische Kanaele zugeordnet,') ;
  writeln ('dabei sind folgende Einschraenkungen zu beachten:') ;
  writeln ('- Kanal 0 und 31 muessen als Blockkanal definiert werden.') ;
  writeln ('- Kanal 1 muss als Streamkanal definiert werden (Systemstart).') ;
  writeln ('- Kein physischer Kanal darf mehrfach zugeordnet werden.') ;
  writeln ;
  writeln ('Folgende physische Kanaele stehen zur Verfuegung:') ;
  writeln ;
  writeln ('Streamkanaele:                     Blockkanaele:') ;
  writeln ('--------------                     -------------') ;
  writeln ('1 ... Basis  - Konsole              0 ... SCSI  - Harddisk #0') ;
  writeln ('2 ... ruc180 - Serielle B         ( 1 ... Basis - Graphikkonsole)') ;
  writeln ('3 ... ruc180 - Serielle A          28 ... SCSI  - Volume "', volume_name, '"') ;
  writeln ('4 ... ruc180 - Centronics          29 ... Basis - Diskdrive 1') ;
  writeln ('5 ... Basis  - Serielle            30 ... Basis - Diskdrive 0') ;
  writeln ('6 ... Basis  - Centronics          31 ... SCSI  - ', scsi_floppy) ;
  writeln ;
  conf.kantab[32] := 32 ; { Parameterkanal }
  writeln ;
   FOR i:= 0 TO 31 DO BEGIN
    REPEAT
     REPEAT
      channel := kanal_erfragen (i) ;
      ok := FALSE ;
      IF channel = 255
         THEN IF (i = 0) OR (i = 1) OR (i = 31)
                 THEN message ('Kanal 0, 1 und 31 muessen definiert werden!')
                 ELSE ok := TRUE
         ELSE IF ((i = 0) OR (i = 31)) AND
                 ((conf.ioftb[channel] AND 12) <> 12)
                 THEN message ('Kanal ' + txt (i) + ' muss ein Blockkanal (0, 28..31) sein!')
                 ELSE IF (i = 1) AND ((conf.ioftb[channel] AND 3) <> 3)
                         THEN message ('Kanal 1 muss ein Stream I/O-Kanal sein!')
                         ELSE ok := TRUE
     UNTIL ok ;
     IF channel <> 255
        THEN BEGIN
         j := 0 ;
         WHILE (j < i) AND (conf.kantab[j] <> channel) DO j := succ (j) ;
         IF j < i
            THEN message ('Der phys. Kanal ' + txt(channel) +
                          ' wurde schon dem log. Kanal ' + txt (j) +
                          ' zugeordnet!') ;
     END ;
    UNTIL (j = i) OR (channel = 255) ;
    conf.kantab[i] := channel ;         { Zuordnung log. --> phys. }
    IF channel < 7
       THEN conf.ikantab[channel] := i ; { Zuordnung phys. --> log. }
   END ;

   clrscr ;
   writeln ('So sind die physischen Kanaele den logischen Kanaelen zugeordnet:') ;
   FOR i:= 0 TO 31 DO BEGIN
    gotoxy (succ ((i DIV 16) * 40), 3 + (i MOD 16)) ;
    write (i:2, ': ') ;
    CASE conf.kantab[i] OF
      0 : write ('SCSI   - Harddisk #0') ;
      1 : write ('Basis  - Konsole') ;
      2 : write ('ruc180 - Serielle B') ;
      3 : write ('ruc180 - Serielle A') ;
      4 : write ('ruc180 - Centronics') ;
      5 : write ('Basis  - Serielle') ;
      6 : write ('Basis  - Centronics') ;
     28 : write ('SCSI   - Volume "', volume_name, '"') ;
     29 : write ('Basis  - Diskdrive 1') ;
     30 : write ('Basis  - Diskdrive 0') ;
     31 : write ('SCSI   - ', scsi_floppy) ;
    255 : write ('       -')
    END { CASE } ;
   END ;
   writeln ;
   writeln ;

  UNTIL yes ('Alle Kanal-Zuordnungen korrekt') ;
END { kanalzuordnungen } ;


PROCEDURE konfigurieren ;
 VAR freq : REAL ;
 BEGIN
  writeln ;
  writeln ('************************* Systemstart - Parameter ************************') ;
  writeln ;

  IF yes ('EUMEL-Vortest beim Systemstart')
     THEN IF NOT yes ('Speichertest durchfuehren')
             THEN conf.mode := $0100
             ELSE conf.mode := 0
     ELSE conf.mode := $0200 ;
  writeln ;

  conf.urlk1 := 31 ;
  conf.urlk2 := 0 ;
  IF NOT yes ('Soll der Urlader zuerst auf dem Archivkanal gesucht werden')
     THEN BEGIN
      conf.urlk1 := 0 ;
      conf.urlk2 := 31
  END ;
  writeln ;

  writeln ('**************** Parameter der Konsole (phys. Kanal 1) ******************') ;
  writeln ;

  freq := conf.blinkp * 0.1 ;
  write ('Cursor Blinkperiode (s)  : ', freq:2:1, #8#8#8#8) ;
  REPEAT
    readln (freq)
  UNTIL (freq >= 0.05) AND (freq <= 25.5) ;
  conf.blinkp := round (freq * 10.0) ;
  writeln ;

  freq := int (5000.0/conf.beepfreq + 0.5) ;
  write ('Tonfrequenz bei Bell (Hz): ', freq:4:0, #8#8#8#8) ;
  REPEAT
    readln (freq)
  UNTIL freq >= 1.0 ;
  conf.beepfreq := round (5000.0/freq) ;
  writeln ;

  IF NOT floppy_version
     THEN BEGIN
      writeln ('********** Parameter fuer Harddisk-Volume (phys. Kanal 28) **************') ;
      writeln ;

      writeln ('Welches CP/M-Volume soll angesprochen werden ?') ;
      cpm_volume_suchen ;
      conf.cpmofs  := superdirectory.volumeentry[volume].first ;
      conf.cpmlast := superdirectory.volumeentry[volume].last ;
      volume_name  := superdirectory.volumeentry[volume].name ;
     END
  ELSE volume_name := '(1. Volume)' ;

  writeln ;
  writeln ('************* Parameter fuer SCSI-Floppy (phys. Kanal 31) ****************') ;
  writeln ;
  conf.arc31.drive := $60 ;
  scsi_floppy := 'Floppy #1' ;
  IF yes ('SCSI-Floppy #0 statt SCSI-Floppy #1')
     THEN BEGIN
       conf.arc31.drive := $40 ;
       scsi_floppy := 'Floppy #0'
  END ;

  writeln ;
  IF yes ('Zuordnung der logischen/physischen Kanaele aendern')
     THEN kanalzuordnungen ;

  writeln ;
  writeln ;
 END { konfigurieren } ;


BEGIN { MAIN }
 clrscr ;
 writeln ('                            EUMEL-SHard Installation') ;
 writeln ('                            Version ', vers) ;
 writeln ('                            (c) M. Staubermann (ruc)') ;
 writeln ;
 writeln ;

 IF yes ('SHard auf der Harddisk installieren')
    THEN BEGIN
     floppy_version := FALSE ;
     shard_lesen ;
     superdirectory_lesen ;
     IF yes ('SHard-Defaults aendern')
        THEN konfigurieren ;
     eumel_volume_suchen ;
     shard_schreiben ;
     superdirectory_schreiben ;
     writeln ('SHard erfolgreich auf Harddisk installiert.')
    END
 ELSE IF yes ('SHard auf einer (CP/M-)Floppy installieren')
    THEN BEGIN
     floppy_version := TRUE ;
     shard_lesen ;
     IF yes ('SHard-Defaults aendern')
        THEN konfigurieren ;
     shard_auf_floppy_schreiben ;
     writeln ('SHard erfolgreich auf Floppy installiert.')
    END
 ELSE writeln ('Kein SHard installiert.')
END.