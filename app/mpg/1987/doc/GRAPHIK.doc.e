#type ("prop.lq")##limit (16.0)# 
#free(10.0)# 
#headoff##bottomoff# 
 
#type("prop.breit.lq")##center##on("u")#Dokumentation des MPG-Graphik-Systems#off("u")#
 
#free(1.0)#
#type("prop")##center#Version 2.1 vom 10.09.87 
 
#free(0.5)#
#center#(c) 1987 Beat Jegerlehner & Carsten Weinholz
 
#page# 
#type("prop")##center#Dokumentation des MPG-Graphik-Systems
#type("8.5.klein")##center#Inhaltsverzeichnis
#type("pica.lq")##free(1.0)#
#type("prop")##limit(16.0)##linefeed(01.0)# 
#type("pica")##on("u")#Inhaltsverzeichnis#off("u")##type("prop.lq")# 
#free(0.5)#
#type ("prop.lq")##limit (16.0)# 
      Teil  1: Komponenten des Graphik-Systems ...................  1 
                1.0 GRAPHIK.Basis ................................  1 
                2.0 GRAPHIK.Configuration/GRAPHIK.Configurator ...  1 
                3.0 GRAPHIK.Plot .................................  1 
      Teil  1.1: Generierung der Graphik .........................  2 
      Teil  1.2: Tasks des Graphik-Systems .......................  3 
                1.0 Task: 'GRAPHIK' ..............................  3 
                2.0 Task: 'PLOT' .................................  3 
                3.0 Task: 'FKT' ..................................  4 
      Teil  2: Operationen der Basisgraphik ......................  5 
                1.0 Paket: 'transformation' ......................  5 
                2.0 Paket: picture ...............................  8 
                3.0 Paket: 'picfile' .............................  13 
                4.0 Paket: 'devices' .............................  17 
      Teil  2.1: Operationen des 'device interface' ..............  19 
                1.0 Paket: 'device interface' ....................  19 
      Teil  2.2: Operationen zur Graphik-Ausgabe .................  23 
                2.0 Paket: 'basisplot' ...........................  23 
                3.0 Paket: 'plot interface' ......................  27 
                4.0 Paket: 'plot' ................................  29 
      Teil  3: Konfigurierung der Graphik ........................  30 
      Teil  3.1: Der Graphik-Konfigurator ........................  30 
      Teil  3.2: Erstellung der Konfigurationsdateien ............  31 
                1.0 Pseudo-SchlÅsselworte ........................  32 
                2.0 Pseudo-Prozeduren ............................  34 
      Teil  4: Graphik-Applikationen .............................  37 
      Teil  4.1: Der Funktionenplotter 'FKT' .....................  37 
                1.0 Allgemeines Åber FKT .........................  37 
                2.0 Das FKT-Menue ................................  37 
                3.0 FKT-Menuepunkte ..............................  38 
      Teil  4.2: Die TURTLE-Graphik ..............................  44 
                1.0 Paket: 'turtlegraphics' ......................  44 
      Stichwortverzeichnis .......................................  XX
#page(1)# 
#head on##bottom on# 
#bottom#
#right#Seite %
#end#
#head#
#type("prop")##center#Dokumentation des MPG-Graphik-Systems
#type("8.5.klein")##center#Teil 1: Komponenten des Graphik-Systems
#type("pica.lq")##free(1.0)#
#end#
#type("pica")##on("u")##ib(1)#Teil 1: Komponenten des Graphik-Systems#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
 
 
   Das MPG-Graphik-System besteht aus folgenden Komponenten: 
 
   #ib(1)#1.0 GRAPHIK.Basis#ie(1)# 
 
      1.1 #ib(2," (1.1)")#PACKET transformation#ie(2,"")# 
            - Transformations- und Umrechnungsprozeduren zur EndgerÑt-
              unabhÑngigen Abbildung von PICTURES bzw. PICFILES. 
 
      1.2 #ib(2," (1.2)")#PACKET picture#ie(2,"")# 
            - Verwaltung des Datentyps PICTURE, der eine Bildebene objekt-
              orientiert beschreibt. 
 
      1.3 #ib(2," (1.3)")#PACKET picfile#ie(2,"")# 
            - Verwaltung des Datentyps PICFILE, der ein aus verschiedenen Bild-
              ebenen (PICTURES) bestehendes Bild und seine (allgemeine) Abbildung
              auf den EndgerÑten beschreibt. 
 
      1.4 #ib(2," (1.4)")#PACKET devices#ie(2,"")# 
            - Allgemeine Verwaltung der verschiedenen EndgerÑte. 
 
 
   #ib(1)#2.0 GRAPHIK.Configuration/GRAPHIK.Configurator#ie(1)# 
 
      2.1 #ib(2," (2.1)")#PACKET deviceinterface#ie(2,"")# 
            - Bereitstellung der allgemeinen graphischen Basisoperationen, die
              fÅr jedes Endgerat gleichartig vorhanden sind. 
            - Das 'deviceinterface' wird vom 'GRAPHIK.Configurator' bei Bedarf
              durch geeignetes Zusammenbinden veschiedener EndgerÑt-
              Konfigurationsdateien automatisch erzeugt. 
 
 
   #ib(1)#3.0 GRAPHIK.Plot#ie(1)# 
 
      3.1 #ib(2," (3.1)")#PACKET basisplot#ie(2,"")# 
            - Bereitstellung der von der EUMEL-Graphik benîtigten
              Basisoperationen. 
 
      3.2 #ib(2," (3.2)")#PACKET plotinterface#ie(2,"")# 
            - Paket zur Ansteuerung und Kontrolle der EndgerÑte. 
 
      3.3 #ib(2," (3.3)")#PACKET plot#ie(2,"")# 
            - Ausgabeprozeduren fÅr PICTURES bzw. PICFILES fÅr alle EndgerÑte. 
