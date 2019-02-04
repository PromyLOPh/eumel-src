 PACKETqueryselektion DEFINES SELEKTION,#putoptyp,putrechts,putlinks,putselwert,#optyp,rechts,links,selwert,fnrlinks,fnrrechts,#allocselelement,#:=,checkselektion
,baueselektionauf,werteselektionaus,mittestausgaben,initselektionen,initsel,initialisiereselektion,lex,lexon,lexoff: LETuuuuuv=0,uuuuuw=1,uuuuux=2,uuuuuy=6,uuuuuz
=7,uuuuvu=8,uuuuvv=9,#uuuuvw=1,uuuuvx=3,#uuuuvy=2,uuuuvz=4,uuuuwu=5,uuuuwv=10,uuuuww=11,uuuuwx=12,uuuuwy=13,uuuuwz=14,uuuuxu=15,uuuuxv=16,uuuuxw=17,uuuuxx=18,uuuuxy
=19,uuuuxz=20,uuuuyu=30,uuuuyv=73,uuuuyw=82,uuuuyx=68,uuuuyy=84; TYPE NODE= STRUCT( INTuuuuyz,uuuuzu,uuuuzv, TEXTselwert); TYPE SELEKTION= STRUCT( INTuuuuzx, ROWuuuuyu
 NODEexp); INT VARuuuuzz,uuuvuu,uuuvuv; REAL VARuuuvuw,uuuvux; TEXT VARuuuvuy,uuuvuz; INT VARuuuvvu; TEXT VARuuuvvv:=""; BOOL VARuuuvvw:= FALSE,lexsort:= FALSE; BOOL
 PROClex:lexsort ENDPROClex; PROClexon:lexsort:= TRUE ENDPROClexon; PROClexoff:lexsort:= FALSE ENDPROClexoff; PROCmittestausgaben( BOOL CONSTuuuvwy):uuuvvw:=uuuvwy
 ENDPROCmittestausgaben; BOOL PROCmittestausgaben:uuuvvw ENDPROCmittestausgaben; OP:=( NODE VARuuuvxz, NODE CONSTuuuvyu): CONCR(uuuvxz):= CONCR(uuuvyu) ENDOP:=; OP
:=( SELEKTION VARuuuvxz, SELEKTION CONSTuuuvyu): CONCR(uuuvxz):= CONCR(uuuvyu) ENDOP:=; PROCinitsel( SELEKTION VARuuuvzw):uuuvzw.uuuuzx:=0 ENDPROCinitsel; PROCinitselektionen
( SELEKTION VARuuuwuv): INT VARuuuwuw; FORuuuwuw FROM1 UPTOuuuuyu REPuuuwuv.exp[uuuwuw].selwert:="" PER ENDPROCinitselektionen; PROCinitialisiereselektion( SELEKTION
 VARuuuvzw):initsel(uuuvzw);initselektionen(uuuvzw) ENDPROCinitialisiereselektion; PROCuuuwwy( SELEKTION VARuuuvzw, INT CONSTuuuwxu):uuuvzw.exp[uuuwxu].uuuuyz:=uuuuxy
;uuuvzw.exp[uuuwxu].uuuuzv:=0;uuuvzw.exp[uuuwxu].uuuuzu:=0;uuuvzw.exp[uuuwxu].selwert:="" ENDPROCuuuwwy; INT PROCallocselelement( SELEKTION VARuuuvzw):uuuvzw.uuuuzx
 INCR1;uuuwwy(uuuvzw,uuuvzw.uuuuzx);uuuvzw.uuuuzx ENDPROCallocselelement; PROCputoptyp( SELEKTION VARuuuvzw, INT CONSTuuuxvy,optyp):uuuvzw.exp[uuuxvy].uuuuyz:=optyp
 ENDPROCputoptyp; PROCuuuxwz( SELEKTION VARuuuvzw, INT CONSTuuuxvy,uuuxxw):uuuvzw.exp[uuuxvy].uuuuzv:=uuuxxw ENDPROCuuuxwz; PROCputrechts( SELEKTION VARuuuvzw, INT
 CONSTuuuxvy,uuuxyz):uuuvzw.exp[uuuxvy].uuuuzv:=uuuxyz ENDPROCputrechts; PROCuuuxzz( SELEKTION VARuuuvzw, INT CONSTuuuxvy,uuuxxw):uuuvzw.exp[uuuxvy].uuuuzu:=uuuxxw
 ENDPROCuuuxzz; PROCputlinks( SELEKTION VARuuuvzw, INT CONSTuuuxvy,uuuwuw):uuuvzw.exp[uuuxvy].uuuuzu:=uuuwuw ENDPROCputlinks; PROCputselwert( SELEKTION VARuuuvzw,
 INT CONSTuuuxvy, TEXT CONSTuuuyxw):uuuvzw.exp[uuuxvy].selwert:=uuuyxw ENDPROCputselwert; INT PROCoptyp( SELEKTION VARuuuvzw, INT CONSTuuuxvy):uuuvzw.exp[uuuxvy].
