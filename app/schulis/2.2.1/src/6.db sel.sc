PACKET queryselektionDEFINES SELEKTION ,#putoptyp,putrechts,putlinks,
putselwert,#optyp,rechts,links,selwert,fnrlinks,fnrrechts,#allocselelement,#
:=,checkselektion,baueselektionauf,werteselektionaus,mittestausgaben,
initselektionen,initsel,initialisiereselektion,lex,lexon,lexoff:LET uuuuuv=0,
uuuuuw=1,uuuuux=2,uuuuuy=6,uuuuuz=7,uuuuvu=8,uuuuvv=9,#uuuuvw=1,uuuuvx=3,#
uuuuvy=2,uuuuvz=4,uuuuwu=5,uuuuwv=10,uuuuww=11,uuuuwx=12,uuuuwy=13,uuuuwz=14,
uuuuxu=15,uuuuxv=16,uuuuxw=17,uuuuxx=18,uuuuxy=19,uuuuxz=20,uuuuyu=30,uuuuyv=
73,uuuuyw=82,uuuuyx=68,uuuuyy=84;TYPE NODE =STRUCT (INT uuuuyz,uuuuzu,uuuuzv,
TEXT selwert);TYPE SELEKTION =STRUCT (INT uuuuzx,ROW uuuuyuNODE exp);INT VAR 
uuuuzz,uuuvuu,uuuvuv;REAL VAR uuuvuw,uuuvux;TEXT VAR uuuvuy,uuuvuz;INT VAR 
uuuvvu;TEXT VAR uuuvvv:="";BOOL VAR uuuvvw:=FALSE ,lexsort:=FALSE ;BOOL PROC 
lex:lexsortENDPROC lex;PROC lexon:lexsort:=TRUE ENDPROC lexon;PROC lexoff:
lexsort:=FALSE ENDPROC lexoff;PROC mittestausgaben(BOOL CONST uuuvwy):uuuvvw
:=uuuvwyENDPROC mittestausgaben;BOOL PROC mittestausgaben:uuuvvwENDPROC 
mittestausgaben;OP :=(NODE VAR uuuvxz,NODE CONST uuuvyu):CONCR (uuuvxz):=
CONCR (uuuvyu)ENDOP :=;OP :=(SELEKTION VAR uuuvxz,SELEKTION CONST uuuvyu):
CONCR (uuuvxz):=CONCR (uuuvyu)ENDOP :=;PROC initsel(SELEKTION VAR uuuvzw):
uuuvzw.uuuuzx:=0ENDPROC initsel;PROC initselektionen(SELEKTION VAR uuuwuv):
INT VAR uuuwuw;FOR uuuwuwFROM 1UPTO uuuuyuREP uuuwuv.exp[uuuwuw].selwert:=""
PER ENDPROC initselektionen;PROC initialisiereselektion(SELEKTION VAR uuuvzw)
:initsel(uuuvzw);initselektionen(uuuvzw)ENDPROC initialisiereselektion;PROC 
uuuwwy(SELEKTION VAR uuuvzw,INT CONST uuuwxu):uuuvzw.exp[uuuwxu].uuuuyz:=
uuuuxy;uuuvzw.exp[uuuwxu].uuuuzv:=0;uuuvzw.exp[uuuwxu].uuuuzu:=0;uuuvzw.exp[
uuuwxu].selwert:=""ENDPROC uuuwwy;INT PROC allocselelement(SELEKTION VAR 
uuuvzw):uuuvzw.uuuuzxINCR 1;uuuwwy(uuuvzw,uuuvzw.uuuuzx);uuuvzw.uuuuzx
ENDPROC allocselelement;PROC putoptyp(SELEKTION VAR uuuvzw,INT CONST uuuxvy,
optyp):uuuvzw.exp[uuuxvy].uuuuyz:=optypENDPROC putoptyp;PROC uuuxwz(
SELEKTION VAR uuuvzw,INT CONST uuuxvy,uuuxxw):uuuvzw.exp[uuuxvy].uuuuzv:=
uuuxxwENDPROC uuuxwz;PROC putrechts(SELEKTION VAR uuuvzw,INT CONST uuuxvy,
uuuxyz):uuuvzw.exp[uuuxvy].uuuuzv:=uuuxyzENDPROC putrechts;PROC uuuxzz(
SELEKTION VAR uuuvzw,INT CONST uuuxvy,uuuxxw):uuuvzw.exp[uuuxvy].uuuuzu:=
uuuxxwENDPROC uuuxzz;PROC putlinks(SELEKTION VAR uuuvzw,INT CONST uuuxvy,
uuuwuw):uuuvzw.exp[uuuxvy].uuuuzu:=uuuwuwENDPROC putlinks;PROC putselwert(
SELEKTION VAR uuuvzw,INT CONST uuuxvy,TEXT CONST uuuyxw):uuuvzw.exp[uuuxvy].
selwert:=uuuyxwENDPROC putselwert;INT PROC optyp(SELEKTION VAR uuuvzw,INT 
CONST uuuxvy):uuuvzw.exp[uuuxvy].uuuuyzENDPROC optyp;INT PROC fnrrechts(
SELEKTION VAR uuuvzw,INT CONST uuuxvy):uuuvzw.exp[uuuxvy].uuuuzvENDPROC 
fnrrechts;INT PROC fnrlinks(SELEKTION VAR uuuvzw,INT CONST uuuxvy):uuuvzw.exp
[uuuxvy].uuuuzuENDPROC fnrlinks;INT PROC rechts(SELEKTION CONST uuuvzw,INT 
CONST uuuxvy):uuuvzw.exp[uuuxvy].uuuuzvENDPROC rechts;INT PROC links(
SELEKTION CONST uuuvzw,INT CONST uuuxvy):uuuvzw.exp[uuuxvy].uuuuzuENDPROC 
links;TEXT PROC selwert(SELEKTION VAR uuuvzw,INT CONST uuuxvy):uuuvzw.exp[
uuuxvy].selwertENDPROC selwert;INT PROC baueselektionauf(SELEKTION VAR uuuzzx
,TEXT CONST uuuzzy):IF compress(uuuzzy)<>""THEN scan(uuuzzy);uuvuuv(uuuzzx)
ELSE 0FI ENDPROC baueselektionauf;INT PROC uuvuuv(SELEKTION VAR uuuzzx):INT 
VAR uuuwuw,uuvuvv;uuuwuw:=uuvuvx(uuuzzx);nextsymbol;IF uuvuvz=uuuuxxOR uuvuvz
=uuuuxvTHEN uuvuvv:=allocselelement(uuuzzx);putoptyp(uuuzzx,uuvuvv,uuvuvz);
putlinks(uuuzzx,uuvuvv,uuuwuw);putrechts(uuuzzx,uuvuvv,uuvuuv(uuuzzx));uuvuvv
ELSE uuuwuwFI ENDPROC uuvuuv;INT PROC uuvuvx(SELEKTION VAR uuuzzx):INT VAR 
uuvvuu;nextsymbol;SELECT uuvuvzOF CASE uuuuuw:uuvvuu:=uuvuuv(uuuzzx);#
nextsymbol;#IF uuvuvz<>uuuuuxTHEN errorstop("Klammer zu fehlt! Gefunden: "+
uuuvvv)FI ;CASE uuuuxw:uuvvuu:=allocselelement(uuuzzx);putoptyp(uuuzzx,uuvvuu
,uuvuvz);putlinks(uuuzzx,uuvvuu,uuvuvx(uuuzzx));CASE uuuuuy:CASE uuuuvu:
uuvvuu:=allocselelement(uuuzzx);uuvvyx;uuvvyy;nextsymbol;uuvvyzCASE uuuuvv:
uuvvuu:=allocselelement(uuuzzx);uuvvzy;uuvvzz;uuvwuuCASE uuuuuz:OTHERWISE :
errorstop("Falsches Symbol: "+uuuvvv+text(uuuvvu))ENDSELECT ;uuvvuu.uuvvyx:
nextsymbol;IF uuuvvu<>uuuuvzTHEN uuvwvw("Falsche Wertangabe")ELSE putselwert(
uuuzzx,uuvvuu,uuuvvv);nextsymbol;IF uuuvvu<>uuuuwuCAND uuuvvv<>">"THEN uuvwvw
(""">"" bei Wertangabe fehlt!")FI FI .uuvvzz:nextsymbol;IF uuuvvu<>uuuuwu
THEN uuvwvw("Falscher Operator: "+uuuvvv)FI ;putoptyp(uuuzzx,uuvvuu,uuvwyv).
uuvvyy:nextsymbol;IF (uuuvvu=uuuuwu)COR (uuuvvu=uuuuvyCAND uuuvvv="IN")THEN 
putoptyp(uuuzzx,uuvvuu,uuvwyv)ELSE uuvwvw("Falscher Operator: "+uuuvvv)FI ;.
uuvvyz:uuuxwz(uuuzzx,uuvvuu,feldnr(uuuvvv)).uuvvzy:uuuxzz(uuuzzx,uuvvuu,
feldnr(uuuvvv)).uuvwuu:nextsymbol;IF uuvuvz=uuuuvuTHEN uuvvyxELSE uuvvyzFI .
ENDPROC uuvuvx;INT PROC uuvwyv:IF uuuvvv=">"THEN uuuuwzELIF uuuvvv="<"THEN 
uuuuxuELIF uuuvvv="="THEN uuuuwvELIF uuuvvv=">="THEN uuuuwyELIF uuuvvv="<="
THEN uuuuwxELIF uuuvvv="<>"THEN uuuuwwELIF uuuvvv="IN"THEN uuuuxzELSE uuuuxy
FI ENDPROC uuvwyv;PROC nextsymbol:nextsymbol(uuuvvv,uuuvvu)ENDPROC nextsymbol
;INT PROC uuvuvz:IF uuuvvv="("THEN uuuuuwELIF uuuvvv=")"THEN uuuuuxELIF 
uuuvvv="NOT"OR uuuvvv="NICHT"THEN uuuuxwELIF uuuvvv="AND"OR uuuvvv="UND"THEN 
uuuuxvELIF uuuvvv="OR"OR uuuvvv="ODER"THEN uuuuxxELIF uuuvvu=13THEN uuuuuy
ELIF uuuvvu=uuuuwuCAND uuuvvv="<"THEN uuuuvuELIF uuuvvu=uuuuvzTHEN uuuuvv
ELIF uuuvvu=7THEN uuuuuzELSE uuuuuvFI ENDPROC uuvuvz;PROC uuvwvw(TEXT CONST 
uuvyyz):errorstop("FEHLERHAFTER AUSDRUCK: "+uuvyyz)ENDPROC uuvwvw;PROC 
checkselektion(SELEKTION CONST uuuzzx):INT VAR uuvyzy,uuvyzz:=uuuzzx.uuuuzx;
note("Anzahl Knoten: "+text(text(uuvyzz),5));noteline;noteline;noteline;FOR 
uuvyzyFROM 1UPTO uuvyzzREP note("Knoten: "+text(uuvyzy));noteline;note(
"     Operat: "+uuvzvu(uuuzzx.exp[uuvyzy]));noteline;note("     links : "+
text(links(uuuzzx,uuvyzy)));noteline;note("     rechts: "+text(rechts(uuuzzx,
uuvyzy)));noteline;note("     Wert  : "+">"+uuuzzx.exp[uuvyzy].selwert+"<");
notelinePER ENDPROC checkselektion;TEXT PROC uuvzvu(NODE CONST uuuvzw):
SELECT uuuvzw.uuuuyzOF CASE uuuuwv:"="CASE uuuuww:"<>"CASE uuuuwx:"<="CASE 
uuuuwy:">="CASE uuuuwz:">"CASE uuuuxu:"<"CASE uuuuxw:"NOT"CASE uuuuxv:"AND"
CASE uuuuxx:"OR"CASE uuuuxz:"IN"OTHERWISE :"UNDEFINED OPERATOR"ENDSELECT 
ENDPROC uuvzvu;BOOL PROC werteselektionaus(SELEKTION VAR uuuvzw,INT CONST 
uuvyzy):IF uuvyzy=0THEN LEAVE werteselektionausWITH TRUE FI ;uuwuux;SELECT 
uuwuuyOF CASE uuuuxx:uuwuvuOR uuwuvvCASE uuuuxv:uuwuvuAND uuwuvvCASE uuuuxw:
NOT uuwuvuCASE uuuuwx:uuwuwwCASE uuuuwy:uuwuwyCASE uuuuww:uuwuxuCASE uuuuwv:
uuwuxwCASE uuuuxu:uuwuxyCASE uuuuwz:uuwuyuCASE uuuuxz:uuwuywOTHERWISE :FALSE 
ENDSELECT .uuwuvu:werteselektionaus(uuuvzw,links(uuuvzw,uuvyzy)).uuwuvv:
werteselektionaus(uuuvzw,rechts(uuuvzw,uuvyzy)).uuwuux:IF uuwuuy=uuuuxxCOR 
uuwuuy=uuuuxvCOR uuwuuy=uuuuxwTHEN LEAVE uuwuuxELSE uuwvvz;uuwvwuFI .uuwvvz:
IF fnrlinks(uuuvzw,uuvyzy)=0THEN SELECT uuwvwzOF CASE uuuuyv:uuuvuu:=int(
selwert(uuuvzw,uuvyzy));uuuuzz:=uuuuyvCASE uuuuyw:uuuvuw:=real(selwert(uuuvzw
,uuvyzy));uuuuzz:=uuuuywCASE uuuuyx:uuuvuw:=date(selwert(uuuvzw,uuvyzy));
uuuuzz:=uuuuywOTHERWISE :uuuvuy:=selwert(uuuvzw,uuvyzy);uuuuzz:=uuuuyy
ENDSELECT ELSE SELECT feldtyp(fnrlinks(uuuvzw,uuvyzy))OF CASE uuuuyv:uuuvuu:=
intwert(fnrlinks(uuuvzw,uuvyzy));uuuuzz:=uuuuyvCASE uuuuyw:uuuvuw:=realwert(
fnrlinks(uuuvzw,uuvyzy));uuuuzz:=uuuuywCASE uuuuyx:uuuvuw:=date(datumwert(
fnrlinks(uuuvzw,uuvyzy)));uuuuzz:=uuuuywOTHERWISE :uuuvuy:=wert(fnrlinks(
uuuvzw,uuvyzy));uuuuzz:=uuuuyyENDSELECT FI .uuwvwu:IF fnrrechts(uuuvzw,uuvyzy
)=0THEN SELECT uuwxvvOF CASE uuuuyv:uuuvuv:=int(selwert(uuuvzw,uuvyzy))CASE 
uuuuyw:uuuvux:=real(selwert(uuuvzw,uuvyzy))CASE uuuuyx:uuuvux:=date(selwert(
uuuvzw,uuvyzy))OTHERWISE :uuuvuz:=selwert(uuuvzw,uuvyzy)ENDSELECT ELSE 
SELECT feldtyp(fnrrechts(uuuvzw,uuvyzy))OF CASE uuuuyv:uuuvuv:=intwert(
fnrrechts(uuuvzw,uuvyzy))CASE uuuuyw:uuuvux:=realwert(fnrrechts(uuuvzw,uuvyzy
))CASE uuuuyx:uuuvux:=date(datumwert(fnrrechts(uuuvzw,uuvyzy)))OTHERWISE :
uuuvuz:=wert(fnrrechts(uuuvzw,uuvyzy))ENDSELECT FI .uuwxvv:IF fnrlinks(uuuvzw
,uuvyzy)=0THEN uuuuyyELSE feldtyp(fnrlinks(uuuvzw,uuvyzy))FI .uuwvwz:IF 
fnrrechts(uuuvzw,uuvyzy)=0THEN uuuuyyELSE feldtyp(fnrrechts(uuuvzw,uuvyzy))
FI .uuwuuy:optyp(uuuvzw,uuvyzy).ENDPROC werteselektionaus;BOOL PROC uuwuww:
SELECT uuuuzzOF CASE uuuuyv:uuuvuu<=uuuvuvCASE uuuuyw:uuuvuw<=uuuvux
OTHERWISE :uuuvuy<=uuuvuzENDSELECT ENDPROC uuwuww;BOOL PROC uuwuwy:SELECT 
uuuuzzOF CASE uuuuyv:uuuvuu>=uuuvuvCASE uuuuyw:uuuvuw>=uuuvuxOTHERWISE :
uuuvuy>=uuuvuzENDSELECT ENDPROC uuwuwy;BOOL PROC uuwuxy:SELECT uuuuzzOF CASE 
uuuuyv:uuuvuu<uuuvuvCASE uuuuyw:uuuvuw<uuuvuxOTHERWISE :IF lexsortTHEN NOT (
uuuvuyLEXGREATEREQUAL uuuvuz)ELSE uuuvuy<uuuvuzFI ENDSELECT ENDPROC uuwuxy;
BOOL PROC uuwuyu:SELECT uuuuzzOF CASE uuuuyv:uuuvuu>uuuvuvCASE uuuuyw:uuuvuw>
uuuvuxOTHERWISE :IF lexsortTHEN uuuvuyLEXGREATER uuuvuzELSE uuuvuy>uuuvuzFI 
ENDSELECT ENDPROC uuwuyu;BOOL PROC uuwuxw:SELECT uuuuzzOF CASE uuuuyv:uuuvuu=
uuuvuvCASE uuuuyw:uuuvuw=uuuvuxOTHERWISE :IF lexsortTHEN uuuvuyLEXEQUAL 
uuuvuzELSE uuuvuy=uuuvuzFI ENDSELECT ENDPROC uuwuxw;BOOL PROC uuwuxu:SELECT 
uuuuzzOF CASE uuuuyv:uuuvuu<>uuuvuvCASE uuuuyw:uuuvuw<>uuuvuxOTHERWISE :IF 
lexsortTHEN NOT (uuuvuyLEXEQUAL uuuvuz)ELSE uuuvuy<>uuuvuzFI ENDSELECT 
ENDPROC uuwuxu;BOOL PROC uuwuyw:IF uuuuzz=uuuuyyTHEN pos(uuuvuz,uuuvuy)>0
ELSE FALSE FI ENDPROC uuwuyw;ENDPACKET queryselektion;

