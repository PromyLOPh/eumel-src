PACKET dos conversion DEFINES 
                              convert to dos file,
                              dos file name,
                              replace eumel special characters,
                              replace multiple blanks by tab stops,
                              trim end of line,
                              refuse nonwrapped file 
                              :
LET eumel line display pos = 1,
    dos   line display pos = 10;
TEXT VAR in l, out l, next l, last char, buffer;
INT VAR act l no, cursor x, cursor y,
        this line indentation, next line indentation;
PROC replace inadmissible characters (TEXT VAR t) :
  LET inadmissible chars = """*+,./:;<=>?| ";
  INT VAR i;
  FOR i FROM 1 UPTO LENGTH inadmissible chars REP
    last char := inadmissible chars SUB i;
    change all (t, last char, "_")
  PER
END PROC replace inadmissible characters;
TEXT PROC dos file name (TEXT CONST eumel file name) :
  INT VAR p := rpos (eumel file name, ".");
  IF p <> 0
     THEN in l := subtext (eumel file name, p+1, p+3);
          p := min (p, 9);
          out l := subtext (eumel file name, 1, p-1);
     ELSE in l := "dos";
          out l := subtext (eumel file name, 1, 8)
  FI;
  dos fn (out l, in l)
END PROC dos file name;
TEXT PROC dos file name (TEXT CONST eumel name, extension) :
  INT VAR p := rpos (eumel name, ".");
  IF p <> 0
     THEN p := min (p, 9);
          out l := subtext (eumel name, 1, p-1);
     ELSE out l := subtext (eumel name, 1, 8)
  FI;
  dos fn (out l, extension)
END PROC dos file name;
TEXT PROC dos fn (TEXT CONST name, extension) :
  buffer := name;
  replace inadmissible characters (buffer);
  buffer CAT ".";
  buffer CAT extension;
  buffer
END PROC dos fn;
PROC convert to dos file (TEXT CONST eumel file name) :
  LET tab char   = ""9"";
  TEXT CONST dfn := dos file name (eumel file name);
  BOOL VAR is last line of paragraph,
           in table := FALSE;
  get cursor (cursor x, cursor y);
  FILE VAR f := sequential file (input, eumel file name);
  IF word wrap (f)
     THEN input (f)          
     ELSE refuse nonwrapped file
  FI;
  forget (dfn, quiet);
  FILE VAR g := sequential file (output, dfn);
  max line length (g, max text length);
  INT CONST file lines := lines (f);
  act l no := 0;
  out l := "";
  getline (f, next l);
  next line indentation := pos (next l, ""33"", ""255"", 1);
  REP
    in l := next l;
    act l no INCR 1;
    cursor (eumel line display pos, cursor y);
    cout (act l no);
    this line indentation := next line indentation;
    IF act l no >= file lines
       THEN next l := "";
            next line indentation := 1
       ELSE getline (f, next l);
            next line indentation := pos (next l, ""33"", ""255"", 1)
    FI;
    trim act line;
    out l CAT in l;
    IF is last line of paragraph CAND
       NOT only command line (in l)
       THEN putline (g, out l);
            out l := "";
            cursor (dos line display pos, cursor y);
            cout (line no (g))
    FI
  UNTIL act l no >= file lines PER
.
  trim act line :
    IF pos (in l, "#table#") <> 0
       THEN in table := TRUE
    ELIF pos (in l, "#table end") <> 0 COR
         pos (in l, "#tableend") <> 0
       THEN in table := FALSE
    FI;
    trim end of line (in l, is last line of paragraph, in table);
    replace eumel special characters (in l);
    trim start of line;
    replace multiple blanks by tab stops (in l, tab char)
.
  trim start of line :
    IF this line indentation > 2
       THEN IF is first line of paragraph
               THEN change (in l, 1, this line indentation - 1, tab char)
               ELSE in l := subtext (in l, this line indentation)
            FI
    FI
.
  is first line of paragraph : out l = ""
END PROC convert to dos file;
PROC replace eumel special characters (TEXT VAR l) :
  LET eumel chars = ""217""218""219""214""215""216""251""221""220""222""223""252"",
      dos   chars = ""132""148""129""142""153""154""225"-k# "21"";
  INT VAR p;
  FOR p FROM 1 UPTO LENGTH eumel chars REP
    change all (l, eumel chars SUB p, dos chars SUB p)
  PER
END PROC replace eumel special characters;
PROC replace eumel special characters (TEXT VAR l,
     BOOL VAR contains number sign) :
  LET eumel chars = ""217""218""219""214""215""216""251""221""220""223""252"",
      dos   chars = ""132""148""129""142""153""154""225"-k "21"";
  INT VAR p;
  FOR p FROM 1 UPTO LENGTH eumel chars REP
    change all (l, eumel chars SUB p, dos chars SUB p)
  PER;
  contains number sign := pos (l, ""222"") <> 0
END PROC replace eumel special characters;
PROC replace multiple blanks by tab stops (TEXT VAR line, TEXT CONST tab char) :
  TEXT VAR new line := "";
  INT VAR double blank pos, transfer start pos := 1,
          blank length;
  line loop;
  line := new line
.
  line loop :
    WHILE transfer start pos <> 0 REP
      double blank pos := pos (line, "  ", transfer start pos);
      IF double blank pos = 0
         THEN transfer rest of line
         ELSE transfer text;
              transfer tab
      FI
    UNTIL double blank pos = 0 PER
.
  transfer rest of line :
    buffer := subtext (line, transfer start pos);
    new line CAT buffer
.
  transfer text :
    buffer := subtext (line, transfer start pos, double blank pos - 1);
    new line CAT buffer
.
  transfer tab :
    transfer start pos := pos (line, ""33"", ""255"", double blank pos);
    IF transfer start pos = 0            
       THEN new line CAT ""13""10""
       ELSE blank length := transfer start pos - double blank pos;
            new line CAT (blank length DIV 2) * tab char
    FI
END PROC replace multiple blanks by tab stops;
PROC replace multiple blanks by tab stops (TEXT VAR l) :
  replace multiple blanks by tab stops (l, ""9"")
END PROC replace multiple blanks by tab stops;
PROC trim end of line (TEXT VAR l, BOOL VAR last paragraph line,
                       BOOL CONST in table) :
  LET syllabication hyphen = ""221"",
      syllabication k      = ""220"",
      protected blank      = ""223"";
  INT CONST line end := LENGTH l;
  last paragraph line := FALSE;
  last char := l SUB line end;
  IF last char = syllabication hyphen
     THEN IF (l SUB (line end - 1)) = syllabication k
             THEN l := subtext (l, 1, line end - 2);
                  l CAT "c"
             ELSE l := subtext (l, 1, line end - 1)
          FI
  ELIF last char = " " COR
     (in table CAND last char = protected blank) COR
     line end = 0
     THEN l := subtext (l, 1, line end - 1);
          IF NOT only command line (l)
             THEN l CAT ""13""10"";
                  last paragraph line := TRUE
          FI
  ELIF last char <> "-" CAND
       NOT only command line (l) CAND
       no footnote start at end of line
     THEN l CAT " "
  FI
.
no footnote start at end of line :
  pos (l, "#foot#", line end - 5) <> line end - 5
END PROC trim end of line;
PROC refuse nonwrapped file :
  putline (""13""10"F"219"r Dateien ohne `word wrap' (kein Leerzeichen am Absatzende)");
  putline ("ist Konversion weder m"218"glich noch n"218"tig.");
  errorstop ("Datei bitte direkt nach DOS schreiben.")
END PROC refuse nonwrapped file;
END PACKET dos conversion;