uuuuyz ENDPROCoptyp; INT PROCfnrrechts( SELEKTION VARuuuvzw, INT CONSTuuuxvy):uuuvzw.exp[uuuxvy].uuuuzv ENDPROCfnrrechts; INT PROCfnrlinks( SELEKTION VARuuuvzw, INT
 CONSTuuuxvy):uuuvzw.exp[uuuxvy].uuuuzu ENDPROCfnrlinks; INT PROCrechts( SELEKTION CONSTuuuvzw, INT CONSTuuuxvy):uuuvzw.exp[uuuxvy].uuuuzv ENDPROCrechts; INT PROC
links( SELEKTION CONSTuuuvzw, INT CONSTuuuxvy):uuuvzw.exp[uuuxvy].uuuuzu ENDPROClinks; TEXT PROCselwert( SELEKTION VARuuuvzw, INT CONSTuuuxvy):uuuvzw.exp[uuuxvy].
selwert ENDPROCselwert; INT PROCbaueselektionauf( SELEKTION VARuuuzzx, TEXT CONSTuuuzzy): IFcompress(uuuzzy)<>"" THENscan(uuuzzy);uuvuuv(uuuzzx) ELSE0 FI ENDPROCbaueselektionauf
; INT PROCuuvuuv( SELEKTION VARuuuzzx): INT VARuuuwuw,uuvuvv;uuuwuw:=uuvuvx(uuuzzx);nextsymbol; IFuuvuvz=uuuuxx ORuuvuvz=uuuuxv THENuuvuvv:=allocselelement(uuuzzx
);putoptyp(uuuzzx,uuvuvv,uuvuvz);putlinks(uuuzzx,uuvuvv,uuuwuw);putrechts(uuuzzx,uuvuvv,uuvuuv(uuuzzx));uuvuvv ELSEuuuwuw FI ENDPROCuuvuuv; INT PROCuuvuvx( SELEKTION
 VARuuuzzx): INT VARuuvvuu;nextsymbol; SELECTuuvuvz OF CASEuuuuuw:uuvvuu:=uuvuuv(uuuzzx);#nextsymbol;# IFuuvuvz<>uuuuux THENerrorstop("Klammer zu fehlt! Gefunden: "
