PACKET font analysis DEFINES  find fonttable,
                              analyze fonts,
                              analyze indent levels :
INT VAR th index, cmd index, no of params;
TEXT VAR buffer line;
TEXT PROC next type command (FILE VAR f, INT VAR line number, cont pos) :
  INT VAR start pos;
  TEXT VAR type cmd := "";
  search loop;
  line number := line no (f);
  type cmd
.
  search loop :
    REP
      downety (f, "#type");
      IF pattern found
         THEN start pos := col (f);
              read record (f, buffer line);
              IF even number of command delimiters (buffer line, start pos - 1)
                 THEN extract command (buffer line, start pos, cont pos, type cmd);
                      col (f, cont pos);
                      LEAVE search loop
                 ELSE col (f, start pos + 1)
              FI
      FI
    UNTIL NOT pattern found PER;
    cont pos := col (f)
END PROC next type command;
PROC find fonttable (THESAURUS CONST used fonts th, TEXT VAR table name) :
  LET old table type = 3009,
      new table type = 3100;
  TEXT VAR font name;
  TEXT CONST users fonttable := fonttable;
  INT VAR ds type, fonttable th index;
  disable stop;
  command dialogue (FALSE);
  THESAURUS CONST fonttable th := ALL /"configurator";
  try all fonttables;
  fonttable (users fonttable);
  command dialogue (TRUE);
  enable stop;
  IF table name = ""
     THEN errorstop ("Keine zur Datei passende Fonttabelle gefunden")
  FI
.
try all fonttables :
  fonttable th index := 0;
  get (fonttable th, table name, fonttable th index);
  WHILE fonttable th index > 0 REP
    fetch (table name, /"configurator");
    ds type := type (old (table name));
    forget (table name);
    IF ds type = old table type COR ds type = new table type
       THEN fonttable (table name);
            IF is error
               THEN put error;
                    putline ("Fonttabelle `" + table name + "' kann nicht eingestellt werden.");
                    IF yes ("Abbrechen")
                       THEN enable stop
                       ELSE clear error
                    FI
               ELSE IF all used fonts present
                       THEN LEAVE try all fonttables
                    FI
            FI
    FI;
    get (fonttable th, table name, fonttable th index)
  PER;
  table name := ""
.
all used fonts present :
  th index := 0;
  get (used fonts th, font name, th index);
  WHILE th index > 0 REP
    IF NOT font exists (font name)
       THEN LEAVE all used fonts present WITH FALSE
    FI;
    get (used fonts th, font name, th index)
  PER;
  TRUE
END PROC find fonttable;
PROC analyze fonts (FILE VAR f, TEXT VAR fonttable name,
                    font numbers, INT VAR base font index) :
  THESAURUS VAR font th;
  TEXT VAR usage, base font;
  fonttable name := "";
  font numbers := "";
  base font index := 0;
  collect fonts (f, font th, usage);
  IF highest entry (font th) <> 0
     THEN analyze users fonts
  FI;
.
analyze users fonts :
  find fonttable (font th, fonttable name);
  TEXT CONST users fonttable := fonttable;
  fonttable (fonttable name);
  provide font numbers (font th, font numbers, usage, base font);
  sort fonts (font numbers);
  base font index := pos (font numbers, base font);
  IF users fonttable <> ""  
     THEN fonttable (users fonttable)
  FI
END PROC analyze fonts;
PROC analyze fonts (TEXT CONST file name, TEXT VAR fonttable name,
                    font numbers, INT VAR base font index) :
  FILE VAR f := sequential file (modify, file name);
  analyze fonts (f, fonttable name, font numbers, base font index)
END PROC analyze fonts;
PROC collect fonts (FILE VAR f, THESAURUS VAR th, TEXT VAR line numbers) :
  TEXT VAR cmd, font name, param2;
  INT VAR current ln, last ln := 0,
          act distance, current font lines,
          next pos;
  th := empty thesaurus;
  line numbers := "";
  toline (f, 1);
  col (f, 1);
  WHILE NOT eof (f) REP
    cmd := next type command (f, current ln, next pos);
    cout (current ln);
    note text lines for last font;
    process font cmd
  PER
