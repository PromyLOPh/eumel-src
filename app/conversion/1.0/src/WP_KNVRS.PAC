PACKET wordperfect conversion  DEFINES konvertiere nach wp :
LET     type1        = 1,
        linefeed     = 3,
        limit        = 4,
        free         = 5,
        page cmd0    = 6,
        page cmd1    = 7,
        on           = 8,
        off          = 9,
        page nr      = 10,
        pagelength   = 11,
        start        = 12,
        foot         = 13,
        end          = 14,
        head         = 15,
        headeven     = 16,
        headodd      = 17,
        bottom       = 18,
        bottomeven   = 19,
        bottomodd    = 20,
        block        = 21,
        material     = 22,
        columns      = 23,
        columnsend   = 24,
        ib0          = 25,
        ib1          = 26,
        ib2          = 27,
        ie0          = 28,
        ie1          = 29,
        ie2          = 30,
        topage       = 31,
        goalpage     = 32,
        count0       = 33,
        count1       = 34,
        setcount     = 35,
        value0       = 36,
        value1       = 37,
        table        = 38,
        table end    = 39,
        r pos        = 40,
        l pos        = 41,
        c pos        = 42,
        d pos        = 43,
        b pos        = 44,
        clear pos0   = 45,
        clear pos1   = 46,
        right        = 47,
        center       = 48,
        skip         = 49,
        skip end     = 50,
        u cmd        = 51,
        d cmd        = 52,
        e cmd        = 53,
        head on      = 54,
        head off     = 55,
        bottom on    = 56,
        bottom off   = 57,
        count per page=58,
        fillchar     = 59,
        mark cmd     = 60,
        mark end     = 61,
        pageblock    = 62,
        bsp          = 63,
        counter1     = 64,
        counter2     = 65,
        setcounter   = 66,
        putcounter0  = 67,
        putcounter1  = 68,
        storecounter = 69,
        ub           = 70,
        ue           = 71,
        fb           = 72,
        fe           = 73,
        region       = 74,
        region end   = 75;
LET eumel line display pos = 1,
    dos   line display pos = 10,
    default tab insert pos = 21;
LET cont paper width  = 20.88,
    cont paper length = 30.48,
    minimal margin    = 0.5;
LET eumel modifications = "ibur";
LET wp cmd start         = "<|",
    wp cmd end           = "|>";
ROW 6 TEXT VAR wp types on off := ROW 6 TEXT :
    ("p\K13",
     "p\K14",
     "",
     "p\K15",
     "p\K16",
     "p\K17");
ROW 4 TEXT CONST wp mods on off := ROW 4 TEXT :
     ("p\K24",
      "p\%",
      "p\'",
      "p\K28");
ROW 2 TEXT CONST wp scripts on off := ROW 2 TEXT :
     ("p\K11", "p\K12");
TEXT VAR cosmetic cmds :=
  "type:1.1linefeed:3.1limit:4.1free:5.1page:6.01on:8.1off:9.1pagenr:10.2
  pagelength:11.1start:12.2foot:13.0end:14.0head:15.0headeven:16.0
  headodd:17.0bottom:18.0bottomeven:19.0bottomodd:20.0block:21.0";
cosmetic cmds CAT
  "material:22.1columns:23.2columnsend:24.0ib:25.012ie:28.012topage:31.1
  goalpage:32.1count:33.01setcount:35.1value:36.01table:38.0tableend:39.0
  rpos:40.1lpos:41.1cpos:42.1dpos:43.2bpos:44.2clearpos:45.01right:47.0";
cosmetic cmds CAT
  "center:48.0skip:49.0skipend:50.0u:51.0d:52.0e:53.0headon:54.0headoff:55.0
  bottomon:56.0bottomoff:57.0countperpage:58.0fillchar:59.1mark:60.2
  markend:61.0pageblock:62.0b:63.0counter:64.12setcounter:66.2putcounter:67.01
  storecounter:69.1";
cosmetic cmds CAT
  "ub:70.0ue:71.0fb:72.0fe:73.0region:74.0regionend:75.0";
TEXT VAR font number string,
         users tabs cmd, no users tabs cmd,
         param1, param2,
         act l, next l, dos l,
         eumel chunk,
         wp cmd, buffer, index buffer, paired move cmd;