+uuuvvv) FI; CASEuuuuxw:uuvvuu:=allocselelement(uuuzzx);putoptyp(uuuzzx,uuvvuu,uuvuvz);putlinks(uuuzzx,uuvvuu,uuvuvx(uuuzzx)); CASEuuuuuy: CASEuuuuvu:uuvvuu:=allocselelement
(uuuzzx);uuvvyx;uuvvyy;nextsymbol;uuvvyz CASEuuuuvv:uuvvuu:=allocselelement(uuuzzx);uuvvzy;uuvvzz;uuvwuu CASEuuuuuz: OTHERWISE:errorstop("Falsches Symbol: "+uuuvvv
+text(uuuvvu)) ENDSELECT;uuvvuu.uuvvyx:nextsymbol; IFuuuvvu<>uuuuvz THENuuvwvw("Falsche Wertangabe") ELSEputselwert(uuuzzx,uuvvuu,uuuvvv);nextsymbol; IFuuuvvu<>uuuuwu
 CANDuuuvvv<>">" THENuuvwvw(""">"" bei Wertangabe fehlt!") FI FI.uuvvzz:nextsymbol; IFuuuvvu<>uuuuwu THENuuvwvw("Falscher Operator: "+uuuvvv) FI;putoptyp(uuuzzx,uuvvuu
,uuvwyv).uuvvyy:nextsymbol; IF(uuuvvu=uuuuwu) COR(uuuvvu=uuuuvy CANDuuuvvv="IN") THENputoptyp(uuuzzx,uuvvuu,uuvwyv) ELSEuuvwvw("Falscher Operator: "+uuuvvv) FI;.uuvvyz
:uuuxwz(uuuzzx,uuvvuu,feldnr(uuuvvv)).uuvvzy:uuuxzz(uuuzzx,uuvvuu,feldnr(uuuvvv)).uuvwuu:nextsymbol; IFuuvuvz=uuuuvu THENuuvvyx ELSEuuvvyz FI. ENDPROCuuvuvx; INT PROC
uuvwyv: IFuuuvvv=">" THENuuuuwz ELIFuuuvvv="<" THENuuuuxu ELIFuuuvvv="=" THENuuuuwv ELIFuuuvvv=">=" THENuuuuwy ELIFuuuvvv="<=" THENuuuuwx ELIFuuuvvv="<>" THENuuuuww
 ELIFuuuvvv="IN" THENuuuuxz ELSEuuuuxy FI ENDPROCuuvwyv; PROCnextsymbol:nextsymbol(uuuvvv,uuuvvu) ENDPROCnextsymbol; INT PROCuuvuvz: IFuuuvvv="(" THENuuuuuw ELIFuuuvvv
=")" THENuuuuux ELIFuuuvvv="NOT" ORuuuvvv="NICHT" THENuuuuxw ELIFuuuvvv="AND" ORuuuvvv="UND" THENuuuuxv ELIFuuuvvv="OR" ORuuuvvv="ODER" THENuuuuxx ELIFuuuvvu=13 THEN
uuuuuy ELIFuuuvvu=uuuuwu CANDuuuvvv="<" THENuuuuvu ELIFuuuvvu=uuuuvz THENuuuuvv ELIFuuuvvu=7 THENuuuuuz ELSEuuuuuv FI ENDPROCuuvuvz; PROCuuvwvw( TEXT CONSTuuvyyz)
:errorstop("FEHLERHAFTER AUSDRUCK: "+uuvyyz) ENDPROCuuvwvw; PROCcheckselektion( SELEKTION CONSTuuuzzx): INT VARuuvyzy,uuvyzz:=uuuzzx.uuuuzx;note("Anzahl Knoten: "
+text(text(uuvyzz),5));noteline;noteline;noteline; FORuuvyzy FROM1 UPTOuuvyzz REPnote("Knoten: "+text(uuvyzy));noteline;note("     Operat: "+uuvzvu(uuuzzx.exp[uuvyzy
]));noteline;note("     links : "+text(links(uuuzzx,uuvyzy)));noteline;note("     rechts: "+text(rechts(uuuzzx,uuvyzy)));noteline;note("     Wert  : "+">"+uuuzzx.
exp[uuvyzy].selwert+"<");noteline PER ENDPROCcheckselektion; TEXT PROCuuvzvu( NODE CONSTuuuvzw): SELECTuuuvzw.uuuuyz OF CASEuuuuwv:"=" CASEuuuuww:"<>" CASEuuuuwx:
"<=" CASEuuuuwy:">=" CASEuuuuwz:">" CASEuuuuxu:"<" CASEuuuuxw:"NOT" CASEuuuuxv:"AND" CASEuuuuxx:"OR" CASEuuuuxz:"IN" OTHERWISE:"UNDEFINED OPERATOR" ENDSELECT ENDPROC
uuvzvu; BOOL PROCwerteselektionaus( SELEKTION VARuuuvzw, INT CONSTuuvyzy): IFuuvyzy=0 THEN LEAVEwerteselektionaus WITH TRUE FI;uuwuux; SELECTuuwuuy OF CASEuuuuxx:
uuwuvu ORuuwuvv CASEuuuuxv:uuwuvu ANDuuwuvv CASEuuuuxw: NOTuuwuvu CASEuuuuwx:uuwuww CASEuuuuwy:uuwuwy CASEuuuuww:uuwuxu CASEuuuuwv:uuwuxw CASEuuuuxu:uuwuxy CASEuuuuwz
:uuwuyu CASEuuuuxz:uuwuyw OTHERWISE: FALSE ENDSELECT.uuwuvu:werteselektionaus(uuuvzw,links(uuuvzw,uuvyzy)).uuwuvv:werteselektionaus(uuuvzw,rechts(uuuvzw,uuvyzy)).
uuwuux: IFuuwuuy=uuuuxx CORuuwuuy=uuuuxv CORuuwuuy=uuuuxw THEN LEAVEuuwuux ELSEuuwvvz;uuwvwu FI.uuwvvz: IFfnrlinks(uuuvzw,uuvyzy)=0 THEN SELECTuuwvwz OF CASEuuuuyv
:uuuvuu:=int(selwert(uuuvzw,uuvyzy));uuuuzz:=uuuuyv CASEuuuuyw:uuuvuw:=real(selwert(uuuvzw,uuvyzy));uuuuzz:=uuuuyw CASEuuuuyx:uuuvuw:=date(selwert(uuuvzw,uuvyzy))
;uuuuzz:=uuuuyw OTHERWISE:uuuvuy:=selwert(uuuvzw,uuvyzy);uuuuzz:=uuuuyy ENDSELECT ELSE SELECTfeldtyp(fnrlinks(uuuvzw,uuvyzy)) OF CASEuuuuyv:uuuvuu:=intwert(fnrlinks
(uuuvzw,uuvyzy));uuuuzz:=uuuuyv CASEuuuuyw:uuuvuw:=realwert(fnrlinks(uuuvzw,uuvyzy));uuuuzz:=uuuuyw CASEuuuuyx:uuuvuw:=date(datumwert(fnrlinks(uuuvzw,uuvyzy)));uuuuzz
:=uuuuyw OTHERWISE:uuuvuy:=wert(fnrlinks(uuuvzw,uuvyzy));uuuuzz:=uuuuyy ENDSELECT FI.uuwvwu: IFfnrrechts(uuuvzw,uuvyzy)=0 THEN SELECTuuwxvv OF CASEuuuuyv:uuuvuv:=
int(selwert(uuuvzw,uuvyzy)) CASEuuuuyw:uuuvux:=real(selwert(uuuvzw,uuvyzy)) CASEuuuuyx:uuuvux:=date(selwert(uuuvzw,uuvyzy)) OTHERWISE:uuuvuz:=selwert(uuuvzw,uuvyzy
) ENDSELECT ELSE SELECTfeldtyp(fnrrechts(uuuvzw,uuvyzy)) OF CASEuuuuyv:uuuvuv:=intwert(fnrrechts(uuuvzw,uuvyzy)) CASEuuuuyw:uuuvux:=realwert(fnrrechts(uuuvzw,uuvyzy
)) CASEuuuuyx:uuuvux:=date(datumwert(fnrrechts(uuuvzw,uuvyzy))) OTHERWISE:uuuvuz:=wert(fnrrechts(uuuvzw,uuvyzy)) ENDSELECT FI.uuwxvv: IFfnrlinks(uuuvzw,uuvyzy)=0 THEN
uuuuyy ELSEfeldtyp(fnrlinks(uuuvzw,uuvyzy)) FI.uuwvwz: IFfnrrechts(uuuvzw,uuvyzy)=0 THENuuuuyy ELSEfeldtyp(fnrrechts(uuuvzw,uuvyzy)) FI.uuwuuy:optyp(uuuvzw,uuvyzy
). ENDPROCwerteselektionaus; BOOL PROCuuwuww: SELECTuuuuzz OF CASEuuuuyv:uuuvuu<=uuuvuv CASEuuuuyw:uuuvuw<=uuuvux OTHERWISE:uuuvuy<=uuuvuz ENDSELECT ENDPROCuuwuww
; BOOL PROCuuwuwy: SELECTuuuuzz OF CASEuuuuyv:uuuvuu>=uuuvuv CASEuuuuyw:uuuvuw>=uuuvux OTHERWISE:uuuvuy>=uuuvuz ENDSELECT ENDPROCuuwuwy; BOOL PROCuuwuxy: SELECTuuuuzz
 OF CASEuuuuyv:uuuvuu<uuuvuv CASEuuuuyw:uuuvuw<uuuvux OTHERWISE: IFlexsort THEN NOT(uuuvuy LEXGREATEREQUALuuuvuz) ELSEuuuvuy<uuuvuz FI ENDSELECT ENDPROCuuwuxy; BOOL
 PROCuuwuyu: SELECTuuuuzz OF CASEuuuuyv:uuuvuu>uuuvuv CASEuuuuyw:uuuvuw>uuuvux OTHERWISE: IFlexsort THENuuuvuy LEXGREATERuuuvuz ELSEuuuvuy>uuuvuz FI ENDSELECT ENDPROC
uuwuyu; BOOL PROCuuwuxw: SELECTuuuuzz OF CASEuuuuyv:uuuvuu=uuuvuv CASEuuuuyw:uuuvuw=uuuvux OTHERWISE: IFlexsort THENuuuvuy LEXEQUALuuuvuz ELSEuuuvuy=uuuvuz FI ENDSELECT
 ENDPROCuuwuxw; BOOL PROCuuwuxu: SELECTuuuuzz OF CASEuuuuyv:uuuvuu<>uuuvuv CASEuuuuyw:uuuvuw<>uuuvux OTHERWISE: IFlexsort THEN NOT(uuuvuy LEXEQUALuuuvuz) ELSEuuuvuy
<>uuuvuz FI ENDSELECT ENDPROCuuwuxu; BOOL PROCuuwuyw: IFuuuuzz=uuuuyy THENpos(uuuvuz,uuuvuy)>0 ELSE FALSE FI ENDPROCuuwuyw; ENDPACKETqueryselektion;

