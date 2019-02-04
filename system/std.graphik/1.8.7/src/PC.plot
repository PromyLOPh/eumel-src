PACKET clipping DEFINES set range,            (*Autor: Heiko Indenbirken *)
                        get range,            (*Stand:    27.06.85/12:39 *)
                        clip:                 (*Änderung: 11.08.86/15:02 *)

INT VAR x min :: 0, x max :: 1024, y min :: 0, y max :: 1024;

PROC set range (INT CONST h min, v min, h max, v max):
  IF h min >= h max OR v min >= v max
  THEN errorstop ("Incorrect Range") FI;
  x min := h min;  x max := h max;
  y min := v min;  y max := v max
END PROC set range;

PROC get range (INT VAR h min, v min, h max, v max):
  h min := x min;  h max := x max;
  v min := y min;  v max := y max
END PROC get range;

PROC clip (INT CONST from x, from y, to x, to y,
           PROC (INT CONST, INT CONST) move,
           PROC (INT CONST, INT CONST) draw):
  INT VAR x, y;
  calculate parts of line;
  IF both points inside
  THEN draw (from x, from y);                          (* Macke im SHARD *)
       draw (to x, to y)
  ELIF both points outside
  THEN 
  ELIF first point outside
  THEN intersection (to x, to y, from x, from y, from part, x, y);
       move (x, y);
       draw (x, y);                                    (* Macke im SHARD *)
       draw (to x, to y)
  ELIF second point outside
  THEN intersection (from x, from y, to x, to y, to part, x, y);
       draw (x, y)
  ELSE intersection (to x, to y, from x, from y, from part, x, y);
       move (x, y);
       draw (x, y);                                    (* Macke im SHARD *)
       clip (x, y, to x, to y,  PROC (INT CONST, INT CONST) move,
                                PROC (INT CONST, INT CONST) draw)
  FI  .

calculate parts of line:
  INT CONST from part :: part (from x, from y),
            to part   :: part (to x, to y)  .

both points inside:
  from part = 0 AND to part = 0  .

both points outside:
  (from part AND to part) <> 0  .

first point outside:
  from part <> 0 AND to part = 0  .

second point outside:
  to part <> 0 AND from part = 0  .

END PROC clip;

INT PROC part (INT CONST x, y):
  INT VAR index :: 0;
  IF x > x max
  THEN set bit (index, 0)
  ELIF x < x min
  THEN set bit (index, 1) FI;

  IF y > y max
  THEN set bit (index, 2)
  ELIF y < y min
  THEN set bit (index, 3) FI;

  index

END PROC part;

PROC intersection (INT CONST from x, from y, to x, to y, to part, INT VAR x, y):
  SELECT to part OF
  CASE  1: right side
  CASE  2: left side 
  CASE  4: up side 
  CASE  5: upright side 
  CASE  6: upleft side 
  CASE  8: down side 
  CASE  9: downright side 
  CASE 10: downleft side
  OTHERWISE errorstop ("wrong partno.:" + text (to part)) ENDSELECT  .

right side:
  y := from y + int (real (x max-from x)*(dy/dx));
  x := x max  .

left side:
  y := from y + int (real (x min-from x)*(dy/dx));
  x := x min  .

up side:
  x := from x + int (real (y max-from y)*(dx/dy));
  y := y max  .

down side:
  x := from x + int (real (y min-from y)*(dx/dy));
  y := y min  .

upright side:
  right side;
  IF y > y max
  THEN up side FI  .

downright side:
  right side;
  IF y < y min
  THEN down side FI  . 

upleft side:
  left side;
  IF y > y max
  THEN up side FI  .

downleft side:
  left side;
  IF y < y min
  THEN down side FI  .

dx: real (to x-from x)  .
dy: real (to y-from y)  .

END PROC intersection;

END PACKET clipping;

PACKET thick line DEFINES thick:              (*Autor: Heiko Indenbirken *)
                                              (*Stand:    02.07.85/15:07 *)
                                              (*Änderung: 05.08.86/15:52 *)