TEXT CONST wp enter tab menu := wp cmd start + "s\318",
           wp clear tabs     := "0\\rt\\ri\\el",
           wp quit tab menu  := "\&00" + wp cmd end,
           wp return         := "\\rt",
           global tabs cmd   := wp enter tab menu + wp clear tabs
                                + "0.0,5c" + wp return + wp quit tab menu,
           page no cmd       := wp cmd start + "s\3263" + wp cmd end;
INT VAR cmd index, no of params,
        base font index, base font offset,
        current wp size, current script value,
        mod flags,
        current index number,
        act l no,
        dos l length,
        first cross pos, second cross pos,
        act text start, next text start,
        act indent level, next indent level,
        current tab insert pos,
        current font,
        cursor x, cursor y;
REAL VAR paper width,
         paper length,
         current top margin,
         current bottom margin,
         current left margin,
         current right margin,
         current limit,
         current pagelength,
         current indent pitch;
BOOL VAR in footnote,
         in table,
         in index,
         in header,
         in bottom,
         in enum,
         is last line of paragraph,
         text in dos l,
         line contains number sign
         ;
PROC konvertiere nach wp (TEXT CONST eumel file name) :
  TEXT VAR wp file name, file fonttable, users fonttable := "";
  BOOL VAR errors found := FALSE;
  IF word wrap (eumel file name)
     THEN 
     ELSE refuse nonwrapped file
  FI;
  IF NOT errors found
     THEN line;
          say ("Schrifttypen werden analysiert ...");
          analyze fonts (eumel file name, file fonttable,
                         font number string, base font index);
          line;
          say ("Fu"251"noten werden plaziert ...");
          move footnotes (eumel file name);
          wp file name := dos file name (eumel file name, "wpf");
          forget (wp file name, quiet);
          line;
          say ("Datei wird konvertiert ...");
          line;
          IF file fonttable <> ""
             THEN users fonttable := fonttable;
                  fonttable (file fonttable)
          FI;
          convert to wp file (eumel file name, wp file name);
          forget (eumel file name, quiet);
          rename (eumel file name + ".orig", eumel file name);
          IF users fonttable <> ""   
             THEN fonttable (users fonttable)
          FI
  FI
END PROC konvertiere nach wp;
PROC konvertiere nach wp (THESAURUS CONST th) :
  do (PROC (TEXT CONST) konvertiere nach wp, th)
END PROC konvertiere nach wp;
PROC konvertiere nach wp :
  konvertiere nach wp (std)
END PROC konvertiere nach wp;
PROC move footnotes (TEXT CONST file name) :
  copy (file name, file name + ".orig");
  FILE VAR f := sequential file (modify, file name);
  INT VAR count line no, count col no,
          foot line no, foot col no,
          end line no, end col no,
          value line no, value col no,
          footnote lines, line length;
  TEXT VAR count line tail;
  toline (f, 1);
  WHILE NOT eof (f) REP
    cout (line no (f));
    down (f, "#count#");
    IF pattern found
       THEN process note
    FI
  PER
.
process note :
  count line no := line no (f);
  count col no := col (f);
  down (f, "#foot#");
  IF pattern found
     THEN foot line no := line no (f);
          foot col no := col (f);
          IF foot line no - count line no > 20
             THEN LEAVE process note
          FI;
          isolate foot cmd if necessary;
          down (f, "#end#");
          IF pattern found
             THEN end line no := line no (f);
                  check for value;
                  isolate end cmd if necessary;
                  remove note;
                  split count line;
                  replace count by note
             ELSE LEAVE process note
          FI
     ELSE LEAVE process note
  FI
.
check for value :
  toline (f, foot line no);
  col (f, foot col no);
  down (f, "#value#");
  IF pattern found
     THEN value line no := line no (f);
          value col no := col (f);
          IF value line no >= end line no
             THEN LEAVE process note
             ELSE delete value cmd
          FI
     ELSE LEAVE process note
  FI;
  toline (f, end line no)
.
delete value cmd :
  read record (f, act l);
  change (act l, "#u##value##e#", "");
  change (act l, "#value#", "");
  write record (f, act l)
.
isolate foot cmd if necessary :
  read record (f, act l);
  IF foot col no > 1
     THEN next l := subtext (act l, foot col no);
          IF (act l SUB (foot col no - 1)) = " "
             THEN act l := subtext (act l, 1, foot col no - 2)
             ELSE act l := subtext (act l, 1, foot col no - 1)
          FI;
          write record (f, act l);
          down (f, 1);
          insert record (f);
          write record (f, next l)
  FI
