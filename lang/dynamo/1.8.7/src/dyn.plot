PACKET dynamo plotter           (* Änder.: C.Szymanski, 21.07.88 *)
 DEFINES b initialize plot, b new plot line, b plot, b end of program,
         b plot scale :
 
LET maxvalue        = 200,
    valuepagelength = 18,
    max param numb  = 10;
 
TYPE PLOTPARAM = STRUCT (TEXT name, id, 
                         INT  scale pointer, 
                         REAL lower bound, upper bound, 
                         BOOL l fixed scale, u fixed scale); 
 
ROW max param numb PLOTPARAM VAR plotparam;(* Enth. Plotparameter *)
ROW maxvalue REAL VAR value;               (* Ausgabepuffer *)
ROW max param numb ROW 5 REAL VAR scale;  (* Enth. errechnete Skalierungen *) 

BOOL VAR plt;
TEXT VAR headline;
REAL VAR pltper, nextplot;
INT VAR  value no, param no, plot line no,
         plot param no, line no;
INT CONST nil := 0;

LET line1 = ".____________.____________.____________.____________.",
    line2 = ".            .            .            .            .";
 
PROC plot one page :
 init plot routine;
 plot values.
 
 init plot routine :
  print suppressed output;
  plot line no := nil.
 
 plot values : 
  INT VAR act value := 1, i;
  TEXT VAR plot buf;
  line;
  vdt;
  line;
  IF b stop request THEN LEAVE plot one page END IF;
  sys page;
  plot output (headline);
  put scales;
  WHILE act value < value no REP
   put time;
   gen line;
   FOR i FROM 1 UPTO plot param no REP
    plot single value
   END REP;
   plot output (plot buf + line0 + collision);
   plot line no INCR 1;
   act value INCR plot param no;
   act value INCR 1
  END REP.
 
 put time :
  plot buf := text (text (round (value (act value), 2)), 6).
  (* Erstes Pufferelement enthaelt time *)
 
 gen line :
  TEXT VAR line0, collision := "";
  line0 := act line.
 
 act line :
  IF (plot line no MOD 5) = nil (* Prueft, ob gestrichelte oder durch - *)
   THEN line1                   (* gezogene Linie gedruckt wird *)
   ELSE line2
  FI.
 
 plot single value :
  INT VAR position := int ((x-low)*53.0/(up-low))+1; (*Interpolationsformel*)
  position := limit;
  IF pos ("._ ", line0 SUB position) > nil
   THEN replace (line0, position, plotparam (i).id)
   ELSE collision CAT plotparam (i).id
  FI.
 
 limit :
  IF position > 53
   THEN 53
  ELIF position < 1
   THEN 1
   ELSE position
  FI.
 
 up :
  scale (i) (5).                (* Oberer Grenzwert (der Skalierung) *)
 
 low :
  scale (i) (1).                (* Unterer Grenzwert *)
 
 x :
  value (act value + i).
 
 put scales :                      (* Gibt Skalierung der Variablen aus *)
  INT VAR j := 1, l, scalecounter;
  WHILE j <= plot param no REP
   plot buf := "     ";
   FOR l FROM 1 UPTO 4 REP
    plot buf CAT text (text (scale (j) (l)), 13)
   END REP;
   plot buf CAT text (scale (j) (5));
   scalecounter := plotparam (j).scalepointer;
   WHILE scalecounter = plotparam (j).scalepointer REP
    plot buf CAT plotparam (j).id;
    j INCR 1
   UNTIL j > max param numb END REP;
   plot output (plot buf)
  END REP.
END PROC plot one page;
 
PROC b plot scale (TEXT CONST id, INT CONST scale pointer,
                   REAL CONST lower bound, upper bound,
                   BOOL CONST l fixed scale, u fixed scale) :
                           (* Liest Skalierungen vom Zielprogramm ein *)
 plot param no INCR 1;
 plot param (plot param no).id := id;                      (*Variablenname *)
 plot param (plot param no).scale pointer := scale pointer;(*Zeiger *)
 plot param (plot param no).lower bound := lower bound;    (*Obere Grenze *)
 plot param (plot param no).upper bound := upper bound;    (*Untere Grenze *)
 plot param (plot param no).l fixed scale := l fixed scale;(*Fix-Skalierung*)
 plot param (plot param no).u fixed scale := u fixed scale;
