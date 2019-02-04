PACKET hp7475 plot DEFINES set range,         (*Autor: Heiko Indenbirken *)
                           get range,         (*Stand:    03.09.86/15:09 *)
                           drawing area,
                           begin plot,
                           end plot,
                           clear,

                           set pen, get pen, 
                           move, 
                           draw,
                           marker,
                           bar, circle,
                           where:

(*                                                                       *)
(*                     Hardware Anschluß des HP7475A:                    *)
(*                  9600 Baud, 8 Bit, no parity, RTS/CTS                 *)
(*   Leitungen                  1  -----  1                              *)
(*   gekreuzt:                  2  --x--  3                              *)
(*                              3  --x--  2                              *)
(*                                                                       *)


LET POS = STRUCT (INT x, y);
LET RANGE = STRUCT (POS min, max);
LET PEN = STRUCT (INT back, fore, thick, line);

LET width scale  = 0.002690217391304,
    height scale = 0.002728921124206;

LET term  = ";",
    comma = ",",
    point = ".",
    zero  = "0",
    nil   = "",
    etx   = ""3"";

 
POS VAR old :: POS:(0, 0);
RANGE VAR area :: RANGE:(POS:(0,0), POS:(11040, 7721));
PEN VAR pen :: PEN : (0, 1, 0, 1);
TEXT VAR result;

ROW 16 TEXT VAR mark := ROW 16 TEXT:
("99,0,2,-2,0,0,-4,4,0,0,4,-2,0;",
"99,0,2,-1,0,-1,-1,0,-2,1,-1,2,0,1,1,0,2,-1,1,-1,0;",
"99,0,2,-2,-3,4,0,-2,3;",
"-99,-2,0,99,4,0,-99,-2,2,99,0,-4;",
"-99,-2,-2,99,4,4,-99,-4,0,99,4,-4;",
"99,0,2,-2,-2,2,-2,2,2,-2,2;",
"-99,0,-2,99,0,4,-2,-2,4,0,-2,2;",
"-99,-2,0,99,4,0,-99,-2,2,99,0,-4,2,2,-2,2,-2,-2,2,-2;",
"-99,-2,-2,99,4,4,-4,0,4,-4;",
"-99,-2,2,99,4,0,-4,-4,4,0;",
"99,0,-2,-99,-2,4,99,2,-2,2,2;",
"99,1,1,-2,0,0,-2,2,0,0,2,1,1,-99,-4,0,99,1,-1,-99,0,-2,99,-1,-1,-99,4,0,99,-1,1;",
"-99,-2,0,99,4,0,-99,-1,1,99,-2,-2,-99,1,-1,99,0,4,-99,-1,-1,99,2,-2;",
"-99,-2,2,99,4,0,-4,-4,4,0,-4,4;",
"-99,-2,0,99,4,0;",
"-99,0,299,0,-4;");

ROW 5 TEXT CONST line pattern := ROW 5 TEXT:("LT;", "LT1;", "LT2;", "LT3;", "LT4;");
ROW 8 TEXT CONST fill pattern := ROW 8 TEXT:("FT4,25,45;", "FT1,0,0;", "FT3,50,0;",
                                 "FT3,50,90;", "FT4,50,0;", "FT3,50,-45;",
                                 "FT3,50,45;", "FT4,50,45;");

PROC drawing area (REAL VAR x cm, y cm, INT VAR x pixel, y pixel) :
   x cm    := 29.7;    y cm    := 21.07; 
   x pixel := 11040;    y pixel :=  7721;
END PROC drawing area;


PROC set range (INT CONST h min, v min, h max, v max):
  IF h min >= h max OR v min >= v max
  THEN errorstop ("Incorrect Range") FI;
  area := RANGE:(POS:(h min, v min), POS:(h max, v max))
END PROC set range;

PROC get range (INT VAR h min, v min, h max, v max):
  h min := area.min.x;   v min := area.min.y;
  h max := area.max.x;   v max := area.max.y
END PROC get range;

PROC begin plot: 
  out ("IN;")
ENDPROC begin plot;

PROC end plot: 
  TEXT VAR rec;
  out ("IN;SP;PA22040,7721;DP;");
  REP pause (10);
      out ("OS;");
      input (rec, ""13"", 600)
  UNTIL enter pressed PER;
  out ("IN;")  .

enter pressed:
  (int (rec) AND 4) > 0  .

ENDPROC end plot;