.
isolate end cmd if necessary :
  read record (f, act l);
  end col no INCR 5;
  next l := subtext (act l, end col no);
  IF next l > " "
     THEN act l := subtext (act l, 1, end col no - 1);
          write record (f, act l);
          down (f, 1);
          insert record (f);
          write record (f, next l);
          up (f, 1)
  FI
.
remove note :
  footnote lines := end line no - foot line no + 1;
  remove (f, footnote lines)
.
split count line :
  toline (f, count line no);
  read record (f, act l);
  cmd start := pos (act l, "#u##count##e#", count col no - 3);
  IF cmd start = count col no - 3
     THEN cmd end := cmd start + 12
     ELSE cmd start := count col no;
          cmd end := cmd start + 7
  FI;
  count line tail := subtext (act l, cmd end + 1);
  IF (count line tail SUB LENGTH count line tail) = " "
     CAND (only command line (count line tail) COR
          LENGTH count line tail = 1)
     THEN count line tail CAT "  "      
  FI;
  act l := subtext (act l, 1, cmd start - 1);
  write record (f, act l)
.
replace count by note :
  toline (f, count line no + 1);
  reinsert (f);
  append count line tail;
  toline (f, count line no + 1);
  read record (f, next l);
  delete record (f);
  up (f, 1);
  read record (f, act l);
  act l CAT next l;
  line length := LENGTH act l;
  IF pos (act l, "#foot#") = line length - 6 CAND
     (act l SUB line length) = " "
     THEN act l := subtext (act l, 1, line length - 1)
  FI;
  write record (f, act l)
.
append count line tail :
  read record (f, act l);
  end col no :=  pos (act l, "#end#");
  act l := subtext (act l, 1, end col no + 4);
  IF count line tail <> ""
     THEN act l CAT count line tail
     ELSE append next line
  FI;
  write record (f, act l)
.
append next line :
  down (f, 1);
  read record (f, next l);
  IF next l > " "      
     THEN delete record (f);
          up (f, 1);
          act l CAT " ";
          act l CAT next l;
          write record (f, act l)
     ELSE up (f, 1)
  FI
.
cmd start : first cross pos
.
cmd end : second cross pos
END PROC move footnotes;
PROC initialize values :
  act l no              := 0;
  current wp size       := 3;
  current script value  := 0;
  mod flags             := 0;
  current index number  := 0;
  current tab insert pos:= default tab insert pos;
  paper length          := cont paper length;
  paper width           := cont paper width;
  current top margin    := 2.5;
  current bottom margin := 2.5;
  current left margin   := 3.0;
  current right margin  := 2.0;
  current pagelength    := paper length - current top margin - current bottom margin;
  current limit         := paper width - current left margin - current right margin;
  current font          := 1;
  current indent pitch  := xstep conversion (indentation pitch (current font));
  in enum               := FALSE;
  in table              := FALSE;
  in footnote           := FALSE;
  in header             := FALSE;
  in bottom             := FALSE;
  in index              := FALSE;
  text in dos l         := FALSE;
  base font offset      := base font index - 3;
  wp cmd                := "";
  dos l                 := "";
  dos l length          := 0;
  next indent level     := 0;
  no users tabs cmd     := no users tabs command;
  users tabs cmd        := no users tabs cmd
END PROC initialize values;
TEXT PROC no users tabs command :
  TEXT VAR t := wp enter tab menu;
  t CAT wp clear tabs;
  t CAT german real (current limit - 2.0);
  t CAT ".0,2c\\rt";    
  t CAT wp quit tab menu;
  t
END PROC no users tabs command;
INT PROC indent level (INT CONST text start pos) :
  LET tab distance = 0.5;
  IF text start pos < 3
     THEN 0
     ELSE positive indent level
  FI
.
positive indent level :
  REAL VAR left margin distance
                         := real (text start pos - 1) * current indent pitch;
  INT VAR ind level := int (round (left margin distance / tab distance, 0));
  IF ind level = 0
     THEN 1
     ELSE ind level
  FI
