PACKET asksam conversion DEFINES append asksam field,
                                 append asksam record,
                                 convert to asksam :
LET card prefix = " +--",
    bo field    = "[ ",
    eo field    = " ]",
    eo line     = ""13""10"",
    eo record   = ""0"",
    eo doc      = ""0""0"",
    dummy fn    = "@";
LET max fields  = 50;
TEXT VAR in l, out l, appended l, asksam record, buffer;
INT VAR card no, in line no, out line no, last named field,
        start pos, end pos, card lines, first line;
FILE VAR f in, f out;
THESAURUS VAR field names;
ROW max fields BOOL VAR complex fields,
                        to be copied;
PROC convert to asksam (TEXT CONST input file) :
  IF NOT exists (input file) THEN errorstop ("") FI;
  TEXT CONST output file := dos file name (input file, "sam");
  forget (output file);
  f out := sequential file (output, output file);
  field names := empty thesaurus;
  IF input is eudas
     THEN convert eudas to asksam (input file)
  ELIF input is cardbox
     THEN convert cardbox to asksam
  ELSE stop process
  FI
.
input is eudas :
  type (old (input file)) = 3243
.
input is cardbox :
  IF type (old (input file)) = 1003
     THEN f in := sequential file (modify, input file);
          toline (f in, 1);
          down (f in, ""26""26"");
          pattern found
     ELSE FALSE
  FI
.
stop process :
  forget (output file, quiet);
  errorstop ("Konversion nur f"219"r EUDAS- und Cardbox-Dateien m"218"glich.")
END PROC convert to asksam;
PROC convert eudas to asksam (TEXT CONST file name) :
  oeffne (file name, FALSE);
  get field names;
  WHILE NOT dateiende REP
    transfer one record;
    weiter (1)
  PER;
  dateien loeschen (FALSE)
.
get field names :
  asksam record := "";
  last named field := anzahl felder;
  auf satz (1);
  FOR in line no FROM 1 UPTO last named field REP
    feld lesen (in line no, in l);
    IF in l <> ""
       THEN to be copied [in line no] := TRUE;
            complex fields [in line no] := is complex field;
            append field name (in l);
            feldnamen lesen (in line no, in l);
            append asksam field (in l)
       ELSE to be copied [in line no] := FALSE;
            append field name (dummy fn)
    FI
  PER;
  append asksam record;
  weiter (1)
.
is complex field :
  end pos := pos (in l, "{");
  IF end pos <> 0
     THEN end pos DECR 1;
          WHILE (in l SUB end pos) = " " REP
            end pos DECR 1
          PER;
          in l := subtext (in l, 1, end pos);
          TRUE
     ELSE FALSE
  FI
.
transfer one record :
  cout (satznummer);
  asksam record := "";
  out line no := 0;
  transfer fields;
  append asksam record
.
transfer fields :
  FOR in line no FROM 1 UPTO last named field REP
    IF to be copied [in line no] 
       THEN feld lesen (in line no, in l);
            IF in l <> ""
               THEN IF complex fields [in line no]
                       THEN transfer complex field (in l)
                       ELSE append asksam field (in l)
                    FI
            FI
    FI
  PER
END PROC convert eudas to asksam;
PROC transfer complex field (TEXT CONST l) :
  TEXT VAR transfer buffer;
  start pos := 1;
  REP
    start pos INCR 1;
    end pos := pos (l, "{", start pos + 1);
    IF end pos = 0
       THEN end pos := LENGTH l
       ELSE end pos DECR 1
    FI;
    WHILE (l SUB end pos) = " " REP
      end pos DECR 1
    PER;
    transfer buffer := subtext (l, start pos, end pos);
    change (transfer buffer, "}", "");
    append asksam field (transfer buffer);
    start pos := pos (l, "{", end pos)
  UNTIL start pos = 0 PER
END PROC transfer complex field;
PROC convert cardbox to asksam :
  BOOL VAR line end;
  ascertain number lines per card;
  convert file;
.
ascertain number lines per card :
  toline (f in, 1);
  col (f in, 1);
  downety (f in, card prefix);
  first line := line no (f in);
  down (f in, card prefix);
  card lines := line no (f in) - first line
.
convert file :
  line;
  input (f in);
  get field names;
  card no := 0;
  WHILE NOT eof (f in) REP
    transfer one card
  UNTIL asksam record = "" PER
.
get field names :
  last named field := 0;
  getline (f in, in l);
  get names from first lines;
  get names from bulk;
.
get names from first lines :
  FOR in line no FROM 1 UPTO card lines - 2 REP
    get cardbox line (in l);
    in l := compress (in l);
    IF in l > ""
       THEN append field name (in l);
            last named field := in line no
       ELSE append field name (dummy fn)
    FI
  PER;
.
get names from bulk :
  in line no := card lines - 2;
  get cardbox line (in l);
  end pos := 0;
  REP
    get card line (appended l, line end);
    IF line end
       THEN LEAVE get names from bulk
    ELIF appended l <> ""
       THEN in line no INCR 1;
            append field name (compress (appended l));
            last named field INCR 1
    FI;
  PER
