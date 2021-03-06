PACKET basis plot DEFINES                     (* Autor: Heiko Indenbirken*)
                                              (* Stand: 12.04.85         *)
                                              (*Änderung: 06.08.86/10:03 *)
(*  ******************  Hardwareunabhängiger Teil  ********************* *)
(*                                                                       *)
(*                                                                       *)
(*      Im Harwareunabhängigen Paket 'basis plot' werden folgende        *)
(*      Prozeduren definiert:                                            *)
(*      Procedure       :  Bedeutung                                     *)
(*      ---------------------------------------------------------------- *)
(*       move           :  Positioniert auf (x, y,[z]) in Weltkoordinaten*)
(*       draw           :  Zeichnet eine Linie bis zum Punkt (x, y, [z]).*)
(*       move r         :  Positioniert (x, y, [z]) weiter               *)
(*       draw r         :  Zeichnet (x, y, [z]) weiter                   *)
(*                                                                       *)
(*       draw           :  Zeichnet einen Text                           *)
(*                                                                       *)
(*       mark           :  Marker mit (no, size)                         *)
(*       bar            :  Balken mit (width, height, pattern)           *)
(*       bar            :  Balken mit (from, to, width, pattern)         *)
(*       circle         :  Kreis(segment) mit (radius, from, to, pattern)*)
(*                                                                       *)
(*       where          :  Gibt die aktuelle Stiftposition (x, y, [z])   *)
(*                                                                       *)
(*************************************************************************)

       move, draw,
       move r, draw r,
       mark, bar, circle,
       where:

LET POS = STRUCT (REAL x, y, z);

POS VAR pos :: POS : (0.0, 0.0, 0.0);
INT VAR h :: 0, v :: 0;

PROC move (REAL CONST x, y) :
  transform (x, y, 0.0, h, v);
  move (h, v);
  pos := POS : (x, y, 0.0)
END PROC move;

PROC move (REAL CONST x, y, z) :
  transform (x, y, z, h, v);
  move (h, v);
  pos := POS : (x, y, z)
END PROC move;

PROC draw (REAL CONST x, y) :
  transform (x, y, 0.0, h, v);
  draw (h, v);
  pos := POS : (x, y, 0.0)
END PROC draw;

PROC draw (REAL CONST x, y, z) :
  transform (x, y, z, h, v);
  draw (h, v);
  pos := POS : (x, y, z) 
END PROC draw;

PROC move r (REAL CONST x, y) :
  transform (pos.x+x, pos.y+y, pos.z, h, v);
  move (h, v);
  pos := POS : (pos.x+x, pos.y+y, pos.z)
END PROC move r;

PROC move r (REAL CONST x, y, z) :
  transform (pos.x+x, pos.y+y, pos.z+z, h, v);
  move (h, v);
  pos := POS : (pos.x+x, pos.y+y, pos.z+z)
END PROC move r;

PROC draw r (REAL CONST x, y) :
  transform (pos.x+x, pos.y+y, pos.z, h, v); 
  draw (h, v);
  pos := POS : (pos.x+x, pos.y+y, pos.z)
END PROC draw r;

PROC draw r (REAL CONST x, y, z) :
  transform (pos.x+x, pos.y+y, pos.z+z, h, v);
  draw (h, v);
  pos := POS : (pos.x+x, pos.y+y, pos.z+z)
END PROC draw r;

PROC where (REAL VAR x, y) :
  x := pos.x;  y := pos.y
END PROC where;

PROC where (REAL VAR x, y, z) :
  x := pos.x;  y := pos.y;  z := pos.z
END PROC where;

PROC draw (TEXT CONST msg, REAL CONST angle, height percent, width percent):
  draw (msg, angle, height (height percent), width (width percent))  .
END PROC draw;

PROC mark (REAL CONST size, INT CONST no):
  marker (h, v, no, diagonal (size))
END PROC mark;

PROC bar (REAL CONST width, height, INT CONST pattern):
  INT VAR diff, up, zero x, zero y;
  transform (0.0, 0.0, 0.0, zero x, zero y);
  transform (width*0.5, height, 0.0, diff, up);
  bar (h-(diff-zero x), v, h+(diff-zero x), v+(up-zero y), pattern);
  move (h, v) 

END PROC bar;

PROC bar (REAL CONST from, to, height, INT CONST pattern):
  INT VAR from h, to h, up;
  transform (from, height, 0.0, from h, up);
  transform (to,   height, 0.0, to h, up);
  bar (from h, v, to h, up, pattern);
  move (h, v) 

END PROC bar;

PROC circle (REAL CONST rad, from, to, INT CONST pattern):
  circle (h, v, diagonal (rad), from, to, pattern)  .

END PROC circle;

ENDPACKET basis plot;