END PROC indent level;
PROC convert to wp file (TEXT CONST eumel file name, wp file name) :
  get cursor (cursor x, cursor y);
  FILE VAR eumel f := sequential file (input, eumel file name),
           dos f   := sequential file (output, wp file name);
  max line length (dos f, max text length);
  INT CONST file lines := lines (eumel f);
  BOOL VAR is last file line := FALSE;
  set file defaults;
  getline (eumel f, next l);
  next text start := pos (next l, ""33"", ""255"", 1);
  REP
    act l := next l;
    act l no INCR 1;
    cursor (eumel line display pos, cursor y);
    cout (act l no);
    act text start := next text start;
    IF act l no >= file lines
       THEN next l := "";
            next text start := 1;
            is last file line := TRUE
       ELSE getline (eumel f, next l);
            get next text start
    FI;
    act indent level := next indent level;
    next indent level := indent level (next text start);
    process act line;
    IF is last line of paragraph
       THEN IF is last file line
               THEN complement pending paired commands
            FI;
            putline (dos f, dos l);
            dos l := "";
            dos l length := 0;
            text in dos l := FALSE;
            cursor (dos line display pos, cursor y);
            cout (line no (dos f))
    FI
  UNTIL act l no >= file lines PER
END PROC convert to wp file;
PROC set file defaults :
  initialize values;
  set endnote options;
  no pagination;
  wp cmd CAT global tabs cmd
.
set endnote options :
  cat to wp command ("s\J243\J22\\rt\&")
.
no pagination :
  cat to wp command ("s\32649\&")
END PROC set file defaults;
PROC get next text start :
  next text start := pos (next l, ""33"", ""255"", 1);
  IF next text start = 2
     THEN next text start := 1
  FI    
END PROC get next text start;
PROC process act line :
  LET tab code        = "<|s\\tb|>",
      indent code     = "<|s\\in|>",
      margin rel code = "<|s\^|>";
  INT VAR enum blanks, past enumerator pos;
  trim end of line (act l, is last line of paragraph, in table);
  replace eumel special characters (act l, line contains number sign);
  trim start of line;
  IF in table CAND NOT text in dos l
     THEN replace multiple blanks by tab stops (act l, tab code)
  FI;
  transfer line in chunks
.
trim start of line :
  IF NOT (text in dos l COR only command line (act l))
     THEN IF NOT is last line of paragraph CAND
             next indent level < act indent level    
             THEN cat to dos l (next indent level * indent code);
                  cat to dos l ((act indent level - next indent level) * tab code)
             ELSE cat to dos l (act indent level * indent code)
          FI;
          enum blanks := enumeration offset (act l, next l, in enum, act text start);
          IF enum blanks <> 0
             THEN in enum := TRUE;
                  past enumerator pos := pos (act l, " ", act text start);
                  change (act l, past enumerator pos, enum blanks, indent code)
             ELSE in enum := FALSE;
                  IF NOT is last line of paragraph CAND
                     next indent level > act indent level
                     THEN cat to dos l (indent code);
                          cat to dos l (margin rel code)
                  FI
          FI
   FI
END PROC process act line;
PROC complement pending paired commands :
  reset modifications;
  IF current wp size <> 3
     THEN cat to wp command (wp types on off [current wp size]);
          cat to dos l (wp cmd)
  FI;
END PROC complement pending paired commands;
PROC transfer line in chunks :
  WHILE act text start <= LENGTH act l REP
    next text command pos (act l, act text start, first cross pos, second cross pos);
    IF first cross pos <> 0
       THEN IF first cross pos <> act text start
               THEN process text chunk (act text start, first cross pos - 1)
            FI;
            process eumel command (first cross pos, second cross pos);
            act text start := second cross pos + 1
       ELSE process text chunk (act text start, LENGTH act l);
            LEAVE transfer line in chunks
    FI;
  PER
END PROC transfer line in chunks;
PROC process text chunk (INT CONST start pos, end pos) :
  eumel chunk := subtext (act l, start pos, end pos);
  IF in header COR in bottom
     THEN change all (eumel chunk, "%", page no cmd)
  FI;
  IF line contains number sign
     THEN change all (eumel chunk, ""222"", "#")
  FI;
  cat to dos l (eumel chunk);
  text in dos l := TRUE;
  IF in index
     THEN index buffer CAT eumel chunk
  FI
END PROC process text chunk;
PROC process eumel command (INT CONST start pos, end pos) :
  eumel chunk := subtext (act l, start pos + 1, end pos - 1);
  IF (eumel chunk SUB 1) = "-"
     THEN process comment (eumel chunk)
     ELSE process command
  FI;
  cat to dos l (wp cmd);
  wp cmd := ""
