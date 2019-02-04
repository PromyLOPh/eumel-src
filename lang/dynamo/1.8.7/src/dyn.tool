PACKET io handling DEFINES error listing, err, message, errors, init errors,
                           text, kill, trunc, hash, no errors :
(* Autor : R. Keil, Version vom 22.07.83, Änderung: C. Szymanski, 21.07.88 *)

LET errmax        = 67,
    max hash size = 300;
 
ROW errmax TEXT VAR error;
FILE VAR listfile;                    (* -> VERSION 3.2  *)
BOOL VAR list;
INT VAR errorno, i;
 
PROC init errors (TEXT CONST fname) :
 FILE VAR errorfile := sequential file (input, fname);
 TEXT VAR buffer;
 FOR i FROM 1 UPTO errmax WHILE NOT eof (errorfile) REP
  getline (errorfile, buffer);
  error (i) := buffer
 END REP
END PROC init errors;
 
PROC init errors :
  errorno := 0
END PROC init errors;
 
PROC error listing (TEXT CONST listname) :
 list := listname <> "nolist";
 IF list
  THEN kill (listname);
       listfile := sequential file (output, listname)
 FI
END PROC error listing;
 
INT PROC errors :
 error no
END PROC errors;
 
PROC err (TEXT CONST s, INT CONST m, line no) :
 message ("Fehler in Zeile " + text (line no) + " bei >>" + s + "<< : "
          + error (m));
 errorno INCR 1
END PROC err;
 
BOOL PROC no errors :
 IF errors = 0
  THEN TRUE
  ELSE display (text (error no) + " Fehler gefunden"13""10""); FALSE
 FI
END PROC no errors;

PROC message (TEXT CONST m) :
 IF list
  THEN putline (list file, m);
 FI;
 note (m);                             (* C.S. 21.07.88 *)
 note line;
 display (m);
 display (""13""10"")
END PROC message;
 
TEXT PROC text (BOOL CONST b) :
 IF b
  THEN "TRUE"
  ELSE "FALSE"
 FI
END PROC text;
 
PROC kill (TEXT CONST file name) :
 command dialogue (FALSE);
 forget (file name);
 command dialogue (TRUE)
END PROC kill;
 
TEXT PROC trunc (TEXT CONST t) :
 text (t, length (t) - 2)
END PROC trunc;
 
INT PROC hash (TEXT CONST word) :
 INT VAR qs := 0;
 FOR i FROM 1 UPTO length (word) REP
  qs INCR code (word SUB i)
 END REP;
 (qs MOD max hash size) + 1.
END PROC hash
 
END PACKET io handling;
 
 
(************************* S C A N N E R **************************)
 
PACKET scan DEFINES next sym, scanner, scanpos :
 
 
LET bold      = 1,          (* Autor : R. Keil, T. Froehlich *)
    number    = 2,          (* Version vom 04.07.83 *)
    delimiter = 3,
    eol       = 4;
 
TEXT VAR main buf, sym;
INT  VAR position, type, cc, begin pos;
 
PROC nextsym (TEXT CONST buf, TEXT VAR scan sym,
              INT VAR scan type, pos) :
 TEXT VAR char := buf SUB pos;
 cc := code (char);
 IF (cc >= 97 AND cc <= 122)
  THEN process lower case
 ELIF cc = 46 OR is int
  THEN process real
 ELIF (cc >= 65 AND cc <= 90)
  THEN process upper case
  ELSE process delimiter
 FI.
 
 process upper case :
  scan type := bold;
  scan sym  := low;
  next char;
  WHILE (cc >= 65 AND cc <= 90) OR is int REP
   scan sym CAT low;
   next char
  END REP.
 
 process lower case :
  scan type := bold;
  begin pos := pos;
  REP
   next char
  UNTIL lower case char AND NOT is int END REP;
  scan sym := subtext (buf, begin pos, pos - 1).
 
 lower case char :
  cc < 97 OR cc > 122.

 process real :
  process base;
  process exponent;
  scan type := number.
 
 process base :
  IF cc = 46
   THEN next char;
        IF is int
         THEN scan sym := "0.";
              process int
         ELSE scan type := delimiter;
              scan sym := ".";
              LEAVE process real
        FI
   ELSE scan sym := "";
        process int;
        IF cc = 46
         THEN scan sym CAT char;
              next char;
              IF is int
               THEN process int
               ELSE scan sym CAT "0"
              FI
         ELSE scan sym CAT ".0"
        FI
  FI.
 
 process exponent :
  IF cc = 69 OR cc = 101
   THEN scan sym CAT "e";
        next char;
        IF cc = 43 OR cc = 45
         THEN scan sym CAT char; next char
        FI;
        IF is int
         THEN process int
         ELSE err (char, 63, 0)
        FI
  FI.
 
 process int :
  WHILE is int REP
   scan sym CAT char;
   next char
  END REP.
 
is int :
 cc >= 48 AND cc <= 57.
 
 process delimiter :
  IF cc = -1
   THEN scan sym := "EOL"; scan type := eol
   ELSE scan type := delimiter;
        scan sym := char
  FI;
  pos INCR 1.
 
 next char :
  pos INCR 1; char := buf SUB pos; cc := code (char).
 
 low :
  IF cc >= 65 AND cc <= 90
   THEN code (cc + 32)
   ELSE char
  FI.
END PROC next sym;
 
PROC scanner (TEXT CONST buf) :
  main buf := buf; position := 1
END PROC scanner;
 
PROC next sym (TEXT VAR sym, INT VAR type) :
  next sym (main buf, sym, type, position)
END PROC next sym;
 
INT PROC scanpos :
 position
END PROC scanpos
 
END PACKET scan
 

