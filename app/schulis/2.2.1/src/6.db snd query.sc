#$IF mitinternerqueryTHEN #PACKET dbsndqueryDEFINES auswertung,
auswertungfortsetzen,qsucc,endofscan,ordernewstack,puttiefennr,gettiefennr,
endqueryserver:LET uuuuuv=25,uuuuuw=0,uuuuux=1,uuuuuy=2,uuuuuz=2,uuuuvu=37,
uuuuvv=10,uuuuvw=39,uuuuvx=40,uuuuvy=41,uuuuvz=1;INT CONST endofscan:=8,
ordernewstack:=9;INT VAR uuuuwu,uuuuwv;DATASPACE VAR uuuuww;BOUND QUERY VAR 
uuuuwx;BOUND TEXT VAR uuuuwy;ROW uuuuvvINT VAR uuuuxu;TYPE TUPEL =STRUCT (
INT uuuuxv,uuuuxw,uuuuxx,TEXT uuuuxy);TYPE QUERYSTACK =STRUCT (INT uuuuxz,
TASK uuuuyu,ROW uuuuuvTUPEL uuuuyw);INT VAR uuuuyx:=getanzahltupel,uuuuyy;
TEXT VAR uuuuyz:="",uuuuzu:="";PROC endqueryserver:forget(uuuuww);uuuuww:=
nilspace;send(uuuuzy,uuuuvx,uuuuww)ENDPROC endqueryserver;TASK VAR uuuuzy;
BOUND QUERYSTACK VAR uuuvux;OP :=(TUPEL VAR uuuvuy,TUPEL CONST uuuvuz):CONCR 
(uuuvuy):=CONCR (uuuvuz)ENDOP :=;OP :=(QUERYSTACK VAR uuuvuy,QUERYSTACK 
CONST uuuvuz):CONCR (uuuvuy):=CONCR (uuuvuz)ENDOP :=;INT PROC gettiefennr(
INT CONST uuuvwv):IF uuuvwv=0THEN 0ELSE uuuuxu[uuuvwv]FI ENDPROC gettiefennr;
PROC puttiefennr(INT CONST uuuvwv,uuuvxw):uuuuxu[uuuvwv]:=uuuvxwENDPROC 
puttiefennr;PROC auswertung(TEXT CONST uuuvyv):uuuuyy:=0;query(uuuvyv);IF 
queryart=uuuuvzTHEN uuuvyzELSE uuuvzuFI .uuuvyz:uuuvzw;forget(uuuuww);uuuuww
:=nilspace;uuuuwx:=uuuuww;getquery(uuuuwx);call(/name(1),uuuuvu,uuuuww,uuuuwu
);uuuwuz;uuuvux:=uuuuww;uuuuzy:=uuuvux.uuuuyu.uuuvzu:forget(uuuuww);uuuuww:=
old(uuuvyv);call(/name(1),uuuuvy,uuuuww,uuuuwu);uuuwuz.ENDPROC auswertung;
PROC uuuvzw:uuuuwv:=0;uuuwxx(1)ENDPROC uuuvzw;PROC uuuwxx(INT CONST uuuwyu):
uuuuwvINCR 1;puttiefennr(uuuwyu,uuuuwv);IF getsohnverb(uuuwyu)<>uuuuuwTHEN 
uuuwxx(getsohnverb(uuuwyu))FI ;IF getbruderverb(uuuwyu)<>uuuuuwTHEN uuuwxx(
getbruderverb(uuuwyu))FI ENDPROC uuuwxx;PROC auswertung(QUERY VAR uuuvyv):
queryart(uuuuvz);uuuvzw;uuuuyy:=0;forget(uuuuww);uuuuww:=nilspace;uuuuwx:=
uuuuww;uuuuwx:=uuuvyv;call(/name(1),uuuuvu,uuuuww,uuuuwu);uuuwuz;uuuvux:=
uuuuww;uuuuzy:=uuuvux.uuuuyuENDPROC auswertung;PROC auswertungfortsetzen:
uuuuyy:=0;forget(uuuuww);uuuuww:=nilspace;call(uuuuzy,uuuuvw,uuuuww,uuuuwu);
uuuwuz;uuuvux:=uuuuwwENDPROC auswertungfortsetzen;PROC uuuwuz:IF uuuuwu=
uuuuuzTHEN dbstatus(dberror);uuuuwy:=uuuuww;forget(uuuuww);errorstop(uuuuwy)
ELSE dbstatus(uuuuwu)FI ENDPROC uuuwuz;PROC qsucc(INT VAR uuuwyu,uuuyuz):
uuuuyyINCR 1;IF uuuuyy>uuuvux.uuuuxzTHEN uuuwyu:=0;uuuyuz:=0;dbstatus(
endoffile)ELSE uuuyuz:=uuuvux.uuuuyw[uuuuyy].uuuuxw;#uuuywz(uuuvux.uuuuyw[
uuuuyy].uuuuxy[uuuuux]);uuuyxz(uuuvux.uuuuyw[uuuuyy].uuuuxy[uuuuuy]);#
parsetupel(uuuyuz,uuuyzu);IF uuuyzvTHEN dbstatus(endofscan)ELSE dbstatus(ok)
FI FI .uuuyzu:uuuvux.uuuuyw[uuuuyy].uuuuxy.uuuyzv:uuuwyu:=uuuvux.uuuuyw[
uuuuyy].uuuuxv;IF uuuwyu<0THEN uuuwyu:=abs(uuuwyu);TRUE ELSE FALSE FI .
ENDPROC qsucc;ENDPACKET dbsndquery;#$FI #