PACKET plot DEFINES plot:                     (*Autor: Heiko Indenbirken *)
                                              (*Stand:    13.10.89/22:31 *)

LET draw key      = 1,
    move key      = 2,
    text key      = 3,
    move r key    = 4,
    draw r key    = 5,
    bar 2 key     = 6,
    bar 3 key     = 7,
    circle key    = 8,
    mark key      = 9;

LET dim error = "PICTURE not initialized",
    key error = "wrong key code: ";

TEXT VAR points;
INT VAR pic length, pic pen, pic dim, read pos;
PICTURE VAR pic;

PROC plot (PICTURE CONST pic):
  init plot;
  IF pic dim = 2
  THEN plot two dim pic
  ELIF pic dim = 3
  THEN plot three dim pic
  ELIF NOT (pic dim = 0 AND pic length = 0)
  THEN errorstop (dim error) FI;
  points := ""  .

init plot:
  picture (pic, points, pic dim, pic pen);
  pic length := length (points);
  read pos := 0  .

plot two dim pic:
  WHILE read pos < pic length
  REP plot two dim position PER  .

plot two dim position :
  read pos INCR 1;
  SELECT key OF
  CASE draw key:   draw (next real, next real)
  CASE move key:   move (next real, next real)
  CASE move r key: move r (next real, next real)
  CASE draw r key: draw r (next real, next real)
  CASE text key:   draw (next text, next real, next real, next real)
  CASE bar 2 key:  bar (next real, next real, next int) 
  CASE bar 3 key:  bar (next real, next real, next real, next int) 
  CASE circle key: circle (next real, next real, next real, next int) 
  CASE mark key:   mark (next real, next int) 
  OTHERWISE errorstop (key error + text (key)) END SELECT  . 

plot three dim pic:
  WHILE read pos < pic length
  REP plot three dim position  PER  .

plot three dim position :
  read pos INCR 1;
  SELECT key OF
  CASE draw key:   draw (next real, next real, next real)
  CASE move key:   move (next real, next real, next real)
  CASE move r key: move r (next real, next real, next real)
  CASE draw r key: draw r (next real, next real, next real)
  CASE text key:   draw (next text, next real, next real, next real)
  CASE bar 2 key:  bar (next real, next real, next int) 
  CASE bar 3 key:  bar (next real, next real, next real, next int)
  CASE circle key: circle (next real, next real, next real, next int) 
  CASE mark key:   mark (next real, next int) 
  OTHERWISE errorstop (key error + text (key)) END SELECT  . 

key:
  code (points SUB read pos)  .

END PROC plot;

REAL PROC next real:
  read pos INCR 8;
  subtext (points, read pos-7, read pos) RSUB 1  .
END PROC next real;

INT PROC next int:
  read pos INCR 2;
  subtext (points, read pos-1, read pos) ISUB 1  .
END PROC next int;

TEXT PROC next text:
  INT CONST text length :: next int;
  read pos INCR text length;
  subtext (points, read pos-text length+1, read pos)  .
END PROC next text;

PROC plot (TEXT CONST name) :
  PICFILE VAR p :: old (name);
  plot (p);
END PROC plot;

PROC plot (PICFILE VAR p) :
  set projektion;
  disable stop;
  begin plot;
  clear screen;
  plot pictures (p);
  errorcheck;
  end plot  .

set projektion:
  ROW 3 ROW 2 REAL VAR size;
  ROW 2 ROW 2 REAL VAR limit;
  ROW 4 REAL VAR angles;
  ROW 2 REAL VAR oblique;
  ROW 3 REAL VAR perspective;

  get values (p, size, limit, angles, oblique, perspective);
  set values (size, limit, angles, oblique, perspective)  .

clear screen:
  INT VAR x0, y0, x1, y1, h max, v max;
  REAL VAR x cm, y cm;

  IF background (p) > -1
  THEN clear
  ELSE drawing area (x cm, y cm, h max, v max);
       new values (x cm, y cm, h max, v max, x0, x1 , y0, y1);
       set range (max (0, x0), max (0, y0), min (h max, x1), min (v max, y1))
  FI  .

errorcheck:
  IF is error
  THEN line;
       put line ("Erorr at PICTURE No " + text (picture no (p)));
  FI  .

END PROC plot;

PROC plot pictures (PICFILE VAR p):
  INT VAR back :: abs (background (p)), no;
  enable stop;
  FOR no FROM 1 UPTO pictures (p)
  REP to pic (p, no);
      read picture (p, pic);

      IF this picture is ok
      THEN set pen of pic;
           plot (pic)
      FI
  PER  .

this picture is ok:
  pen (pic) <> 0 AND length (pic) > 0  .

set pen of pic:
  INT VAR colour, thick, type;
  selected pen (p, pen (pic), colour, thick, type);
  set pen (back, colour, thick, type)  .

END PROC plot pictures;

END PACKET plot