END PROC b plot scale;
 
PROC gen scales :
 INT VAR act param, i;        (* Generiert Skalierungen fuer eine Seite *)
 FOR act param FROM 1 UPTO plot param no REP
  compute single scale
 END REP.
 
 compute single scale :
  REAL VAR max := plotparam(plot param(act param).scale pointer).upper bound,
           min := plotparam(plot param(act param).scale pointer).lower bound;
  IF min > max THEN errorstop ("invalid scale") FI;
  compute extreme scales;
  FOR i FROM 1 UPTO 3 REP
   scale (act param) (i+1) := (scale (act param) (5) - scale (act param) (1))
                               * real (i) / 4.0 + scale (act param) (1)
                              (* Interpolationsformel *)
  END REP.
 
 compute extreme scales :
 (* Wenn die Skalierungen nicht gegeben sind, muessen sie berechnet werden.
    Zur leichteren Lesbarkeit werden die Skalierungen nach oben bzw. unten
    um jeweils eine Stelle gerundet *)
  scale (act param) (5) := upper limit;
  scale (act param) (1) := lower limit.
 
 upper limit :
  IF plot param (plot param (act param).scale pointer).u fixed scale
   THEN max
   ELSE round (floor (max) + 0.5, 0)
  FI.
 
 lower limit :
  IF plot param (plot param (act param).scale pointer).l fixed scale
   THEN min
   ELSE round (floor (min) - 0.5, 0)
  FI.
END PROC gen scales;
 
PROC b initialize plot (TEXT CONST h) :
 headline      := h;
 pltper        := get pltper;
 plot line no  := value pagelength;
 nextplot      := 0.0;
 value no      := nil;
 line no       := nil;
 plot param no := nil
END PROC b initialize plot;
 
PROC b new plot line (REAL CONST time) :
 plt := time >= nextplot;
 IF plt                     (* Wird vom Zielprogramm aufgerufen, um *)
  THEN add (time);          (* Zeilenvorschub durchzufuehren *)
       line no INCR 1;
       param no := nil
 FI;
 WHILE time >= nextplot REP (* Ist noetig, weil pltper ungleich dt sein *)
  nextplot INCR pltper      (* kann *)
 END REP
END PROC b new plot line;
 
PROC b end of program :        (* Druckt am Schluss evt. noch gepufferte *)
 IF plot line no = value page length AND NOT stop request (* Werte aus *)
  THEN gen scales;
       plot one page
 FI
END PROC b end of program;
 
PROC b plot (REAL CONST r) :
 IF plt                       (* Wenn genuegend PLOT-Werte gepuffert *)
  THEN get extreme value;     (* sind, wird eine neue Seite gedruckt *)
       add (r);
       IF param no = plot param no AND line no = value pagelength 
        THEN gen scales;
             plot one page;
             value no := nil;
             line no := nil
       FI
 FI.
 
 get extreme value :
  (* Sucht Maximal bzw. Minimalwert, falls keine festen Skalierungs- *)
  (* grenzen angegeben wurden (im Quellprogramm)*)
  param no INCR 1;
  INT VAR act pointer := plot param (param no).scalepointer;
  set lower bound;
  set upper bound.
 
 set lower bound :
  IF NOT plot param (act pointer).l fixed scale AND
     r < plot param (act pointer).lower bound
   THEN plot param  (act pointer).lower bound := r
  FI.
 
 set upper bound :
  IF NOT plot param (act pointer).u fixed scale AND
     r > plot param (act pointer).upper bound
   THEN plot param  (act pointer).upper bound := r
  FI.
END PROC b plot;
 
PROC add (REAL CONST r) :   (* Puffert PLOT-Werte *)
 value no INCR 1;
 value (value no) := r
END PROC add;
 
END PACKET dynamo plotter;
 



