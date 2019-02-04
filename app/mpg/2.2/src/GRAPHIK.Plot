(**************************************************************************) 
(*                                                                        *) 
(*                        MPG - Graphik - System                          *) 
(*                                                                        *) 
(*                      Version 2.2 vom 23.09.1987                        *) 
(*                                                                        *) 
(*            (c) 1987 Beat Jegerlehner & Carsten Weinholz                *) 
(*                unter Verwendung der Standard-Graphik                   *) 
(*              "Graphik-Plot" geschrieben von C.Weinholz                 *)
(*                                                                        *) 
(**************************************************************************) 
(*                                                                        *) 
(*           Paket II: Endgeraet-abhaengige Graphikroutinen               *) 
(*        (koennen erst nach 'Interface.Conf' insertiert werden)          *) 
(*                                                                        *) 
(*                  1. Plot (Grundlegende Graphik-Operationen             *)
(*                                                                        *) 
(*                  2. Plot Input/Output (Routinen zum                    *)
(*                           Ansprechen des PLOT-Spoolers                 *) 
(*                           zur indirekten Graphik-Ausgabe)              *) 
(*                                                                        *) 
(*                  3. Plot Picture/Picfile                               *)
(*                          (Ausgabe von PICTURES/ PICFILES)              *)
(*                                                                        *)
(**************************************************************************) 
(*   Urversion  : 10.09.87                                                *) 
(*   Aenderungen: 23.09.87, Carsten Weinholz                              *) 
(*                PROC save (PICFILE CONST, TEXT CONST, PLOTTER CONST)    *) 
(*                hinzugefuegt                                            *) 
(*                PROC plot (PICFILE CONST) auch indirekt                 *) 
(*                Fehlermeldung bei indirektem 'plot (PICTURE)'           *) 
(*                20.11.87, Beat Jegerlehner                              *)
(*                Clipping bei move eingefuehrt. Gibt sonst bei Watanabe  *)
(*                Probleme                                                *)
(*                Textgenerator korrigiert                                *)
(*                                                                        *) 
(**************************************************************************)
 
(************************************ Plot ********************************)

PACKET basis plot DEFINES

      beginplot,
      pen      ,

      move     ,
      move r   ,
      move cm  ,
      move cm r,

      draw     ,
      draw r   ,
      draw cm  ,
      draw cm r,

      hidden lines,
      reset    ,

      zeichensatz,
      reset zeichensatz,

      linetype,
      reset linetypes,

      where,
      bar,
      circle,
      box:

LET empty              = 0,             (* Punktmuster *)
    half               = 1,
    full               = 2,
    horizontal         = 3,
    vertical           = 4,
    cross              = 5,
    diagonal right     = 6,
    diagonal left      = 7,
    diagonal both      = 8,
    std zeichenname    = "ZEICHENSATZ";
 
INT VAR  ltype    :: 1, 
         thick    :: 0, 
         xpixel   :: 0, 
         ypixel   :: 0, 
         old x    :: 0, 
         old y    :: 0,
         real old x :: 0,
         real old y :: 0;

REAL VAR x cm, ycm,hor relation, vert relation,x to y,y to x;

ROW 5 TEXT VAR linetypes; 

INT  VAR cnt :: 0;
TEXT VAR muster :: "0";
INT  VAR lentxt :: length(muster);
 
LET POS = STRUCT (REAL x, y, z);
POS VAR pos :: POS : (0.0, 0.0, 0.0);

LET ZEICHENSATZ = ROW 255 TEXT;
ZEICHENSATZ VAR zeichen;
REAL CONST char x :: 6.0, char y :: 6.0,y base :: 2.0;
 
BOUND ZEICHENSATZ VAR std zeichen :: old (std zeichenname);
reset zeichensatz;
reset linetypes;

INT VAR h :: 0, v :: 0, new h :: 0, new v :: 0;

BOOL VAR hidden :: FALSE;

DATASPACE VAR ds :: nilspace;
BOUND STRUCT (ROW 32764 INT akt, last) VAR maxima :: ds;

(*************************** Initialisierung *******************************)

PROC beginplot: 
   init plot; 
   drawing area (x cm, y cm, x pixel, y pixel);
   hor relation := real (x pixel)/x cm;
   vert relation:= real (y pixel)/y cm;
   x to y := x cm / real(x pixel) / (y cm / real (y pixel)); (*umrechnung:*)
   y to x := 1.0 / x to y;             (* x pixel in y pixel u andersherum*)
END PROC beginplot; 

PROC pen (INT CONST backgr,colour,thickn,linetype):
  background(backgr); 
  foreground(colour); 
  thick := thickn;
  ltype := selected linetype; 
  IF ltype > 1 
     THEN muster := linetypes[ltype];
          lentxt := length (muster);
          cnt    := 0 
  FI. 
 
  selected linetype: 
     IF linetype < 0 OR linetype > 5 
        THEN 1 
        ELSE linetype 
     FI 
END PROC pen; 

(************************** MOVE - Prozeduren ******************************)

PROC move (INT CONST x,y): 
  old x := x; 
  old y := y 
END PROC move; 

PROC do move (INT CONST x,y):
  IF x <> real old x OR 
     y <> real old y
    THEN real old x := x;
         real old y := y;
         move to (x,y)
  FI;
  old x := x;
  old y := y
END PROC do move;
 
PROC move (REAL CONST x, y) :
  IF hidden 
  THEN maxima.last := maxima.akt FI;

  transform (x, y, 0.0, h, v);
  move (h, v);
  pos := POS : (x, y, 0.0)
END PROC move;

PROC move (REAL CONST x, y, z) :
  IF hidden 
  THEN maxima.last := maxima.akt FI;

  transform (x, y, z, h, v);
  move (h, v);
  pos := POS : (x, y, z)
END PROC move;

PROC move r (REAL CONST x, y) :
  IF hidden 
  THEN maxima.last := maxima.akt FI;

  transform (pos.x+x, pos.y+y, pos.z, h, v);
  move (h, v);
  pos := POS : (pos.x+x, pos.y+y, pos.z)
END PROC move r;

PROC move r (REAL CONST x, y, z) :
  IF hidden 
  THEN maxima.last := maxima.akt FI;

  transform (pos.x+x, pos.y+y, pos.z+z, h, v);
  move (h, v);
  pos := POS : (pos.x+x, pos.y+y, pos.z+z)
END PROC move r;

PROC move cm (REAL CONST x cm, y cm) :
  IF hidden 
  THEN maxima.last := maxima.akt FI;

  h := int (x cm*hor relation+0.5);
  v := int (y cm*vert relation+0.5);
  move (h, v)
END PROC move cm;

PROC move cm r (REAL CONST x cm, y cm) :
  IF hidden 
  THEN maxima.last := maxima.akt FI;

  h INCR int (x cm*hor relation+0.5);
  v INCR int (y cm*vert relation+0.5);
  move (h, v)
END PROC move cm r;

(************************** DRAW - Prozeduren ******************************)

PROC draw (INT CONST x,y): 
  draw (old x,old y,x,y) 
END PROC draw; 
 
PROC draw (INT CONST x0,y0,x1,y1): 
  IF thick = 0
    THEN line (x0, y0,x1,y1) 
    ELSE old x := x0; 
         old y := y0; 
         draw thick line (x1,y1) 
  FI; 
  old x := x1; 
  old y := y1 
END PROC draw;  

PROC draw (REAL CONST x, y) :
  IF hidden
  THEN transform (x, y, 0.0, new h, new v);
       vector (new h-h, new v-v)
  ELSE transform (x, y, 0.0, h, v);
       draw (h, v)
  FI;
  pos := POS : (x, y, 0.0)
END PROC draw;

PROC draw (REAL CONST x, y, z) :
  IF hidden
  THEN transform (x, y, z, new h, new v);
       vector (new h-h, new v-v)
  ELSE transform (x, y, z, h, v);
       draw (h, v)
  FI;
  pos := POS : (x, y, z) 
END PROC draw;

PROC draw r (REAL CONST x, y) :
  IF hidden
  THEN transform (pos.x+x, pos.y+y, pos.z, h, v); 
       vector (new h-h, new v-v)
  ELSE transform (pos.x+x, pos.y+y, pos.z, h, v); 
       draw (h, v)
  FI;
  pos := POS : (pos.x+x, pos.y+y, pos.z)
END PROC draw r;

PROC draw r (REAL CONST x, y, z) :
  IF hidden
  THEN transform (pos.x+x, pos.y+y, pos.z+z, h, v); 
       vector (new h-h, new v-v)
  ELSE transform (pos.x+x, pos.y+y, pos.z+z, h, v);
       draw (h, v)
  FI;
  pos := POS : (pos.x+x, pos.y+y, pos.z+z)
END PROC draw r;

PROC draw cm (REAL CONST x cm, y cm) :
  IF hidden
  THEN vector (int (x cm*hor relation+0.5)-h, int (y cm*vert relation+0.5)-v)
  ELSE h := int (x cm*hor relation+0.5);
       v := int (y cm*vert relation+0.5);
       draw (h, v)
  FI
END PROC draw cm;

PROC draw cm r (REAL CONST x cm, y cm) :
  IF hidden
  THEN vector (int (x cm*hor relation+0.5), int (y cm*vert relation+0.5))
  ELSE h INCR int (x cm*hor relation+0.5);
       v INCR int (y cm*vert relation+0.5);
       draw (h, v)
  FI
END PROC draw cm r;

(*************************** LINIEN zeichnen *******************************)

PROC line (INT CONST x0,y0,x1,y1): 
  REAL VAR x0r :: real (x0), 
           y0r :: real (y0), 
           x1r :: real (x1), 
           y1r :: real (y1); 
  IF clipped line (x0r,y0r,x1r,y1r) 
     THEN IF ltype > 1 
             THEN draw special line(int(x0r),int(y0r),int(x1r),int(y1r)) 
          ELIF ltype = 1 
             THEN do move (int(x0r),int(y0r)); 
                  draw std line (int(x1r),int(y1r)) 
          FI 
  FI
END PROC line; 

PROC draw std line (INT CONST x,y): 
  old x := x; 
  old y := y;
  real old x := x;
  real old y := y;
  draw to (x,y) 
END PROC draw std line; 
 
PROC draw special line (INT CONST x0,y0,x1,y1): 
  IF x0 = x1 
    THEN vertical line 
  ELIF y0 = y1 
    THEN horizontal line
  ELIF abs(x1-x0) > abs(y1 - y0) 
    THEN steile linie 
    ELSE flache linie 
  FI. 
 
  vertical line: 
    INT VAR steps :: abs(y1 - y0), 
            sig   :: sign(y1-y0),
            i;
    FOR i FROM 0 UPTO steps REP 
      IF next pixel
         THEN set pixel(x0,y0+i*sig)
      FI
    PER. 
 
  horizontal line: 
    steps := abs(x1 - x0); 
    sig :=   sign(x1 - x0); 
    FOR i FROM 0 UPTO steps REP 
      IF next pixel
         THEN set pixel(x0+i*sig,y0)
      FI
    PER. 
 
  steile linie: 
    steps := abs(x1 - x0); 
    sig := sign(x1 - x0); 
    REAL VAR m :: real(y1 - y0) / real(x1 - x0); 
    FOR i FROM 0 UPTO steps REP 
      IF next pixel
         THEN set pixel(x0+sig*i,y0+int(m*real(sig*i) + 0.5))
      FI
    PER. 
 
  flache linie: 
    steps := abs(y1 - y0); 
    sig := sign(y1 - y0); 
    m := real(x1 - x0) / real(y1 - y0); 
    FOR i FROM 0 UPTO steps REP 
      IF next pixel
         THEN set pixel(x0+int(m*real(sig*i) + 0.5),y0+sig*i)
      FI
    PER.

    next pixel:
      BOOL VAR is set :: (muster SUB cnt) <> "0";
      cnt INCR 1;
      IF cnt > lentxt THEN cnt := 1 FI;
      is set
END PROC drawspecialline;

PROC draw thick line (INT CONST xe,ye):
 
  INT VAR x0 :: old x,
          y0 :: old y,
          x1 :: xe,
          y1 :: ye;
 
  IF x0 = x1 AND y0 = y1
    THEN draw point (x0,y0) 
  ELIF abs(x0-x1) >= abs(y0-y1) 
    THEN IF x0 > x1 
           THEN draw thick2(x1,y1,x0,y0) 
           ELSE draw thick2(x0,y0,x1,y1) 
         FI 
    ELSE IF y0 > y1 
           THEN draw thick1(x1,y1,x0,y0) 
           ELSE draw thick1(x0,y0,x1,y1) 
         FI 
  FI 
END PROC draw thick line;

PROC draw point (INT CONST x,y): 
  INT VAR i,k,d :: int(0.5 + real(thick) / (x cm / real(x pixel)) / 10.0 /
  2.0); 
  FOR i FROM 0 UPTO d REP 
    k := int (0.5 + sqrt(real(d)**2 - real(i)**2)* x to y); 
    line (x+i, y-k, x+i, y+k); 
    line (x-i, y-k, x-i, y+k) 
  PER 
END PROC draw point; 
 
PROC draw thick 1 (INT CONST x0,y0,x1,y1): 
  REAL VAR dxx :: real(x1 - x0), 
           dyx :: real(y1 - y0) * y to x, 
           d3 :: real(thick) / (x cm / real(x pixel)) / 10.0, 
           d1 :: sqrt (d3**2 + (d3 * dxx / dyx)**2), 
           d2 :: d3 * dxx / dyx, 
           dh :: (d3**2 - d2**2 + d1**2) / 2.0 / d1, 
           d4 :: sqrt(max(0.0,d3 ** 2 - dh ** 2)) * x to y; 
  INT VAR l :: int (0.5 + d1 / 2.0), 
          dy :: abs(y0 - y1), 
          dx :: abs(x0 - x1), 
          x :: x0 - int(0.5 + d3 / 2.0 * dxx / dyx), 
          y :: y0 - int(d3 / 2.0 * x to y), 
          z :: y1 + int (d3 / 2.0 * x to y), 
          dp :: dx + dx, 
          d :: dp - dy, 
          dq :: dp - dy - dy, 
          a :: sign (y1 - y0),
          b :: sign (x1 - x0); 
  do line; 
  WHILE y <> z REP 
    y INCR a; 
    IF d < 0 
      THEN d INCR dp 
      ELSE x INCR b; 
           d INCR dq 
    FI; 
    do line 
  PER. 
 
  do line: 
    INT VAR s1 :: l, 
            s2 :: l, 
            s3 :: x,
            sh;
    IF y < y0 - int (0.5 + d4 / 2.0) 
      THEN s1 := int (0.5 + sqrt (d3 ** 2 / 4.0 - (real(y - y0) * y to
      x)**2)); 
           s2 := s1; 
           s3 := x0 
    ELIF y < y0 + int (0.5 + d4 / 2.0) 
      THEN sh := int (0.5 + sqrt (d3 ** 2 / 4.0 - (real(y-y0) * y to
      x)**2));
           IF x0 > x1 
             THEN s2 := sh + x0 - x 
             ELSE s1 := sh + x - x0 
           FI; 
           s3 := x 
    ELIF y > y1 + int (0.5 + d4/2.0) 
      THEN s1 := int (0.5 + sqrt (d3 ** 2 / 4.0 - (real(y-y1)*y to x)**2)); 
           s2 := s1; 
           s3 := x1 
    ELIF y > y1 - int(0.5 + d4 / 2.0) 
      THEN sh := int(0.5 + sqrt(d3**2/4.0 - (real(y-y1)*y to x)**2));
           IF x0 > x1 
             THEN s1 := sh + x - x1 
             ELSE s2 := sh + x1 - x 
           FI; 
           s3 := x 
    FI; 
    line (s3 - s1,y,s3 + s2, y) 
END PROC draw thick 1; 
 
PROC draw thick 2 (INT CONST x0,y0,x1,y1): 
  REAL VAR dxx :: real(x1 - x0) * x to y, 
           dyx :: real(y1 - y0),
           d3 :: real(thick) / (y cm / real(y pixel)) / 10.0, 
           d1 :: sqrt (d3**2 + (d3 * dyx / dxx)**2), 
           d2 :: d3 * dyx / dxx, 
           dh :: (d3**2 - d2**2 + d1**2) / 2.0 / d1, 
           d4 :: sqrt(max(0.0,d3 ** 2 - dh ** 2)) * y to x; 
  INT VAR l :: int (0.5 + d1 / 2.0), 
          dy :: abs(y0 - y1), 
          dx :: abs(x0 - x1), 
          y :: y0 - int(0.5 + d3 / 2.0 * dyx / dxx), 
          x :: x0 - int(d3 / 2.0 * y to x), 
          z :: x1 + int (d3 / 2.0 * y to x), 
          dp :: dy + dy, 
          d :: dp - dx, 
          dq :: dp - dx - dx, 
          a :: sign (x1 - x0),
          b :: sign (y1 - y0); 
  do line; 
  WHILE x <> z REP 
    x INCR a; 
    IF d < 0 
      THEN d INCR dp 
      ELSE y INCR b; 
           d INCR dq 
    FI; 
    do line 
  PER. 
 
  do line: 
    INT VAR s1 :: l, 
            s2 :: l, 
            s3 :: y,
            sh;
    IF x < x0 - int (0.5 + d4 / 2.0) 
      THEN s1 := int (0.5 + sqrt (d3 ** 2 / 4.0 - (real(x - x0) * x to y)**2)); 
           s2 := s1; 
           s3 := y0 
    ELIF x < x0 + int (0.5 + d4 / 2.0) 
      THEN sh := int (0.5 + sqrt (d3 ** 2 / 4.0 - (real(x-x0) * x to y)**2));
           IF y0 > y1 
             THEN s2 := sh + y0 - y 
             ELSE s1 := sh + y - y0 
           FI; 
           s3 := y 
    ELIF x > x1 + int (0.5 + d4/2.0) 
      THEN s1 := int (0.5 + sqrt (d3 ** 2 / 4.0 - (real(x-x1)*x to y)**2)); 
           s2 := s1; 
           s3 := y1 
    ELIF x > x1 - int(0.5 + d4 / 2.0) 
      THEN sh := int(0.5 + sqrt(d3**2/4.0 - (real(x-x1)*x to y)**2));
           IF y0 > y1 
             THEN s1 := sh + y - y1 
             ELSE s2 := sh + y1 - y 
           FI; 
           s3 := y 
    FI; 
    line (x, s3-s1, x, s3+s2) 
END PROC draw thick 2; 

(*************************** HIDDEN LINES **********************************)

PROC hidden lines (BOOL CONST dev):
  hidden := NOT dev;
END PROC hidden lines;

PROC vector (INT CONST dx, dy):
  IF dx >= 0
  THEN IF   dy >  dx THEN vector (v, h, dy, dx,  1, 1)
       ELIF dy >   0 THEN vector (h, v, dx, dy,  1, 1)
 
       ELIF dy > -dx THEN vector (h, v, dx, -dy, 1,-1)
       ELSE               vector (v, h, -dy, dx,-1, 1) FI

  ELSE IF   dy > -dx THEN vector (v, h, dy, -dx, 1,-1)
       ELIF dy >   0 THEN vector (h, v, -dx, dy,-1, 1)
 
       ELIF dy >  dx THEN vector (h, v, -dx, -dy,-1,-1)
       ELSE               vector (v, h, -dy, -dx,-1,-1) FI
  FI  .
 
ENDPROC vector ;
 
PROC vector (INT VAR x pos, y pos, INT CONST dx, dy, right, up) :
  INT VAR i;
  prepare first step ;
  draw point;
  FOR i FROM 1 UPTO dx
  REP do one step PER;

  IF was visible
  THEN draw (h, v) FI  .


prepare first step :
  INT VAR up right error := dy - dx,
          right error := dy,
          old error := 0,
          last h :: h, last v :: v;
  BOOL VAR was visible :: visible  .


do one step:
  IF right is better
    THEN do right step
    ELSE do up right step
  FI .
 
right is better :
  abs (old error + right error) < abs (old error + up right error)  .
 
do upright step :
  x pos INCR right ;
  y pos INCR up ;
  draw point ;
  old error INCR upright error .
 
do right step :
  x pos INCR right ;
  draw point ;
  old error INCR right error .
 
draw point :
  IF was visible
  THEN IF NOT visible
       THEN draw (last h, last v);
            was visible := FALSE
       FI;
       last h := h;
       last v := v
  ELSE IF visible
       THEN move (h, v);
            was visible := TRUE;
            last h := h;
            last v := v 
       FI
 FI  .

visible:
  IF h < 1 OR h > x pixel
  THEN FALSE
  ELSE IF maxima.akt [h] < v 
       THEN maxima.akt [h] := v FI; 
       v > maxima.last [h]
  FI
END PROC vector;

PROC reset:
  forget (ds);
  ds := nilspace;
  maxima := ds
END PROC reset;

(**************************** TEXT - Ausgabe *******************************)

PROC zeichensatz (TEXT CONST name):
  IF exists (name)
  THEN BOUND ZEICHENSATZ VAR new zeichen :: old (name);
       zeichen := new zeichen;
  ELSE errorstop ("Der Zeichensatz """ + name + """ existiert nicht") FI
END PROC zeichensatz;

PROC reset zeichensatz: 
   zeichen := std zeichen 
END PROC reset zeichensatz; 
 
PROC draw char (INT CONST char no,REAL CONST x, y,REAL CONST y size, 
                x size, direction):
  TEXT CONST character :: zeichen [char no];
  INT VAR n :: 1, x0, y0, x1, y1;
  INT CONST len :: length (character);
  REAL CONST sindir :: sind(direction),
             cosdir :: cosd(direction);
  WHILE n < len
  REP value (character, n, x0, y0, x1, y1);
  REAL VAR xr0 :: real(x0),
           yr0 :: real(y0),
           xr1 :: real(x1), 
           yr1 :: real(y1);
      transform (xr0, yr0, x, y, x size, y size, sindir,cosdir);
      transform (xr1, yr1, x, y, x size, y size, sindir,cosdir);
      draw (int(xr0), int (yr0 * x to y),
            int(xr1),int(yr1 * x to y));
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

PROC transform (REAL VAR x, y,REAL CONST x0, y0,REAL CONST x size, y size, 
                sindir,cosdir):
  REAL CONST old x :: x, old y :: y;
  REAL CONST dx :: x size / char x * old x * cosdir - 
                   (y size-y base) / char y * old y * sindir, 
             dy :: (y size-y base) / char y * old y * cosdir + 
                   x size / char x * old x * sindir;
  x := x0 + dx; 
  y := y0 + dy
END PROC transform; 

PROC draw text (REAL CONST x pos, y pos,TEXT CONST msg, REAL CONST angle, 
                REAL CONST height, width): 
  INT VAR i;
  REAL VAR x :: x pos, y :: y pos,
           x step :: cosd (angle)*width,
           y step :: sind (angle)*width;
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
  x := x pos;
  y := y pos  .

right:
  x INCR x step;  y INCR y step  . 

up:
  x INCR y step;  y INCR x step  . 

left:
  x DECR x step;  y DECR y step  .

down:
  x DECR y step;  y DECR x step  . 

return:
  x := x pos  .

execute normal char:
  draw char (code (akt char), x, y, height, width,
             angle);
  x INCR x step;
  y INCR y step .

akt char:
  msg SUB i  .

END PROC draw text; 
 
PROC draw (TEXT CONST msg):
   draw (msg,0.0,5.0,5.0)
END PROC draw;
 
PROC draw (TEXT CONST msg,REAL CONST angle,REAL CONST heigth,width):
    REAL CONST  xr :: real(old x), 
                yr :: real(old y) * y to x;
    draw text (xr,yr,msg,angle,heigth * real(x pixel) / x cm / 10.0, 
                               width  * real(x pixel) / x cm / 10.0)
                                    (* heigth  mm --> x punkte *)
END PROC draw; 
 
(***************************** LINETYPES ***********************************)

PROC linetype (INT CONST nummer,TEXT CONST lt): 
   IF nummer > 5 OR nummer < 2 
      THEN errorstop ("number out of range") 
      ELSE linetypes [nummer] := lt 
   FI 
END PROC linetype ; 
 
PROC reset linetypes : 
   linetype (2,"1100"); 
   linetype (3,"11110000"); 
   linetype (4,"1111111100000000"); 
   linetype (5,"1111111100011000"); 
END PROC reset linetypes ; 

(***************************** UTILIES *************************************)

PROC where (REAL VAR x, y) :
  x := pos.x;  y := pos.y
END PROC where;

PROC where (REAL VAR x, y, z) :
  x := pos.x;  y := pos.y;  z := pos.z
END PROC where;

PROC bar (REAL CONST hight, width, INT CONST pattern):
  INT VAR zero x, zero y, end x, end y;
  transform (0.0, 0.0, 0.0, zero x, zero y);
  transform (width, hight, 0.0, end x, end y);
  bar (h-(end x-zero x) DIV 2, v, end x-zero x, end y-zero y, pattern)
END PROC bar;

PROC bar (INT CONST from x, from y, width, hight, pattern):
  INT CONST to x :: from x+width, to y :: from y+hight;
  INT VAR x, y;
  draw frame;
  SELECT pattern OF
  CASE empty: (* nothing to do *)
  CASE half:           half bar
  CASE full:           full bar
  CASE horizontal:     horizontal bar
  CASE vertical:       vertical bar
  CASE cross:          horizontal bar;
                       vertical bar
  CASE diagonal right: diagonal right bar
  CASE diagonal left:  diagonal left bar
  CASE diagonal both:  diagonal both bar
  OTHERWISE errorstop ("Unknown pattern") ENDSELECT  .

draw frame:
  move (from x, from y);
  draw (from x, to y);
  draw (to x, to y);
  draw (to x, from y);
  draw (from x, from y).

full bar:
  FOR y FROM from y UPTO to y
  REP move (from x, y);
      draw (to x, y) 
  PER  .

half bar:
  FOR y FROM from y UPTO to y
  REP x := from x + 1 + (y AND 1);
      WHILE x < to x 
      REP move (x, y);
          draw (x, y);
          x INCR 2
      PER
  PER  .

horizontal bar:
  y := from y;
  WHILE y < to y
  REP move (from x, y);
      draw (to x, y);
      y INCR 5
  PER  .

vertical bar:
  x := from x + 5;
  WHILE x < to x
  REP move (x, from y);
      draw (x, to y);
      x INCR 5
  PER  .

diagonal right bar:
  y := from y-width+5;
  WHILE y < to y
  REP move (max (from x, to x-y-width+from y), max (from y, y));
      draw (min (to x, from x+to y-y), min (to y, y+width));
      y INCR 5
  PER  .

diagonal left bar:
  y := from y-width+5;
  WHILE y < to y
  REP move (min (to x, to x-from y+y),  max (from y, y));
      draw (max (from x, from x+y+width-to y), min (to y, y+width)); 
      y INCR 5
  PER  .

diagonal both bar:
  y := from y-width+5;
  WHILE y < to y
  REP move (max (from x, to x-y-width+from y), max (from y, y));
      draw (min (to x, from x+to y-y), min (to y, y+width)); 
      move (min (to x, to x-from y+y),  max (from y, y));
      draw (max (from x, from x+y+width-to y), min (to y, y+width));
      y INCR 5
  PER  .

END PROC bar;

PROC circle (REAL CONST r, from, to, INT CONST pattern):
  REAL VAR t :: from;   INT VAR i; i := pattern; (* sonst WARNUNG *)
  WHILE t < to
  REP transform (pos.x + r*cosd (t), pos.y + r*sind (t), 0.0, h, v);
      draw (h, v);
      t INCR 1.0
  PER;
  transform (pos.x, pos.y, 0.0, h, v);
  draw (h, v)  .

END PROC circle;

PROC box :
  move (0,0);
  draw (0,y pixel-1);
  draw (x pixel-1, y pixel-1);
  draw (x pixel-1, 0);
  draw (0,0)
END PROC box;

END PACKET basis plot;

(************************* Plot Spool Input/ Output ***********************)

PACKET plot interface   DEFINES                       (* Carsten Weinholz *)
                                                      (* V 1.1  02.07.87  *) 
                                save                 , 
                                exists               , 
                                erase                , 
                                ALL                  ,
                                first                , 
                                start                , 
                                stop                 , 
                                halt                 , 
                                wait for halt        , 
                                list                 , 
                                picfiles             ,
                                generate plot manager:
 
LET initfile         = "GRAPHIK.Manager", 
    plot manager name= "PLOT"   , 

    picfiletype      = 1102,
 
    ack              = 0, 
    false code       = 6,
    fetch code       = 11,
    save code        = 12,
    exists code      = 13, 
    erase code       = 14, 
    list code        = 15,
    all code         = 17, 
    first code       = 25,
    start code       = 26,
    stop  code       = 27,
    halt code        = 28,
    wait for halt  code = 29;
 
BOUND STRUCT (TEXT tname,user id,pass) VAR msg; 
 
DATASPACE VAR ds; 

INT VAR reply;
THESAURUS VAR all myself picfiles; 
 
PROC first (TEXT CONST ds name, PLOTTER CONST plotter id): 
   call (first code, ds name + ""0"" + id name (plotter id), plot id (plotter id)) 
END PROC first; 
 
PROC start (PLOTTER CONST plotter id):
   call (start code, id name (plotter id), plot id (plotter id)) 
END PROC start;
 
PROC stop (PLOTTER CONST plotter id): 
   call (stop code, id name (plotter id), plot id (plotter id)) 
END PROC stop;
 
PROC halt (PLOTTER CONST plotter id): 
   call (halt code, id name (plotter id), plot id (plotter id)) 
END PROC halt; 
 
PROC wait for halt (PLOTTER CONST plotter id): 
   call (wait for halt code, id name (plotter id), plot id (plotter id)) 
END PROC wait for halt; 
 
PROC save (TEXT CONST ds name, PLOTTER CONST plotter id):
   enable stop;
   last param (ds name);
   call (save code, ds name + ""0"" + id name (plotter id), 
                                 old (ds name), plot id (plotter id))
END PROC save; 
 
PROC save (PICFILE CONST p, TEXT CONST pname, PLOTTER CONST plotter id): 
   enable stop;
   DATASPACE VAR ds; 
   ds BECOMES p; 
   call (save code, pname + ""0"" + id name (plotter id), ds, 
         plot id (plotter id)); 
END PROC save; 
 
OP BECOMES (DATASPACE VAR ds, PICFILE CONST p):
   EXTERNAL 260
END OP BECOMES;
 
PROC save (THESAURUS CONST nameset, PLOTTER CONST plotter id): 
   TEXT VAR name; 
   INT VAR i :: 0; 
   get (nameset, name, i); 
   WHILE i > 0 REP 
      save (name, plotter id); 
      cout (i); 
      get (nameset, name, i) 
   PER
END PROC save;

BOOL PROC exists (TEXT CONST ds name, PLOTTER CONST plotter id): 
   INT VAR reply;
   DATASPACE VAR ds :: nilspace; 
   BOUND TEXT VAR qname :: ds; 
   qname := ds name + ""0"" + id name (plotter id); 
   REP 
      call (plot id (plotter id), exists code, ds, reply) 
   UNTIL reply = false code OR reply = ack PER;
   forget (ds); 
   reply = ack 
END PROC exists; 

PROC erase (TEXT CONST ds name,PLOTTER CONST plotter id): 
   call (erase code, ds name + ""0"" + id name (plotter id), plot id (plotter id)) 
END PROC erase;
 
PROC erase (THESAURUS CONST nameset, PLOTTER CONST plotter id): 
   TEXT VAR name; 
   INT VAR i :: 0; 
   get (nameset, name, i); 
   WHILE i > 0 REP 
      erase (name, plotter id); 
      cout (i); 
      get (nameset, name, i) 
   PER
END PROC erase; 
 
THESAURUS OP ALL (PLOTTER CONST plotter id): 
   REP
      forget (ds);
      ds := nilspace;
      msg := ds;
      msg.tname   := id name (plotter id);
      msg.user id := "";
      msg.pass    := "";
      call (plot id (plotter id), all code, ds, reply)
   UNTIL reply = ack PER;
   BOUND THESAURUS VAR result ds :: ds;
   THESAURUS VAR result :: result ds;
   forget (ds);
   result 
END OP ALL;

PROC list (FILE VAR f,PLOTTER CONST plotter id): 
      REP
         forget (ds); 
         ds := nilspace; 
         msg := ds;
         msg.tname   := id name (plotter id); 
         msg.user id := "";
         msg.pass    := "";
         call (plot id (plotter id), list code, ds, reply) 
      UNTIL reply = ack PER; 
      f := sequential file (modify, ds)
END PROC list; 

PROC list (PLOTTER CONST plotter id): 
   FILE VAR list file; 
   list (list file, plotter id); 
   show (list file) 
END PROC list;
 
THESAURUS PROC picfiles: 
   all myself picfiles := empty thesaurus; 
   do (PROC (TEXT CONST) insert if picfile,ALL myself); 
   all myself picfiles 
END PROC picfiles; 
 
PROC insert if picfile (TEXT CONST filename): 
   IF type (old (filename)) = picfiletype 
      THEN insert (all myself picfiles,filename) 
   FI 
END PROC insert if picfile; 
 
PROC generate plot manager: 
   TASK VAR plot manager; 
   IF exists (initfile) 
      THEN generate in background 
      ELSE errorstop ("""" + init file + """ existiert nicht") 
   FI. 
 
   generate in background: 
      begin (plot manager name,PROC init plot manager, plot manager); 
      INT VAR manager call; 
      DATASPACE VAR initspace; 
      TASK VAR order task; 
      REP 
         wait (initspace, manager call, order task) 
      UNTIL order task = plot manager PER; 
      initspace := old (initfile); 
      send (plot manager, ack, initspace); 
      say ("Plot-Manager wird generiert"13""10"");
      say ("Bitte etwas Geduld..."13""10"");
      REP
         wait (initspace, manager call, order task)
      UNTIL order task = plot manager PER;
      forget (initspace);
      say ("Plotmanager generiert !"13""10"") 
END PROC generate plot manager; 
 
PROC init plot manager: 
   DATASPACE VAR initspace :: nilspace; 
   INT VAR dummy; 
   call (father, fetch code, initspace, dummy); 
   copy (init space,init file);
   insert (init file); 
   send (father,ack,initspace);
   do ("plot manager");
END PROC init plot manager;
 
TASK PROC plot id (PLOTTER CONST plotter id):
   IF plotter id = no plotter
      THEN task (plot manager name) 
      ELSE station (plotter id)/plot manager name
   FI
END PROC plot id;
 
TEXT PROC id name (PLOTTER CONST plotter id):
   text (station (plotter id)) + "/" + text (channel (plotter id)) + "/" + 
   name (plotter id)
END PROC id name;

END PACKET plot interface; 

(************************* Plot Picture / Picfile *************************)

PACKET plot DEFINES plot : 

LET draw key      = 1,
    move key      = 2,
    text key      = 3,
    move r key    = 4,
    draw r key    = 5,
    move cm key   = 6, 
    draw cm key   = 7,
    move cm r key = 8,
    draw cm r key = 9,
    bar key       = 10,
    circle key    = 11;

LET postfix = ".PICFILE"

INT VAR read pos; 
 
PROC plot (TEXT CONST name) :
  PICFILE VAR p :: old (name);
  IF channel <> channel (plotter) OR station (myself) <> station (plotter)
     THEN save (name, plotter) 
     ELSE plot (p)
  FI
END PROC plot;

PROC plot (PICFILE VAR p) :
  IF channel <> channel (plotter) OR station(myself) <> station(plotter)
     THEN save (p, name (myself) + "." + text (highest entry (ALL plotter))
                   + postfix, plotter)
     ELSE direct plot
  FI. 
 
  direct plot: 
    ROW 3 ROW 2 REAL VAR sizes; 
    ROW 2 ROW 2 REAL VAR limits; 
    ROW 4 REAL VAR angles; 
    ROW 2 REAL VAR obliques; 
    ROW 3 REAL VAR perspectives; 
    get values (p,sizes,limits,angles,obliques,perspectives); 
    set values (sizes,limits,angles,obliques,perspectives);
    begin plot;
    clear;
    INT VAR i;
    FOR i FROM 1 UPTO pictures (p)
    REP PICTURE VAR act pic :: nilpicture;
        to pic (p,i);
        read picture (p,act pic);
        IF pen (act pic) <> 0
           THEN plot pic FI
    PER;
    end plot  .
 
  plot pic:
    INT VAR colour, thickness, linetype; 
    BOOL VAR  hidden; 
    selected pen (p,pen (act pic),colour,thickness,linetype,hidden); 
    pen (background (p),colour,thickness,linetype); 
    hidden lines (hidden);
    plot (act pic).
 
END PROC plot;

PROC plot (PICTURE CONST p) :
  IF channel <> channel (plotter) OR station (myself) <> station (plotter)
     THEN errorstop ("PICTURES koennen nur direkt ausgegeben werden")
     ELSE plot pic
  FI.

plot pic:
  INT CONST pic length :: length (p);
  TEXT CONST points :: subtext (text(p),5); 
  read pos := 0;
  IF dim (p) = 2
  THEN plot two dim pic
  ELSE plot three dim pic FI  .

plot two dim pic:
  WHILE read pos < pic length
  REP plot two dim position PER  .

plot two dim position :
  read pos INCR 1;
  SELECT code (points SUB read pos) OF
  CASE draw key : draw (next real, next real)
  CASE move key : move (next real, next real)
  CASE move r key : move r (next real, next real)
  CASE draw r key : draw r (next real, next real)
  CASE move cm key : move cm (next real, next real)
  CASE draw cm key : draw cm (next real, next real)
  CASE move cm r key : move cm r (next real, next real)
  CASE draw cm r key : draw cm r (next real, next real)
  CASE text key : draw (next text, next real, next real, next real)
  CASE bar key : bar (next real, next real, next int) 
  CASE circle key : circle (next real, next real, next real, next int) 
  OTHERWISE errorstop ("wrong key code") END SELECT  . 

plot three dim pic:
  WHILE read pos < pic length
  REP plot three dim position PER  .

plot three dim position :
  read pos INCR 1;
  SELECT code (points SUB read pos) OF
  CASE draw key : draw (next real, next real, next real)
  CASE move key : move (next real, next real, next real)
  CASE move r key : move r (next real, next real, next real)
  CASE draw r key : draw r (next real, next real, next real)
  CASE move cm key : move cm (next real, next real)
  CASE draw cm key : draw cm (next real, next real)
  CASE move cm r key : move cm r (next real, next real)
  CASE draw cm r key : draw cm r (next real, next real)
  CASE text key : draw (next text, next real, next real, next real)
  CASE bar key : bar (next real, next real, next int) 
  CASE circle key : circle (next real, next real, next real, next int) 
  OTHERWISE errorstop ("wrong key code") END SELECT  . 

next real :
  read pos INCR 8;
  subtext (points, read pos-7, read pos) RSUB 1  .

next int :
  read pos INCR 2;
  subtext (points, read pos-1, read pos) ISUB 1  .

next text :
  INT CONST text length :: next int;
  read pos INCR text length;
  subtext (points, read pos-text length+1, read pos)  .
 
END PROC plot;

END PACKET plot