.
  process command :
    analyze command (cosmetic cmds, eumel chunk, 3, cmd index, no of params,
                     param1, param2);
    customized command processing;
    IF in index
       THEN index buffer CAT wp cmd
    FI
.
  customized command processing :
    SELECT cmd index OF
      CASE type1      : process type cmd (param1)
      CASE linefeed   : cat to wp command ("s\316" +
                        german real (param1) + "\\rt\&")
      CASE limit      : process limit (param1)
      CASE free       : process free (param1)
      CASE page cmd0  : cat to wp command ("s\_")
      CASE page cmd1  : cat to wp command ("s\_\3261" + param1 + "\\rt\&")
      CASE on         : process mod on (param1)
      CASE off        : process mod off (param1)
      CASE page nr    : 
      CASE pagelength : process pagelength (param1)
      CASE start      : process start (param1, param2)
      CASE foot       : process footnote
      CASE end        : process end
      CASE head,
           headeven,
           headodd    : process head (cmd index)
      CASE bottom,
           bottomeven,
           bottomodd  : process bottom (cmd index)
      CASE block      : cat to wp command ("s\3134\&")
      CASE material   :
      CASE columns    : process columns
      CASE columnsend : cat to wp command ("s\>12")
      CASE ib0,
           ib1,
           ib2        : process index on (param1, param2)
      CASE ie0, ie1, ie2 : process index off (param 1)
      CASE topage     : cat to wp command ("s\<111" + param1 + wp return)
      CASE goalpage   : cat to wp command ("s\<12" + param1 + wp return)
      CASE count0     : cat to wp command ("s\051\\rt")
      CASE count1     : process reference target (param1)
      CASE setcount   : cat to wp command ("s\J13" + param1 + wp return)
      CASE value0     : 
      CASE value1     : cat to wp command ("s\<114" + param1 + wp return)
      CASE table      : process table
      CASE table end  : process table end
      CASE r pos, l pos, c pos, d pos,
           b pos      : process tab stop (eumel chunk SUB 1, param1)
      CASE clear pos0 : process clear all tabs
      CASE clear pos1 : process clear tab (param1)
      CASE right      : cat to wp command ("s\=")
      CASE center     : cat to wp command ("s\1")
      CASE skip       :
      CASE skip end   :
      CASE u cmd      : process script cmd (1)
      CASE d cmd      : process script cmd (2)
      CASE e cmd      : process e cmd
      CASE head on    :
      CASE head off   : cat to wp command ("s\32311\&")
      CASE bottom on  :
      CASE bottom off : cat to wp command ("s\32411\&")
      CASE count per page : cat to wp command ("s\J146y\&")
      CASE fillchar   :
      CASE mark cmd   :
      CASE mark end    :
      CASE pageblock  :
      CASE bsp        :
      CASE counter1   :
      CASE counter2   :
      CASE setcounter :
      CASE putcounter0:
      CASE putcounter1:
      CASE storecounter:
      CASE ub         : process mod on ("u")
      CASE ue         : process mod off ("u")
      CASE fb         :
      CASE fe         :
      CASE region, region end : cat to wp command ("p\3y")
    END SELECT
END PROC process eumel command;
PROC process comment (TEXT CONST t) :
  buffer := "p\Hy";
  cat to wp command (buffer);
  wp cmd CAT subtext (t, 2);
  cat to wp command (buffer)
END PROC process comment;
PROC cat to dos l (TEXT CONST t) :
  LET mtl = 32000;
  INT CONST t length := LENGTH t;
  IF mtl - t length < dos l length
     THEN report ("Absatz ist zu lang")
     ELSE dos l CAT t;
          dos l length INCR t length
  FI
END PROC cat to dos l;
PROC cat to wp command (TEXT CONST t) :
  IF t <> ""
     THEN wp cmd CAT wp cmd start;
          wp cmd CAT t;
          wp cmd CAT wp cmd end
  FI
END PROC cat to wp command;
PROC process mod on (TEXT CONST kind of mod) :
  TEXT CONST mod char := kind of mod SUB 1;
  INT CONST mod no := pos (eumel modifications, mod char);
  cat to wp command (wp mods on off [mod no]);
  set bit (mod flags, mod no)
END PROC process mod on;
PROC process mod off (TEXT CONST kind of mod) :
  TEXT CONST mod char := kind of mod SUB 1;
  INT CONST mod no := pos (eumel modifications, mod char);
  process mod off (mod no)