.
  note text lines for last font :
    IF last ln <> 0
       THEN act distance := current ln - last ln;
            current font lines := line numbers ISUB th index;
            current font lines INCR act distance;
            replace (line numbers, th index, current font lines)
    FI
.
process font cmd :
  analyze command ("type:1.1", cmd, 0, cmd index, no of params,
                   font name, param2);
  IF cmd index = 1                
     THEN th index := link (th, font name);
          IF th index = 0
             THEN add new font
          FI;
          last ln := current ln
  FI
.
  add new font :
    insert (th, font name, th index);
    line numbers CAT ""0""0""
END PROC collect fonts;
PROC provide font numbers (THESAURUS CONST fonts th, TEXT VAR font numbers,
                           line numbers, base font name) :
  TEXT VAR font name, font no, old line numbers := line numbers;
  font numbers := "";
  line numbers := "";
  INT VAR font index, line number, last greatest;
  th index := 0;
  get (fonts th, font name, th index);
  WHILE th index > 0 REP
    font no := code (font (font name));
    font index := pos (font numbers, font no);
    IF font index = 0
       THEN transfer font
       ELSE sum text line number  
    FI;
    get (fonts th, font name, th index)
  PER;
  determine font with most text
.
  transfer font :
    font numbers CAT font no;
    line numbers CAT (old line numbers ISUB th index)
.
  sum text line number :
    line number := line numbers ISUB font index;
    line number INCR (old line numbers ISUB th index);
    replace (line numbers, font index, line number)
.
  determine font with most text :
    last greatest := 0;
    FOR font index FROM 1 UPTO (LENGTH line numbers) DIV 2 REP
      line number := line numbers ISUB font index;
      IF line number > last greatest
         THEN last greatest := line number;
              base font name := font numbers SUB font index
      FI
    PER;
END PROC provide font numbers;
PROC sort fonts (TEXT VAR fonts) :
  TEXT VAR font name, spec font;
  INT VAR font no, size;
  th index := 0; 
  disable stop;
  FILE VAR f := sequential file (output, "fonts");
  get font sizes;
  sort ("fonts");
  restore fonts text;
  forget ("fonts", quiet);
  enable stop
.
  get font sizes :
    FOR th index FROM 1 UPTO LENGTH fonts REP
      font name := fonts SUB th index;
      font no := code (font name);
      specify size
    PER
.
  specify size :
    size := (indentation pitch (font no) DIV 2)
                * (font height (font no) DIV 2);
    rotate (size, 8);
    spec font := ""223""223"";
    replace (spec font, 1, size);
    spec font CAT font name;
    putline (f, spec font)
.
  restore fonts text :
    fonts := "";
    input (f);
    WHILE NOT eof (f) REP
      getline (f, spec font);
      font name := spec font SUB 3;
      fonts CAT font name
    PER
END PROC sort fonts;
PROC analyze indent levels (TEXT CONST file name, TEXT VAR levels string) :
  FILE VAR f := sequential file (input, file name);
  analyze indent levels (f, levels string);
  modify (f)
END PROC analyze indent levels;
PROC analyze indent levels (FILE VAR f, TEXT VAR levels string) :
  INT VAR i;
  TEXT VAR l, act blanks, current item;
  levels string := "";
  WHILE NOT eof (f) REP
    getline (f, l);
    i := pos (l, ""33"", ""255"", 1) - 1;
    IF i > 0
       THEN act blanks := code (i);
            i := 1;
            IF not yet remembered
               THEN insert act blanks
            FI
    FI
  PER;
  modify (f)
.
not yet remembered :
  WHILE i <= LENGTH levels string REP
    current item := levels string SUB i;
    IF current item < act blanks
       THEN i INCR 1
    ELIF current item = act blanks
       THEN LEAVE not yet remembered WITH FALSE
    ELSE LEAVE not yet remembered WITH TRUE
    FI
  PER;
  TRUE
.
insert act blanks :
  insert char (levels string, act blanks, i)
END PROC analyze indent levels;
END PACKET font analysis;