END PROC convert cardbox to asksam;
PROC transfer one card :
  BOOL VAR line end;
  card no INCR 1;
  cout (card no);
  asksam record := "";
  transfer first lines;
  transfer bulk line;
  append asksam record
.
transfer first lines :
  getline (f in, in l);
  IF pos (in l, card prefix) <> 2
     THEN errorstop ("Programmfehler 1")
  ELIF pos (in l, "LAST CARD") <> 0
     THEN LEAVE transfer one card
  FI;
  out line no := 0;
  FOR in line no FROM 1 UPTO card lines - 2 REP
    get cardbox line (in l);
    IF pos (in l, ""25""25"") = 1
       THEN process hypertext
       ELSE append asksam field (in l)
    FI;
  PER
.
process hypertext :
  asksam record CAT ":"13""10""9"";
  end pos := pos (in l, ".card") - 1;
  appended l := subtext (in l, 55, end pos);
  asksam record CAT appended l;
  asksam record CAT ""255""13""10""13""10"";
  asksam record CAT "(Datei zum Thema `";
  asksam record CAT appended l;
  asksam record CAT "')"13""10"";
  out line no := 4
.
transfer bulk line :
  get cardbox line (in l);
  end pos := 0;
  first line := 0;
  in line no DECR 1;
  REP
    get card line (appended l, line end);
    IF line end
       THEN LEAVE transfer bulk line
    FI;
    in line no INCR 1;
    cout (in line no);
    append asksam field (appended l)
  PER
END PROC transfer one card;
PROC get cardbox line (TEXT VAR t) :
  getline (f in, t);
  start pos := pos (t, "|");
  IF start pos = 0
     THEN errorstop ("Programmfehler 2")
  FI;
  t := subtext (t, start pos + 1)
END PROC get cardbox line;
PROC get card line (TEXT VAR t, BOOL VAR end) :
  start pos := pos (in l, ""32"", ""255"", endpos + 1);
  IF start pos = 0
     THEN end := TRUE;
          LEAVE get card line
  FI;
  end pos := pos (in l, ""26"", start pos);
  IF end pos = 0     
     THEN end := TRUE;
          LEAVE get card line
  FI;
  end pos DECR 1;
  t := subtext (in l, start pos, end pos);
  end := FALSE
END PROC get card line;
PROC append asksam line (TEXT CONST t) :
  asksam record CAT t;
  out line no INCR 1;
  IF out line no MOD 20 = 0
     THEN asksam record CAT eo record
     ELSE asksam record CAT eo line
  FI
END PROC append asksam line;
PROC append asksam field (TEXT CONST t) :
  BOOL VAR named field;
  INT VAR s pos, e pos, length l;
  IF t > " " CAND in line no <= last named field
     THEN get field name (in line no, out l);
          IF out l <> dummy fn
             THEN out l CAT bo field;
                  named field := TRUE
             ELSE out l := "";
                  named field := FALSE
          FI
     ELSE out l := "";
          named field := FALSE
  FI;
  buffer := t;
  prepare line for asksam (buffer);
  out l CAT buffer;
  transfer line
.
transfer line :
  length l := LENGTH out l;
  e pos := -1;
  REP
    s pos := e pos + 2;
    IF (length l - s pos) > 79
       THEN determine e pos;
            transfer chunk
       ELSE transfer rest
    FI
  PER
.
determine e pos :
  e pos := s pos + 79;
  move before last blank
.
move before last blank :
  WHILE (out l SUB e pos) <> " " REP
    e pos DECR 1
  UNTIL e pos = s pos PER;
  IF e pos = s pos
     THEN e pos := s pos + 79
     ELSE e pos DECR 1
  FI
.
transfer chunk :
  append asksam line (subtext (out l, s pos, e pos));
.
transfer rest :
  buffer := subtext (out l, s pos);
  IF named field
     THEN buffer CAT eo field
  FI;
  append asksam line (buffer);
  LEAVE transfer line
END PROC append asksam field;
PROC append asksam record :
  IF was eo record
     THEN asksam record CAT eo record
     ELSE buffer := subtext (asksam record, 1, LENGTH asksam record - 2);
          buffer CAT eo doc;
          asksam record := buffer
  FI;
  putline (f out, asksam record)
.
was eo record :
  out line no MOD 20 = 0
END PROC append asksam record;
PROC prepare line for asksam (TEXT VAR t) :
  IF (t SUB LENGTH t) = " "
     THEN t := subtext (t, 1, LENGTH t - 1)
  FI;
  replace eumel special characters (t);
  change all (t, "[", ""174"");
  change all (t, "]", ""175"");
  change all (t, "#on(""i"")#", "<I>");
  change all (t, "#off(""i"")#", "<i>")
END PROC prepare line for asksam;
PROC append field name (TEXT CONST fn) :
  INT VAR index;
  buffer := fn;
  prepare line for asksam (buffer);
  insert (field names, buffer, index)
END PROC append field name;
PROC get field name (INT CONST index, TEXT VAR fn) :
  fn := name (field names, index)
END PROC get field name;
END PACKET asksam conversion;