END PROC process mod off;
PROC process mod off (INT CONST mod no) :
  cat to wp command (wp mods on off [mod no]);
  reset bit (mod flags, mod no)
END PROC process mod off;
PROC reset modifications :
  INT VAR mod no;
  IF mod flags > 0
     THEN FOR mod no FROM 1 UPTO 4 REP
            IF bit (mod flags, mod no)
               THEN process mod off (mod no)
            FI
          PER
  FI
END PROC reset modifications;
PROC process type cmd (TEXT CONST wanted type) :
  reset modifications;
  current wp size off;
  process type change (wanted type)
.
  current wp size off :
    cat to wp command (wp types on off [current wp size])
END PROC process type cmd;
PROC process type change (TEXT CONST eumel type) :
  current font             := font (eumel type);
  current indent pitch     := xstep conversion (indentation pitch (current font));
  TEXT CONST eumel type no := code (current font);
  INT CONST eumel size     := pos (font number string, eumel type no);
  current wp size          := eumel size - base font offset;
  IF current wp size < 1
     THEN current wp size := 1
  ELIF current wp size > 6
     THEN current wp size := 6
  FI;
  cat to wp command (wp types on off [current wp size])
END PROC process type change;
PROC process script cmd (INT CONST script value) :
  current script value := script value;
  cat to wp command (wp scripts on off [script value])
END PROC process script cmd;
PROC process e cmd :
  cat to wp command (wp scripts on off [current script value]);
  current script value := 0
END PROC process e cmd;
PROC process free (TEXT CONST cm) :
  IF NOT in header COR in bottom  
     THEN buffer := "s\3412";
          buffer CAT german real (cm);
          buffer CAT "c\\rt\&";
          cat to wp command (buffer)
  FI
END PROC process free;
PROC process limit (TEXT CONST t limit) :
  current limit := real (t limit);
  current limit := min (current limit, paper width - 2.0 * minimal margin);
  process horizontal margins
END PROC process limit;
PROC process horizontal margins :
  current right margin := paper width - current limit - current left margin;
  IF current right margin - minimal margin < 0.0
     THEN current right margin := minimal margin;
          current left margin := paper width - current limit - current right margin
  FI;
  wp cmd := wp cmd start;
  wp cmd CAT "s\317";
  wp cmd CAT german real (current left margin);
  wp cmd CAT "c\\rt";
  wp cmd CAT german real (current right margin);
  wp cmd CAT "c\\rt\&";
  wp cmd CAT wp cmd end;
END PROC process horizontal margins;
PROC process pagelength (TEXT CONST t length) :
  current pagelength := real (t length);
  current pagelength
            := min (current pagelength, paper length - 2.0 * minimal margin);
  process vertical margins
END PROC process pagelength;
PROC process vertical margins :
  current bottom margin := paper length - current pagelength - current top margin;
  IF current bottom margin - minimal margin < 0.0
     THEN current bottom margin := minimal margin;
          current top margin
                 := paper length - current pagelength - current bottom margin
  FI;
  wp cmd := wp cmd start;
  wp cmd CAT "s\325";
  wp cmd CAT german real (current top margin);
  wp cmd CAT "c\\rt";
  wp cmd CAT german real (current bottom margin);
  wp cmd CAT "c\\rt\&";
  wp cmd CAT wp cmd end;
END PROC process vertical margins;
PROC process start (TEXT CONST t x, t y) :
  current left margin := real (t x);
  process horizontal margins;
  current top margin  := real (t y);
  process vertical margins
END PROC process start;
PROC process footnote :
  IF in footnote
     THEN report ("Fu"251"notenschachtelung")
  FI;
  paired move cmd := "f\J11 \\rt\&";
  cat to wp command (paired move cmd);
  in footnote := TRUE
END PROC process footnote;
PROC process head (INT CONST index) :
  IF in header
     THEN report ("Header-Schachtelung")
  FI;
  paired move cmd := "f\323";
  IF index <= headeven
     THEN paired move cmd CAT "1";
          IF index = head
             THEN paired move cmd CAT "2"
             ELSE paired move cmd CAT "4"
          FI
     ELSE paired move cmd CAT "23"
  FI;
  paired move cmd CAT "\\rt\&00";
  cat to wp command (paired move cmd);
  in header := TRUE