#page# 
#type("pica")##on("u")##ib(1)#Teil 1.1: Generierung der Graphik#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
 
   Es wird zunÑchst eine Task 'GRAPHIK' (o.Ñ.) eingerichtet. 
   Das MPG-Graphik-Sytem befindet sich auf der Diskette 'GRAPHIK 2.1': 
 
      - archive  ("GRAPHIK 2.1") 
      - fetch    ("GRAPHIK.Install",archive) 
      - run      ("GRAPHIK.Install") 
 
   'GRAPHIK.Install' enthÑlt ein Generierungsprogramm, das die weitere Generierung
   des Graphik-Systems vornimmt. 
   Existiert auf dem Archiv eine Datei 'GRAPHIK.Configuration', so wird nachge-
   fragt, ob das Graphiksystem hinsichtlich der anzusteuernden EndgerÑte neu-
   konfiguriert('GRAPHIK.Configuration' also in AbhÑngigkeit von den ebenfalls
   auf der Diskette vorhandenen EndgerÑt-Konfigurationsdateien neu erstellt
   werden soll). Fehlt 'GRAPHIK.Configuration', so wird es zwangslÑufig neu er-
   stellt (siehe 'Neukonfiguration des Graphik-Systems', S. #to page ("newconf")#). 
   Mit der im Hintergrund ablaufenden Installation des Plotmanagers in der
   (Sohn-)Task 'PLOT' (siehe 'Funktion von PLOT', S.#to page ("plotmanager")#) steht dann die Graphik allen
   Sohntasks von 'GRAPHIK' zur VerfÅgung: 
 
                                  . 
                                  . 
                               GRAPHIK 
                                  PLOT 
                                  FKT 
                                  EUCLID 
                                  user 
                                  usw. 
                                  . 
                                  . 
#page# 
#type("pica")##on("u")##ib(1)#Teil 1.2: Tasks des Graphik-Systems#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
 
 
   #ib(1)#1.0 Task: 'GRAPHIK'#ie(1)# 
 
      'GRAPHIK' ist die Ausgangstask des Graphik-Systems; in ihr werden (s.o) die
      einzelnen Graphikpakete insertiert, und stehen den Sohntasks zur VerfÅgung
      (siehe 'Operationen der Basisgraphik', S. #topage("gfuncts")#). ZusÑtzlich kann sie den Plot-
      manager in der Task 'PLOT' kontrollieren 
 
   #ib(1)#2.0 Task: 'PLOT'#ie(1)##goalpage("plotmanager")# 
 
      'PLOT' enthÑlt den Multispool-Manager des Graphik-Systems, der die indirekte
      Ausgabe von PICFILES auf jedem EndgerÑt der Station ermîglicht. Der Manager
      verwaltet im Gegensatz zum 'PRINTER' aber nicht nur eine Warteschlange bzw.
      Server sondern mehrere (die Anzahl ist durch die Konstante 'max spools' in
      'GRAPHIK.Manager' festgelegt). 
      (Achtung !, eine Task kann nicht mehr als 255 DatenrÑume, also EintrÑge in
      Warteschlangen verwalten !). 
      Sollte PLOT neben PRINTER zur graphischen Ausgabe auf dem Drucker arbei-
      ten, so ist in PRINTER 'spool control task (/"PLOT")' einzustellen. 
      Der Plotmanager besitzt eine Kommandoebene, die wie folgt arbeitet: 
         Nach 'continue' erscheint der Prompt 'All-Plotter', der anzeigt, da· nach-
         folgende Kommandos gleichermassen auf alle Spools/Server wirken; sollen
         die Kommandos auf nur einen Spool/Server wirken, so ist dieser mit 'select
         plotter' einzustellen, was durch eine énderung des Prompts auf den
         Plotternamen angezeigt wird. 
 
            - 2.1 #ib(2," (2.1)")#listspool#ie(2,"")# 
                 Gibt Auskunft Åber die Inhalte und AktivitÑten aller bzw. des
                 gewÑhlten Spools. 
 
            - 2.2 #ib(2," (2.2)")#clearspool#ie(2,"")# 
                 Initialisiert nach RÅckfrage alle bzw. den gewÑhlten Spool;
                 sÑmtliche EintrÑge werden gelîscht, evtl. laufende Ausgaben
                 abgebrochen (der Server beendet). 
 
            - 2.3 #ib(2," (2.3)")#spool control#ie(2,"")# 
                 (TEXT CONST control task) 
                 Stellt die Task mit dem Namen 'control task' und alle ihre Sîhne
                 als privilegiert ein, d.h. Kommandos wie 'start', 'stop' usw. werden
                 von diesen Tasks wie auch von Systemstasks und von 'GRAPHIK'
                 aus zugelassen. 
 
            - 2.4 #ib(2," (2.4)")#stop#ie(2,"")# 
                 Unterbricht eine evtl. laufende Ausgabe und unterbindet die
                 weitere Ausgabe von EintrÑgen aller bzw. des gewÑhlten Spools;
                 wobei nach RÅckfrage die abgebrochene Ausgabe als erster
                 Eintrag erneut eingetragen wird. 
 
            - 2.5 #ib(2," (2.5)")#start#ie(2,"")# 
                 Nimmt die Ausgabe des gewÑhlten bzw. aller Spools wieder auf. 
 
            - 2.6 #ib(2," (2.6)")#halt#ie(2,"")# 
                 Unterbindet die weitere Ausgabe von EintrÑgen aller bzw. des
                 gewÑhlten Spools; evtl. laufende Ausgaben werden jedoch nicht
                 abgebrochen. 
 
            - 2.7 #ib(2," (2.7)")#select plotter#ie(2,"")# 
                 Bietet als Auswahl die EndgerÑte der Station an; die obenge-
                 nannten Operationen wirken danach nur auf den gewÑhlten Spool,
                 was durch die énderung des Prompts auf den Namen des gewÑhlten
                 EndgerÑtes angezeigt wird. 
                 Der Abbruch der Auswahloperation fÅhrt dementsprechend wieder
                 zur Einstellung 'All-Plotter'. 
                 Das aktuell zu kontrollierende EndgerÑt kann jedoch auch mit
                 den Standard-Auswahloperationen gewÑhlt werden; diese lassen
                 aber auch die Wahl von Plottern anderer Stationen zu, was im
                 Plotmanager als 'All-Plotter' gewertet wird. 
 
         Folgende Funktionen kînnen nur auf einzelne Spools; also nicht auf
         'All-Plotter' angewendet werden: 
 
            - 2.8 #ib(2," (2.8)")#killer#ie(2,"")# 
                 Bietet im Dialog alle im Spool enthaltenen EintrÑge zum Lîschen
                 an. 
 
            - 2.9 #ib(2," (2.9)")#first#ie(2,"")# 
                 Bietet im Dialog alle dem ersten Eintrag nachfolgenden EintrÑge
                 zum Vorziehen an. 
 
   #ib(1)#3.0 Task: 'FKT'#ie(1)# 
 
      Die Task 'FKT' stellt den Funktionenplotter FKT, bzw. dessen menuegesteuerten
      Monitor als Taskmonitor zur VerfÅgung. 
      Wird die Task mit dem Menuepunkt 
                  'q' - in die Kommandoebene zurueck 
      verlassen, so werden alle enthaltenen PICFILES gelîscht. 
      Der Funktionenplotter wird in 'FKT' mit dem Kommando 'fktmanager' instal-
      liert; er ist jedoch auch in jeder anderen Task mit dem Kommando 'fktplot'
      erreichbar. 
 
#page# 
#bottom#
#right#Seite %
#end#
#head#
#type("prop")##center#Dokumentation des MPG-Graphik-Systems
#type("8.5.klein")##center#Teil 2: Operationen der Basisgraphik
#type("pica.lq")##free(1.0)#
#end#
#type("pica")##on("u")##ib(1)#Teil 2: Operationen der Basisgraphik#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
#goalpage("gfuncts")# 
   Die Pakete der Basisgraphik sind in der Datei 'GRAPHIK.Basis' enthalten, und
   realisieren folgende Aufgaben: 
         - Vektorielle Abbildung virtueller Koordinaten unter Verwendung einer
           Transformationsmatrix auf die konkrete EndgerÑt-ZeichenflÑche unter
           BerÅcksichtigung des eingestellten Teils der ZeichenflÑche ('viewport')
           und des Fensters ('window'). 
         - Bereitstellung des Datentyps PICTURE, der die gemeinsame Manipulation
           von Objekten ermîglicht. 
         - Bereitstellung des Datentyps PICFILE, der die gemeinsame Manipulation
           von PICTURES hinsichtlich ihrer Ausgabe ermîglicht. 
         - Bereitstellung des Datentyps PLOTTER, der die freie Auswahl von End-
           gerÑten ermîglicht, und Informationen Åber sie liefert. 
 
   Zu den mit '*' gekennzeichneten Beschreibungen vgl. die Beschreibung im
   Programmierhandbuch. 
 
      #ib(1)#1.0 Paket: 'transformation'#ie(1)# 
 
         1.1 BOOL PROC #ib(2," (1.1)")#clippedline#ie(2," (PROC)")# 
              (REAL VAR x0, y0, x1, y1) 
              - Intern verwendete Prozedur, welche die in den Variablen Åber-
                gebenen Anfangs- und Endkoordinaten einer Geraden auf die
                Ausma·e der aktuellen EndgerÑt-ZeichenflÑche begrenzt. 
                Es wird zurÅckgeliefert, ob Teile der Åbergebenen Geraden inner-
                halb der ZeichenflÑche liegen, also gezeichnet werden mÅssen. 
 
         1.2 PROC #ib(2," (1.2)")#drawingarea *#ie(2," (PROC)")# 
              (REAL VAR x cm, REAL VAR y cm, REAL VAR xp, REAL yp) 
              - TrÑgt in die Åbergebenen Variablen die Ausma·e der aktuellen
                EndgerÑt-ZeichenflÑche in cm und Pixel ein. 
 
         1.3 PROC #ib(2," (1.3)")#getvalues#ie(2," (PROC)")# 
              (ROW 3 ROW 2 REAL VAR, ROW 2 ROW 2 REAL VAR, 
               ROW 4 REAL VAR, ROW 2 REAL VAR, ROW 3 REAL VAR) 
              - Intern verwendete Prozedur, die in die Åbergebenen Felder die
                aktuellen Werte der Transformationsmatrix eintrÑgt. 
 
         1.4 BOOL PROC #ib(2," (1.4)")#newvalues#ie(2," (PROC)")# 
              - Intern verwendete Prozedur, die anzeigt, ob die Transformations-
                matrix verÑndert wurde. 
 
         1.5 PROC #ib(2," (1.5)")#oblique *#ie(2," (PROC)")# 
              (REAL CONST a, b) 
              - Stellt fÅr o.g. Abbildungsfunktion die Projektionsart
               'schiefwinklig' ein; 'a;b' ist der Punkt in der X-Y-Ebene, auf den der
               Einheitsvektor in Z-Richtung abgebildet werden soll. 
 
         1.6 PROC #ib(2," (1.6)")#orthographic *#ie(2," (PROC)")# 
              - Stellt die Projektionsart 'Paralellprojektion' ein (s.o.). 
 
         1.7 PROC #ib(2," (1.7)")#perspective *#ie(2," (PROC)")# 
              (REAL CONST x,y,z) 
              - Stellt die Abbildungsart 'perspektivisch' ein; 'x;y;z' gibt den
                Fluchtpunkt der Zentralperspektive an. 
 
         1.8 PROC #ib(2," (1.8)")#setdrawingarea#ie(2," (PROC)")# 
              (REAL CONST x cm, y cm, x p, y p) 
              - Intern verwendete Prozedur, die vorm Beginn des Zeichnens dem
                Transformationspaket die Ausma·e der EndgerÑt-ZeichenflÑche
                Åbergibt. 
 
         1.9 PROC #ib(2," (1.9)")#setvalues#ie(2," (PROC)")# 
              (ROW 3 ROW 2 REAL CONST, ROW 2 ROW 2 REAL CONST, 
               ROW 4 REAL CONST, ROW 2 REAL CONST, ROW 3 REAL CONST) 
              - Intern verwendete Prozedur, welche die Transformationsmatrix mit
                den Werten der Åbergebenen Felder fÅllt. 
 
         1.10 PROC #ib(2," (1.10)")#transform#ie(2," (PROC)")# 
              (REAL CONST x, y, z, xp, yp) 
              - Intern verwendete Prozedur zur Abbildung eines drei-
                dimensionalen Vektors in virtuellen Koordinaten auf
                (zweidimensionale) Bildschirmkoordinaten. 
 
         1.11 PROC #ib(2," (1.11)")#view *#ie(2," (PROC)")# 
              (REAL CONST alpha, phi, theta) 
              - Stellt fÅr o.g. Abbildungsfunktion zusÑtzlich die Drehwinkel der
                Abbildung in Polarkoordinaten ein. 
                In der derzeitigen Version fehlerhaft ! 
 
         1.12 PROC #ib(2," (1.12)")#view *#ie(2," (PROC)")# 
              (REAL CONST alpha, phi) 
              - s.o.; ebenfalls fehlerhaft ! 
 
         1.13 PROC #ib(2," (1.13)")#view *#ie(2," (PROC)")# 
              (REAL CONST alpha) 
              - Dreht die Abbildung um den Mittelpunkt der ZeichenflÑche um
                'alpha' Grad ! 
 
         1.14 PROC #ib(2," (1.14)")#viewport *#ie(2," (PROC)")##goalpage("viewport")# 
              (REAL CONST hormin, hormax, vertmin, vertmax) 
              - Definiert den verwendeten Teil der EndgerÑt-ZeichenflÑche in
                Welt- oder GerÑtekoordinaten, bei Verwendung dieser Prozedur ist
                vorangehend 'window (TRUE)' aufzurufen; damit die neuen Werte
                auch BerÅcksichtigung finden. 
 
                1. Angabe in Weltkoordinaten (cm): 
                   'hor min;vert min' - Position der unteren linken Ecke der ver-
                                        wendeten ZeichenflÑche in cm. 
                   'hor max;vert max' - Position der oberen rechten Ecke der ver-
                                        wendeten ZeichenflÑche in cm. 
 
                2. Angabe in GerÑtekoordinaten: 
                   Es wird eine Angabe in GerÑtekoordinaten angenommen, wenn 
                          hor max < 2.0 und vert max < 2.0 gilt. 
                   Die Werte werden als Bruchteile der Grî·e der gesamten Zei-
                   chenflÑche aufgefa·t, wobei fÅr die horizontalen Werte zu-
                   sÑtzlich das VerhÑltnis 'Horizontale/Vertikale' (i.d. Regel > 1)
                   berÅcksichtigt wird. 
                   Das bedeutet fÅr 'vert max' = 'hor max' = 1, 
                   da· der obere Rand der spezifizierten ZeichenflÑche an der
                   Oberkante der Gesamt-ZeichenflÑche, und der rechte Rand an
                   der rechten Kante des durch die Gesamthîhe der ZeichenflÑche
                   gegebenen Quadrates liegt (unverzerrt). 
                   Soll die gesamte ZeichenflÑche genutzt werden, so ist 'hor min'
                   = 'vert min' = 0 und 'vert max' = 1 zu setzen; 
                   'hor max' dagegen auf das VerhÑltnis 'Horizontale/Vertikale' !.
                   Die halbe horizontale Verwendung der ZeichenflÑche ist durch
                   Halbierung des SeitenverhÑltnisses zu erreichen. 
 
         1.15 PROC #ib(2," (1.15)")#window *#ie(2," (PROC)")# 
              (REAL CONST xmin, xmax, ymin, ymax, zmin, zmax) 
              - Stellt die Fenstergrî·e der virtuellen ZeichenflÑche, zu der die
                virtuellen Koordinaten in Bezug gesetzt werden sollen, mittels
                der gegenÅberliegenden Ecken 'min' und 'max' ein. 
 
         1.16 PROC #ib(2," (1.16)")#window *#ie(2," (PROC)")# 
              (REAL CONST xmin, xmax, ymin, ymax) 
              - s.o., jedoch fÅr zweidimensionale Darstellungen. 
 
         1.17 PROC #ib(2," (1.17)")#window *#ie(2," (PROC)")# 
              (BOOL CONST update) 
              - Die öbergabe von TRUE verursacht die interne Neuberechnung der
                Transformationsmatrix beim nÑchsten 'set values'; die immer dann
                notwendig wird, wenn die ZeichenflÑche oder das mit 'viewport'
                eingestellte virtuelle Fenster verÑndert werden soll. 
#page# 
      #ib(1)#2.0 Paket: picture#ie(1)# 
 
         2.1 #ib(2," (2.1)")#TYPE PICTURE *#ie(2,"")# 
              - Datentyp zur Verwaltung eines einfarbigen Bildes; das aus entwe-
                der zwei- oder dreidimensionalen Objekten besteht. 
 
         2.2 OP #ib(2," (2.2)")#:= *#ie(2," (OP)")# 
              (PICTURE VAR dest, PICTURE CONST source) 
              - Zuweisungsoperator fÅr den Datentyp PICTURE. 
 
         2.3 PROC #ib(2," (2.3)")#bar *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST width, height, pattern) 
              - Zeichnet in 'pic' an der aktuellen Position ein Rechteck 
                'width/height' mit dem Muster 'pattern', wobei zu beachten ist, da·
                die aktuelle X-Position die horizontale Position der vertikalen
                Symmetrieachse des Rechtecks angibt. 
                Als 'pattern' z.Zt. implementiert: 
                                 0 - nicht gefÅllt 
                                 1 - halb gefÅllt (zeitaufwendig!) 
                                 2 - gefÅllt 
                                 3 - horizontal schraffiert 
                                 4 - vertikal schraffiert 
                                 5 - horizontal und vertikal schraffiert 
                                 6 - diagonal rechts schraffiert 
                                 7 - diagonal links schraffiert 
                                 8 - diagonal rechts und links schraffiert 
 
         2.4 OP #ib(2," (2.4)")#CAT *#ie(2," (OP)")# 
              (PICTURE VAR dest, PICTURE CONST add) 
              - FÅgt die Bilder 'dest' und 'add' in 'dest' zusammen. 
 
         2.5 PROC #ib(2," (2.5)")#circle *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST x, y, rad, INT CONST pattern) 
              - Zeichnet in 'pic' an der Position 'x;y' mit dem Radius 'rad' und dem
                Muster 'pattern' gefÅllt ('pattern' z.Zt. wirkungslos) 
 
         2.6 INT PROC #ib(2," (2.6)")#dim *#ie(2," (PROC)")# 
              (PICTURE CONST pic) 
              - Liefert die fÅr 'pic' eingestellte DimensionalitÑt 
                (2 - zweidimensional; 3 - dreidimensional); wobei die Dimensionali-
                tÑt mit der ersten Zeichenoperation eingestellt wird. 
 
         2.7 PROC #ib(2," (2.7)")#draw *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST x, y, z) 
              - Zeichnet in 'pic' von der aktuellen Position einen Gerade zur
                Position 'x;y'. 
 
         2.8 PROC #ib(2," (2.8)")#draw *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST x, y, z) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
 
         2.9 PROC #ib(2," (2.9)")#draw *#ie(2," (PROC)")# 
              (PICTURE VAR pic, TEXT CONST text, REAL CONST angle, height, width) 
              - Zeichnet in 'pic' an der aktuellen Position 'text' in der Grî·e
                'height/width' unter dem Winkel 'angle'. 
 
         2.10 PROC #ib(2," (2.10)")#draw *#ie(2," (PROC)")# 
              (PICTURE VAR pic, TEXT CONST text) 
              - Zeichnet in 'pic' an der aktuellen Position 'text' in Standardgrî·e
                und normaler Ausrichtung. 
 
         2.11 PROC #ib(2," (2.11)")#draw cm *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST x cm, y cm) 
              - Zeichnet in 'pic' eine Gerade zur cm-Position 'x;y', d.h., die Projek-
                tionseinstellung wird nicht beachtet. 
 
         2.12 PROC #ib(2," (2.12)")#draw cm r *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST dx cm, dy cm) 
              - Zeichnet in 'pic' eine Gerade zur um 'dx cm;dy cm' verschobenen
                Zeichenposition, d.h, die Projektionseinstellung wird nicht beach-
                tet. 
 
         2.13 PROC #ib(2," (2.13)")#draw r *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST dx, dy, dz) 
              - Zeichnet in 'pic' eine Gerade der LÑnge 'dx;dy;dz' relativ zur
                aktuellen Position. 
 
         2.14 PROC #ib(2," (2.14)")#draw r *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST dx, dy) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
 
         2.15 PROC #ib(2," (2.15)")#extrema *#ie(2," (PROC)")# 
              (PICTURE CONST pic, REAL VAR x min, x max, y min, y max, z min, z max) 
              - TrÑgt in die Åbergebenen Variablen die grîssten und kleinsten
                Koordinaten aller Objekte in 'pic' ein. 
 
         2.16 PROC #ib(2," (2.16)")#extrema *#ie(2," (PROC)")# 
              (PICTURE CONST pic, REAL VAR x min, x max, y min, y max) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
 
         2.17 INT PROC #ib(2," (2.17)")#length *#ie(2," (PROC)")# 
              (PICTURE CONST pic) 
              - Liefert die LÑnge des Objekt-Verwaltungstextes von 'pic'. 
 
         2.18 PROC #ib(2," (2.18)")#move *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST x, y, z) 
              - FÑhrt den Zeichenstift auf 'pic' an die Position 'x;y;z'. 
 
         2.19 PROC #ib(2," (2.19)")#move *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST x, y) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
 
         2.20 PROC #ib(2," (2.20)")#move cm *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST x cm, y cm) 
              - Die aktuelle Zeichenposition wird auf 'x cm;y cm' verschoben, wobei
                die Darstellungsart unberÅcksichtigt bleibt. 
 
         2.21 PROC #ib(2," (2.21)")#move cm r *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST d xcm, d ycm) 
              - Die aktuelle Zeichenposition wird um 'd xcm;d ycm' verschoben,
                wobei die Darstellungsart unberÅcksichtigt bleibt. 
 
         2.22 PROC #ib(2," (2.22)")#move r *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST dx, dy, dz) 
              - Verschiebt die aktuelle Zeichenposition in 'pic' um 'dx;dy;dz'. 
 
         2.23 PROC #ib(2," (2.23)")#move r *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST dx, dy) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
 
         2.24 PICTURE PROC #ib(2," (2.24)")#nilpicture *#ie(2," (PROC)")# 
              - Initialisierungsfunktion; liefert 'leeres Bild'. 
 
         2.25 INT PROC #ib(2," (2.25)")#pen *#ie(2," (PROC)")# 
              (PICTURE CONST pic) 
              - Liefert den fÅr 'pic' eingestellten Stift (Nummer 1 - 16). 
 
         2.26 PROC #ib(2," (2.26)")#pen *#ie(2," (PROC)")# 
              (PICTURE VAR pic, INT CONST no) 
              - Stellt den Stift 'no' fÅr 'pic' ein, wobei 'no' die Werte 1 - 16 an-
                nehmen darf. 
 
         2.27 PICTURE PROC #ib(2," (2.27)")#picture *#ie(2," (PROC)")# 
              (TEXT CONST objects) 
              - Die Objektbeschreibung aller Objekte eines Bildes wird in einem
                Text verwaltet; mit dieser Prozedur wird ein TEXT im entsprechen-
                den Format in ein PICTURE verwandelt. 
                Das Format des TEXTes:   <INT>  Dimension : 2- oder 3-D 
                                         <INT>  Zeichenstift-Nummer 
                                         <...>  ObjekteintrÑge 
 
                Die ObjekteintrÑge haben folgendes Format: 
                   <INT> Objektcode <...> Parameter. 
 
                Objektcodes fÅr:    >  Die Parameter entsprechen der 
                   -  draw       1     Parameterfolge der Prozeduren. 
                   -  move       2 
                   -  text       3  >  Vor dem Text wird als <INT> die 
                   -  move r     4     TextlÑnge gehalten. 
                   -  draw r     5 
                   -  move cm    6 
                   -  draw cm    7 
                   -  move cm r  8 
                   -  draw cm r  9 
                   -  bar       10 
                   -  circle    11 
 
         2.28 PROC #ib(2," (2.28)")#rotate *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST alpha, beta, gamma) 
              - Die Objekte von 'pic' werden gemÑ· den Winkeln 'alpha;beta;gamma'
                im positiven Sinne um die X-,Y-,Z-Achse gedreht; wobei nur ein
                Winkel <> 0.0 sein darf. 
 
         2.29 PROC #ib(2," (2.29)")#rotate *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST alpha) 
              - Die Objekte von 'pic' werden gemÑ· dem Winkel 'alpha' im positiven
                Sinne um die X-Achse gedreht. 
 
         2.30 PROC #ib(2," (2.30)")#stretch *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST xc, yc, zc) 
              - 'pic' wird um die Faktoren 'xc;yc;zc' gestreckt oder gestaucht:
                               Faktor > 1 -> Streckung 
                               Faktor < 1 -> Stauchung 
                               Faktor < 0 -> zusÑtzlich Achsenspiegelung 
 
         2.31 PROC #ib(2," (2.31)")#stretch *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST xc, yc) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
 
         2.32 TEXT PROC #ib(2," (2.32)")#text *#ie(2," (PROC)")# 
              (PICTURE CONST pic) 
              - Liefert den Objekt-Verwaltungstext von 'pic'(vergleiche 
                'picture'). 
 
         2.33 PROC #ib(2," (2.33)")#translate *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST dx, dy, dz) 
              - 'pic' wird um 'dx;dy;dz' verschoben. 
 
         2.34 PROC #ib(2," (2.34)")#translate *#ie(2," (PROC)")# 
              (PICTURE VAR pic, REAL CONST dx, dy) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
 
         2.35 PROC #ib(2," (2.35)")#where *#ie(2," (PROC)")# 
              (PICTURE CONST pic, REAL VAR x, y, z) 
              - TrÑgt die aktuelle Zeichenposition in 'pic' in die Åbergebenen
                Variablen 'x;y;z' ein. 
 
         2.36 PROC #ib(2," (2.36)")#where *#ie(2," (PROC)")# 
              (PICTURE CONST pic, REAL VAR x, y) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
#page# 
      #ib(1)#3.0 Paket: 'picfile'#ie(1)# 
 
         3.1 #ib(2," (3.1)")#TYPE PICFILE#ie(2,"")# 
              - Datentyp zur Verwaltung mehrerer Bilder (PICTUREs) und der
                Darstellungsparameter.(Aktuelle Typnummer: 1102 !). 
 
         3.2 OP #ib(2," (3.2)")#:= *#ie(2," (OP)")# 
              (PICFILE VAR dest, DATASPACE CONST source) 
              - Assoziiert das PICFILE 'dest' mit dem DATASPACE 'source'. 
 
         3.3 OP #ib(2," (3.3)")#:= *#ie(2," (OP)")# 
              (PICFILE VAR dest, PICFILE CONST source): 
              - Assoziiert das PICFILE 'dest' mit 'source'; wie bei Files entsteht
                keine Kopie! 
 
         3.4 INT PROC #ib(2," (3.4)")#background *#ie(2," (PROC)")# 
              (PICFILE CONST pf) 
              - Liefert die auf 'pf' eingestellte Hintergrundfarbe. 
 
         3.5 PROC #ib(2," (3.5)")#background *#ie(2," (PROC)")# 
              (PICFILE VAR pf, INT CONST no) 
              - Stellt die Farbe 'no' als Hintergrundfarbe fÅr 'pf' ein: 
 
         3.6 PROC #ib(2," (3.6)")#delete picture *#ie(2," (PROC)")# 
              (PICFILE VAR pf) 
              - Lîscht das aktuelle Bild in 'pf'. 
 
         3.7 PROC #ib(2," (3.7)")#down *#ie(2," (PROC)")# 
              (PICFILE VAR pf) 
              - Positioniert in 'pf' ein Bild weiter. 
 
         3.8 PROC #ib(2," (3.8)")#down *#ie(2," (PROC)")# 
              (PICFILE VAR pf, INT CONST step) 
              - Positioniert in 'pf' 'step'-Bilder weiter. 
 
         3.9 BOOL PROC #ib(2," (3.9)")#eof *#ie(2," (PROC)")# 
              (PICFILE CONST) 
              - Liefert zurÅck, ob das aktuelle Bild auch das letzte des PICFILES
                ist. 
 
         3.10 PROC #ib(2," (3.10)")#extrema *#ie(2," (PROC)")# 
              (PICFILE VAR pf, REAL VAR x min, x max, y min, y max, z min, z max) 
              - TrÑgt in die Åbergebenen Variablen die kleinsten bzw. grî·ten
                Koordinaten aller Bilder in 'pf' ein. 
 
         3.11 PROC #ib(2," (3.11)")#extrema *#ie(2," (PROC)")# 
              (PICFILE VAR pf, REAL VAR x min, x max, y min, y max) 
              - s.o., jedoch fÅr zweidimensionale PICFILEs. 
 
         3.12 PROC #ib(2," (3.12)")#get *#ie(2," (PROC)")# 
              (PICFILE VAR pf, FILE VAR source) 
              - Liest die in 'source' enthaltenen Informationen Åber Bilder nach
                'pf' ein. 
 
         3.13 PROC #ib(2," (3.13)")#get values *#ie(2," (PROC)")# 
              (PICFILE CONST pf,  ROW 3 ROW 2 REAL VAR,ROW 2 ROW 2 REAL VAR, 
                                  ROW 4 REAL VAR, ROW 2 REAL VAR, ROW 3 REAL VAR) 
              - TrÑgt die Werte der Transformationsmatrix von 'pf' in die Åber-
                gebenen Variablenfelder ein. 
 
         3.14 PROC #ib(2," (3.14)")#insert picture *#ie(2," (PROC)")# 
              (PICFILE VAR pf) 
              - FÅgt vor das aktuelle Bild von 'pf' ein leeres Bild ein. 
 
         3.15 BOOL PROC #ib(2," (3.15)")#is first picture *#ie(2," (PROC)")# 
              (PICFILE CONST pf) 
              - Liefert zurÅck, ob das aktuelle auch das erste Bild von 'pf' ist. 
 
         3.16 PROC #ib(2," (3.16)")#oblique *#ie(2," (PROC)")# 
              (PICFILE VAR pf, REAL CONST a, b) 
              - Stellt fÅr 'pf' die Projektionsart 'schiefwinklig' ein; 'a;b' ist der
                Punkt in der X-Y-Ebene, auf den der Einheitsvektor in Z-Richtung
                abgebildet werden soll. 
 
         3.17 PROC #ib(2," (3.17)")#perspective *#ie(2," (PROC)")# 
              (PICFILE VAR pf, REAL CONST x, y, z) 
              - Stellt fÅr 'pf' die Projektionsart 'perspektivisch' ein; 'x;y;z' gibt
                den Fluchtpunkt der Zentralperspektive an. 
 
         3.18 INT PROC #ib(2," (3.18)")#picture no *#ie(2," (PROC)")# 
              (PICFILE CONST pf) 
              - Liefert die Nummer des aktuellen Bildes von 'pf' zurÅck. 
 
         3.19 INT PROC #ib(2," (3.19)")#pictures *#ie(2," (PROC)")# 
              (PICFILE CONST pf) 
              - Liefert die Anzahl der in 'pf' enthaltenen Bilder zurÅck. 
 
         3.20 PROC #ib(2," (3.20)")#put *#ie(2," (PROC)")# 
              (FILE VAR dest, PICFILE CONST pf) 
              - Liest 'pf' nach 'dest' aus. 
 
         3.21 PROC #ib(2," (3.21)")#put picture *#ie(2," (PROC)")# 
              (PICFILE VAR pf, PICTURE CONST ins) 
              - FÅgt das Bild 'ins' vor das aktuelle Bild von 'pf' ein. 
 
         3.22 PROC #ib(2," (3.22)")#read picture *#ie(2," (PROC)")# 
              (PICFILE VAR pf, PICTURE VAR pic) 
              - TrÑgt das aktuelle Bild von 'pf' in 'pic' ein. 
 
         3.23 PROC #ib(2," (3.23)")#selected pen *#ie(2," (PROC)")# 
              (PICFILE VAR pf, INT CONST no, INT VAR color, thickness, linetype,
               BOOL VAR visible) 
              - TrÑgt in die Åbergebenen Variablen die fÅr den Stift 'no' aktuell
                eingestellten Werte ein, wobei 'no' die Werte 1 - 16 annehmen darf. 
 
         3.24 PROC #ib(2," (3.24)")#select pen *#ie(2," (PROC)")# 
              (PICFILE VAR pf, INT CONST no, INT CONST color, thickness, linetype,
               BOOL CONST visible) 
              - Stellt fÅr den Stift 'no' von 'pf' die Åbergebenen Werte fÅr Farbe,
                Stiftbreite, Art des Linenzuges ein, wobei 'no' die Werte 1 - 16
                annehmen darf. 
                'visible' = FALSE bedeutet, das die mit diesem Stift gezogenen
                Linien innerhalb bereits durch das Zeichnen entstandener FlÑchen
                nicht gezeichnet werden, die FlÑchen sie also 'verdecken'. 
                Vordefiniert sind: 
                             - color: 
                                     <0 - nicht standardisierte XOR-Modi 
                                      0 - Lîschstift 
                                      1 - Standardfarbe d. EndgerÑtes (s/w) 
                                      2 - rot 
                                      3 - blau 
                                      4 - grÅn 
                                      5 - schwarz 
                                      6 - weiss 
                                      n - Sonderfarben 
                             - thickness: 
                                      0 - StandardstrichstÑrke d. EndgerÑtes 
                                      n - StrichstÑrke in 1/10 mm 
                             - linetype: 
                                      0 - keine Linie 
                                      1 - durchgÑngige Linie 
                                      2 - gepunktete Linie 
                                      3 - kurz gesrichelte Linie 
                                      4 - lang gestrichelte Linie 
                                      5 - Strichpunktlinie 
                               (Standard-Definitionen, die Linetypes kînnen
                                Åber 'basisplot' auch verÑndert werden.) 
 
         3.25 PROC #ib(2," (3.25)")#set values *#ie(2," (PROC)")# 
              (PICFILE VAR pf,  ROW 3 ROW 2 REAL CONST, 
                                ROW 2 ROW 2 REAL CONST, 
                                ROW 4 REAL CONST, 
                                ROW 2 REAL CONST, ROW 3 REAL CONST) 
              - Die Åbergebenen Felder werden in die Transformationsmatrix von
                'pf' Åbernommen. 
 
         3.26 PROC #ib(2," (3.26)")#to eof *#ie(2," (PROC)")# 
              (PICFILE VAR pf) 
              - Positioniert auf das letzte Bild von 'pf'. 
 
         3.27 PROC #ib(2," (3.27)")#to first pic *#ie(2," (PROC)")# 
              (PICFILE VAR pf) 
              - Positioniert auf das erste Bild von 'pf'. 
 
         3.28 PROC #ib(2," (3.28)")#to pic *#ie(2," (PROC)")# 
              (PICFILE VAR pf, INT CONST n) 
              - Positioniert auf das 'n'-te Bild von 'pf'. 
 
         3.29 PROC #ib(2," (3.29)")#up *#ie(2," (PROC)")# 
              (PICFILE VAR pf) 
              - Positioniert in 'pf' ein Bild zurÅck. 
 
         3.30 PROC #ib(2," (3.30)")#up *#ie(2," (PROC)")# 
              (PICFILE VAR pf, INT CONST step) 
              - Positioniert in 'pf' 'step'-Bilder zurÅck. 
 
         3.31 PROC #ib(2," (3.31)")#view *#ie(2," (PROC)")# 
              (PICFILE VAR pf, REAL CONST alpha, phi, theta) 
              - Stellt fÅr die Abbildung von 'pf' zusÑtzlich die Drehwinkel der
                Abbildung in Polarkoordinaten ein. 
                In der derzeitigen Version fehlerhaft ! 
 
         3.32 PROC #ib(2," (3.32)")#view *#ie(2," (PROC)")# 
              (PICFILE VAR pf, REAL CONST alpha, phi) 
              - s.o.; in der derzeitigen Version fehlerhaft ! 
 
         3.33 PROC #ib(2," (3.33)")#view *#ie(2," (PROC)")# 
              (REAL CONST alpha) 
              - Dreht das Bild um den Mittelpunkt der ZeichenflÑche um 'alpha'
                Grad ! 
 
         3.34 PROC #ib(2," (3.34)")#viewport *#ie(2," (PROC)")# 
              (PICFILE VAR pf, REAL CONST hor min, hor max, vert min, vert max) 
              - Spezifiziert die ZeichenflÑche, auf die 'pf' abgebildet werden soll.
                Siehe dazu auch 'viewport' im 'transformation'-Paket (S. #topage("viewport")#). 
 
         3.35 PROC #ib(2," (3.35)")#window *#ie(2," (PROC)")# 
              (PICFILE VAR pf, REAL CONST x min, x max, y min, y max, z min, z max) 
              - Definiert die virtuelle ZeichenflÑche von 'pf'. 
 
         3.36 PROC #ib(2," (3.36)")#window *#ie(2," (PROC)")# 
              (PICFILE VAR pf, REAL CONST x min, x max, y min, y max) 
              - s.o., jedoch fÅr zweidimensionale PICFILEs. 
 
         3.37 PROC #ib(2," (3.37)")#write picture *#ie(2," (PROC)")# 
              (PICFILE VAR pf, PICTURE CONST new) 
              - öberschreibt das aktuelle Bild von 'pf' mit 'new'. 
#page# 
      #ib(1)#4.0 Paket: 'devices'#ie(1)# 
 
         4.1 #ib(2," (4.1)")#TYPE PLOTTER#ie(2,"")# 
              - Verwaltungstyp zur ReprÑsentation eines EndgerÑtes hinsichtlich
                seiner Station, seines Kanals, seines Namens sowie seiner Zeichen-
                flÑche. Dabei ist zu beachten, da· der gÅltige EndgerÑt-
                Descriptor, der zur Selektion verwendet wird, aus Station, Kanal
                und Namen besteht; die Namen also nicht eindeutig vergeben
                werden mÅssen. 
 
         4.2 OP #ib(2," (4.2)")#:=#ie(2," (OP)")# 
              (PLOTTER VAR dest, PLOTTER CONST source) 
              - Zuweisungsoperator fÅr den Datentyp 'PLOTTER'. 
 
         4.3 BOOL OP #ib(2," (4.3)")#=#ie(2," (OP)")# 
              (PLOTTER CONST left, right) 
              - Vergleichsoperator fÅr den Datentyp 'PLOTTER'. 
 
         4.4 INT PROC #ib(2," (4.4)")#actual plotter#ie(2," (PROC)")# 
              - Liefert die interne Verwaltungsnummer des eingestellten End-
                gerÑtes (Kein EndgerÑt eingestellt -> 0). 
 
         4.5 INT PROC #ib(2," (4.5)")#channel#ie(2," (PROC)")# 
              (PLOTTER CONST plotter) 
              - Liefert den Kanal von 'plotter'. 
 
         4.6 PROC #ib(2," (4.6)")#drawingarea#ie(2," (PROC)")# 
              (REAL VAR x cm, y cm, INT VAR x p, y p) 
              - TrÑgt in die Åbergebenen Variablen die Ma·e der 
                ZeichenflÑche des eingestellten EndgerÑtes ein. 
 
         4.7 PROC #ib(2," (4.7)")#drawingarea#ie(2," (PROC)")# 
              (REAL VAR x cm, y cm, INT VAR x p, y p, PLOTTER CONST plotter) 
              - TrÑgt in die Åbergebenen Variablen die Ma·e der ZeichenflÑche
                von 'plotter' ein. 
 
         4.8 PROC #ib(2," (4.8)")#install plotter#ie(2," (PROC)")# 
              (TARGET VAR new descriptors) 
              - öbergibt dem Verwaltungspacket den zu verwaltenden Satz End-
                gerÑte. Wird intern vom 'device interface' verwendet, kann aber
                auch im nachhinein zur Installation von EndgerÑten anderer
                Stationen oder zum Ausblenden von EndgerÑten dienen. Nachdem
                die Graphik installiert wurde, kînnen jedoch keine neuen sta-
                tionseigenen EndgerÑte erzeugt werden (oder nur verwaltungs-
                seitig, d.h. die Ansteuerung fehlt). 
 
         4.9 TEXT PROC #ib(2," (4.9)")#name#ie(2," (PROC)")# 
              (PLOTTER CONST plotter) 
              - Liefert den Namen von 'plotter' 
 
         4.10 PLOTTER PROC #ib(2," (4.10)")#no plotter#ie(2," (PROC)")# 
              - Liefert den EndgerÑt-Descriptor 'kein Plotter'. 
 
         4.11 PLOTTER PROC #ib(2," (4.11)")#plotter#ie(2," (PROC)")# 
              - Liefert den EndgerÑt-Descriptor des eingestellten EndgerÑtes. 
 
         4.12 PLOTTER PROC #ib(2," (4.12)")#plotter#ie(2," (PROC)")# 
              (TEXT CONST descriptor) 
              - Liefert den EndgerÑt-Descriptor des durch 'descriptor' beschrie-
                benen EndgerÑtes. 
                'descriptor' hat folgendes Format: 
                    <Stationsnummer>/<Kanalnummer>/EndgerÑtname, 
                wobei nicht vorhandene EndgerÑte abgelehnt werden. 
 
         4.13 TEXT PROC #ib(2," (4.13)")#plotterinfo#ie(2," (PROC)")# 
              (TEXT CONST descriptor, INT CONST length) 
              - Liefert einen auf die LÑnge 'length' eingerichteten TEXT, der
                'descriptor' in aufbereiteter Form wiedergibt. 
                Format von 'descriptor' s.o. 
 
        4.14 THESAURUS PROC #ib(2," (4.14)")#plotters#ie(2," (PROC)")# 
              - Liefert alle vorhandenen EndgerÑte in Form o.g. Descriptoren. 
 
         4.15 PROC #ib(2," (4.15)")#select plotter#ie(2," (PROC)")# 
              (PLOTTER CONST plotter) 
              - Stellt 'plotter' als aktuelles EndgerÑt ein. 
 
         4.16 PROC #ib(2," (4.16)")#select plotter#ie(2," (PROC)")# 
              (TEXT CONST descriptor) 
              - Stellt das durch 'descriptor' beschriebene EndgerÑt als aktuelles
                EndgerÑt ein. 
 
         4.17 PROC #ib(2," (4.17)")#select plotter#ie(2," (PROC)")# 
              - Bietet eine Auswahl aller EndgerÑte an, und stellt das gewÑhlte
                als aktuelles EndgerÑt ein. 
 
         4.18 INT PROC #ib(2," (4.18)")#station#ie(2," (PROC)")# 
              (PLOTTER CONST plotter) 
              - Liefert die Stationsnummer von 'plotter' zurÅck. 
#page# 
#type("pica")##on("u")##ib(1)#Teil 2.1: Operationen des 'device interface'#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
 
 
      Das automatisch vom 'GRAPHIK.Configurator' anhand von Konfigurationsda-
      teien erstellte Paket 'device interface' realisiert die normierte, jedoch von
      der ZeichenflÑche des EndgerÑts abhÑngige Ansteuerung der verschiedenen
      EndgerÑte. Es entspricht dabei dem Paket 'EndgerÑt.Basis' der EUMEL-Graphik,
      geht aber teilweise Åber dessen Leistungen hinaus.Hinweis: Falls diese Lei-
      stung nicht bereits endgerÑtseitig implementiert ist, wird nicht geclipped;
      die öberschreitung der Zeichengrenzen hat also Undefiniertes zur Folge. 
      Zudem ist die Mehrheit der Prozeduren ausschlie·lich nach 'initplot' funk-
      tionsfÑhig. 
 
      #ib(1)#1.0 Paket: 'device interface'#ie(1)# 
 
         1.1 INT PROC #ib(2," (1.1)")#background#ie(2," (PROC)")# 
              - Liefert die Nummer der aktuell fÅr den Hintergrund eingestellten
                Farbe zurÅck. 
 
         1.2 PROC #ib(2," (1.2)")#background#ie(2," (PROC)")# 
              (INT CONST color no) 
              - Stellt die Farbe 'color no' als Hintergrundfarbe ein. 
 
         1.3 PROC #ib(2," (1.3)")#box#ie(2," (PROC)")# 
              (INT CONST x1, y1, x2, y2, pattern) 
              - Zeichnet ein Rechteck mit den gegenÅberliegenden Ecken 'x1;y1'
                und 'x2;y2', das mit dem Muster 'pattern' gefÅllt wird, wobei
                'pattern' endgerÑtspezifisch ist. 
 
         1.4 PROC #ib(2," (1.4)")#circle#ie(2," (PROC)")# 
              (INT CONST x, y, rad, from, to) 
              - Zeichnet an der Stelle 'x;y' einen Kreis (bzw. Kreissegment) des
                Radius 'rad' mit dem Anfangswinkel 'from' und dem Endwinkel 'to'. 
 
         1.5 PROC #ib(2," (1.5)")#clear#ie(2," (PROC)")# 
              - Initialisiert die ZeichenflÑche des aktuellen EndgerÑtes, wobei
                die Zeichenposition auf '0;0' und die Standardfarben 
                gesetzt werden. 
 
         1.6 PROC #ib(2," (1.6)")#clear#ie(2," (PROC)")# 
              (BOOL CONST onoff) 
              - Die öbergabe von FALSE bewirkt, da· alle nachfolgenden Aufrufe
                von 'clear' wirkungslos sind; mit TRUE werden sie entsprechend
                wieder aktiviert. 
 
         1.7 INT PROC #ib(2," (1.7)")#color#ie(2," (PROC)")# 
              (INT CONST color no) 
              - Liefert den fÅr die Farbe 'color no' eingestellten Farbwert im
                normierten RGB-Code von 0-999. 
 
         1.8 INT PROC #ib(2," (1.8)")#colors#ie(2," (PROC)")# 
              - Liefert die Anzahl mîglicher Farben fÅr das aktuelle EndgerÑt. 
 
         1.9 PROC #ib(2," (1.9)")#draw to#ie(2," (PROC)")# 
              (INT CONST x, y) 
              - Zieht von der aktuellen Zeichenposition eine Gerade zur Position
                'x;y'. 
 
         1.10 PROC #ib(2," (1.10)")#endplot#ie(2," (PROC)")# 
              - Wartet auf eine Eingabe des Benutzers und beendet dann die
                graphische Ausgabe; ggf. durch Umschalten in den Text-Modus. 
                Falls mîglich, sollte die ausgegebene Graphik jedoch auf dem
                Bildschirm erhalten bleiben. 
 
         1.11 PROC #ib(2," (1.11)")#end plot#ie(2," (PROC)")# 
              (BOOL CONST onoff) 
              - Die öbergabe von FALSE bewirkt, da· alle nachfolgenden Aufrufe
                von 'endplot' wirkungslos sind; mit TRUE werden sie entsprechend
                wieder aktiviert. 
 
         1.12 PROC #ib(2," (1.12)")#fill#ie(2," (PROC)")# 
              (INT CONST x, y, INT CONST pattern) 
              - Die Umgebung von 'x;y' wird mit dem Muster 'pattern' gefÅllt, wobei
                sowohl 'pattern' als auch die genauen FÅll-Bedingungen (Art der
                Umrahmung usw.) endgerÑtspezifisch sind. 
 
         1.13 INT PROC #ib(2," (1.13)")#foreground#ie(2," (PROC)")# 
              - Liefert die Nummer der aktuell fÅr den Vordergrund eingestellten
                Farbe zurÅck. 
 
         1.14 PROC #ib(2," (1.14)")#foreground#ie(2," (PROC)")# 
              (INT CONST color no) 
              - Stellt die Farbe 'color no' als Vordergrundfarbe ein. 
 
         1.15 PROC #ib(2," (1.15)")#get cursor#ie(2," (PROC)")# 
              (INT VAR x, y, TEXT VAR exit char) 
              - Nach Aufruf dieser Prozedur sollte das EndgerÑt die Eingabe
                einer Position mittels eines graphischen Cursors (i.d.R.
                Fadenkreuz) ermîglichen. Dieser Modus soll bleibt solange auf-
                rechterhalten bis eine Taste gedrÅckt wird; in 'x;y' findet sich
                dann die Position des Cursors, und in 'exit char' die gedrÅckte
                Taste. 
                Diese Prozedur ist jedoch nicht fÅr das Ein bzw. Ausschalten des
                graphischen Cursors zustÑndig, d.h der eingeschaltete Cursor ist
                stÑndig sichtbar; bei ausgeschaltetem Cursor kehrt die Prozedur
                sofort mit 'exit char' = ""0"" zurÅck. 
 
         1.16 BOOL PROC #ib(2," (1.16)")#graphik cursor#ie(2," (PROC)")# 
              - Diese Prozedur gibt an, ob graphische Eingabeoperationen und 
                die dazugehîrigen Operationen auf dem aktuellen EndgerÑt ver-
                fÅgbar sind. 
 
         1.17 PROC #ib(2," (1.17)")#graphik cursor#ie(2," (PROC)")# 
              (INT CONST x, y, BOOL CONST onoff) 
              - Diese Prozedur schaltet den graphischen Cursor an bzw. aus oder
                positioniert ihn. Nach dem Einschalten sollte der Cursor perma-
                nent sichtbar sein. Ein erneutes Einschalten hat die
                Neupositionierung des Cursors zur Folge. 
 
         1.18 PROC #ib(2," (1.18)")#home#ie(2," (PROC)")# 
              - Positioniert die aktuelle Zeichenposition auf den Punkt '0;0'; bei
                eingeschaltetem graphischen Cursor diesen auf die Mitte der
                ZeichenflÑche. 
 
         1.19 PROC #ib(2," (1.19)")#init plot#ie(2," (PROC)")# 
              - Initialisiert das aktuelle EndgerÑt zur graphischen Ausgabe,
                (schaltet ggf. in den Graphik-Modus), wobei der Bildschirm jedoch
                mîglichst nicht gelîscht werden sollte. 
 
         1.20 PROC #ib(2," (1.20)")#move to#ie(2," (PROC)")# 
              (INT CONST xp, yp) 
              - Die Position 'xp;yp' wird neue Stiftposition; die Wirkung ist unde-
                finiert bei öberschreitung der Bildschrimgrenzen. 
 
         1.21 PROC #ib(2," (1.21)")#prepare#ie(2," (PROC)")# 
              - Bereitet die Ausgabe auf einem EndgerÑt vor; d.h. die Task wird an
                den entsprechenden Kanal angekoppelt, und andere Tasks am An-
                koppeln gehindert (z.B. 'stop' des PRINTER-Servers). Dabei wird die
                Prozedur erst dann verlassen, wenn die Aktion erfolgreich been-
                det ist. (z.B. bis zur Freigabe des Kanals). 
 
 
         1.22 PROC #ib(2," (1.22)")#set color#ie(2," (PROC)")# 
              (INT CONST no, rgb) 
              - Setzt die Farbe von 'no' auf die normierte RGB-Farbkombination
                'rgb' (0 - 999). 
 
         1.23 PROC #ib(2," (1.23)")#setmarker#ie(2," (PROC)")# 
              (INT CONST xp, yp, type) 
              - Zeichnet an der Position 'xp;yp' eine Markierung; wobei die Wir-
                kung bei öberschreitung der Bildschirmgrenzen undefiniert ist.
                Als 'type' sollten vorhanden sein: 
                         0  - Kreuz '+' 
                         1  - Kreuz diagonal 'x' 
                            - weitere beliebig 
 
         1.24 PROC #ib(2," (1.24)")#setpalette#ie(2," (PROC)")# 
              - Initialisiert die Farben des EndgerÑtes gemÑ· den im Paket ge-
                setzten Farben. 
 
         1.25 PROC #ib(2," (1.25)")#setpixel#ie(2," (PROC)")# 
              (INT CONST xp, yp) 
              - Setzt das Pixel 'xp;yp' in der aktuellen Schreibfarbe. 
 
         1.26 PROC #ib(2," (1.26)")#stdcolors#ie(2," (PROC)")# 
              - Initialisiert die Paket-Intern verwendete Farbtabelle auf die
                standardmÑ·ig fÅr das EndgerÑt definierten Farben; 
                wobei die Farben jedoch nicht auf dem EndgerÑt eingestellt
                werden. 
 
         1.27 PROC #ib(2," (1.27)")#stdcolors#ie(2," (PROC)")# 
              (BOOL CONST onoff) 
              - Die öbergabe von FALSE bewirkt, da· alle nachfolgenden Aufrufe
                von 'stdcolors' wirkungslos sind; mit TRUE werden sie entspre-
                chend wieder aktiviert. 
#page# 
#type("pica")##on("u")##ib(1)#Teil 2.2: Operationen zur Graphik-Ausgabe#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
 
       Die Pakete zur Ausgabe von Graphiken (PICFILES) sind in der Datei
       'GRAPHIK.Basis' enthalten, und realisieren folgende Leistungen: 
         - Im Datentyp PICTURE bzw. PICFILE in Codierter Form verwendete Ausgabe-
           prozeduren auf einzelne Objekte unter BerÅcksichtigung der Abbil-
           dungsparameter und ZeichenflÑche. 
         - Kommunikations- und Kontrolloperationen auf die Task 'PLOT' zur
           indirekten Ausgabe von PICFILES. 
         - Ausgabeoperationen auf den Datentyp PICTURE bzw. PICFILE unter Be-
           rÅcksichtung des eingestellten EndgerÑtes. 
      Wird fÅr die Angabe von Koordinaten der Typ REAL verwendet, so handelt es
      sich um virtuelle Koordinaten, d.h. die Ausgabe-Parameter wie 'viewport' und
      'window' werden berÅcksichtigt; bei Verwendung von INT ist die Ausgabe end-
      gerÑtspezifisch. 
 
      #ib(1)#2.0 Paket: 'basisplot'#ie(1)# 
 
         2.1 PROC #ib(2," (2.1)")#bar *#ie(2," (PROC)")# 
              (INT CONST x, y, height, width, pattern) 
              - Zeichnet an der Position 'x;y' ein Rechteck der LÑnge/Breite
                'width/height' mit dem Muster 'pattern', wobei 'x;y' die untere linke
                Ecke des Rechtecks angibt. 
                Als 'pattern' z.Zt. implementiert: 
                                 0 - nicht gefÅllt 
                                 1 - halb gefÅllt 
                                 2 - gefÅllt 
                                 3 - horizontal schraffiert 
                                 4 - vertikal schraffiert 
                                 5 - horizontal und vertikal schraffiert 
                                 6 - diagonal rechts schraffiert 
                                 7 - diagonal links schraffiert 
                                 8 - diagonal rechts und links schraffiert 
 
         2.2 PROC #ib(2," (2.2)")#bar *#ie(2," (PROC)")# 
              (REAL CONST height, width, INT CONST pattern) 
              - siehe oben, jedoch mit Ausgangspunkt an der aktuellen Zeichen-
                position, wobei zu beachten ist, da· die x-Koordinate die horizon-
                tale Position der vertikalen Symmetrieachse des Rechtecks angibt. 
 
         2.3 PROC #ib(2," (2.3)")#beginplot#ie(2," (PROC)")# 
              - Leitet die graphische Ausgabe ein, wobei das EndgerÑt in seinen
                Startzustand versetzt wird, und dem Transformationspaket die
                Abmessungen der ZeichenflÑche mitgeteilt werden. 
 
         2.4 PROC #ib(2," (2.4)")#box *#ie(2," (PROC)")# 
              - Zeichnet eine Umrahmung der gesamten ZeichenflÑche (Nicht nur
                des verwendeten Teiles). 
 
         2.5 PROC #ib(2," (2.5)")#circle *#ie(2," (PROC)")# 
              (REAL CONST rad, from, to, INT CONST pattern) 
              - Zeichnet an aktuellen Position einen Kreis od. ein Kreissegment
                des Radius 'rad'; beginnend bei 'from' bis zum Endwinkel 'to' und
                gefÅllt mit dem Muster 'pattern' ('pattern' z.Zt. nicht
                implementiert). 
 
         2.6 PROC #ib(2," (2.6)")#draw *#ie(2," (PROC)")# 
              (INT CONST x, y) 
              - Zeichnet von der aktuellen Position eine Gerade zur Position 'x;y'. 
 
         2.7 PROC #ib(2," (2.7)")#draw *#ie(2," (PROC)")# 
              (INT CONST x0, y0, x1, y1) 
              - Zieht eine Gerade von der Position 'x0;y0' bis zur Position 'x1;y1'. 
 
         2.8 PROC #ib(2," (2.8)")#draw *#ie(2," (PROC)")# 
              (REAL CONST x, y, z) 
              - Zieht von der aktuellen Zeichenposition eine Gerade zur
                (transformierten) 3-D Position 'x;y;z'. 
 
         2.9 PROC #ib(2," (2.9)")#draw *#ie(2," (PROC)")# 
              (REAL CONST x, y) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
 
         2.10 PROC #ib(2," (2.10)")#draw *#ie(2," (PROC)")# 
              (TEXT CONST text, REAL CONST angle, height, width) 
              - Zeichnet den TEXT 'text' ab der aktuellen Zeichenposition unter
                dem Winkel 'angle' und in der Hîhe/Breite 'height;width'. 
 
         2.11 PROC #ib(2," (2.11)")#draw *#ie(2," (PROC)")# 
              - s.o., jedoch in Standard-Ausrichtung (0 Grad) und
                Standard-Hîhe/Breite (0.5/0.5). 
 
         2.12 PROC #ib(2," (2.12)")#draw cm *#ie(2," (PROC)")# 
              (REAL CONST x cm, y cm) 
              - Zeichnet von der aktuellen Position eine Gerade zur cm-Position
                'x cm;y cm'. 
 
         2.13 PROC #ib(2," (2.13)")#draw cm r *#ie(2," (PROC)")# 
              (REAL CONST x cm, REAL CONST y cm) 
              - Zieht von der aktuellen Zeichenposition eine Gerade zur um 'x cm;
                y cm' verschobenen Zielposition. 
 
         2.14 PROC #ib(2," (2.14)")#draw r *#ie(2," (PROC)")# 
              (REAL CONST dx, dy) 
              - Zieht von der aktuellen Zeichenposition eine Gerade zur um 'dx;dy'
                Einheiten verschobenen Zielposition. 
 
         2.15 PROC #ib(2," (2.15)")#draw r *#ie(2," (PROC)")# 
              (REAL CONST dx, dy, dz) 
              - Zeichnet von der aktuellen Zeichenposition eine Gerade zur um
                'dx;dy;dz' Einheiten verschobenen und transformierten 3-D Ziel-
                position. 
 
         2.16 PROC #ib(2," (2.16)")#hidden lines *#ie(2," (PROC)")# 
              (BOOL CONST visible) 
              - Schaltet die vektorisierte Speicherung aller zukÅnftigen Aus-
                gabe ein (FALSE) bzw. aus.Ist dieser Modus eingeschaltet, so werden
                alle durch vorheriges Zeichnen entstandenen FlÑchen beim Zeichen
                berÅcksichtigt, also nicht Åbermalt; sie 'verdecken' die weiteren
                Linien. 
 
         2.17 PROC #ib(2," (2.17)")#linetype#ie(2," (PROC)")# 
              (INT CONST line no, TEXT CONST bitpattern) 
              - Stellt fÅr den Linientyp 'line no' das Bitmuster 'bitpattern' ein;
                wobei der 'bitpattern'-TEXT ausschlie·lich aus den Zeichen '0' und
                '1' bestehen sollte. 
 
         2.18 PROC #ib(2," (2.18)")#move *#ie(2," (PROC)")# 
              (INT CONST x,y) 
              - Zeichnet von der aktuellen Position eine Gerade zur Position 'x;y'. 
 
         2.19 PROC #ib(2," (2.19)")#move *#ie(2," (PROC)")# 
              (REAL CONST x, y, z) 
              - Zeichnet von der aktuellen Position eine Gerade zur trans-
                formierten 3-D-Position 'x;y;z' 
 
         2.20 PROC #ib(2," (2.20)")#move *#ie(2," (PROC)")# 
              (REAL CONST x, y) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
 
         2.21 PROC #ib(2," (2.21)")#move cm#ie(2," (PROC)")# 
              (REAL CONST x cm, y cm) 
              - Setzt die aktuelle Zeichenposition auf die cm-Position 'x cm,;y cm'. 
 
         2.22 PROC #ib(2," (2.22)")#move cm r *#ie(2," (PROC)")# 
              (REAL CONST d x cm, d y cm) 
              - Zeichnet von der aktuellen Position eine Gerade zur um
                'd x cm;d y cm' verschobenen Zielposition. 
 
         2.23 PROC #ib(2," (2.23)")#move r *#ie(2," (PROC)")# 
              (REAL CONST d x, d y, d z) 
              - Zeichnet von der aktuellen Position eine Gerade zur um 'd x;d y;d z'
                Einheiten verschobenen und transformierten Zielposition. 
 
         2.24 PROC #ib(2," (2.24)")#move r *#ie(2," (PROC)")# 
              (REAL CONST d x, d y) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
 
         2.25 PROC #ib(2," (2.25)")#pen *#ie(2," (PROC)")# 
              (INT CONST background, foreground, thickness, linetype) 
              - Aktiviert fÅr alle folgenden Ausgaben mit virtuellen Koordi-
                naten den Hintergrund 'background'; die Schreibfarbe
                'foreground'; die ZeichenstÑrke 'thickness' in 1/10 mm und den
                Linientyp 'linetype' (i.d.R. 1-6). Vergleiche 'select pen'. 
 
         2.26 PROC #ib(2," (2.26)")#reset *#ie(2," (PROC)")# 
              - Die mit 'hidden lines (FALSE)' vektorisiert abgespeicherte
                Ausgabe wird gelîscht. 
 
         2.27 PROC #ib(2," (2.27)")#reset linetypes *#ie(2," (PROC)")# 
              - Setzt die Linientypen 1-6 auf Standard-Linientypen: 1 - durch-
                          gÑngige Linie 
                          2 - gepunktete Linie 
                          3 - kurz gestrichelte Linie 
                          4 - lang gestrichelte Linie 
                          5 - Strichpunktlinie 
 
         2.28 PROC #ib(2," (2.28)")#reset zeichensatz *#ie(2," (PROC)")# 
              - Setzt den Zeichensatz auf den Standard-Zeichensatz 'ZEICHENSATZ'. 
 
         2.29 PROC #ib(2," (2.29)")#where *#ie(2," (PROC)")# 
              (REAL VAR x, y, z) 
              - TrÑgt die aktuelle Zeichenposition als (retransformierte) 3-D
                Position in die Åbergeben Variablen ein. 
 
         2.30 PROC #ib(2," (2.30)")#where *#ie(2," (PROC)")# 
              (REAL VAR x, y) 
              - s.o., jedoch fÅr zweidimensionale Bilder. 
 
         2.31 PROC #ib(2," (2.31)")#zeichensatz *#ie(2," (PROC)")# 
              (TEXT CONST zeichenname) 
              - LÑdt den Zeichensatz 'zeichenname' zur Verwendung bei Beschrif-
                tungen. 
#page# 
      #ib(1)#3.0 Paket: 'plot interface'#ie(1)# 
 
         3.1 THESAURUS OP #ib(2," (3.1)")#ALL#ie(2," (OP)")# 
              (PLOTTER CONST plotter) 
              - Liefert die Namen der z.Zt. im Spool 'plotter' zur indirekten
                Graphik-Ausgabe gespoolten task-eigenen PICFILES. 
                Bei Aufruf aus 'GRAPHIK' werden die Namen aller zur Ausgabe
                gespoolten PICFILES geliefert. 
 
         3.2 PROC #ib(2," (3.2)")#erase#ie(2," (PROC)")# 
              (TEXT CONST picname, PLOTTER CONST plotter) 
              - Lîscht nach RÅckfrage das im Spool 'plotter' zur indirekten
                Graphik-Ausgabe gespoolte task-eigene PICFILE 'picname'. 
                Bei Aufruf aus 'GRAPHIK' ist auch das Lîschen fremder zur Ausgabe
                gespoolter PICFILES mîglich. 
 
         3.3 PROC #ib(2," (3.3)")#erase#ie(2," (PROC)")# 
              (THESAURUS CONST piclist, PLOTTER CONST plotter) 
              - Lîscht im Dialog alle in 'piclist' und im Spool 'plotter' zur in-
                direkten Graphik-Ausgabe gespoolten task-eigenen PICFILES. 
                Bei Aufruf aus 'GRAPHIK' ist auch das Lîschen fremder zur Ausgabe
                gespoolter PICFILES mîglich. 
 
         3.4 BOOL PROC #ib(2," (3.4)")#exists#ie(2," (PROC)")# 
              (TEXT CONST picname, PLOTTER CONST plotter) 
              - Liefert zurÅck, ob z.Zt. im Spool 'plotter' ein task-eigenes PICFILE
                'picname' zur indirekten Graphik-Ausgabe gespoolt wird. 
                Bei Aufruf aus 'GRAPHIK' kann auch die Existenz fremder zur Aus-
                gabe gespoolter PICFILES erfragt werden. 
 
         3.5 PROC #ib(2," (3.5)")#first#ie(2," (PROC)")# 
              (TEXT CONST picname, PLOTTER CONST plotter) 
              - Zieht das im Spool 'plotter' zur indirekten Ausgabe gespoolte
                PICFILE 'picname' an die erste Stelle der Warteschlange. Der Auf-
                ruf ist nur aus 'GRAPHIK' zulÑssig. 
 
         3.6 PROC #ib(2," (3.6)")#generate plotmanager#ie(2," (PROC)")# 
              - Erzeugt die Task 'PLOT', in der dann im Hintergrund der Plot-
                manager insertiert wird. Dabei darf 'PLOT' zuvor nicht existieren,
                und in der Task mu· die Datei 'GRAPHIK.Manager' vorhanden sein. 
 
         3.7 PROC #ib(2," (3.7)")#halt#ie(2," (PROC)")# 
              (PLOTTER CONST plotter) 
              - Unterbindet die weitere indirekte Graphik-Ausgabe aus dem Spool
                'plotter'; eine aktuell laufende Ausgabe wird jedoch nicht ab-
                gebrochen. Der Aufruf ist nur aus 'GRAPHIK' zulÑssig. 
 
         3.8 PROC #ib(2," (3.8)")#list#ie(2," (PROC)")# 
              (FILE VAR list file, PLOTTER CONST plotter) 
              - Erzeugt in 'list file' eine Inhalts/AktivitÑtsÅbersicht des Spools
                'plotter'. 
 
         3.9 PROC #ib(2," (3.9)")#list#ie(2," (PROC)")# 
              (PLOTTER CONST plotter) 
              - Zeigt eine Inhalts/AktivitÑtsÅbersicht des Spools 'plotter'. 
 
         3.10 THESAURUS PROC #ib(2," (3.10)")#picfiles#ie(2," (PROC)")# 
              - Liefert eine Liste der Namen aller in der Task enthaltenen
                PICFILES. 
 
         3.11 PROC #ib(2," (3.11)")#save#ie(2," (PROC)")# 
              (TEXT CONST picname, PLOTTER CONST plotter) 
              - Sendet das PICFILE 'picname' zwecks indirekter Graphik-Ausgabe
                zum Spool 'plotter'. 
 
         3.12 PROC #ib(2," (3.12)")#save#ie(2," (PROC)")# 
              (THESAURUS CONST piclist, PLOTTER CONST plotter) 
              - Sendet alle in 'piclist' namentlich enthaltenen PICFILES zwecks
                indirekter Graphik-Ausgabe zum Spool 'plotter'. 
 
          3.13 PROC #ib(2," (3.13)")#start#ie(2," (PROC)")# 
               (PLOTTER CONST plotter) 
               - Nimmt die zuvor mit 'halt','wait for halt','stop' oder spoolseitig
                 unterbrochene indirekte Graphik-Ausgabe des Spools 'plotter'
                 wieder auf. Der Aufruf ist nur aus 'GRAPHIK' zulÑssig. 
 
         3.14 PROC #ib(2," (3.14)")#stop#ie(2," (PROC)")# 
              (PLOTTER CONST plotter) 
              - Unterbricht sofort die aktuell laufende Ausgabe des Spools
                'plotter', und unterbindet weitere Ausgaben. Nach RÅckfrage wird
                das PICFILE, das aktuell ausgegeben wurde, erneut an erster
                Steller der Warteschlange eingetragen. 
 
         3.15 PROC #ib(2," (3.15)")#wait for halt#ie(2," (PROC)")# 
              (PLOTTER CONST plotter) 
              - Unterbindet die weitere Ausgabe der
                gespoolten PICFILES, und wartet bis die aktuell laufende Ausgabe
                beendet ist. 
#page# 
      #ib(1)#4.0 Paket: 'plot'#ie(1)# 
 
         4.1 PROC #ib(2," (4.1)")#plot *#ie(2," (PROC)")# 
              (PICTURE CONST picture) 
              - Ausgabe der Objektebene 'picture', unter Verwendung des in
                'picture' angegebenen Stiftes gemÑ· seiner aktuellen Einstellung
                im 'basisplot'.Nur fÅr Direkt-Ausgaben verwendbar. 
 
         4.2 PROC #ib(2," (4.2)")#plot *#ie(2," (PROC)")# 
              (PICFILE CONST pf) 
              - Ausgabe des Bildes 'pf' unter vollstÑndiger BerÅcksichtung der in
                'pf' mit 'select pen';'window';'viewport' usw. eingestellten
                Ausgabeparameter. Nur fÅr Direkt-Ausgaben verwendbar. 
 
         4.3 PROC #ib(2," (4.3)")#plot *#ie(2," (PROC)")# 
              (TEXT CONST picfile name) 
              - Direkte oder indirekte Ausgabe des Bildes 'picfile name'. 
                Bei direkter Ausgabe wird obiges 'plot' verwendet; bei indirekter
                Ausgabe wird das PICFILE an den aktuell eingestellten Spool zur
                graphischen Ausgabe gesendet. 
#page# 
#bottom#
#right#Seite %
#end#
#head#
#type("prop")##center#Dokumentation des MPG-Graphik-Systems
#type("8.5.klein")##center#Teil 3: Konfigurierung der Graphik
#type("pica.lq")##free(1.0)#
#end#
#type("pica")##on("u")##ib(1)#Teil 3: Konfigurierung der Graphik#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
 
 
#type("pica")##on("u")##ib(1)#Teil 3.1: Der Graphik-Konfigurator#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
#goalpage("newconf")# 
       Die MPG-EUMEL-Graphik besitzt eine normierte Schnittstelle zu allen graphischen
       EndgerÑten. Diese wird vom Programm 'GRAPHIK.Configurator' aus verschiede-
       nen Dateien, die einer gewissen Syntax zu genÅgen haben, zu einem Paket
       namens 'device interface' zusammengefÅgt. Diese Dateien enthalten verschie-
       dene Informationen und endgerÑtspezifische ELAN-Prozeduren, die zur
       Erzeugung graphischer Primitiva wie Gerade, Kreis, Rechteck und zur Be-
       rechnung der konkreten Abbildung graphischer Objekte sowie zur Realisa-
       tion von Eingaben benîtigt werden. Das Konfigurationsprogramm erkennt
       diese Dateien an der Namensendung '.GCONF', und bietet diese zu
       Programmbeginn zur Auswahl an. 
       Dann werden die gewÑhlten Dateien inhaltlich untersucht und die relevan-
       ten Informationen, RÅmpfe der benîtigten Prozeduren sowie alle vom Benut-
       zer zusÑtzlich eingetragenen globalen Objekte (globale Variablen,
       LET-Objekte, zusÑtzlich benîtigte Prozeduren usw.) vom Programm extrahiert
       und zwischengespeichert. 
       Im letzten Schritt erstellt das Programm schlie·lich das Paket 'device
       interface' in der Datei 'GRAPHIK.Configuration', indem die zwischengespei-
       cherten Texte sinnvoll zusammengefÅgt werden. 
       Die benîtigten Konfigurationsdateien sind relativ einfach zu erstellen, da
       sich der Programmierer ausschlie·lich mit der Realisation der geforderten
       Leistungen auf einem EndgerÑt-Typ befassen kann, da die programmseitige
       Einbindung ins Graphiksystem vom Konfigurationsprogramm vorgenommen
       wird. 
#page# 
#type("pica")##on("u")##ib(1)#Teil 3.2: Erstellung der Konfigurationsdateien#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
 
      Namensgebung: "<EndgerÑtname><Kanalangaben>.GCONF" 
         Konfigurationsdateien zur Anbindung eines EndgerÑt-Types auf der
         eigenen Station enthalten die benîtigten ELAN-Quelltexte zur Realisa-
         tion der geforderten Leistungen und weitere Verwaltungs- und Berech-
         nungsoperationen. 
         Das Konfigurationsprogramm erkennt die relevanten Daten bzw. Quelltexte
         dieser Dateien an verschiedenen Pseudo-SchlÅsselworten bzw. Pseudo-
         Prozedurdeklarationen, wobei die Namensgebung hinsichtlich des Pro-
         zedurnamens, der Parameter sowie ihrer Namen vollstÑndig festgelegt ist. 
         Daher ist es unzulÑssig, Parameternamen zu Ñndern oder Delimiter
         (Semikolon, Doppelpunkt) fortzulassen. 
         Derartige Fehler werden jedoch i.d.R. vom Konfigurationsprogramm
         erkannt und gemeldet, wohingegen Fehler in den ProzedurrÅmpfen, den
         zusÑtzlichen Prozeduren bzw. das Fehlen zusÑtzlich benîtigter Pro-
         zeduren nicht erkannt, sondern erst beim Compilieren des Gesamt-Paketes
         vom ELAN-Compiler gemeldet werden. 
         (Die Korrektur im Gesamt-Paket sollte unterlassen werden, vielmehr ist
         der Fehler in der entsprechenden Konfigurationsdatei zu beheben, falls
         nicht einfach die Einbindung eines zusÑtzlichen Paketes vergessen
         wurde.) 
         Zudem ist zu beachten, da· die benîtigten ProzedurrÅmpfe vom Kon-
         figurationsprogramm in Refinements umgewandelt werden, und zusÑtz-
         liche Objekte (Prozeduren, LET-Objekte, Variablen) einfach mit ein-
         gebunden werden, so da·: 
          - Globale und lokale Variablen eindeutig fÅr alle! Konfigurations-
            dateien benannt werden mÅssen. 
            (ZweckmÑssig: ... VAR endgerÑtname variablenname) 
          - ZusÑtzliche Prozeduren und LET-Objekte ebenso eindeutig benannt
            werden mÅssen. 
          - öberflÅssige Delimiter, die aber vom ELAN-Compiler nicht bemÑngelt
            werden (z.B. Punkt am Ende des Prozedurrumpfes) nicht vorkommen
            dÅrfen. 
          - Nicht realisierbare Pseudo-Prozeduren mit leerem Rumpf enthalten
            sein mÅssen (z.B. Vordergrund/Hintergrund od. Farben bei
            Monochrom-EndgerÑten) 
          - Prozedur-Kîpfe bzw. -Enden allein in einer Zeile und an ihrem Anfang
            stehen mÅssen. 
 
      Namensgebung: "ENVIRONMENT.GCONF" 
         Dient zur verwaltungsseitigen Einbindung von EndgerÑten anderer
         Stationen, da fÅr diese EndgerÑte nur die Verwaltungsinformationen
         benîtigt werden, weil die konkrete Anpassung auf der anderen Station
         erfolgt. 
         Die in 'ENVIRONMENT.GCONF' zeilenweise enthaltenen Informationen werden
         dem Benutzer bei der Auswahl der Konfigurationsdateien mit angeboten; er
         kann sie aber auch 'von Hand' in die THESAURUS-Auswahl einfÅgen. 
 
      Namensgebung: "Dateizweck" (also beliebig) 
         DarÅberhinaus existieren weitere Dateien, die globale Prozeduren und
         weitere Objekte enthalten, die fÅr verschiedene EndgerÑt-Anpassungen
         nÅtzlich sein kînnen, wie z.B. unten beschriebene Dateien: 
          - 'std primitives' 
            EnthÑlt Prozeduren zur softwareseitigen Emulation von zwar gefor-
            derten, hardwareseitig aber eventuell nicht bereitgestellten
            Leistungen wie 'circle' und 'box'. 
          - 'matrix printer' 
            EnthÑlt Prozeduren zur Erzeugung von Geraden und FÅllmustern auf
            einer Bitmatrix, die zur graphischen Ausgabe auf Druckern benîtigt
            wird. 
          - 'terminal plot' 
            EnthÑlt grundlegende Prozeduren zur (behelfsmÑ·igen) Ausgabe von
            Graphiken auf Ascii-Terminals (Zeichenorientiert, nicht graphikfÑhig) 
 
      Folgende Pseudo-SchlÅsselworte bzw. Pseudo-Prozeduren werden vom
      Konfigurationsprogramm erkannt und behandelt: 
 
      #ib(1)#1.0 Pseudo-SchlÅsselworte#ie(1)# 
 
         1.1 #ib(2," (1.1)")#COLORS#ie(2,"")# 
              Syntax: COLORS "RGB-Kombinationen"; 
              - Dient der Definition der Standard-Farben. 
                - "RGB-Kombinationen":  (TEXT)  Pro Farbe 3-ziffrige RGB-
                                                (Rot-GrÅn-Blau)-
                                                 Kombinationen in normierter
                                                 Notation 
                                                (jeder Farbanteil wird durch
                                                die Ziffern 0-9 dargestellt;
                                                sollte das EndgerÑt dieser
                                                Notation nicht genÅgen, so ist
                                                eine anteilige Umrechnung
                                                vorzunehmen). 
                                                Die erste RGB-Kombination
                                                wird fÅr die Hintergrundfarbe
                                                verwendet (i.d.R. 000), bei
                                                monochromen EndgerÑten ist
                                                also "000999" einzusetzen. 
 
         1.2 #ib(2," (1.2)")#EDITOR#ie(2,"")# 
              Syntax: EDITOR; 
              - SchlÅsselwort, das dem Konfigurationsprogramm anzeigt, da·
                folgende Eingabeprozeduren vorhanden sind: 
                - 'graphik cursor' 
                - 'get cursor' 
                - 'set marker' 
                Fehlt das SchlÅsselwort, so kînnen o.g. Pseudo-Prozeduren weg-
                gelasssen werden, brauchen also nicht mit leerer Leistung
                implementiert werden. 
 
         1.3 #ib(2," (1.3)")#INCLUDE#ie(2,"")# 
              Syntax: INCLUDE "Name der Includedatei"; 
              - SchlÅsselwort, mit dem weitere Dateien in die Konfigurationsdatei
                textuell eingebunden werden kînnen (s.o). 
 
         1.4 #ib(2," (1.4)")#LINK#ie(2,"")# 
              Syntax: LINK <Station>/<Kanal>, .... ; 
              - Dient zur Anbindung mehrerer EndgerÑte an einen EndgerÑt-Typ,
                die hier genannten KanÑle werden eigenstÑndig verwaltet, aber
                wie das bei 'PLOTTER' definierte EndgerÑt angesteuert; wobei fÅr
                alle EndgerÑte der gleiche Name gilt, sie also durch die Kanal-
                nummer unterschieden werden. 
                Durch Kommata getrennt, kînnen mit dieser Anweisung beliebig
                viele EndgerÑte zusÑtzlich angebunden werden. 
                - <Station>     :  (INT)  Stationsnummer des EndgerÑtes
                                          (eigene Station) 
                - <Kanal>       :  (INT)  Kanalnummer des EndgerÑtes 
 
         1.5 #ib(2," (1.5)")#PLOTTER#ie(2,"")# 
              Syntax: PLOTTER "EndgerÑtname",<Station>,<Kanal>, 
                              <Xpixel>,<Ypixel>,<Xcm>,<Ycm>; 
              - Dient zur Erkennung als EndgerÑt-Konfigurationsdatei, und zur
                öbergabe der verwaltungsseitig benîtigten
                EndgerÑt-Spezifikationen: 
                - "EndgerÑtname":  (TEXT)  Name des EndgerÑtes 
                - <Station>     :  (INT)   Stationsnummer des EndgerÑtes
                                           (eigene Station) 
                - <Kanal>       :  (INT)   Kanalnummer des EndgerÑtes 
                Jedes EndgerÑt wird Åber diese drei Werte eindeutig identifiziert,
                der EndgerÑtname kann also mehrfach verwendet werden. 
                - <Xpixel>      :  (INT)   X-Rasterkoordinate des letzten
                                           Pixels in X-Richtung (i.d.R
                                           adressierbare Pixel - 1) 
                - <Ypixel>      :  (INT)   Y-Rasterkoordinate des letzten
                                           Pixels in Y-Richtung (s.o.) 
                - <Xcm>         :  (REAL)  Breite der ZeichenflÑche in cm. 
                - <Ycm>         :  (REAL)  Hîhe der ZeiuchenflÑche in cm. 
                (Mîglichst genau ausmessen od. berechnen, um Verzerrungen zu
                vermeiden) 
                'PLOTTER' mu· als erstes in der Konfigurationsdatei stehen! 
 
      #ib(1)#2.0 Pseudo-Prozeduren#ie(1)# 
 
         2.1 PROC #ib(2," (2.1)")#background#ie(2," (PROC)")# 
              Syntax: PROC background (INT VAR type): 
              - Stellt die Hintergrundfarbe 'type' ein. Ist bei monochromen End-
                gerÑten mit leerer Leistung zu implementieren.In 'type' ist die
                tatsÑchlich eingestellte Hintergrundfarbe angegeben, womit die
                erbrachte Leistung kontrolliert werden kann. 
 
         2.2 PROC #ib(2," (2.2)")#box#ie(2," (PROC)")# 
              Syntax: PROC box (INT CONST x1, y1, x2, y2, pattern): 
              - Zeichnet ein Rechteck mit den gegenÅberliegenden Ecken
                'x1;y1/x2;y2'. Sollte das EndgerÑt diese Leistung nicht erbringen,
                so mu· 'std box' aus 'std.GCONF' mit gleichen Parametern aufge-
                rufen werden. 
                'pattern' als FÅllmuster kann endgerÑtspezifisch implementiert
                werden, wobei von System nur 'pattern' = 0 verwendet wird, was ein
                ungefÅlltes Rechteck anfordert. 
 
         2.3 PROC #ib(2," (2.3)")#circle#ie(2," (PROC)")# 
              Syntax: PROC circle (INT CONST x, y, rad, from, to): 
              - Zeichnet einen Kreis oder ein Kreissegment an den Raster-
                Koordinaten 'x;y', die auch neue Zeichenposition werden. 'rad' gibt
                den Radius und 'from,to' den Start bzw. Endwinkel im mathematisch
                positivem Sinne an. 
                Sollte das EndgerÑt diese Leistung nicht erbringen, so mu· 'std
                circle' aus 'std.GCONF' mit gleichen Parametern aufgerufen werden. 
 
         2.4 PROC #ib(2," (2.4)")#clear#ie(2," (PROC)")# 
              Syntax: PROC clear: 
              - Lîscht den Bildschirm bzw. initialisiert das Ausgabe-Raster. 
                Die Zeichenposition wird '0;0' und die Standardfarben werden
                eingestellt. 
 
         2.5 PROC #ib(2," (2.5)")#drawto#ie(2," (PROC)")# 
              Syntax: PROC drawto (INT CONST x, y): 
              - Zieht von der aktuellen Zeichenposition eine Gerade zu den Ko-
                ordinaten 'x;y', die Zeichenposition wird entsprechend geÑndert. 
 
         2.6 PROC #ib(2," (2.6)")#endplot#ie(2," (PROC)")# 
              Syntax: PROC endplot: 
              - Schlie·t die Graphik-Ausgabe auf einem EndgerÑt ab; evtl. Wechsel
                in den Text-Modus, ggf. Cursor einschalten. 
                Bei Terminals sollte der Bildschirm nicht gelîscht werden. 
 
         2.7 PROC #ib(2," (2.7)")#fill#ie(2," (PROC)")# 
              Syntax: PROC fill (INT CONST x, y, pattern): 
              - ZusÑtzliche vom System nicht verwendete Leistung zum FÅllen von
                Polygonen (rundum geschlossen), wobei die genau erbrachte Lei-
                stung und die Bedingungen endgerÑtspezifisch sind. 
 
         2.8 PROC #ib(2," (2.8)")#foreground#ie(2," (PROC)")# 
              Syntax: PROC foreground (INT VAR type): 
              - Stellt die Vordergrundfarbe 'type' ein. Ist bei monochromen
                EndgerÑten mit leerer Leistung zu implementieren.In 'type' ist die
                tatsÑchlich eingestellte Hintergrundfarbe angegeben, womit die
                erbrachte Leistung kontrolliert werden kann. 
 
         2.9 PROC #ib(2," (2.9)")#get cursor#ie(2," (PROC)")# 
              Syntax: PROC get cursor (INT VAR x, y, TEXT VAR exit char): 
              - Wartet auf eine Eingabe vom EndgerÑt, wobei der Cursor beweglich
                bleiben mu·. Wird eine Taste gedrÅckt, so wird deren Code in 'exit
                char' und die aktuelle Position des Cursors in 'x;y' eingetragen. 
                Der Cursor sollte nur innerhalb dieser Prozedur beweglich sein,
                aber immer sichtbar bleiben (falls er eingeschaltet ist). 
 
         2.10 PROC #ib(2," (2.10)")#graphik cursor#ie(2," (PROC)")# 
              Syntax: PROC graphik cursor (INT CONST x, y, BOOL CONST on): 
              - Schaltet einen endgerÑtseitig vorhandenen graphischen Cursor
                (i.d.R Fadenkreuz) ein oder aus bzw. setzt ihn auf eine bestimmte
                Position. 
                Mit 'on' = TRUE wird der Cursor dauerhaft! eingeschaltet bzw. neu
                positioniert, falls er bereits eingeschaltet war. 
                Mit 'on' = FALSE wird er grundsÑtzlich abgeschaltet. 
                Durch Einschalten des Cursors wird die Wirkung von 'home'
                verÑndert: 
                           normal - 'home' positioniert die Zeichenposition auf
                                     '0;0' 
                           cursor - 'home' positioniert die Zeichenposition und
                                    den graphischen Cursor auf die Mitte der
                                    ZeichenflÑche. 
 
         2.11 PROC #ib(2," (2.11)")#home#ie(2," (PROC)")# 
              Syntax: PROC home: 
              - Die Zeichenposition wird auf '0;0' eingestellt; ist ein graphischer
                Cursor eingeschaltet, so sollte dieser, sowie die Zeichenposition,
                jedoch auf den Mittelpunkt der ZeichenflÑche gesetzt werden. 
 
         2.12 PROC #ib(2," (2.12)")#initplot#ie(2," (PROC)")# 
              Syntax: PROC initplot: 
              - Bereitet die Graphik-Ausgabe auf einem EndgerÑt vor; evtl.
                Wechsel in den Graphik-Modus, ggf. Cursor abschalten. 
                Bei Terminals sollte der Bildschirm nicht gelîscht werden. 
 
         2.13 PROC #ib(2," (2.13)")#moveto#ie(2," (PROC)")# 
              Syntax: PROC moveto (INT CONST x, y): 
              - Die Zeichenposition wird auf die Koordinaten 'x;y' gesetzt, bei
                öberschreitung der ZeichenflÑche ist die Wirkung undefiniert. 
 
         2.14 PROC #ib(2," (2.14)")#prepare#ie(2," (PROC)")# 
              Syntax: PROC prepare: 
              - Bereitet die Ausgabe auf einem Kanal vor. 
                Die eigene Task sollte an den Kanal angekoppelt, und andere Tasks
                ggf. am Ankoppeln gehindert bzw. abgekoppelt werden (z.B. der
                PRINTER-Server bei Drucker-Graphik). Es darf erst nach erfolg-
                reichem Abschlu· der Aktion zurÅckgekehrt werden. 
 
         2.15 PROC #ib(2," (2.15)")#set marker#ie(2," (PROC)")# 
              Syntax: PROC set marker (INT CONST x, y, type): 
              - Zeichnet an der Position 'x;y', die auch neue Zeichenposition wird,
                eine Markierung. Folgende Markierungsarten kînnen systemseitig
                verwendet werden: 
                                 0 - Kreuz '+' 
                                 1 - Kreuz diagonal 'x' 
                Weitere Typen kînnen endgerÑtspezifisch implementiert werden. 
 
         2.16 PROC #ib(2," (2.16)")#setpalette#ie(2," (PROC)")# 
              Syntax: PROC setpalette: 
              - Stellt die aktuell eingestellten RGB-Kombinationen auf dem End-
                gerÑt ein. Dazu sind die vom Konfigurationsprogramm
                hinzugefÅgten Prozeduren 'colors' und 'color' zu verwenden: 
                   INT PROC colors 
                   - Liefert die Anzahl der fÅr das EndgerÑt mîglichen Farben
                     (abgeleitet aus den mit 'COLOR' angebenen
                     Standard-Kombinationen). 
                   INT PROC color (INT CONST no) 
                   - Liefert die normierte RGB-Kombination der fÅr 'no' ein-
                     gestellten Farbe (0 - 999). Die RÅckgabe von 'maxint' (32767)
                     bedeutet: Farbe nicht initialisiert oder existiert nicht. 
 
         2.17 PROC #ib(2," (2.17)")#setpixel#ie(2," (PROC)")# 
              Syntax: PROC setpixel (INT CONST x, y): 
              - Setzt ein Pixel an den Raster-Koordinaten 'x;y'. 
#page# 
#bottom#
#right#Seite %
#end#
#head#
#type("prop")##center#Dokumentation des MPG-Graphik-Systems
#type("8.5.klein")##center#Teil 4: Graphik-Applikationen
#type("pica.lq")##free(1.0)#
#end#
#type("pica")##on("u")##ib(1)#Teil 4: Graphik-Applikationen#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
 
 
#type("pica")##on("u")##ib(1)#Teil 4.1: Der Funktionenplotter 'FKT'#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
 
      Mit diesem Programmpaket kann man fÅr beliebige reelle und reellwertige
      Funktionen Graphen erstellen. Diese Graphen werden im System gespeichert. 
 
      Zur Ausgabe der erstellten Graphen stehen alle graphikfÑhigen EndgerÑte
      zur VerfÅgung. 
 
      #ib(1)#1.0 Allgemeines Åber FKT#ie(1)# 
           Zu einer Zeichnung, wie sie mit 'FKT' erstellt werden kann, gehîren
           folgende Eigenschaften: 
              - Der Name der Zeichnung (zum Wiederfinden) 
              - Das Format 
              - Der Graph mit den Achsen bzw. dem Rahmen. 
 
           Es kînnen beliebig viele Zeichnungen angelegt und aufbewahrt werden,
           wobei der Name aller Zeichnungen mit "PICFILE." beginnt. 
 
           Es wird von FKT zwischen den Definitions- und Wertebereich einerseits
           und dem Format anderseits unterschieden: 
              - Der Definitionsbereich wird vom Benutzer gewÑhlt. Er gibt das
                Intervall an, Åber dem der Graph gezeichnet wird. Der
                Wertebereich wird vom Rechner automatisch ermittelt. 
              - Das Format besteht aus der Angabe von vier Werten, die Auskunft
                geben Åber die maximale Ausdehnung der Koordinatenachsen, wobei
                die Zeichnung auf den EndgerÑten stets so abgebildet wird, da· sie
                unverzerrt in maximaler Grî·e (also im grî·tmîglichen Quadrat)
                gezeichnet wird. 
 
           Der Funktionenplotter FKT ist in allen Sohntasks von 'GRAPHIK' verfÅg-
           bar, zusÑtzlich existiert die Task 'FKT', in der das FKT-Menue als
           Kommandoebene verwendet wird. 
 
      #ib(1)#2.0 Das FKT-Menue#ie(1)# 
           Das Menue des Funktionenplotters ist wie folgt aufgebaut: 
           - in der obersten Zeile wird der eingegebene Funktionsterm angezeigt 
           - die nachfolgende Zeile zeigt in eckigen Klammern den Definitions-
             bereich und die Schachtelung des Intervalles, Åber dem der Graph
             gezeichnet wird. 
           - dann folgt ebenfalls in eckigen Klammern der von FKT selbst zu
             ermittelnde Wertebereich der Funktion innerhalb des zuvor
             definierten Intervalles. 
           Wird kein Funktionsterm angezeigt, oder erscheinen in den eckigen
           Klammern Sternchen, so wurde noch kein Funktionsterm bzw.
           Definitionsbereich eingegeben, oder der Wertebereich noch nicht
           ermittelt. 
           - Der Bereich zwischen o.g Anzeige und der Auflistung der Menuepunkte
             ist der Dialogbereich, in dem weitere Anfragen an den Benutzer oder
             auch Fehlermeldungen erscheinen. 
           - Unterhalb der Bildschirmmitte werden die unten beschriebenen
             Menuepunkte zur Auswahl aufgefÅhrt. 
           - Dann folgt der EndgerÑt-Auswahlbereich, das EndgerÑt, auf dem eine
             Zeichnung ausgegeben werden soll, kann mit den Tasten 'Links' bzw.
             'Rechts' eingestellt werden, wobei der Name des aktuell eingestellten
             EndgerÑtes invertiert erscheint. 
           - Als unterste Zeile der FKT-Tapete folgt der Eingabebereich, hier wird
             der Benutzer zur Eingabe eines bei den Menuepunkten genannten
             Buchstabens aufgefordert, und dieser bei einem zulÑssigen
             Tastendruck dort angezeigt. 
 
      #ib(1)#3.0 FKT-Menuepunkte#ie(1)# 
 
         Jede Eingabe oder Operation kann durch DrÅcken der Taste 'ESC'
         abgebrochen werden, die Eingabe wird dann ignoriert, und im Dialog-
         bereich erscheint die Fehlermeldung 'F E H L E R : Abgebrochen'. 
 
         3.1 #ib(2," (3.1)")#(f) Funktionsterm eingeben#ie(2,"")# 
             Im Dialogbereich wird die Eingabe des Funktionsterms erwartet, wobei
             als Variable im Term 'x' verwendet werden mu·. 
             Es stehen alle mathematischen Funktionen des EUMEL-Systems zur
             VerfÅgung, sofern sie reelle Werte (REAL) zurÅckliefern. 
             Beispiele von Funktionstermen (alternative Mîglichkeiten in eckigen,
             ErklÑrungen in runden Klammern): 
 
               2*x 
               [2x] 
               2x*x + 3x - 5 
               [2.0*x*x + 3.0*x - 5.0] 
               0.7 * sqrt (x)                   (sqrt  : Quadratwurzel aus) 
               log10 (x)                        (log10 : 10-er Logar.) 
               ln (3x)                          (ln    : Nat. Logar.) 
               2**x                             (**    : Potenzieren) 
               exp (1/x) 
               [e**(1/x)]                       (exp   : Expon.Fktn) 
               arctan (pi*x)                    (arctan: arkus tangens ) 
               sin (x)                          (sin   : Sinus in Radiant ) 
               sind (x)                         (sind  : Sinus in Altgrad ) 
               1/(x*x+1) 
 
            Die Klammern dÅrfen dabei NICHT weggelassen werden, es sind nur
            runde Klammern zulÑssig, auch geschachtelt, wie z.B. in: 
 
               log10 (abs (sin (x) + 5))        (abs   : Absolutbetrag ) 
 
            Ein Dezimalkomma gibt es nicht, sondern nur den Dezimalpunkt. 
 
            Beispiele von abschnittsweise definierten Funktionen: 
 
               IF x < 5 THEN x*x ELSE sqrt (x - 5) END IF 
               IF x = 0 THEN 0 ELSE 1/x END IF 
               IF x < 0 THEN x ELIF x = 0 THEN 1 ELSE x*x END IF 
 
            Die sog. SchlÅsselworte "IF" "THEN" "ELIF" "ELSE" "END IF" mÅssen
            dabei immer in der angegebenen Form (alle, in der angegebenen Reihen-
            folge, vollstÑndig aus Gro·buchstaben) auftauchen. 
 
               IF --+--> THEN --+--> ELSE --> END IF 
                    |           | 
                    |           | 
                    +--- ELIF --+ 
 
 
            Es kînnen bei IF auch mehrere Bedingungen mit logischem OR oder AND
            verknÅpft werden: 
 
               IF x <= 0  OR  x > 100 THEN 0 ELSE x*x END IF 
 
            Hat die Funktion eine DefinitionslÅcke an einer bereits bekannten
            Stelle, so kann dies im Term auf folgende Art berÅcksichtigt werden,
            z.B.: 
 
               IF x = 0 THEN luecke ELSE 1/x END IF 
               IF x < -0.05 THEN -1/x ELIF x > 0.05 THEN 1/x ELSE luecke END IF 
 
            Taucht eine unvorhergesehene DefinitionslÅcke auf, so wird beim
            Erstellen des Wertebereichs eine entspr. Fehlermeldung ausgegeben.
            Dann mu· entweder der Funktionsterm durch Fallunterscheidung (s.o.)
            angepa·t, oder der Definitionsbereich geÑndert werden. 
 
            Graphen mit DefinitionslÅcken kînnen auch in zwei oder mehr Teilen
            erstellt werden, nÑmlich jeweils Åber den zusammenhÑngenden
            Definitionsintervallen, die keine LÅcke enthalten. Dazu mu· jeweils
            die Zeichnung ergÑnzt (siehe '(z) Zeichnung anfertigen') werden. 
 
    Fehlerquelle: Der Funktionsterm ist fehlerhaft. 
                  Es tauchen z.B. dem Rechner unbekannte Operationen auf,
                  Multiplikationszeichen fehlen, andere Symbole als 'x' wurden
                  fÅr die Variable benutzt, 'END IF' fehlt o.Ñ. 
 
         3.2 #ib(2," (3.2)")#(d) Definitionsbereich waehlen#ie(2,"")# 
            Im Dialogbereich wird die Eingabe von Unter- und Obergrenze erwartet,
            wobei Untergrenze < Obergrenze gilt, ansonsten wird die Eingabe der
            Obergrenze nochmals gefordert. 
            Erscheinen in der zug. Informationszeile Sterne, so ist die gewÑhlte
            Genauigkeit zu gro· und sollte umgewÑhlt werden. 
 
            Fehlerquelle: Der Funktionsterm ist noch nicht vorhanden. 
 
         3.3 #ib(2," (3.3)")#(w) Wertebereich ermitteln lassen#ie(2,"")# 
             Es werden automatisch der grî·te und kleinste Funktionswert
             ermittelt, also die tatsÑchlichen Grenzen des Wertebereichs. 
             Erscheinen in der zug. Informationszeile Sterne, so ist die gewÑhlte
             Genauigkeit zu gro· und sollte umgewÑhlt werden. 
 
         3.4 #ib(2," (3.4)")#(z) Zeichnung anfertigen#ie(2,"")# 
             Eine Zeichnung kann auf allen zur VerfÅgung stehenden GerÑten
             ausgegeben werden, wenn sie erzeugt ist. 
             Mit diesem Menuepunkt werden die Zeichnungen nur erstellt, d.h. der
             Graph erscheint noch nicht auf einem AusgabegerÑt. 
             Diese Zeichnungen werden dann im System aufbewahrt und kînnen
             somit mehrfach ausgegeben werden. 
 
             Im Dialogbereich wird zunÑchst der Name der Zeichnung angefordert,
             dieser beginnt grundsÑtzlich mit dem Prefix 'PICFILE.', das nicht
             verÑndert werden kann. 
             Dabei wird als ErgÑnzung des Namens der Funktionsterm angeboten, so
             da· die Zeichnung z.B. 'PICFILE.sin(x)' hei·t. 
             Dieser Teil des Namens kann aber frei verÑndert werden. 
             Existiert bereits eine Zeichnung gleichen Namens, so erscheint im
             Dialogbereich eine Anfrage, wie verfahren werden soll, wobei
             folgende Mîglichkeiten genannt werden: 
 
             - <l> :  Die alte Zeichnung wird gelîscht. 
             - <n> :  Der Name wird erneut zur énderung angeboten. 
             - <e> :  Die neue Zeichnung, welche hiernach erstellt wird, wird an die
                      schon existierende Zeichnung angahÑngt. Dies ist vorteil-
                      haft, wenn mehrere od. abschnittsweise definierte Graphen
                      auf in eine Zeichnung kommen sollen. 
             Die Eingabe anderer Buchstaben wird ignoriert. 
 
             Ansonsten wird eine Zeichnung erstellt, die unter dem eingegebenen
             Namen abgelegt wird. 
 
             Danach wird im Dialogbereich erfragt, ob und wie das Format der
             Zeichnung geÑndert werden soll. 
             Nachdem die Zeichnung erstellt wurde, was durch den
             StÅtzpunkt-ZÑhler angezeigt wird, mu· noch die Farbe, in der der
             Graph gezeichnet werden soll eingegeben werden. 
 
             Fehlerquelle: Wertebereich ist noch nicht bestimmt (siehe 4). 
                           UnzulÑessiges Format:  ymax ist kleiner oder gleich
                                                  ymin, bzw. xmax ist kleiner
                                                  oder gleich xmin. 
 
         3.5 #ib(2," (3.5)")#(a) Ausgabe der Zeichnung auf EndgerÑt#ie(2,"")# 
             Im Dialogbereich wird der Name der auszugebenden Zeichnung erfragt,
             wobei die zuletzt bearbeitete Zeichnung angeboten wird. 
             Die Wahl von '?' als Namen der Zeichnung ('PICFILE.?') fÅhrt zu einer
             Auswahl aller vorhanden Bilder, von denen eines zur Ausgabe
             ausgewÑhlt werden kann. 
             Danach kann wie oben nochmals das Format variiert werden. 
             Dann wird im Dialogbereich die öberschrift der Zeichnung erfragt,
             wobei der Funktionsterm angeboten wird. Die öberschrift erscheint
             zentriert am oberen Rand. 
             Je nach Lage des Ursprungs (innerhalb od. au·erhalb der Zeichnung)
             kann die Ausgabe mit Koordinatensystem od. mit Rahmen gewÑhlt
             werden, liegt der Ursprung nicht innerhalb der Zeichnung, so wird
             grundsÑtzlich der Rahmen verwendet. 
             Zum Abschlu· wird dann die Farbgebung von Koordinatensystem bzw.
             Rahmen sowie der öberschrift erfragt, dann wird die Zeichnung auf
             dem im unteren Teil eingestelltem EndgerÑt ausgegeben. 
 
         3.6 #ib(2," (3.6)")#(t) Wertetafel erstellen lassen#ie(2,"")# 
             In dem gewÑhlten Definitionsbereich kann eine Wertetafel erstellt
             werden, die in einer von Ihnen gewÅnschten Schrittweite ermittelte
             Funktionswerte zeigt. 
             ZunÑchst wird die Schrittweite erfragt, dann die von FKT formatiert
             erstellte Wertetafel gezeigt. 
             Diese befindet sich in einer Datei, die den Namen des zugehîrigen
             Funktionsterms trÑgt, existiert diese bereits, so wird die Wertetafel
             ergÑnzt. 
             EnthÑlt diese Tafel Sterne, so mÅssen Sie die Genauigkeit umwÑhlen
             und die Tafel neu erstellen lassen. 
             Nach Verlassen der Anzeige wird noch gefragt, ob die Wertetafel
             gedruckt, und ob sie aufbewahrt werden soll. 
 
             Fehlerquelle: Definitionsbereich bzw. Funktionsterm ist noch nicht
                           gewÑhlt. 
                           Die Schrittweite wurde zu klein gewÑhlt. Sie mu· so
                           gro· sein, da· nicht mehr als 512 Werte zu berechnen
                           sind. 
 
         3.7 #ib(2," (3.7)")#(l) Zeichnungen auflisten#ie(2,"")# 
             Es wird eine Namesliste aller vorhandenen Zeichnungen gezeigt. 
 
         3.8 #ib(2," (3.8)")#(?) Hilfestellung#ie(2,"")# 
             Es wird eine Kurzanleitung gezeigt. 
 
         3.9 #ib(2," (3.9)")#(q) in die Kommandoebene zurÅck#ie(2,"")# 
             Die Arbeit mit dem Funktionsplotter wird beendet, in normalen Tasks
             erscheint die Ebene, aus der 'FKT' mit 'fktplot' aufgerufen wurde. 
             Wird die Task 'FKT' mit 'q' verlassen, so wird dagegen die Task
             abgekoppelt und alle in ihr enthaltenen Zeichnungen gelîscht! 
 
         3.10 #ib(2," (3.10)")#(s) Anzahl der StÅtzpunkte waehlen#ie(2,"")# 
             Bei der Ermittlung des Wertebereiches und beim Erstellen des Funk-
             tionsgraphen ist es wegen der Endlichkeit des Computers nicht mîg-
             lich, alle Punkte des Definitionsbereiches zu benutzen. Deshalb wird
             der Definitionsbereich diskretisiert, d.h. es wird eine endliche An-
             zahl von StÅtzpunkten ausgesucht. Diese StÅtzpunkte liegen gleich-
             verteilt Åber dem Definitionsbereich. Die Mindestanzahl ist 2, d.h. als
             StÅtzpunkte werden nur die beiden Randwerte zugelassen. Aus
             technischen GrÅnden ist die Hîchstgrenze 512. 
 
             Fehlerquelle: Zahl der StÅtzpunkte ist fehlerhaft. 
                           Nur ganze Zahlen aus dem Intervall [2;512] zulÑssig. 
 
         3.11 #ib(2," (3.11)")#(n) Nachkommastellenzahl wÑhlen#ie(2,"")# 
             Hier kann die Zahl der angezeigten Nachkommastellen eingestellt
             werden (intern wird immer hîchstmîgliche Genauigkeit verwendet). 
             Maximal sind neun Nachkommastellen zulÑssigt, jedoch kann die
             Genauigkeit zu gro· fÅr das Anzeigeformat werden; dann erscheinen
             in der Anzeige Sterne (*************). 
             Es gilt grundsÑtzlich: 
                  Anzahl Vorkommastellen + Anz. Nachkommastellen = 12. 
 
         3.12 #ib(2," (3.12)")#(e) Arbeit beenden#ie(2,"")# 
             Die Arbeit mit 'FKT' wird abgeschlossen, die Task vom Terminal
             abgekoppelt. FÅr jede Task bleibt dabei FKT das laufende Programm,
             d.h. nach erneutem Ankoppeln erscheint wieder die FKT-Tapete. In der
             Task FKT bleiben die Zeichnungen bei Verlassen mit 'e' erhalten (im
             Gegensatz zum Verlassen mit 'q'). 
 
         3.13 #ib(2," (3.13)")#(L) Zeichnungen loeschen#ie(2,"")# 
             Es erscheint eine Namensliste aller in der Task enthaltenen
             Zeichnungen. Die dann ausgewÑhlten Zeichnungen werden nach noch-
             maliger RÅckfrage gelîscht. 
 
         3.14 #ib(2," (3.14)")#(A) Zeichnungen archivieren#ie(2,"")# 
             Nach Aufruf dieses Menuepunktes kînnen Zeichnungen zu anderen
             Tasks geschickt, oder auch auf Diskette geschrieben werden. 
             Dazu wird der MPG-Dateimanager 'dm' verwendet. 
 
         3.15 #ib(2," (3.15)")#(b) Zeichnungen beschriften#ie(2,"")# 
             Mit diesem Menuepunkt kînnen Zeichnungen frei beschriftet werden. 
             ZunÑchst wird im Dialogbereich erfragt, wie mit bereits bestehenden
             Beschriftungen verfahren werden soll: 
 
             - <e> :  Die nachfolgenden Texte werden zusÑtzlich zu den schon
                      vorhandenen Beschriftungen angefÅgt. 
             - <l> :  Die vorhandenen Beschriftungen werden gelîscht, und es wird
                      zum Menue zurÅckgekehrt. 
             - <a> :  Die Operation wird abgebrochen. 
 
            Nun wird die Farbgebung aller Beschriftungen erfragt, 
            danach wird das aktuelle Format der Zeichnung gezeigt, was bei der
            Positionierung hilfreich sein kann. 
            Nach der nun geforderten Eingabe des Beschriftungstextes wird die
            Positionierung der Beschriftung in zwei Weisen angeboten: 
            - in cm  :  Die nachfolgend einzugebenden Werte werden als
                        cm-Angabe relativ zur unteren linken Ecke der Zeichnung
                        aufgefa·t. 
            - in REAL:  Die nachfolgend einzugebenden Werte werden als
                        Koordinatenangabe im Koordinatensystem der erstellten
                        Zeichnung aufgefa·t ('0;0' demnach im Ursprung) Nach
            Eingabe o.g. Werte wird noch die Texthîhe und Breite erfragt, wobei die
            eingegebenen Werte als mm-Angaben aufgefÑ·t werden (Standard: 5 * 5
            mm). 
            Anschlie·end wird erfragt, ob noch weitere Beschriftungen
            vorgenommen werden sollen. 
 
            Fehlerquelle: Zeichnung existiert nicht. 
#page# 
 
#type("pica")##on("u")##ib(1)#Teil 4.2: Die TURTLE-Graphik#ie(1)##off("u")##type("prop.lq")#
#free(0.5)#
 
      Die TURTLE-Graphik bietet die Mîglichkeit, sehr einfach zweidimensionale
      Zeichnungen zu erstellen. Sie basiert auf dem in LOGO verwendeten Modell, in
      dem eine Zeichenposition in jeweils eine bestimmte Richtung vorwÑrts bzw.
      rÅckwÑrts bewegt werden kann, und die Zeichenrichtung verÑndert werden
      kann.Bei den Bewegungen, die vornehmlich relativ zur alten Position bzw.
      Zeichenrichtung ausgefÅhrt werden, kann dann eine Linie hinterlassen
      werden. Diese Art der Graphik eignet sich insbesondere fÅr Programm-
      gesteuerte Zeichnungen, wie z.B. die rekursiven 'Sierpinski' - bzw. 'Hilbert'-
      "Funktionen". 
 
     Die Koordinaten bewegen sich im Intervall von [-500.0,500.0]. 
     (0,0) liegt dabei in der Bildschirmmitte und ist auch die Anfangsposition.
     Der Anfangswinkel ist 0. Winkel werden in Grad angegeben. 
 
     #ib(1)#1.0 Paket: 'turtlegraphics'#ie(1)# 
 
         1.1 REAL PROC #ib(2," (1.1)")#angle#ie(2," (PROC)")# 
              - liefert den momentanen Winkel zwischen Zeichenrichtung und
                X-Achse. 
 
         1.2 PROC #ib(2," (1.2)")#turnto#ie(2," (PROC)")# 
              (REAL CONST w) 
              - Die Zeichenrichtung wird absolut auf den Winkel 'w' als Winkel
                zwischen Zeichenrichtung und X-Achse eingestellt. 
 
         1.3 PROC #ib(2," (1.3)")#forward#ie(2," (PROC)")# 
              (REAL CONST s) 
              - Die Zeichenposition wird in Zeichenrichtung um die Strecke 's'
                verschoben, wobei ggf. gezeichnet wird. 
 
         1.4 PROC #ib(2," (1.4)")#penup#ie(2," (PROC)")# 
              - Der Zeichenstift wird abgehoben, Bewegungen erzeugen keine
                Linien mehr. 
 
         1.5 PROC #ib(2," (1.5)")#forward to#ie(2," (PROC)")# 
              (REAL CONST x,y) 
              - Die Zeichenposition wird absolut auf die Position 'x;y' gesetzt, die
                Zeichenrichtung wird nicht verÑndert. 
 
         1.6 PROC #ib(2," (1.6)")#endturtle#ie(2," (PROC)")# 
              - Wurde die Graphik im Direktmodus ('begin turtle' ohne Parameter),
                also auch sofort sichtbar erzeugt, so wird die Graphikausgabe in
                Åblicher Weise beendet, sonst nunmehr das erzeugte PICFILE
                ausgegeben. 
 
         1.7 PROC #ib(2," (1.7)")#pendown#ie(2," (PROC)")# 
              - Der Zeichenstift wird gesenkt, Bewegungen erzeugen Linien. 
 
         1.8 PROC #ib(2," (1.8)")#beginturtle#ie(2," (PROC)")# 
              (TEXT CONST picfile name) 
              - îffnet ein PICFILE 'picfile name', in das alle Aktionen eingetragen
                werden. Auf dem Bildschirm geschieht nichts. Ist das Picfile schon
                vorhanden, werden die Aktionen hinzugefÅgt. 
 
         1.9 PROC #ib(2," (1.9)")#beginturtle#ie(2," (PROC)")# 
              - Leitet die direkte graphische Ausgabe einer TURTLE-Graphik ein,
                alle Aktionen werden sofort auf dem Bildschirm sichtbar. 
 
         1.10 PROC #ib(2," (1.10)")#turn#ie(2," (PROC)")# 
              (REAL CONST w) 
              - Dreht die Zeichenposition um 'w'-Grad im mathematisch positiven
                Sinne. 
 
         1.11 BOOL PROC #ib(2," (1.11)")#pen#ie(2," (PROC)")# 
              - Liefert zurÅck, ob der Zeichenstift oben (FALSE) oder unten (TRUE)
                ist, also ob Bewegungen Linien hervorrufen oder nicht. 
 
         1.12 PROC #ib(2," (1.12)")#getturtle#ie(2," (PROC)")# 
              - In die Åbergebenen Variablen wird die aktuelle Zeichenposition
                absolut eingetragen. 
#page# 
      Diese Dokumentation und die einzelnen Programme wurden mit grî·tmîglicher
      Sorgfalt erstellt bzw. weiterentwickelt. 
      Dennoch kann keine Fehlerfreiheit garantiert oder die Haftung fÅr evtl. aus
      Fehlern resultierende Folgen Åbernommen werden. 
      FÅr Hinweise auf Fehler sind die Autoren stets dankbar. 
#page# 
#bottom off#
#head#
#type("prop")##center#Dokumentation des MPG-Graphik-Systems
#type("8.5.klein")##center#Stichwortverzeichnis
#type("pica.lq")##free(1.0)#
#end#
#type("pica")##on("u")##ib(1)#Stichwortverzeichnis#ie(1)##off("u")##type("prop.lq")# 
#free(0.5)#
(a) Ausgabe der Zeichnung auf EndgerÑt ...........  41 (3.5) 
actual plotter (PROC) ............................  17 (4.4) 
ALL (OP) .........................................  27 (3.1) 
angle (PROC) .....................................  44 (1.1) 
(A) Zeichnungen archivieren ......................  42 (3.14) 
background * (PROC) ..............................  13 (3.4), 13 (3.5), 19 (1.1),
                                                    19 (1.2), 34 (2.1) 
bar * (PROC) .....................................  8 (2.3), 23 (2.1), 23 (2.2) 
beginplot (PROC) .................................  23 (2.3) 
beginturtle (PROC) ...............................  45 (1.9), 45 (1.8) 
box (PROC) .......................................  19 (1.3), 23 (2.4), 34 (2.2) 
(b) Zeichnungen beschriften ......................  42 (3.15) 
CAT * (OP) .......................................  8 (2.4) 
channel (PROC) ...................................  17 (4.5) 
circle (PROC) ....................................  8 (2.5), 19 (1.4), 24 (2.5),
                                                    34 (2.3) 
clear (PROC) .....................................  19 (1.5), 19 (1.6), 34 (2.4) 
clearspool .......................................  3 (2.2) 
clippedline (PROC) ...............................  5 (1.1) 
color (PROC) .....................................  19 (1.7) 
COLORS ...........................................  32 (1.1) 
colors (PROC) ....................................  20 (1.8) 
(d) Definitionsbereich waehlen ...................  39 (3.2) 
delete picture * (PROC) ..........................  13 (3.6) 
dim * (PROC) .....................................  8 (2.6) 
down * (PROC) ....................................  13 (3.7), 13 (3.8) 
draw cm * (PROC) .................................  9 (2.11), 24 (2.12) 
draw cm r * (PROC) ...............................  9 (2.12), 24 (2.13) 
drawingarea * (PROC) .............................  5 (1.2), 17 (4.6), 17 (4.7) 
draw * (PROC) ....................................  8 (2.8), 8 (2.7), 9 (2.10),
                                                    9 (2.9), 24 (2.6), 24 (2.9),
                                                    24 (2.8), 24 (2.7), 24 (2.11),
                                                    24 (2.10) 
draw r * (PROC) ..................................  9 (2.13), 9 (2.14), 24 (2.14),
                                                    25 (2.15) 
drawto (PROC) ....................................  20 (1.9), 34 (2.5) 
(e) Arbeit beenden ...............................  42 (3.12) 
EDITOR ...........................................  33 (1.2) 
end plot (PROC) ..................................  20 (1.10), 20 (1.11), 34 (2.6) 
endturtle (PROC) .................................  44 (1.6) 
eof * (PROC) .....................................  13 (3.9) 
erase (PROC) .....................................  27 (3.3), 27 (3.2) 
exists (PROC) ....................................  27 (3.4) 
extrema * (PROC) .................................  9 (2.16), 9 (2.15), 13 (3.11),
                                                    13 (3.10) 
(f) Funktionsterm eingeben .......................  38 (3.1) 
fill (PROC) ......................................  20 (1.12), 34 (2.7) 
first ............................................  4 (2.9) 
first (PROC) .....................................  27 (3.5) 
foreground (PROC) ................................  20 (1.14), 20 (1.13), 35 (2.8) 
forward (PROC) ...................................  44 (1.3) 
forward to (PROC) ................................  44 (1.5) 
generate plotmanager (PROC) ......................  27 (3.6) 
get cursor (PROC) ................................  20 (1.15), 35 (2.9) 
get * (PROC) .....................................  14 (3.12) 
getturtle (PROC) .................................  45 (1.12) 
getvalues (PROC) .................................  5 (1.3), 14 (3.13) 
graphik cursor (PROC) ............................  20 (1.16), 21 (1.17), 35 (2.10) 
halt .............................................  4 (2.6) 
halt (PROC) ......................................  27 (3.7) 
hidden lines * (PROC) ............................  25 (2.16) 
(?) Hilfestellung ................................  41 (3.8) 
home (PROC) ......................................  21 (1.18), 35 (2.11) 
INCLUDE ..........................................  33 (1.3) 
init plot (PROC) .................................  21 (1.19), 35 (2.12) 
insert picture * (PROC) ..........................  14 (3.14) 
install plotter (PROC) ...........................  17 (4.8) 
is first picture * (PROC) ........................  14 (3.15) 
killer ...........................................  4 (2.8) 
length * (PROC) ..................................  9 (2.17) 
linetype (PROC) ..................................  25 (2.17) 
LINK .............................................  33 (1.4) 
list (PROC) ......................................  27 (3.8), 28 (3.9) 
listspool ........................................  3 (2.1) 
(l) Zeichnungen auflisten ........................  41 (3.7) 
(L) Zeichnungen loeschen .........................  42 (3.13) 
move cm (PROC) ...................................  10 (2.20), 25 (2.21) 
move cm r * (PROC) ...............................  10 (2.21), 25 (2.22) 
move * (PROC) ....................................  9 (2.19), 9 (2.18), 25 (2.18),
                                                    25 (2.19), 25 (2.20) 
move r * (PROC) ..................................  10 (2.23), 10 (2.22),
                                                    25 (2.23), 25 (2.24) 
move to (PROC) ...................................  21 (1.20), 35 (2.13) 
name (PROC) ......................................  17 (4.9) 
newvalues (PROC) .................................  5 (1.4) 
nilpicture * (PROC) ..............................  10 (2.24) 
(n) Nachkommastellenzahl wÑhlen ..................  42 (3.11) 
no plotter (PROC) ................................  17 (4.10) 
oblique * (PROC) .................................  5 (1.5), 14 (3.16) 
:= (OP) ..........................................  8 (2.2), 13 (3.2), 13 (3.3),
                                                    17 (4.3), 17 (4.2) 
orthographic * (PROC) ............................  5 (1.6) 
PACKET basisplot .................................  1 (3.1) 
PACKET deviceinterface ...........................  1 (2.1) 
PACKET devices ...................................  1 (1.4) 
PACKET picfile ...................................  1 (1.3) 
PACKET picture ...................................  1 (1.2) 
PACKET plot ......................................  1 (3.3) 
PACKET plotinterface .............................  1 (3.2) 
PACKET transformation ............................  1 (1.1) 
pendown (PROC) ...................................  44 (1.7) 
pen * (PROC) .....................................  10 (2.25), 10 (2.26),
                                                    26 (2.25), 45 (1.11) 
penup (PROC) .....................................  44 (1.4) 
perspective * (PROC) .............................  6 (1.7), 14 (3.17) 
picfiles (PROC) ..................................  28 (3.10) 
picture no * (PROC) ..............................  14 (3.18) 
picture * (PROC) .................................  11 (2.27) 
pictures * (PROC) ................................  14 (3.19) 
plot * (PROC) ....................................  29 (4.3), 29 (4.2), 29 (4.1) 
PLOTTER ..........................................  33 (1.5) 
plotterinfo (PROC) ...............................  18 (4.13) 
plotter (PROC) ...................................  18 (4.11), 18 (4.12) 
plotters (PROC) ..................................  18 (4.14) 
prepare (PROC) ...................................  21 (1.21), 36 (2.14) 
put picture * (PROC) .............................  14 (3.21) 
put * (PROC) .....................................  14 (3.20) 
(q) in die Kommandoebene zurÅck ..................  41 (3.9) 
read picture * (PROC) ............................  14 (3.22) 
reset linetypes * (PROC) .........................  26 (2.27) 
reset * (PROC) ...................................  26 (2.26) 
reset zeichensatz * (PROC) .......................  26 (2.28) 
rotate * (PROC) ..................................  11 (2.28), 11 (2.29) 
(s) Anzahl der StÅtzpunkte waehlen ...............  42 (3.10) 
save (PROC) ......................................  28 (3.12), 28 (3.11) 
selected pen * (PROC) ............................  15 (3.23) 
select pen * (PROC) ..............................  15 (3.24) 
select plotter ...................................  4 (2.7) 
select plotter (PROC) ............................  18 (4.16), 18 (4.15), 18 (4.17) 
set color (PROC) .................................  21 (1.22) 
setdrawingarea (PROC) ............................  6 (1.8) 
set marker (PROC) ................................  21 (1.23), 36 (2.15) 
setpalette (PROC) ................................  21 (1.24), 36 (2.16) 
setpixel (PROC) ..................................  21 (1.25), 36 (2.17) 
setvalues (PROC) .................................  6 (1.9), 15 (3.25) 
spool control ....................................  3 (2.3) 
start ............................................  4 (2.5) 
start (PROC) .....................................  28 (3.13) 
station (PROC) ...................................  18 (4.18) 
stdcolors (PROC) .................................  22 (1.26), 22 (1.27) 
stop .............................................  3 (2.4) 
stop (PROC) ......................................  28 (3.14) 
stretch * (PROC) .................................  11 (2.31), 11 (2.30) 
text * (PROC) ....................................  11 (2.32) 
to eof * (PROC) ..................................  15 (3.26) 
to first pic * (PROC) ............................  16 (3.27) 
to pic * (PROC) ..................................  16 (3.28) 
transform (PROC) .................................  6 (1.10) 
translate * (PROC) ...............................  12 (2.33), 12 (2.34) 
turn (PROC) ......................................  45 (1.10) 
turnto (PROC) ....................................  44 (1.2) 
(t) Wertetafel erstellen lassen ..................  41 (3.6) 
TYPE PICFILE .....................................  13 (3.1) 
TYPE PICTURE * ...................................  8 (2.1) 
TYPE PLOTTER .....................................  17 (4.1) 
up * (PROC) ......................................  16 (3.30), 16 (3.29) 
viewport * (PROC) ................................  7 (1.14), 16 (3.34) 
view * (PROC) ....................................  6 (1.13), 6 (1.12), 6 (1.11),
                                                    16 (3.32), 16 (3.31), 16 (3.33) 
wait for halt (PROC) .............................  28 (3.15) 
where * (PROC) ...................................  12 (2.35), 12 (2.36),
                                                    26 (2.30), 26 (2.29) 
window * (PROC) ..................................  7 (1.15), 7 (1.16), 7 (1.17),
                                                    16 (3.35), 16 (3.36) 
write picture * (PROC) ...........................  16 (3.37) 
(w) Wertebereich ermitteln lassen ................  40 (3.3) 
zeichensatz * (PROC) .............................  26 (2.31) 
(z) Zeichnung anfertigen .........................  40 (3.4) 

