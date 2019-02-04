PACKET eumel file utilities
                             DEFINES sort,
                                     in denoter,
                                     even number of command delimiters,
                                     extract command,
                                     next text command pos,
                                     word wrap,
                                     enumerator,
                                     enumeration offset :
PROC sort (THESAURUS VAR th) :
  disable stop;
  FILE VAR d := sequential file (output, "dummy");
  d FILLBY th;
  sort ("dummy");
  th := empty thesaurus;
  input (d);
  th FILLBY d;
  forget ("dummy", quiet);
  enable stop
END PROC sort;
BOOL PROC in denoter (TEXT CONST l, INT CONST p) :
  INT VAR number of quotes := 0,
          last quote pos,
          quote pos := 0;
  quote count loop;
  number of quotes MOD 2 = 1
.
quote count loop :
  REP
    last quote pos := quote pos;
    quote pos := pos (l, """", last quote pos + 1, p - 1);
    IF quote pos <> 0
       THEN number of quotes INCR 1
       ELSE LEAVE quote count loop
    FI
 PER
END PROC in denoter;
BOOL PROC even number of command delimiters (TEXT CONST l, INT CONST end pos) :
  INT VAR number := 0, current pos := 1, cross pos;
  counting loop;
  number MOD 2 = 0
.
  counting loop :
  REP
    cross pos := pos (l, "#", current pos, end pos);
    IF cross pos <> 0
       THEN number INCR 1;
            current pos := cross pos + 1
    FI
  UNTIL cross pos = 0 PER
END PROC even number of command delimiters;
BOOL PROC even number of command delimiters (TEXT CONST l) :
  even number of command delimiters (l, LENGTH l)
END PROC even number of command delimiters;
PROC extract command (TEXT CONST l, INT CONST start pos, INT VAR next pos,
                      TEXT VAR cmd) :
  next pos := pos (l, "#", start pos + 1);
  IF next pos = 0
     THEN errorstop ("unkorrekte Textanweisung")
  FI;
  cmd := subtext (l, start pos + 1, next pos - 1);
  next pos INCR 1
END PROC extract command;
PROC next text command pos (TEXT CONST t, INT CONST start pos,
                            INT VAR start cross pos, end cross pos) :
  start cross pos := pos (t, "#", start pos);
  IF start cross pos <> 0 
     THEN end cross pos := pos (t, "#", start cross pos + 1)
  FI
END PROC next text command pos;
BOOL PROC word wrap (TEXT CONST file name) :
  FILE VAR f := sequential file (input, file name);
  word wrap (f)
END PROC word wrap;
BOOL PROC word wrap (FILE VAR f) :
  TEXT VAR l;
  modify (f);       
  toline (f, lines (f));
  WHILE line no (f) > 1 REP
    read record (f, l);
    IF l <> ""
       THEN LEAVE word wrap WITH (l SUB LENGTH l) = " "
       ELSE up (f, 1)
    FI
  PER;
  FALSE
END PROC word wrap;
INT PROC enumeration offset (TEXT CONST this line, next line,
                             BOOL CONST in enumeration, INT CONST start pos) :
  TEXT VAR initial chunk, next line initial chunk;
  INT VAR blank pos, next line blank pos,
          text start pos := 0, next line text start pos;
  IF NOT only command line (this line)
     THEN ascertain text start pos
  FI;
  text start pos
.
ascertain text start pos :
  blank pos := pos (this line, " ", start pos);
  IF blank pos > 1 CAND blank pos < LENGTH this line
     THEN text start pos := pos (this line, ""33"", ""255"", blank pos);
          IF is enumeration
             THEN text start pos DECR 1
             ELSE text start pos := 0
          FI
  FI
.
is enumeration :
  neighboring lines correspond CAND this line is enumerated
.
neighboring lines correspond :
  in enumeration COR next line corresponds
.
next line corresponds :
  next line blank pos := pos (next line, " ", start pos);
  next line text start pos :=
                       pos (next line, ""33"", ""255"", next line blank pos);
  text start pos = next line text start pos CAND
  (next line indented COR also enumerated)
.
next line indented :
  pos (next line, ""33"", ""255"", 1) = next line text start pos
.
also enumerated :
  next line initial chunk
                  := subtext (next line, start pos, next line blank pos - 1);
  enumerator (next line initial chunk)
.
this line is enumerated :
  initial chunk := subtext (this line, start pos, blank pos - 1);
  enumerator (initial chunk)
END PROC enumeration offset;
BOOL PROC enumerator (TEXT CONST t) :
  t = "-" COR substantial enumerator
.
substantial enumerator :
  INT CONST l := LENGTH t;
  TEXT CONST last char := t SUB l;
  l < 20 CAND last char = ":" COR
  l < 7 CAND pos (".)", last char) <> 0
END PROC enumerator;
END PACKET eumel file utilities;