PROC thick (INT CONST x0, y0, x1, y1, thick,
            PROC (INT CONST, INT CONST, INT CONST, INT CONST) line):
  IF is point
  THEN draw point
  ELIF is horizontal line 
  THEN horizontal line (PROC (INT CONST, INT CONST, INT CONST, INT CONST) line,
                        x0, y0, x1, y1, thick)
  ELSE vertical line (PROC (INT CONST, INT CONST, INT CONST, INT CONST) line,
                      x0, y0, x1, y1, thick)
  FI  .

is point:
  x0 = x1 AND y0 = y1  .

is horizontal line:
  abs (x0-x1) >= abs (y0-y1)  .

draw point:
  INT VAR i;
  FOR i FROM -thick UPTO thick
  REP line (x0-thick, y0+i, x0+thick, y0+i) PER  .

END PROC thick;

PROC horizontal line (PROC (INT CONST, INT CONST, INT CONST, INT CONST) line,
                      INT CONST from x, from y, to x, to y, thick):
  IF from x > to x
  THEN horizontal line (PROC (INT CONST, INT CONST, INT CONST, INT CONST) line, 
                        to x, to y, from x, from y, thick)
  ELSE draw line FI  .

draw line:
  INT VAR i;
  calculate increase;
  calculate limit points;
  FOR i FROM -thick UPTO thick
  REP calculate delta x;
      line (x start+delta x, y start+i, x end+delta x, y end+i)
  PER  .

calculate increase:
  REAL VAR increase :: -dy / dx  .

calculate limit points:
  INT CONST x start :: from x - thick,
            x end   :: to x   + thick,
            y start :: from y + int (increase * real (thick)), 
            y end   :: to y   - int (increase * real (thick))  .

calculate delta x:
  INT CONST delta x :: int (increase*real (i))  .

dx: real (to x-from x)  .
dy: real (to y-from y)  .

END PROC horizontal line;

PROC vertical line (PROC (INT CONST, INT CONST, INT CONST, INT CONST) line,
                    INT CONST from x, from y, to x, to y, thick):
  IF from y > to y
  THEN vertical line (PROC (INT CONST, INT CONST, INT CONST, INT CONST) line,
                      to x, to y, from x, from y, thick)
  ELSE draw line FI  .

draw line:
  INT VAR i;
  calculate increase;
  calculate limit points;
  FOR i FROM -thick UPTO thick
  REP calculate delta y;
      line (x start+i, y start+delta y, x end+i, y end+delta y)
  PER  .

calculate increase:
  REAL VAR increase :: -dx / dy  .

calculate limit points:
  INT CONST x start :: from x + int (increase * real (thick)), 
            x end   :: to x   - int (increase * real (thick)),
            y start :: from y - thick,
            y end   :: to y   + thick  .

calculate delta y:
  INT CONST delta y :: int (increase*real (i))  .

dx: real (to x-from x)  .
dy: real (to y-from y)  .

END PROC vertical line;

END PACKET thick line;

PACKET graphik text DEFINES draw char,        (*Autor: Heiko Indenbirken *)
                            zeichensatz:      (*Stand:    27.06.85/16:03 *)
                                              (*Änderung: 28.06.85/19:06 *)
                                              (*Änderung: 05.08.86/16:00 *)
LET ZEICHENSATZ = ROW 255 TEXT;
ZEICHENSATZ VAR zeichen;
INT CONST char x :: 6, char y :: 10;

zeichensatz ("ZEICHENSATZ");

