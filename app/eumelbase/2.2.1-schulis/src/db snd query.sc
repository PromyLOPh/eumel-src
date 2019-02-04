#$ IFmitinternerquery THEN# PACKETdbsndquery DEFINESauswertung,auswertungfortsetzen,qsucc,endofscan,ordernewstack,puttiefennr,gettiefennr,endqueryserver: LETuuuuuv
=25,uuuuuw=0,uuuuux=1,uuuuuy=2,uuuuuz=2,uuuuvu=37,uuuuvv=10,uuuuvw=39,uuuuvx=40,uuuuvy=41,uuuuvz=1; INT CONSTendofscan:=8,ordernewstack:=9; INT VARuuuuwu,uuuuwv; DATASPACE
 VARuuuuww; BOUND QUERY VARuuuuwx; BOUND TEXT VARuuuuwy; ROWuuuuvv INT VARuuuuxu; TYPE TUPEL= STRUCT( INTuuuuxv,uuuuxw,uuuuxx, TEXTuuuuxy); TYPE QUERYSTACK= STRUCT
( INTuuuuxz, TASKuuuuyu, ROWuuuuuv TUPELuuuuyw); INT VARuuuuyx:=getanzahltupel,uuuuyy; TEXT VARuuuuyz:="",uuuuzu:=""; PROCendqueryserver:forget(uuuuww);uuuuww:=nilspace
;send(uuuuzy,uuuuvx,uuuuww) ENDPROCendqueryserver; TASK VARuuuuzy; BOUND QUERYSTACK VARuuuvux; OP:=( TUPEL VARuuuvuy, TUPEL CONSTuuuvuz): CONCR(uuuvuy):= CONCR(uuuvuz
) ENDOP:=; OP:=( QUERYSTACK VARuuuvuy, QUERYSTACK CONSTuuuvuz): CONCR(uuuvuy):= CONCR(uuuvuz) ENDOP:=; INT PROCgettiefennr( INT CONSTuuuvwv): IFuuuvwv=0 THEN0 ELSE
uuuuxu[uuuvwv] FI ENDPROCgettiefennr; PROCputtiefennr( INT CONSTuuuvwv,uuuvxw):uuuuxu[uuuvwv]:=uuuvxw ENDPROCputtiefennr; PROCauswertung( TEXT CONSTuuuvyv):uuuuyy
:=0;query(uuuvyv); IFqueryart=uuuuvz THENuuuvyz ELSEuuuvzu FI.uuuvyz:uuuvzw;forget(uuuuww);uuuuww:=nilspace;uuuuwx:=uuuuww;getquery(uuuuwx);call(/name(1),uuuuvu,uuuuww
,uuuuwu);uuuwuz;uuuvux:=uuuuww;uuuuzy:=uuuvux.uuuuyu.uuuvzu:forget(uuuuww);uuuuww:=old(uuuvyv);call(/name(1),uuuuvy,uuuuww,uuuuwu);uuuwuz. ENDPROCauswertung; PROC
uuuvzw:uuuuwv:=0;uuuwxx(1) ENDPROCuuuvzw; PROCuuuwxx( INT CONSTuuuwyu):uuuuwv INCR1;puttiefennr(uuuwyu,uuuuwv); IFgetsohnverb(uuuwyu)<>uuuuuw THENuuuwxx(getsohnverb
(uuuwyu)) FI; IFgetbruderverb(uuuwyu)<>uuuuuw THENuuuwxx(getbruderverb(uuuwyu)) FI ENDPROCuuuwxx; PROCauswertung( QUERY VARuuuvyv):queryart(uuuuvz);uuuvzw;uuuuyy:=
0;forget(uuuuww);uuuuww:=nilspace;uuuuwx:=uuuuww;uuuuwx:=uuuvyv;call(/name(1),uuuuvu,uuuuww,uuuuwu);uuuwuz;uuuvux:=uuuuww;uuuuzy:=uuuvux.uuuuyu ENDPROCauswertung;
 PROCauswertungfortsetzen:uuuuyy:=0;forget(uuuuww);uuuuww:=nilspace;call(uuuuzy,uuuuvw,uuuuww,uuuuwu);uuuwuz;uuuvux:=uuuuww ENDPROCauswertungfortsetzen; PROCuuuwuz
: IFuuuuwu=uuuuuz THENdbstatus(dberror);uuuuwy:=uuuuww;forget(uuuuww);errorstop(uuuuwy) ELSEdbstatus(uuuuwu) FI ENDPROCuuuwuz; PROCqsucc( INT VARuuuwyu,uuuyuz):uuuuyy
 INCR1; IFuuuuyy>uuuvux.uuuuxz THENuuuwyu:=0;uuuyuz:=0;dbstatus(endoffile) ELSEuuuyuz:=uuuvux.uuuuyw[uuuuyy].uuuuxw;#uuuywz(uuuvux.uuuuyw[uuuuyy].uuuuxy[uuuuux]);
uuuyxz(uuuvux.uuuuyw[uuuuyy].uuuuxy[uuuuuy]);#parsetupel(uuuyuz,uuuyzu); IFuuuyzv THENdbstatus(endofscan) ELSEdbstatus(ok) FI FI.uuuyzu:uuuvux.uuuuyw[uuuuyy].uuuuxy
.uuuyzv:uuuwyu:=uuuvux.uuuuyw[uuuuyy].uuuuxv; IFuuuwyu<0 THENuuuwyu:=abs(uuuwyu); TRUE ELSE FALSE FI. ENDPROCqsucc; ENDPACKETdbsndquery;#$ FI#