END PROC process head;
PROC process bottom (INT CONST index) :
  IF in bottom
     THEN report ("Bottom-Schachtelung")
  FI;
  paired move cmd := "f\324";
  IF index <= bottomeven
     THEN paired move cmd CAT "1";
          IF index = bottom
             THEN paired move cmd CAT "2"
             ELSE paired move cmd CAT "4"
          FI
     ELSE paired move cmd CAT "23"
  FI;
  paired move cmd CAT "\\rt\&00";
  cat to wp command (paired move cmd);
  in bottom := TRUE
END PROC process bottom;
PROC process end :
  reset types and mods;
  cat to wp command (paired move cmd);
  IF in header
     THEN in header := FALSE
  ELIF in bottom
     THEN in bottom := FALSE
  ELIF in footnote
     THEN in footnote := FALSE
  ELSE report ("Unmotivierte End-Anweisung")
  FI
.
reset types and mods :
  reset modifications;
  IF current wp size <> 3
     THEN cat to wp command (wp types on off [current wp size]);
          current wp size := 3;
  FI
END PROC process end;
PROC process columns :
  INT VAR fcp, scp;
  cat to wp command ("s\>1301");          
  next text command pos (act l, act text start, fcp, scp);
  IF fcp = second cross pos + 1
     THEN eumel chunk := subtext (act l, fcp + 1, scp - 1);
          analyze command (cosmetic cmds, eumel chunk, 3, cmd index,
                           no of params, param1, param2);
          IF cmd index = limit
             THEN second cross pos := scp
          FI
  FI                       
END PROC process columns;
PROC process index on (TEXT CONST index number, registered text) :
  IF in index
     THEN report ("Kann Indexschachtelung nicht verarbeiten")
  FI;
  current index number := int (index number);
  index buffer := "<|s\<3";
  IF registered text <> ""
     THEN index buffer CAT registered text
     ELSE in index := TRUE
  FI
END PROC process index on;
PROC process index off (TEXT CONST index number) :
  INT CONST index off number := int (index number);
  IF current index number = index off number
     THEN current index number := 0
     ELSE report ("Kann Indexschachtelung nicht verarbeiten")
  FI;
  wp cmd := index buffer;
  wp cmd CAT "\\rt\ |>";
  in index := FALSE
END PROC process index off;
PROC process reference target (TEXT CONST marker) :
  buffer := "s\J21\&\<12";
  buffer CAT marker;
  buffer CAT wp return;
  cat to wp command (buffer)
END PROC process reference target;
PROC process table :
  IF users tabs cmd <> no users tabs cmd
     THEN wp cmd := users tabs cmd
  FI;
  in table := TRUE
END PROC process table;
PROC process table end :
  wp cmd := global tabs cmd;
  in table := FALSE
END PROC process table end;
PROC process tab stop (TEXT CONST tab type, tab pos) :
  buffer := german real (tab pos);
  buffer CAT wp return;
  IF pos ("rcd", tab type) <> 0
     THEN buffer CAT tab type
  FI;                     
  insert new tab stop;
  IF in table
     THEN wp cmd CAT users tabs cmd
  FI
.
insert new tab stop :
  insert char (users tabs cmd, buffer, current tab insert pos);
  current tab insert pos INCR LENGTH buffer
END PROC process tab stop;
PROC process clear all tabs :
  users tabs cmd := no users tabs cmd;
  current tab insert pos := default tab insert pos;
END PROC process clear all tabs;
PROC process clear tab (TEXT CONST tab pos) :
  INT VAR del start, del end;
  del start := pos (users tabs cmd, tab pos);
  IF del start <> 0
     THEN clear pos
  FI
.
clear pos :
  del end := pos (users tabs cmd, wp return, del start) + 4;
  buffer := users tabs cmd SUB del end + 1;
  IF pos ("rcd", buffer) <> 0
     THEN del end INCR 1
  FI;
  change (users tabs cmd, del start, del end, "");
  IF in table
     THEN wp cmd CAT users tabs cmd
  FI
END PROC process clear tab;
PROC report (TEXT CONST t) :
  errorstop ("Zeile " + text (act l no) + ": " + t)
END PROC report;
TEXT PROC german real (TEXT CONST t) :
  TEXT VAR t1 := t;
  change (t1, ".", ",");
  t1
END PROC german real;
TEXT PROC german real (REAL CONST r) :
  TEXT VAR t := text (r);
  german real (t)
END PROC german real;
END PACKET wordperfect conversion;