PROC zeichensatz (TEXT CONST name):
  IF exists (name)
  THEN BOUND ZEICHENSATZ VAR new zeichen :: old (name);
       zeichen := new zeichen;
  ELSE errorstop ("Der Zeichensatz """ + name + """ existiert nicht") FI
END PROC zeichensatz;

PROC draw char (INT CONST char no, INT CONST x, y, x size, y size, direction,
                PROC (INT CONST, INT CONST, INT CONST, INT CONST) line):
  TEXT CONST character :: zeichen [char no];
  INT VAR n :: 1, x0, y0, x1, y1;
  INT CONST len :: length (character);
  WHILE n < len
  REP value (character, n, x0, y0, x1, y1);
      transform (x0, y0, x, y, x size, y size, direction);
      transform (x1, y1, x, y, x size, y size, direction); 
      line (x0, y0, x1, y1);
      n INCR 4
  PER  .

END PROC draw char;

PROC value (TEXT CONST char, INT CONST n, INT VAR x0, y0, x1, y1):
  x0 := val (code (char SUB n));    y0 := val (code (char SUB n+1));
  x1 := val (code (char SUB n+2));  y1 := val (code (char SUB n+3));
END PROC value;

INT PROC val (INT CONST n):
  IF n > 127
  THEN -256 OR n
  ELSE n FI
END PROC val;

PROC transform (INT VAR x, y, INT CONST x0, y0, x size, y size, direction):
  INT CONST old x :: x, old y :: y;
  SELECT direction OF
  CASE 0: x := x0 + x vektor;  y := y0 + y vektor
  CASE 1: x := x0 - y vektor;  y := y0 + x vektor
  CASE 2: x := x0 - x vektor;  y := y0 - y vektor
  CASE 3: x := x0 + y vektor;  y := y0 - x vektor
  ENDSELECT  .

x vektor:
  IF x size = 0
  THEN old x
  ELSE (old x*x size) DIV char x FI  .

y vektor:
  IF y size = 0
  THEN old y
  ELSE (old y*y size) DIV char y FI  .

END PROC transform;

END PACKET graphik text;

PACKET graphik text DEFINES draw text:        (*Autor: Heiko Indenbirken *)
                                              (*Stand:    03.07.85/11:55 *)
                                              (*Änderung: 05.08.86/16:04 *)
PROC draw text (INT CONST x pos, y pos,
                TEXT CONST msg, REAL CONST angle, INT CONST height, width,
                PROC (INT CONST, INT CONST,
                INT CONST, INT CONST, INT CONST, INT CONST) draw char):
  INT CONST dir :: int (((angle MOD 360.0)+45.0) / 90.0);
  INT VAR i;
  REAL VAR x :: real (x pos), y :: real (y pos),
           x step :: cosd (angle)*real (width),
           y step :: sind (angle)*real (width);
  FOR i FROM 1 UPTO length (msg)
  REP IF control char
      THEN execute control char
      ELSE execute normal char FI
  PER  .

control char:
  akt char < ""32""  .

execute control char:
  SELECT code (akt char) OF
  CASE  1: home
  CASE  2: right
  CASE  3: up
  CASE  7: out (""7"")
  CASE  8: left
  CASE 10: down
  CASE 13: return
  ENDSELECT  .

home:
  x := real (x pos);
  y := real (y pos)  .

right:
  x INCR x step;  y INCR y step  . 

up:
  x INCR y step;  y INCR x step  . 

left:
  x DECR x step;  y DECR y step  .

down:
  x DECR y step;  y DECR x step  . 

return:
  x := real (x pos)  .

execute normal char:
  draw char (code (akt char), dir, int (x+0.5), int (y+0.5), height, width);
  x INCR x step;
  y INCR y step  .

akt char:
  msg SUB i  .

END PROC draw text;

END PACKET graphik text;

PACKET comercial plot DEFINES bar,            (*Autor: Heiko Indenbirken *)
                              circle:         (*Stand:    03.04.1985     *)
                                              (*Änderung: 03.07.85/15:37 *)
PROC bar (INT CONST from x, from y, to x, to y, pattern,
          PROC (INT CONST, INT CONST, INT CONST, INT CONST) line):
  IF from x > to x
  THEN bar (to x, from y, from x, to y, pattern, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line)
  ELIF from y > to y
  THEN bar (from x, to y, to x, from y, pattern, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line)
  ELSE draw frame;
       fill frame with pattern
  FI  .

draw frame:
  line (from x, from y, from x, to y);
  line (from x, to y, to x, to y);
  line (to x, to y, to x, from y);
  line (to x, from y, from x, from y)  .

fill frame with pattern:
  SELECT pattern OF
  CASE 1: fill right (from x, to x, from y, to y, 2, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line)
  CASE 2: fill hor   (from x, to x, from y, to y, 1, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line)
  CASE 3: fill hor   (from x, to x, from y, to y, 5, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line)
  CASE 4: fill vert  (from x, to x, from y, to y, 5, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line)
  CASE 5: fill hor   (from x, to x, from y, to y, 5, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line);
          fill vert  (from x, to x, from y, to y, 5, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line)
  CASE 6: fill right (from x, to x, from y, to y, 5, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line)
  CASE 7: fill left  (from x, to x, from y, to y, 5, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line)
  CASE 8: fill right (from x, to x, from y, to y, 5, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line);
          fill left  (from x, to x, from y, to y, 5, PROC (INT CONST, INT CONST, INT CONST, INT CONST) line)
  ENDSELECT  .

END PROC bar;

PROC fill hor (INT CONST from x, to x, from y, to y, step,
               PROC (INT CONST, INT CONST, INT CONST, INT CONST) line):
  INT VAR y :: from y;
  REP line (from x, y, to x, y);
      y INCR step
  UNTIL y > to y PER  .

END PROC fill hor;

PROC fill vert (INT CONST from x, to x, from y, to y, step,
                PROC (INT CONST, INT CONST, INT CONST, INT CONST) line):
  INT VAR x :: from x;
  REP line (x, from y, x, to y);
      x INCR step
  UNTIL x > to x PER  .

END PROC fill vert;

PROC fill right (INT CONST from x, to x, from y, to y, step,
                 PROC (INT CONST, INT CONST, INT CONST, INT CONST) line):
  INT CONST width  :: to x - from x,
            height :: to y - from y,
            length :: width + height,
            height step :: height + step,
            width step  :: width + step;

  INT VAR t :: step, left  :: from x, right :: from x,
                     lower :: from y, upper :: from y;
(*               Ausfüllen von links unten nach rechts oben              *)
  WHILE t < length
  REP calc start point;
      calc end point;
      line (left, upper, right, lower);
      t INCR step
  PER  .

calc start point:
  IF t < height
  THEN upper INCR step
  ELIF t < height step
  THEN left  := from x + t - height;
       upper := to y
  ELSE left INCR step FI  .

calc end point:
  IF t < width
  THEN right INCR step
  ELIF t < width step
  THEN lower := from y + t - width;
       right := to x
  ELSE lower INCR step FI  .

END PROC fill right;

PROC fill left (INT CONST from x, to x, from y, to y, step,
                PROC (INT CONST, INT CONST, INT CONST, INT CONST) line):
  INT CONST width  :: to x - from x,
            height :: to y - from y,
            length :: width + height,
            height step :: height + step,
            width step  :: width + step;

  INT VAR t :: step, left  :: to x,   right :: to x,
                     lower :: from y, upper :: from y;
(*               Ausfüllen von rechts unten nach links oben              *)
  WHILE t < length
  REP calc start point;
      calc end point;
      line (right, upper, left, lower);
      t INCR step
  PER  .

calc start point:
  IF t < height
  THEN upper INCR step
  ELIF t < height step
  THEN right := to x - t + height;
       upper := to y
  ELSE right DECR step FI  .

calc end point:
  IF t < width
  THEN left DECR step
  ELIF t < width step
  THEN lower := from y + t - width;
       left  := from x
  ELSE lower INCR step FI  .

END PROC fill left;

PROC circle (INT CONST x, y, rad, REAL CONST  from, to, INT CONST pattern,
             PROC (INT CONST, INT CONST, INT CONST, INT CONST) line):
  REAL VAR t :: from;
  INT VAR last x :: x, last y :: y;
  WHILE t <= to
  REP calc circle;
      draw step;
      t INCR 5.0
  PER;
  line (x rad, y rad, x, y)  .

draw step:
  IF pattern = 0
  THEN line (last x, last y, x rad, y rad);
       last x := x rad;
       last y := y rad
  ELSE line (x, y, x rad, y rad) FI  .

calc circle:
  INT CONST x rad :: int (cosd (t)*real (rad)+0.5)+x,
            y rad :: int (sind (t)*real (rad)+0.5)+y  .

END PROC circle;

END PACKET comercial plot;

PACKET pc plot DEFINES drawing area,          (*Autor: Heiko Indenbirken *)
                       begin plot,            (*Stand:    20.05.85       *)
                       end plot,              (*Änderung: 27.06.85/16:17 *)
                       clear,                 (*Änderung: 03.07.85/15:59 *)
                                              (*Änderung: 06.08.86/10:03 *)
                       graphik,
                       set pen, get pen, 

                       move, 
                       draw,
                       draw line,
                       marker,
                       bar, circle,
                       where:

 
LET POS = STRUCT (INT x, y);
LET PEN = STRUCT (INT back, fore, thick, line);
INT CONST back code  :: -4,
          modus code :: -5,
          draw code  :: -6,
          move code  :: -7,
          pen code   :: -8,
          full line  :: -1;
 
INT VAR d, y, pause time :: 10,
        resolution :: 4, max x :: 319, max y :: 199; 
BOOL VAR is clear := FALSE;
POS VAR old :: POS : (0, 0);
PEN VAR pen :: PEN : (0, 1, 0, full line);

PROC drawing area (REAL VAR x cm, y cm, INT VAR x pixel, y pixel) : 
   x cm    := 22.0;    y cm    := 13.7; 
   x pixel := max x;   y pixel := max y;
END PROC drawing area;

PROC graphik (INT CONST modus, pause):
  pause time := pause;
  SELECT modus OF
  CASE 0: resolution := 3;
  CASE 1: resolution := 72;
          max x := 639;
          max y := 399 
  CASE 2: resolution := 64;
          max x := 639;
          max y := 399 
  CASE 3: resolution := 6;
          max x := 639;
          max y := 199 
  CASE 4: resolution := 4;
          max x := 319;
          max y := 199
  OTHERWISE errorstop ("Nur Modi 0-4") ENDSELECT;

  set range (0, 0, max x, max y);
END PROC graphik;
 
PROC begin plot : 
  control (modus code, resolution, 0, d);
  is clear := TRUE;
ENDPROC begin plot ;

PROC end plot : 
  IF pause time > 0
  THEN indicate end plot FI;
  control (modus code, 3, 0, d)  .

indicate end plot:
  control (pen code, full line, full line, d);
  REP set indicator;
  UNTIL incharety (pause time) <> "" PER  .

set indicator:
  control (move code, 0, max y, d);
  control (draw code, max x, max y, d)  .

ENDPROC end plot ;

PROC clear:
  INT VAR x0, x1, y0, y1;
  new values (22.0, 13.7, max x, max y, x0, x1, y0, y1);
  set range (x0, y0, x1, y1);
  clear screen;
  clear pen;
  clear pos;
  is clear := FALSE  .

clear screen:
  IF is clear OR full screen
  THEN control (modus code, resolution, 0, d)
  ELSE draw frame;
       clear frame
  FI  .

full screen:
  x0 < 10 AND x1 > (max x-10) AND
  y0 < 10 AND y1 > (max y-10)  .

draw frame:
   control (move code, x0, y0, d);
   control (draw code, x1, y0, d);
   control (draw code, x1, y1, d);
   control (draw code, x0, y1, d);
   control (draw code, x0, y0, d)  .

clear frame:
  control (pen code, full line, 0, d);
  FOR y FROM max y-y1 UPTO max y-y0
  REP control (move code, x0, y, d); 
      control (draw code, x1, y, d); 
  PER  .

clear pen:
  pen := PEN : (0, 1, 0, full line); 
  control (pen code, full line, 1, d)  .

clear pos:
  old := POS : (x0, y0);
  control (move code, x0, max y-y0, d)  .

END PROC clear;

PROC set pen (INT CONST back, fore, thick, type):
  set background;
  set foreground and linetype;
  set thickness  .

set background:
  pen.back := back;                    (*Hintergrund über niederwertiges *)
  control (back code, 0, back no, d)  .(*Byte von colour code            *)
                                       (*Höherwetiges Byte regelt die    *)
back no:                               (*Farbpalette                     *)
  IF back = 0
  THEN std background
  ELSE back FI  .

std background:
  IF resolution = 4
  THEN 16
  ELSE 15 FI  .

set foreground and linetype:               (*0, 1, 2, 3 Farben: löschend,*)
  pen.fore := possible colour;             (*ändernd oder überschreibend *)
  pen.line := type;                        (* in allen Linientypen.      *)
  control (pen code, line (type), pen.fore, d)  .

possible colour:
  IF fore <= full line
  THEN full line
  ELIF fore > 3 OR  (fore > 1 AND resolution <> 4)
  THEN 1
  ELSE fore FI  .

set thickness:
  pen.thick := thick DIV 10  .

END PROC set pen;

PROC get pen (INT VAR back, fore, thick, line):
  back  := pen.back;
  fore  := pen.fore;
  thick := pen.thick;
  line  := pen.line
END PROC get pen;

INT PROC line (INT CONST type):
  SELECT type OF
  CASE 0: 0
  CASE 1: full line
  CASE 2: 21845
  CASE 3: 3855
  CASE 4: 255
  CASE 5: 4351
  OTHERWISE type END SELECT
END PROC line;

PROC int move (INT CONST x, y):
  control (move code, x,  max y-y, d);
END PROC int move;

PROC int draw (INT CONST x, y):
  control (draw code, x, max y-y, d);
END PROC int draw;

PROC draw line (INT CONST from x, from y, to x, to y):
  control (move code, from x, max y-from y, d);
  clip (from x, from y, to x, to y, PROC int move, PROC int draw)
END PROC draw line;

PROC move (INT CONST x, y) :
  control (move code, x, max y-y, d);
  old := POS  : (x, y) 
END PROC move;
 
PROC draw (INT CONST x, y):
  IF std thickness
  THEN clip (old.x, old.y, x, y, PROC int move, PROC int draw)
  ELSE thick (old.x, old.y, x, y, pen.thick, PROC (INT CONST, INT CONST, INT CONST, INT CONST) draw line) FI;
  old := POS  : (x, y)   .

std thickness:  pen.thick = 0  .
END PROC draw;

PROC draw (TEXT CONST msg, REAL CONST angle, INT CONST height, width):
  control (pen code, full line, pen.fore, d);
  draw text (old.x, old.y, msg, angle, y size, x size,
  PROC (INT CONST, INT CONST, INT CONST, INT CONST, INT CONST, INT CONST) draw char);
  control (move code, old.x, max y-old.y, d);
  control (pen code, line (pen.line), pen.fore, d)  .

x size: IF width = 0
        THEN 6
        ELSE width FI  .
y size: IF height = 0
        THEN 10
        ELSE height FI .

END PROC draw;

PROC draw char (INT CONST char, direction, x, y, INT CONST height, width):
  draw char (char, x, y, width, height, direction,
             PROC (INT CONST, INT CONST, INT CONST, INT CONST) draw line)
END PROC draw char;

PROC bar (INT CONST from x, from y, to x, to y, pattern):
  control (pen code, full line, pen.fore, d);
  bar (from x, from y, to x, to y, pattern, PROC (INT CONST, INT CONST, INT CONST, INT CONST) draw line);
  control (move code, old.x, max y-old.y, d);
  control (pen code, line (pen.line), pen.fore, d)  .
END PROC bar;

PROC circle (INT CONST x, y, rad, REAL CONST from, to, INT CONST pattern):
  control (pen code, full line, pen.fore, d);
  circle (x, y, rad, from, to, pattern, PROC (INT CONST, INT CONST, INT CONST, INT CONST) draw line);
  control (move code, old.x, max y-old.y, d);
  control (pen code, line (pen.line), pen.fore, d)  .
END PROC circle;

PROC marker (INT CONST x, y, no, size):
  control (pen code, full line, pen.fore, d);
  draw char (no, 0, x, y, size, size);
  control (move code, old.x, max y-old.y, d);
  control (pen code, line (pen.line), pen.fore, d)  .
END PROC marker;

PROC where (INT VAR x, y):
  x := old.x;  y := old.y
END PROC where;

END PACKET pc plot