PROC clear:
  new values (29.7, 21.07, 11040, 7721, area.min.x, area.max.x, area.min.y, area.max.y);
  pen := PEN : (0, 1, 0, 1); 
  old := area.min;
  out ("DF;IP;");                                     (* Default     *)
  out ("IW" + text (area.min.x, area.min.y) + ", " +  (* Clipping    *)
               text (area.max.x, area.max.y) + term);
  out ("SP1;");                                       (* Pen 1       *)
  out ("LT;");                                        (* durchgehend *)
  out ("PU;PA" + text (old.x, old.y));                (*  Startpunkt *)

END PROC clear;

PROC set pen (INT CONST back, fore, thick, type):
  set colour;
  set linetype  .

set colour:
  IF abs (fore) >= 1 AND abs (fore) <= 6
  THEN out ("SP" + text (abs (fore)) + term);
       pen.fore := abs (fore);
  FI  .

set linetype:
  IF type >= 1 AND type <= 5
  THEN out (line pattern [type]);
       pen.line := type
  ELSE out ("SP;");
       pen.line := 0
  FI  .

END PROC set pen;

PROC get pen (INT VAR back, fore, thick, line):
  back  := pen.back;
  fore  := pen.fore;
  thick := pen.thick;
  line  := pen.line
END PROC get pen;

PROC move (INT CONST x, y) :
  out ("PU;PA" + text (x, y) + term);
  old := POS : (x, y) 
END PROC move;
 
PROC draw (INT CONST x, y):
  out ("PD;PA" + text (x, y) + term);
  old := POS : (x, y)
END PROC draw;

PROC draw (TEXT CONST msg, REAL CONST angle, INT CONST height, width):
  set angle;
  set height and width;
  plot msg  .

set angle:
  out ("DI " + text (cosd (angle), sind (angle)) + term)  .

set height and width:
  IF width = 0 AND height = 0
  THEN out ("SR;")
  ELSE out ("SI" + text (real (width) * width scale,
                             real (height) * height scale) + term)
  FI  .

plot msg:
  out ("LB" + msg + etx)  .

END PROC draw;

PROC bar (INT CONST from x, from y, to x, to y, pattern):
  out ("PU;PA" + text (from x, from y) + term);
  out ("LT;EA" + text (to x, to y) + term);
  IF pattern > 0 AND pattern <= 8
  THEN out (fill pattern [pattern]);
       out ("RA" + text (to x, to y) + term);
  FI;
  out ("PU;PA" + text (old.x, old.y) + term);
  out (line pattern [pen.line])  .

END PROC bar;

PROC circle (INT CONST x, y, rad, REAL CONST from, to, INT CONST pattern):
  out ("LT;PU;PA" + text (x, y) + term);
  IF (from MOD 360.0) = 0.0 AND (to MOD 360.0) = 0.0
  THEN out ("CI" + text (rad) + term)
  ELSE out ("EW" + text (rad) + comma + text (from, to-from) + term) FI;

  IF pattern > 0 AND pattern <= 6
  THEN out (fill pattern [pattern]);
       out ("WG" + text (rad) + comma + text (from, to-from) + term)
  FI;
  out ("PU;PA" + text (old.x, old.y) + term);
  out (line pattern [pen.line])  .

END PROC circle;

PROC marker (INT CONST x, y, no, size):
  out ("LT;PU;PA" + text (x, y) + term);
  out ("DI1,0;");
  IF size = 0
  THEN out ("SI0.25,0.5;")
  ELSE out ("SI" + text (real (size)*0.001, real (size)*0.002) + term) FI;
  out ("UC" + mark [mark no]);
  out ("PU;PA" + text (old.x, old.y) + term);
  out (line pattern [pen.line])  .

mark no:
  IF no >= 1 AND no <= 16
  THEN no
  ELSE 1 FI  .

END PROC marker;

PROC where (INT VAR x, y):
  x := old.x;  y := old.y
END PROC where;

TEXT PROC text (INT CONST x, y):
  text (x) + comma + text (y)
END PROC text;

TEXT PROC text (REAL CONST x, y):
  text (x) + comma + text (y)
END PROC text;

TEXT PROC text (REAL CONST x):
  result := compress (text (x, 9, 4));

  IF (result SUB 1) = point
  THEN insert char (result, zero, 1)
  ELIF (result SUB LENGTH result) = point
  THEN result CAT zero FI;
  result
END PROC text;

PROC input (TEXT VAR rec, TEXT CONST del, INT CONST time):
  enable stop;
  rec := nil;
  REP TEXT CONST char := incharety (time);

      IF char = nil
      THEN errorstop ("Timeout after " + text (time))
      ELIF pos (del, char) > 0
      THEN LEAVE input
      ELSE rec CAT char FI

  PER  .

END PROC input;

END PACKET hp7475 plot

