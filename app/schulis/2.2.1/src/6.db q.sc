#$IF mitinternerqueryTHEN #PACKET queryparserDEFINES QUERY ,query,
getscanbedingung,getdnr,getinr,getanzahlverbunde,getselpointer,
getstopbedpointer,getquery,putquery,setzeschluessel,getanzahltupel,
getswanzfld,getswnachfld,getswvonfld,getswallefelder,getswfwert,getsohnverb,
getbruderverb,geterstestupel,puterstestupel,selektionerfuellt,initquery,:=,
baumdurchlauf,listeschluessel,putletzterverbund,getletzterverbund,puttid,
gettid,getbruder,putbruder,tidfeld,updatefnr,updateausdruck,queryart,
anzupdatefelder:TYPE UPDSTACK =STRUCT (INT uuuuuv,TEXT uuuuuw);BOUND ROW 100
UPDSTACK VAR uuuuux;TYPE VERBELEMENT =STRUCT (TEXT uuuuuy,uuuuuz,BOOL uuuuvu,
INT uuuuvv,uuuuvw,uuuuvx,uuuuvy,uuuuvz,uuuuwu);TYPE VERBUND =ROW uuuuwv
VERBELEMENT ;TYPE QUERY =STRUCT (INT uuuuww,uuuuwx,uuuuwy,TEXT uuuuwz,uuuuxu,
SELEKTION uuuuxv,VERBUND uuuuxw,SCHLUESSEL uuuuxx);TYPE SWERT =STRUCT (INT 
uuuuxy,uuuuxz,TEXT wert);TYPE SCHLUESSELWERTE =STRUCT (BOOL uuuuyu,INT uuuuyv
,ROW uuuuywSWERT uuuuyx);TYPE SCHLUESSEL =ROW uuuuwvSCHLUESSELWERTE ;LET 
uuuuyz=0,uuuuzu=1,uuuuzv=2,uuuuzw=3,uuuuzx=6,uuuuzy=5,uuuuzz=7,uuuvuu=7,
uuuvuv=4,uuuvuw="BY",uuuvux="UPDATE",uuuvuy="DELETE",uuuvuz=".query",uuuvvu=
";",uuuvvv="(",uuuvvw=")",#uuuvvx=",",uuuvvy="=",uuuvvz=">=",uuuvwu="<=",#
uuuvwv="/",uuuvww="""",uuuvwx=".",uuuvwy=":",uuuvwz=" ",uuuvxu=":=",uuuvxv=
"<",uuuuwv=10,uuuvxx=20,uuuuyw=10,uuuvxz=80,uuuvyu=1,uuuvyv=2,uuuvyw=3;INT 
VAR uuuvyx:=-5,uuuvyy:=-33,uuuvyz;DATASPACE VAR uuuvzu:=nilspace;INT VAR 
uuuvzv:=0;INT PROC tidfeld:uuuvyyENDPROC tidfeld;FILE VAR uuuvzz;TEXT VAR 
uuuwuu:="",uuuwuv:="",uuuwuw:="",uuuwux:="";INT VAR uuuwuy,uuuwuz,uuuwvu;
BOOL VAR uuuwvv,uuuwvw;INT VAR uuuwvx:=0,uuuwvy,uuuwvz;ROW uuuvxxTEXT VAR 
uuuwwv;OP :=(QUERY VAR uuuwww,QUERY CONST uuuwwx):CONCR (uuuwww):=CONCR (
uuuwwx)ENDOP :=;OP :=(VERBELEMENT VAR uuuwww,VERBELEMENT CONST uuuwwx):CONCR 
(uuuwww):=CONCR (uuuwwx)ENDOP :=;OP :=(VERBUND VAR uuuwww,VERBUND CONST 
uuuwwx):CONCR (uuuwww):=CONCR (uuuwwx)ENDOP :=;INT PROC updatefnr(INT CONST 
uuuwyx):uuuuux[uuuwyx].uuuuuvENDPROC updatefnr;TEXT PROC updateausdruck(INT 
CONST uuuwyx):uuuuux[uuuwyx].uuuuuwENDPROC updateausdruck;INT PROC queryart:
uuuvzvENDPROC queryart;PROC queryart(INT CONST uuuxvu):uuuvzv:=uuuxvuENDPROC 
queryart;INT PROC anzupdatefelder:uuuvyzENDPROC anzupdatefelder;PROC 
initquery(QUERY VAR uuuxww):uuuxwx;uuuxww.uuuuww:=0;uuuxww.uuuuwx:=0;uuuxww.
uuuuwz:="";uuuxww.uuuuxu:="";initselektionen(uuuxww.uuuuxv);uuuxyw(uuuxww.
uuuuxw);uuuxyz(uuuxww.uuuuxx)ENDPROC initquery;PROC uuuxwx:forget(uuuvzu);
uuuvzu:=nilspace;uuuuux:=uuuvzuENDPROC uuuxwx;initquery(uuuyuy);PROC uuuxyw(
VERBUND VAR uuuyvu):FOR uuuwvyFROM 1UPTO uuuuwvREP uuuyvx(uuuyvu[uuuwvy])PER 
ENDPROC uuuxyw;PROC uuuyvx(VERBELEMENT VAR uuuyww):uuuyww.uuuuuy:="";uuuyww.
uuuuuz:=""ENDPROC uuuyvx;#BOUND QUERY VAR uuuyuy;#QUERY VAR uuuyuy;PROC 
getquery(QUERY VAR uuuxww):CONCR (uuuxww):=CONCR (uuuyuy)ENDPROC getquery;
PROC putquery(QUERY CONST uuuxww):CONCR (uuuyuy):=CONCR (uuuxww)ENDPROC 
putquery;PROC query:query(lastparam)ENDPROC query;PROC uuuyzz(TEXT CONST 
uuuzuu):TEXT VAR uuuzuv:="",uuuzuw:="",uuuzux:="",uuuwuv:="";INT VAR uuuzuz;
uuuxwx;uuuzvv;nextsymbol;queryparser(uuuzvx);uuuzvy;uuuzvz;uuuzwu;uuuzwv;
baumdurchlauf;.uuuzvy:nextsymbol;WHILE uuuwuy<>uuuuzzREP uuuzxu;nextsymbol
PER .uuuzxu:uuuzuw:="";IF uuuwuy<>uuuuzuTHEN uuuzxz(
"Refinementname erwartet: "+uuuwuu)ELSE uuuzuv:=uuuwuu;nextsymbol;IF uuuwuu<>
uuuvwyTHEN uuuzxz(uuuvww+uuuvwy+uuuvww+" erwartet: "+uuuwuu)ELSE uuuzzy;
putref(uuuzuv,uuuzuw)FI FI .uuuzzy:nextsymbol;WHILE uuuwuy<>uuuuzzCAND uuuwuu
<>uuuvwxREP uuuzuw:=uuuzuw+uuvuvw;nextsymbolPER ;IF uuuwuy=uuuuzzTHEN uuuzxz(
"Refinement nicht mit ""."" abgeschlossen")FI .uuuzvv:enablestop;uuuvzz:=
sequentialfile(input,uuuzuu);IF exists(uuuzuu+uuuvuz)THEN forget(uuuzuu+
uuuvuz,quiet)FI ;#uuuyuy:=new(uuuzuu+uuuvuz);#lastparam(uuuzuu);uuvuxz(0);
uuuwvx:=0;clearrefs;scan(uuuvzz);.uuuzwu:FOR uuuzuzFROM 1UPTO uuuwvxREP 
uuuzux:="";uuuwuv:=uuvuzv(uuuzuz);scan(uuuwuv);nextsymbol(uuuwuu,uuuwuy);
WHILE uuuwuy<>uuuuzzREP IF uuuwuy=uuuuzuTHEN uuuzux:=uuuzux+getreftext(uuuwuu
)ELSE uuuzux:=uuuzux+uuvuvwFI ;nextsymbol(uuuwuu,uuuwuy)PER ;uuvvwu(uuuzux,
uuuzuz)PER .uuuzwv:INT VAR uuvvwy;initsel(uuuyuy.uuuuxv);FOR uuuzuzFROM 1
UPTO getanzahlverbundeREP uuvvxx;uuvvxyPER .uuvvxx:uuvvwy:=getstopbedpointer(
uuuzuz);IF uuvvwy>uuuuyzTHEN uuuwuv:=uuvuzv(uuvvwy);uuvvzw(baueselektionauf(
uuuyuy.uuuuxv,uuuwuv),uuuzuz)FI .uuvvxy:uuvvwy:=getselpointer(uuuzuz);IF 
uuvvwy>uuuuyzTHEN uuuwuv:=uuvuzv(uuvvwy);uuvwvy(baueselektionauf(uuuyuy.
uuuuxv,uuuwuv),uuuzuz)FI .ENDPROC uuuyzz;PROC uuuzvz:INT VAR uuuzuz:=1;BOOL 
VAR uuvwxu:=FALSE ;TEXT VAR uuuzux:="";WHILE uuuzuz<=getanzahlverbundeREP 
uuuzux:="";uuuwuv:=getscanbedingung(uuuzuz);scan(uuuwuv);nextsymbol(uuuwuu,
uuuwuy);WHILE uuuwuy<>uuuuzzREP IF uuuwuy=uuuuzuTHEN uuuzux:=uuuzux+
getreftext(uuuwuu)ELSE uuuzux:=uuuzux+uuvuvwFI ;nextsymbol(uuuwuu,uuuwuy)PER 
;IF getdnr(uuuzuz)=uuuvyxTHEN queryparser(uuuzux,uuuzuz);uuvwxu:=TRUE ELSE 
uuvxwu(uuuzux,uuuzuz)FI ;uuuzuzINCR 1PER ;IF uuvwxuTHEN uuuzvzFI ENDPROC 
uuuzvz;PROC queryparser(TEXT CONST uuuwuv,INT CONST uuvxxx):INT VAR uuvxxy;
scan(uuuwuv);nextsymbol;uuvxyu;queryparser(uuvxxx);uuvxyx.uuvxyu:uuvxxy:=
getbruderverb(uuvxxx);.uuvxyx:uuvxzx(uuvxxy,uuvxxx).ENDPROC queryparser;PROC 
queryparser(INT CONST uuvxxx):TEXT VAR uuvyux:="";BOOL VAR uuvyuy:=FALSE ;
uuuvzv:=0;REP uuvyvu;UNTIL uuvyuyPER ;uuvyvw;uuvyvx;uuvyvy;uuvyvz;SELECT 
uuuvzvOF CASE uuuvyv,uuuvyu:uuvywx;IF uuvxxx=1THEN uuvywzFI CASE uuuvyw:
uuvyxvENDSELECT .uuvyvu:IF uuuwuy=uuuvuvTHEN uuvyxz(dateinr(uuuwuu),uuvxxx);
IF uuuvzv<1THEN uuuvzv:=uuuvyuFI ;uuvyuy:=TRUE ELSE IF uuuwuy=uuuuzvTHEN IF 
uuuwuu=uuuvuxTHEN nextsymbol;uuuvzv:=uuuvywELIF uuuwuu=uuuvuyTHEN nextsymbol;
uuuvzv:=uuuvyvELSE uuuzxz("Dateiname nicht gefunden: "+uuuwuu)FI FI FI .
uuvyvw:nextsymbol;IF uuuwuy=uuuuzvCAND uuuwuu=uuuvuwTHEN uuvzvz;uuvzwuELSE 
IF uuuwuy=uuuuzxCAND uuuwuu=uuuvvvTHEN uuvzwz(#getdnr(uuvxxx)#0,uuvxxx)ELSE 
uuuzxz("Indexname bzw. ""("" fehlt")FI FI .uuvzvz:nextsymbol;IF uuuwuy=uuuvuv
THEN uuvzwz(indexnr(uuuwuu),uuvxxx)ELSE uuuzxz("Indexname nicht gefunden: "+
uuuwuu)FI .uuvzwu:nextsymbol;IF NOT (uuuwuy=uuuuzxCAND uuuwuu=uuuvvv)THEN 
uuuzxz(uuuvww+uuuvvv+uuuvww+" erwartet")FI .uuvyvx:uuwuuy(uuuwuv);uuvxwu(
uuuwuv,uuvxxx);.uuvyvy:BOOL VAR stop:=TRUE ;uuwuvy.uuvyvz:stop:=FALSE ;uuwuvy
.uuwuvy:INT VAR uuvvwy;uuuwuw:="";IF NOT uuuwvvTHEN uuwuuy(uuuwuw);IF uuuwuw=
""THEN IF stopTHEN uuvvzw(uuuuyz,uuvxxx)ELSE uuvwvy(uuuuyz,uuvxxx)FI ELSE 
uuvvwy:=uuwuyx;IF stopTHEN uuvvzw(uuvvwy,uuvxxx)ELSE uuvwvy(uuvvwy,uuvxxx)FI 
;uuvvwu(uuuwuw,uuvvwy)FI ELSE uuvwvy(uuuuyz,uuvxxx)FI .uuvywx:INT VAR uuwvuz;
IF NOT uuuwvvTHEN uuwvvv(uuvxxx,uuwvuz);uuwvvy(uuwvuz,uuvxxx);uuvxzx(uuuuyz,
uuvxxx)FI .uuvywz:nextsymbol;IF uuuwuy=uuuuzxOR uuuwuy=uuuuzzOR uuuwuy=uuuuzy
THEN IF uuuwuu<>uuuvwvTHEN uuwvyvFI ;uuuuwx;uuwvyxELSE uuuzxz(uuuvww+uuuvwv+
uuuvww+" bzw. "+uuuvww+uuuvvu+uuuvww+uuuvwv+uuuvww+uuuvwx+uuuvww+" erwartet")
FI .uuwvyv:IF uuuwuu=uuuvvuOR uuuwuu=uuuvwxOR uuuwuy=uuuuzzTHEN uuwwvy(0);
LEAVE uuvywzELSE uuuzxz("Falscher Tupelzahl-Operator: "+uuuwuu)FI .uuuuwx:
nextsymbol;IF uuuwuy=uuuuzwTHEN uuwwvy(int(uuuwuu));ELSE uuuzxz(
"Keine Zahlenangabe: "+uuuwuu)FI .uuwvyx:nextsymbol;IF uuuwuy<>uuuuzzCAND (
NOT (uuuwuu=uuuvvuCOR uuuwuu=uuuvwx))THEN uuuzxz("""."" oder "";"" erwartet")
FI .uuvyxv:uuuvyz:=0;nextsymbol;WHILE NOT uuuwvvREP uuuvyzINCR 1;uuwwzx;
uuwwzy;uuwwzz;PER .uuwwzx:IF uuuwuy=uuuuzuTHEN uuwxuxELSE uuwxuyFI .uuwxux:
uuuzxz("Zur Zeit keine Refinements in Update-Liste erlaubt!").uuwxuy:uuuuux[
uuuvyz].uuuuuv:=feldnr(uuuwuu);IF uuuuux[uuuvyz].uuuuuv<3THEN uuuzxz(
"Falscher Feldname: "+uuuwuu)FI ;nextsymbol.uuwwzy:IF NOT (uuuwuy=uuuuzyCAND 
uuuwuu=uuuvxu)THEN uuuzxz("Keine Zuweisung: "+uuuwuu)FI .uuwwzz:uuwxyv(uuvyux
);uuuuux[uuuvyz].uuuuuw:=uuvyux;nextsymbol.ENDPROC queryparser;PROC uuwxyv(
TEXT VAR uuwxzx):INT VAR uuwxzy:=0,uuwxzz:=0;uuwxzx:="";uuuwuu:="";uuuwuy:=0;
REP uuwxzx:=uuwxzx+uuvuvw;uuwxzy:=uuuwuy;nextsymbolUNTIL uuwyvwPER .uuwyvw:
IF (uuuwuy=uuuuzxCAND (uuuwuu=uuuvvuCOR (uuuwuu=uuuvvwCAND uuwxzz=0)))THEN 
uuuwvv:=uuuwuu=uuuvvw;TRUE ELSE IF uuuwuy=uuuuzzTHEN uuuzxz(
"Vorzeitiges END OF FILE!");FALSE ELSE IF uuuwuy=uuuuzxTHEN IF uuuwuu=uuuvvv
THEN uuwxzzINCR 1FI ;IF uuuwuu=uuuvvwTHEN uuwxzzDECR 1FI ;FI ;FALSE FI FI .
ENDPROC uuwxyv;PROC uuwvvv(INT CONST uuvxxx,INT VAR uuwvuz):INT VAR uuwyzz:=
uuuuyz;uuwvuz:=uuuuyz;nextsymbol;IF uuuwuy=uuuuzxCAND uuuwuu=uuuvvwTHEN 
uuuwvv:=TRUE ;LEAVE uuwvvvELIF uuuwuy=uuuuzuTHEN uuwvuz:=uuuzvx;uuvxwu(uuuwuu
,uuwvuz);uuvwvy(uuuuyz,uuwvuz);uuvyxz(uuuvyx,uuwvuz);uuwvvv(uuwvuz,uuwyzz);
uuvxzx(uuwyzz,uuwvuz)ELIF uuuwuy=uuuvuvTHEN uuwvuz:=uuuzvx;queryparser(uuwvuz
);uuuwvv:=FALSE ;uuwvvv(uuwvuz,uuwyzz);uuvxzx(uuwyzz,uuwvuz)ELIF (uuuwuy=
uuuuzxCAND uuuwuu=uuuvvu)THEN uuwvvv(uuvxxx,uuwvuz)ELSE uuuzxz(
"Verbund-Fehler bei : "+uuuwuu)FI ENDPROC uuwvvv;PROC uuwuuy(TEXT VAR uuwxzx)
:INT VAR uuwxzy:=0;uuwxzx:="";uuuwuu:="";uuuwuy:=0;uuuwvv:=FALSE ;REP uuwxzx
:=uuwxzx+uuvuvw;uuwxzy:=uuuwuy;nextsymbolUNTIL uuxuyxPER .uuxuyx:IF (uuuwuy=
uuuuzyCAND uuuwuu=uuuvwv)THEN TRUE ELSE IF uuuwuy=uuuuzzTHEN uuuzxz(uuuvww+
uuuvwv+uuuvww+" fehlt");FALSE ELSE FALSE FI FI .ENDPROC uuwuuy;TEXT PROC 
uuvuvw:IF uuuwuy=uuuvuvTHEN uuuvww+uuuwuu+uuuvwwELIF uuuwuy=uuuuzvTHEN uuuvwz
+uuuwuu+uuuvwzELSE uuuwuuFI ENDPROC uuvuvw;PROC nextsymbol:nextsymbol(uuuvzz,
uuuwuu,uuuwuy);ENDPROC nextsymbol;PROC uuuzxz(TEXT CONST uuxvxx):errorstop(
"Zeile "+text(lineno(uuuvzz))+" : "+uuxvxx)ENDPROC uuuzxz;PROC puterstestupel
(TEXT CONST uuxvyw):uuuyuy.uuuuwz:=uuxvywENDPROC puterstestupel;TEXT PROC 
geterstestupel:uuuyuy.uuuuwzENDPROC geterstestupel;PROC uuxvzz(TEXT CONST 
uuxvyw):uuuyuy.uuuuxu:=uuxvywENDPROC uuxvzz;TEXT PROC uuxwuz:uuuyuy.uuuuxu
ENDPROC uuxwuz;PROC uuwwvy(INT CONST uuxwvy):uuuyuy.uuuuwx:=uuxwvyENDPROC 
uuwwvy;INT PROC getanzahltupel:uuuyuy.uuuuwxENDPROC getanzahltupel;PROC 
putletzterverbund(INT CONST uuxwxw):uuuyuy.uuuuwy:=uuxwxwENDPROC 
putletzterverbund;INT PROC getletzterverbund:uuuyuy.uuuuwyENDPROC 
getletzterverbund;PROC puttid(INT CONST uuxwzu,TEXT CONST uuxwzv):uuuyuy.
uuuuxw[uuxwzu].uuuuuz:=uuxwzvENDPROC puttid;TEXT PROC gettid(INT CONST uuxwzu
):uuuyuy.uuuuxw[uuxwzu].uuuuuzENDPROC gettid;PROC putbruder(INT CONST uuxwzu,
BOOL CONST uuxxvz):uuuyuy.uuuuxw[uuxwzu].uuuuvu:=uuxxvzENDPROC putbruder;
BOOL PROC getbruder(INT CONST uuxwzu):uuuyuy.uuuuxw[uuxwzu].uuuuvuENDPROC 
getbruder;PROC uuvxwu(TEXT CONST uuxxyw,INT CONST uuuzuz):uuuyuy.uuuuxw[
uuuzuz].uuuuuy:=uuxxywENDPROC uuvxwu;TEXT PROC getscanbedingung(INT CONST 
uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuuyENDPROC getscanbedingung;PROC uuvyxz(INT 
CONST uuxyvu,uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvv:=uuxyvuENDPROC uuvyxz;PROC 
uuvzwz(INT CONST uuxywx,uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvw:=uuxywxENDPROC 
uuvzwz;INT PROC getdnr(INT CONST uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvvENDPROC 
getdnr;INT PROC getinr(INT CONST uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvwENDPROC 
getinr;PROC uuvwvy(INT CONST uuxzuw,uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvx:=
uuxzuwENDPROC uuvwvy;INT PROC getselpointer(INT CONST uuuzuz):uuuyuy.uuuuxw[
uuuzuz].uuuuvxENDPROC getselpointer;PROC uuvvzw(INT CONST uuxzuw,uuuzuz):
uuuyuy.uuuuxw[uuuzuz].uuuuvy:=uuxzuwENDPROC uuvvzw;INT PROC getstopbedpointer
(INT CONST uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvyENDPROC getstopbedpointer;
PROC uuvxzx(INT CONST uuxzuw,uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvz:=uuxzuw
ENDPROC uuvxzx;INT PROC getbruderverb(INT CONST uuuzuz):uuuyuy.uuuuxw[uuuzuz]
.uuuuvzENDPROC getbruderverb;PROC uuwvvy(INT CONST uuxzuw,uuuzuz):uuuyuy.
uuuuxw[uuuzuz].uuuuwu:=uuxzuwENDPROC uuwvvy;INT PROC getsohnverb(INT CONST 
uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuwuENDPROC getsohnverb;PROC uuvuxz(INT 
CONST uuyuzu):uuuyuy.uuuuww:=uuyuzuENDPROC uuvuxz;INT PROC getanzahlverbunde:
uuuyuy.uuuuwwENDPROC getanzahlverbunde;INT PROC uuuzvx:INT VAR uuyuzu:=
getanzahlverbunde+1;uuvuxz(uuyuzu);uuvxzx(uuuuyz,uuyuzu);uuwvvy(uuuuyz,uuyuzu
);uuvxwu("",uuyuzu);uuyuzuENDPROC uuuzvx;INT PROC uuwuyx:uuuwvxINCR 1;uuuwvx
ENDPROC uuwuyx;PROC uuvvwu(TEXT CONST uuuwuw,INT CONST uuvvwy):uuuwwv[uuvvwy]
:=uuuwuwENDPROC uuvvwu;TEXT PROC uuvuzv(INT CONST uuvvwy):uuuwwv[uuvvwy]
ENDPROC uuvuzv;PROC baumdurchlauf:IF mittestausgabenTHEN uuyvzzFI .uuyvzz:
INT VAR uuywuv;FOR uuywuvFROM 1UPTO getanzahlverbundeREP note("Verbund  : "+
text(uuywuv));noteline;note("   Datei : "+text(getdnr(uuywuv)));noteline;note
("   Index : "+text(getinr(uuywuv)));noteline;note("   Scan  : "+
getscanbedingung(uuywuv));noteline;note("   Bruder: "+text(getbruderverb(
uuywuv)));noteline;note("   Sohn  : "+text(getsohnverb(uuywuv)));noteline;
note("   SelPoi: "+text(getselpointer(uuywuv)));noteline;noteline;PER ;
checkselektion(uuuyuy.uuuuxv).ENDPROC baumdurchlauf;PROC setzeschluessel(INT 
CONST uuxwzu):TEXT VAR uuywxy:=getscanbedingung(uuxwzu);scan(uuywxy);
nextsymbol;uuywyw;uuywyx;uuywyy;uuywyz;WHILE uuuwuy<>uuuvuuREP IF uuuwuu=
uuuvxvTHEN nextsymbol;uuywzy(uuxwzu,uuyxuu,uuuwuu);uuyxuw(uuxwzu,uuyxuu,
uuyxuz);uuyxvu(uuxwzu,uuyxuu,0);ELIF uuuwuy=uuuvuvTHEN uuywzy(uuxwzu,uuyxuu,
"");uuyxuw(uuxwzu,uuyxuu,uuyxuz);uuyxvu(uuxwzu,uuyxuu,feldnr(uuuwuu));ELIF 
uuuwuu=uuuvvuTHEN uuyxyuFI ;nextsymbolPER ;uuyxyv.uuywyx:IF uuuwuy=uuuvuv
CAND feldtyp(feldnr(uuuwuu))=uuuvxzTHEN uuywzy(uuxwzu,1,"");uuyxuw(uuxwzu,1,
tidfeld);uuyxvu(uuxwzu,1,feldnr(uuuwuu));uuyyux(uuxwzu,TRUE );uuyyuz(uuxwzu,1
);LEAVE setzeschluesselFI ;.uuywyz:uuywzy(uuxwzu,1,"");uuyxuw(uuxwzu,1,0);
uuyxvu(uuxwzu,1,0).uuyxyu:IF uuuwvwTHEN uuyxuzINCR 1ELSE uuuwuz:=uuuwvu+1;
uuuwvu:=pos(uuuwux,uuuvvu,uuuwuz);uuyxuz:=uuxyvu+int(subtext(uuuwux,uuuwuz,
uuuwvu-1))FI ;uuyxuuINCR 1.uuywyw:INT VAR uuyyzv:=getinr(uuxwzu),uuxyvu:=
getdnr(uuxwzu),uuyxuz;IF uuyyzv=0THEN uuuwvw:=TRUE ;uuyxuz:=uuxyvu+1ELSE 
uuuwux:=zugriff(uuyyzv);uuuwvu:=pos(uuuwux,uuuvvu);uuyxuz:=int(subtext(uuuwux
,1,uuuwvu-1))+uuxyvu;uuuwvw:=FALSE FI .uuyzwy:IF uuuwvwTHEN (uuyxuz-uuxyvu)=
anzkey(uuxyvu)ELSE uuuwvu=length(uuuwux)FI .uuywyy:INT VAR uuyxuu:=1;IF 
uuuwuy=uuuvuuTHEN uuyxuu:=0FI .uuyxyv:uuyyux(uuxwzu,uuyzwyCAND (uuyxuu>0));
uuyyuz(uuxwzu,uuyxuu).ENDPROC setzeschluessel;PROC uuyxvu(INT CONST uuxwzu,
uuzuux,uuyxuz):uuuyuy.uuuuxx[uuxwzu].uuuuyx[uuzuux].uuuuxy:=uuyxuzENDPROC 
uuyxvu;PROC uuyxuw(INT CONST uuxwzu,uuzuux,uuyxuz):uuuyuy.uuuuxx[uuxwzu].
uuuuyx[uuzuux].uuuuxz:=uuyxuzENDPROC uuyxuw;INT PROC getswvonfld(INT CONST 
uuxwzu,uuzuux):uuuyuy.uuuuxx[uuxwzu].uuuuyx[uuzuux].uuuuxyENDPROC getswvonfld
;INT PROC getswnachfld(INT CONST uuxwzu,uuzuux):uuuyuy.uuuuxx[uuxwzu].uuuuyx[
uuzuux].uuuuxzENDPROC getswnachfld;PROC uuywzy(INT CONST uuxwzu,uuzuux,TEXT 
CONST uuzvwu):uuuyuy.uuuuxx[uuxwzu].uuuuyx[uuzuux].wert:=uuzvwuENDPROC uuywzy
;TEXT PROC getswfwert(INT CONST uuxwzu,uuzuux):uuuyuy.uuuuxx[uuxwzu].uuuuyx[
uuzuux].wertENDPROC getswfwert;PROC uuyyux(INT CONST uuxwzu,BOOL CONST uuzvzv
):uuuyuy.uuuuxx[uuxwzu].uuuuyu:=uuzvzvENDPROC uuyyux;BOOL PROC 
getswallefelder(INT CONST uuxwzu):uuuyuy.uuuuxx[uuxwzu].uuuuyuENDPROC 
getswallefelder;PROC uuyyuz(INT CONST uuxwzu,uuzwvz):uuuyuy.uuuuxx[uuxwzu].
uuuuyv:=uuzwvzENDPROC uuyyuz;INT PROC getswanzfld(INT CONST uuxwzu):uuuyuy.
uuuuxx[uuxwzu].uuuuyvENDPROC getswanzfld;PROC query(TEXT CONST uuzwyw):INT 
VAR uuuzuz;uuuyzz(uuzwyw);FOR uuuzuzFROM 1UPTO getanzahlverbundeREP 
setzeschluessel(uuuzuz)PER ;listeschluesselENDPROC query;OP :=(
SCHLUESSELWERTE VAR uuuwww,SCHLUESSELWERTE CONST uuuwwx):CONCR (uuuwww):=
CONCR (uuuwwx)ENDOP :=;OP :=(SWERT VAR uuuwww,SWERT CONST uuuwwx):CONCR (
uuuwww):=CONCR (uuuwwx)ENDOP :=;OP :=(SCHLUESSEL VAR uuuwww,SCHLUESSEL CONST 
uuuwwx):CONCR (uuuwww):=CONCR (uuuwwx)ENDOP :=;PROC listeschluessel:IF NOT 
mittestausgabenTHEN LEAVE listeschluesselFI ;INT VAR uuuzuz,uuywuv;FOR uuuzuz
FROM 1UPTO getanzahlverbundeREP noteline;note("Verbund : "+text(uuuzuz));
noteline;note("=============");noteline;noteline;note("ANZAHL FLD: "+text(
getswanzfld(uuuzuz)));noteline;note("ALLE      : "+uuzxxx);noteline;noteline;
FOR uuywuvFROM 1UPTO getswanzfld(uuuzuz)REP note("   VON : "+text(getswvonfld
(uuuzuz,uuywuv)));noteline;note("   NACH: "+text(getswnachfld(uuuzuz,uuywuv))
);noteline;note("   WERT: "+getswfwert(uuuzuz,uuywuv));noteline;PER PER .
uuzxxx:IF getswallefelder(uuuzuz)THEN "vollständiger Schlüssel"ELSE 
"unvollständiger Schlüssel"FI .ENDPROC listeschluessel;BOOL PROC 
selektionerfuellt(INT CONST uuzyux):werteselektionaus(uuuyuy.uuuuxv,uuzyux)
ENDPROC selektionerfuellt;PROC uuuxyz(SCHLUESSEL VAR uuzyvx):FOR uuuwvyFROM 1
UPTO uuuuwvREP FOR uuuwvzFROM 1UPTO uuuuywREP uuzyvx[uuuwvy].uuuuyx[uuuwvz].
wert:=""PER PER ENDPROC uuuxyz;ENDPACKET queryparser;#$FI #

