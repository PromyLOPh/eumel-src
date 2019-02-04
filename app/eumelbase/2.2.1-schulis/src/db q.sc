#$ IFmitinternerquery THEN# PACKETqueryparser DEFINES QUERY,query,getscanbedingung,getdnr,getinr,getanzahlverbunde,getselpointer,getstopbedpointer,getquery,putquery
,setzeschluessel,getanzahltupel,getswanzfld,getswnachfld,getswvonfld,getswallefelder,getswfwert,getsohnverb,getbruderverb,geterstestupel,puterstestupel,selektionerfuellt
,initquery,:=,baumdurchlauf,listeschluessel,putletzterverbund,getletzterverbund,puttid,gettid,getbruder,putbruder,tidfeld,updatefnr,updateausdruck,queryart,anzupdatefelder
: TYPE UPDSTACK= STRUCT( INTuuuuuv, TEXTuuuuuw); BOUND ROW100 UPDSTACK VARuuuuux; TYPE VERBELEMENT= STRUCT( TEXTuuuuuy,uuuuuz, BOOLuuuuvu, INTuuuuvv,uuuuvw,uuuuvx
,uuuuvy,uuuuvz,uuuuwu); TYPE VERBUND= ROWuuuuwv VERBELEMENT; TYPE QUERY= STRUCT( INTuuuuww,uuuuwx,uuuuwy, TEXTuuuuwz,uuuuxu, SELEKTIONuuuuxv, VERBUNDuuuuxw, SCHLUESSEL
uuuuxx); TYPE SWERT= STRUCT( INTuuuuxy,uuuuxz, TEXTwert); TYPE SCHLUESSELWERTE= STRUCT( BOOLuuuuyu, INTuuuuyv, ROWuuuuyw SWERTuuuuyx); TYPE SCHLUESSEL= ROWuuuuwv SCHLUESSELWERTE
; LETuuuuyz=0,uuuuzu=1,uuuuzv=2,uuuuzw=3,uuuuzx=6,uuuuzy=5,uuuuzz=7,uuuvuu=7,uuuvuv=4,uuuvuw="BY",uuuvux="UPDATE",uuuvuy="DELETE",uuuvuz=".query",uuuvvu=";",uuuvvv
="(",uuuvvw=")",#uuuvvx=",",uuuvvy="=",uuuvvz=">=",uuuvwu="<=",#uuuvwv="/",uuuvww="""",uuuvwx=".",uuuvwy=":",uuuvwz=" ",uuuvxu=":=",uuuvxv="<",uuuuwv=10,uuuvxx=20
,uuuuyw=10,uuuvxz=80,uuuvyu=1,uuuvyv=2,uuuvyw=3; INT VARuuuvyx:=-5,uuuvyy:=-33,uuuvyz; DATASPACE VARuuuvzu:=nilspace; INT VARuuuvzv:=0; INT PROCtidfeld:uuuvyy ENDPROC
tidfeld; FILE VARuuuvzz; TEXT VARuuuwuu:="",uuuwuv:="",uuuwuw:="",uuuwux:=""; INT VARuuuwuy,uuuwuz,uuuwvu; BOOL VARuuuwvv,uuuwvw; INT VARuuuwvx:=0,uuuwvy,uuuwvz; ROW
uuuvxx TEXT VARuuuwwv; OP:=( QUERY VARuuuwww, QUERY CONSTuuuwwx): CONCR(uuuwww):= CONCR(uuuwwx) ENDOP:=; OP:=( VERBELEMENT VARuuuwww, VERBELEMENT CONSTuuuwwx): CONCR
(uuuwww):= CONCR(uuuwwx) ENDOP:=; OP:=( VERBUND VARuuuwww, VERBUND CONSTuuuwwx): CONCR(uuuwww):= CONCR(uuuwwx) ENDOP:=; INT PROCupdatefnr( INT CONSTuuuwyx):uuuuux
[uuuwyx].uuuuuv ENDPROCupdatefnr; TEXT PROCupdateausdruck( INT CONSTuuuwyx):uuuuux[uuuwyx].uuuuuw ENDPROCupdateausdruck; INT PROCqueryart:uuuvzv ENDPROCqueryart; PROC
queryart( INT CONSTuuuxvu):uuuvzv:=uuuxvu ENDPROCqueryart; INT PROCanzupdatefelder:uuuvyz ENDPROCanzupdatefelder; PROCinitquery( QUERY VARuuuxww):uuuxwx;uuuxww.uuuuww
:=0;uuuxww.uuuuwx:=0;uuuxww.uuuuwz:="";uuuxww.uuuuxu:="";initselektionen(uuuxww.uuuuxv);uuuxyw(uuuxww.uuuuxw);uuuxyz(uuuxww.uuuuxx) ENDPROCinitquery; PROCuuuxwx:forget
(uuuvzu);uuuvzu:=nilspace;uuuuux:=uuuvzu ENDPROCuuuxwx;initquery(uuuyuy); PROCuuuxyw( VERBUND VARuuuyvu): FORuuuwvy FROM1 UPTOuuuuwv REPuuuyvx(uuuyvu[uuuwvy]) PER
 ENDPROCuuuxyw; PROCuuuyvx( VERBELEMENT VARuuuyww):uuuyww.uuuuuy:="";uuuyww.uuuuuz:="" ENDPROCuuuyvx;# BOUND QUERY VARuuuyuy;# QUERY VARuuuyuy; PROCgetquery( QUERY
 VARuuuxww): CONCR(uuuxww):= CONCR(uuuyuy) ENDPROCgetquery; PROCputquery( QUERY CONSTuuuxww): CONCR(uuuyuy):= CONCR(uuuxww) ENDPROCputquery; PROCquery:query(lastparam
) ENDPROCquery; PROCuuuyzz( TEXT CONSTuuuzuu): TEXT VARuuuzuv:="",uuuzuw:="",uuuzux:="",uuuwuv:=""; INT VARuuuzuz;uuuxwx;uuuzvv;nextsymbol;queryparser(uuuzvx);uuuzvy
;uuuzvz;uuuzwu;uuuzwv;baumdurchlauf;.uuuzvy:nextsymbol; WHILEuuuwuy<>uuuuzz REPuuuzxu;nextsymbol PER.uuuzxu:uuuzuw:=""; IFuuuwuy<>uuuuzu THENuuuzxz("Refinementname erwartet: "
+uuuwuu) ELSEuuuzuv:=uuuwuu;nextsymbol; IFuuuwuu<>uuuvwy THENuuuzxz(uuuvww+uuuvwy+uuuvww+" erwartet: "+uuuwuu) ELSEuuuzzy;putref(uuuzuv,uuuzuw) FI FI.uuuzzy:nextsymbol
; WHILEuuuwuy<>uuuuzz CANDuuuwuu<>uuuvwx REPuuuzuw:=uuuzuw+uuvuvw;nextsymbol PER; IFuuuwuy=uuuuzz THENuuuzxz("Refinement nicht mit ""."" abgeschlossen") FI.uuuzvv
:enablestop;uuuvzz:=sequentialfile(input,uuuzuu); IFexists(uuuzuu+uuuvuz) THENforget(uuuzuu+uuuvuz,quiet) FI;#uuuyuy:=new(uuuzuu+uuuvuz);#lastparam(uuuzuu);uuvuxz
(0);uuuwvx:=0;clearrefs;scan(uuuvzz);.uuuzwu: FORuuuzuz FROM1 UPTOuuuwvx REPuuuzux:="";uuuwuv:=uuvuzv(uuuzuz);scan(uuuwuv);nextsymbol(uuuwuu,uuuwuy); WHILEuuuwuy<>
uuuuzz REP IFuuuwuy=uuuuzu THENuuuzux:=uuuzux+getreftext(uuuwuu) ELSEuuuzux:=uuuzux+uuvuvw FI;nextsymbol(uuuwuu,uuuwuy) PER;uuvvwu(uuuzux,uuuzuz) PER.uuuzwv: INT VAR
uuvvwy;initsel(uuuyuy.uuuuxv); FORuuuzuz FROM1 UPTOgetanzahlverbunde REPuuvvxx;uuvvxy PER.uuvvxx:uuvvwy:=getstopbedpointer(uuuzuz); IFuuvvwy>uuuuyz THENuuuwuv:=uuvuzv
(uuvvwy);uuvvzw(baueselektionauf(uuuyuy.uuuuxv,uuuwuv),uuuzuz) FI.uuvvxy:uuvvwy:=getselpointer(uuuzuz); IFuuvvwy>uuuuyz THENuuuwuv:=uuvuzv(uuvvwy);uuvwvy(baueselektionauf
(uuuyuy.uuuuxv,uuuwuv),uuuzuz) FI. ENDPROCuuuyzz; PROCuuuzvz: INT VARuuuzuz:=1; BOOL VARuuvwxu:= FALSE; TEXT VARuuuzux:=""; WHILEuuuzuz<=getanzahlverbunde REPuuuzux
:="";uuuwuv:=getscanbedingung(uuuzuz);scan(uuuwuv);nextsymbol(uuuwuu,uuuwuy); WHILEuuuwuy<>uuuuzz REP IFuuuwuy=uuuuzu THENuuuzux:=uuuzux+getreftext(uuuwuu) ELSEuuuzux
:=uuuzux+uuvuvw FI;nextsymbol(uuuwuu,uuuwuy) PER; IFgetdnr(uuuzuz)=uuuvyx THENqueryparser(uuuzux,uuuzuz);uuvwxu:= TRUE ELSEuuvxwu(uuuzux,uuuzuz) FI;uuuzuz INCR1 PER
; IFuuvwxu THENuuuzvz FI ENDPROCuuuzvz; PROCqueryparser( TEXT CONSTuuuwuv, INT CONSTuuvxxx): INT VARuuvxxy;scan(uuuwuv);nextsymbol;uuvxyu;queryparser(uuvxxx);uuvxyx
.uuvxyu:uuvxxy:=getbruderverb(uuvxxx);.uuvxyx:uuvxzx(uuvxxy,uuvxxx). ENDPROCqueryparser; PROCqueryparser( INT CONSTuuvxxx): TEXT VARuuvyux:=""; BOOL VARuuvyuy:= FALSE
;uuuvzv:=0; REPuuvyvu; UNTILuuvyuy PER;uuvyvw;uuvyvx;uuvyvy;uuvyvz; SELECTuuuvzv OF CASEuuuvyv,uuuvyu:uuvywx; IFuuvxxx=1 THENuuvywz FI CASEuuuvyw:uuvyxv ENDSELECT
.uuvyvu: IFuuuwuy=uuuvuv THENuuvyxz(dateinr(uuuwuu),uuvxxx); IFuuuvzv<1 THENuuuvzv:=uuuvyu FI;uuvyuy:= TRUE ELSE IFuuuwuy=uuuuzv THEN IFuuuwuu=uuuvux THENnextsymbol
;uuuvzv:=uuuvyw ELIFuuuwuu=uuuvuy THENnextsymbol;uuuvzv:=uuuvyv ELSEuuuzxz("Dateiname nicht gefunden: "+uuuwuu) FI FI FI.uuvyvw:nextsymbol; IFuuuwuy=uuuuzv CANDuuuwuu
=uuuvuw THENuuvzvz;uuvzwu ELSE IFuuuwuy=uuuuzx CANDuuuwuu=uuuvvv THENuuvzwz(#getdnr(uuvxxx)#0,uuvxxx) ELSEuuuzxz("Indexname bzw. ""("" fehlt") FI FI.uuvzvz:nextsymbol
; IFuuuwuy=uuuvuv THENuuvzwz(indexnr(uuuwuu),uuvxxx) ELSEuuuzxz("Indexname nicht gefunden: "+uuuwuu) FI.uuvzwu:nextsymbol; IF NOT(uuuwuy=uuuuzx CANDuuuwuu=uuuvvv)
 THENuuuzxz(uuuvww+uuuvvv+uuuvww+" erwartet") FI.uuvyvx:uuwuuy(uuuwuv);uuvxwu(uuuwuv,uuvxxx);.uuvyvy: BOOL VARstop:= TRUE;uuwuvy.uuvyvz:stop:= FALSE;uuwuvy.uuwuvy
: INT VARuuvvwy;uuuwuw:=""; IF NOTuuuwvv THENuuwuuy(uuuwuw); IFuuuwuw="" THEN IFstop THENuuvvzw(uuuuyz,uuvxxx) ELSEuuvwvy(uuuuyz,uuvxxx) FI ELSEuuvvwy:=uuwuyx; IF
stop THENuuvvzw(uuvvwy,uuvxxx) ELSEuuvwvy(uuvvwy,uuvxxx) FI;uuvvwu(uuuwuw,uuvvwy) FI ELSEuuvwvy(uuuuyz,uuvxxx) FI.uuvywx: INT VARuuwvuz; IF NOTuuuwvv THENuuwvvv(uuvxxx
,uuwvuz);uuwvvy(uuwvuz,uuvxxx);uuvxzx(uuuuyz,uuvxxx) FI.uuvywz:nextsymbol; IFuuuwuy=uuuuzx ORuuuwuy=uuuuzz ORuuuwuy=uuuuzy THEN IFuuuwuu<>uuuvwv THENuuwvyv FI;uuuuwx
;uuwvyx ELSEuuuzxz(uuuvww+uuuvwv+uuuvww+" bzw. "+uuuvww+uuuvvu+uuuvww+uuuvwv+uuuvww+uuuvwx+uuuvww+" erwartet") FI.uuwvyv: IFuuuwuu=uuuvvu ORuuuwuu=uuuvwx ORuuuwuy
=uuuuzz THENuuwwvy(0); LEAVEuuvywz ELSEuuuzxz("Falscher Tupelzahl-Operator: "+uuuwuu) FI.uuuuwx:nextsymbol; IFuuuwuy=uuuuzw THENuuwwvy(int(uuuwuu)); ELSEuuuzxz("Keine Zahlenangabe: "
+uuuwuu) FI.uuwvyx:nextsymbol; IFuuuwuy<>uuuuzz CAND( NOT(uuuwuu=uuuvvu CORuuuwuu=uuuvwx)) THENuuuzxz("""."" oder "";"" erwartet") FI.uuvyxv:uuuvyz:=0;nextsymbol;
 WHILE NOTuuuwvv REPuuuvyz INCR1;uuwwzx;uuwwzy;uuwwzz; PER.uuwwzx: IFuuuwuy=uuuuzu THENuuwxux ELSEuuwxuy FI.uuwxux:uuuzxz("Zur Zeit keine Refinements in Update-Liste erlaubt!"
).uuwxuy:uuuuux[uuuvyz].uuuuuv:=feldnr(uuuwuu); IFuuuuux[uuuvyz].uuuuuv<3 THENuuuzxz("Falscher Feldname: "+uuuwuu) FI;nextsymbol.uuwwzy: IF NOT(uuuwuy=uuuuzy CAND
uuuwuu=uuuvxu) THENuuuzxz("Keine Zuweisung: "+uuuwuu) FI.uuwwzz:uuwxyv(uuvyux);uuuuux[uuuvyz].uuuuuw:=uuvyux;nextsymbol. ENDPROCqueryparser; PROCuuwxyv( TEXT VARuuwxzx
): INT VARuuwxzy:=0,uuwxzz:=0;uuwxzx:="";uuuwuu:="";uuuwuy:=0; REPuuwxzx:=uuwxzx+uuvuvw;uuwxzy:=uuuwuy;nextsymbol UNTILuuwyvw PER.uuwyvw: IF(uuuwuy=uuuuzx CAND(uuuwuu
=uuuvvu COR(uuuwuu=uuuvvw CANDuuwxzz=0))) THENuuuwvv:=uuuwuu=uuuvvw; TRUE ELSE IFuuuwuy=uuuuzz THENuuuzxz("Vorzeitiges END OF FILE!"); FALSE ELSE IFuuuwuy=uuuuzx THEN
 IFuuuwuu=uuuvvv THENuuwxzz INCR1 FI; IFuuuwuu=uuuvvw THENuuwxzz DECR1 FI; FI; FALSE FI FI. ENDPROCuuwxyv; PROCuuwvvv( INT CONSTuuvxxx, INT VARuuwvuz): INT VARuuwyzz
:=uuuuyz;uuwvuz:=uuuuyz;nextsymbol; IFuuuwuy=uuuuzx CANDuuuwuu=uuuvvw THENuuuwvv:= TRUE; LEAVEuuwvvv ELIFuuuwuy=uuuuzu THENuuwvuz:=uuuzvx;uuvxwu(uuuwuu,uuwvuz);uuvwvy
(uuuuyz,uuwvuz);uuvyxz(uuuvyx,uuwvuz);uuwvvv(uuwvuz,uuwyzz);uuvxzx(uuwyzz,uuwvuz) ELIFuuuwuy=uuuvuv THENuuwvuz:=uuuzvx;queryparser(uuwvuz);uuuwvv:= FALSE;uuwvvv(uuwvuz
,uuwyzz);uuvxzx(uuwyzz,uuwvuz) ELIF(uuuwuy=uuuuzx CANDuuuwuu=uuuvvu) THENuuwvvv(uuvxxx,uuwvuz) ELSEuuuzxz("Verbund-Fehler bei : "+uuuwuu) FI ENDPROCuuwvvv; PROCuuwuuy
( TEXT VARuuwxzx): INT VARuuwxzy:=0;uuwxzx:="";uuuwuu:="";uuuwuy:=0;uuuwvv:= FALSE; REPuuwxzx:=uuwxzx+uuvuvw;uuwxzy:=uuuwuy;nextsymbol UNTILuuxuyx PER.uuxuyx: IF(
uuuwuy=uuuuzy CANDuuuwuu=uuuvwv) THEN TRUE ELSE IFuuuwuy=uuuuzz THENuuuzxz(uuuvww+uuuvwv+uuuvww+" fehlt"); FALSE ELSE FALSE FI FI. ENDPROCuuwuuy; TEXT PROCuuvuvw:
 IFuuuwuy=uuuvuv THENuuuvww+uuuwuu+uuuvww ELIFuuuwuy=uuuuzv THENuuuvwz+uuuwuu+uuuvwz ELSEuuuwuu FI ENDPROCuuvuvw; PROCnextsymbol:nextsymbol(uuuvzz,uuuwuu,uuuwuy);
 ENDPROCnextsymbol; PROCuuuzxz( TEXT CONSTuuxvxx):errorstop("Zeile "+text(lineno(uuuvzz))+" : "+uuxvxx) ENDPROCuuuzxz; PROCputerstestupel( TEXT CONSTuuxvyw):uuuyuy
.uuuuwz:=uuxvyw ENDPROCputerstestupel; TEXT PROCgeterstestupel:uuuyuy.uuuuwz ENDPROCgeterstestupel; PROCuuxvzz( TEXT CONSTuuxvyw):uuuyuy.uuuuxu:=uuxvyw ENDPROCuuxvzz
; TEXT PROCuuxwuz:uuuyuy.uuuuxu ENDPROCuuxwuz; PROCuuwwvy( INT CONSTuuxwvy):uuuyuy.uuuuwx:=uuxwvy ENDPROCuuwwvy; INT PROCgetanzahltupel:uuuyuy.uuuuwx ENDPROCgetanzahltupel
; PROCputletzterverbund( INT CONSTuuxwxw):uuuyuy.uuuuwy:=uuxwxw ENDPROCputletzterverbund; INT PROCgetletzterverbund:uuuyuy.uuuuwy ENDPROCgetletzterverbund; PROCputtid
( INT CONSTuuxwzu, TEXT CONSTuuxwzv):uuuyuy.uuuuxw[uuxwzu].uuuuuz:=uuxwzv ENDPROCputtid; TEXT PROCgettid( INT CONSTuuxwzu):uuuyuy.uuuuxw[uuxwzu].uuuuuz ENDPROCgettid
; PROCputbruder( INT CONSTuuxwzu, BOOL CONSTuuxxvz):uuuyuy.uuuuxw[uuxwzu].uuuuvu:=uuxxvz ENDPROCputbruder; BOOL PROCgetbruder( INT CONSTuuxwzu):uuuyuy.uuuuxw[uuxwzu
].uuuuvu ENDPROCgetbruder; PROCuuvxwu( TEXT CONSTuuxxyw, INT CONSTuuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuuy:=uuxxyw ENDPROCuuvxwu; TEXT PROCgetscanbedingung( INT CONST
uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuuy ENDPROCgetscanbedingung; PROCuuvyxz( INT CONSTuuxyvu,uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvv:=uuxyvu ENDPROCuuvyxz; PROCuuvzwz( INT
 CONSTuuxywx,uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvw:=uuxywx ENDPROCuuvzwz; INT PROCgetdnr( INT CONSTuuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvv ENDPROCgetdnr; INT PROCgetinr
( INT CONSTuuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvw ENDPROCgetinr; PROCuuvwvy( INT CONSTuuxzuw,uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvx:=uuxzuw ENDPROCuuvwvy; INT PROCgetselpointer
( INT CONSTuuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvx ENDPROCgetselpointer; PROCuuvvzw( INT CONSTuuxzuw,uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvy:=uuxzuw ENDPROCuuvvzw; INT PROC
getstopbedpointer( INT CONSTuuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvy ENDPROCgetstopbedpointer; PROCuuvxzx( INT CONSTuuxzuw,uuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvz:=uuxzuw
 ENDPROCuuvxzx; INT PROCgetbruderverb( INT CONSTuuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuvz ENDPROCgetbruderverb; PROCuuwvvy( INT CONSTuuxzuw,uuuzuz):uuuyuy.uuuuxw[uuuzuz
].uuuuwu:=uuxzuw ENDPROCuuwvvy; INT PROCgetsohnverb( INT CONSTuuuzuz):uuuyuy.uuuuxw[uuuzuz].uuuuwu ENDPROCgetsohnverb; PROCuuvuxz( INT CONSTuuyuzu):uuuyuy.uuuuww:=
uuyuzu ENDPROCuuvuxz; INT PROCgetanzahlverbunde:uuuyuy.uuuuww ENDPROCgetanzahlverbunde; INT PROCuuuzvx: INT VARuuyuzu:=getanzahlverbunde+1;uuvuxz(uuyuzu);uuvxzx(uuuuyz
,uuyuzu);uuwvvy(uuuuyz,uuyuzu);uuvxwu("",uuyuzu);uuyuzu ENDPROCuuuzvx; INT PROCuuwuyx:uuuwvx INCR1;uuuwvx ENDPROCuuwuyx; PROCuuvvwu( TEXT CONSTuuuwuw, INT CONSTuuvvwy
):uuuwwv[uuvvwy]:=uuuwuw ENDPROCuuvvwu; TEXT PROCuuvuzv( INT CONSTuuvvwy):uuuwwv[uuvvwy] ENDPROCuuvuzv; PROCbaumdurchlauf: IFmittestausgaben THENuuyvzz FI.uuyvzz:
 INT VARuuywuv; FORuuywuv FROM1 UPTOgetanzahlverbunde REPnote("Verbund  : "+text(uuywuv));noteline;note("   Datei : "+text(getdnr(uuywuv)));noteline;note("   Index : "
+text(getinr(uuywuv)));noteline;note("   Scan  : "+getscanbedingung(uuywuv));noteline;note("   Bruder: "+text(getbruderverb(uuywuv)));noteline;note("   Sohn  : "+
text(getsohnverb(uuywuv)));noteline;note("   SelPoi: "+text(getselpointer(uuywuv)));noteline;noteline; PER;checkselektion(uuuyuy.uuuuxv). ENDPROCbaumdurchlauf; PROC
setzeschluessel( INT CONSTuuxwzu): TEXT VARuuywxy:=getscanbedingung(uuxwzu);scan(uuywxy);nextsymbol;uuywyw;uuywyx;uuywyy;uuywyz; WHILEuuuwuy<>uuuvuu REP IFuuuwuu=
uuuvxv THENnextsymbol;uuywzy(uuxwzu,uuyxuu,uuuwuu);uuyxuw(uuxwzu,uuyxuu,uuyxuz);uuyxvu(uuxwzu,uuyxuu,0); ELIFuuuwuy=uuuvuv THENuuywzy(uuxwzu,uuyxuu,"");uuyxuw(uuxwzu
,uuyxuu,uuyxuz);uuyxvu(uuxwzu,uuyxuu,feldnr(uuuwuu)); ELIFuuuwuu=uuuvvu THENuuyxyu FI;nextsymbol PER;uuyxyv.uuywyx: IFuuuwuy=uuuvuv CANDfeldtyp(feldnr(uuuwuu))=uuuvxz
 THENuuywzy(uuxwzu,1,"");uuyxuw(uuxwzu,1,tidfeld);uuyxvu(uuxwzu,1,feldnr(uuuwuu));uuyyux(uuxwzu, TRUE);uuyyuz(uuxwzu,1); LEAVEsetzeschluessel FI;.uuywyz:uuywzy(uuxwzu
,1,"");uuyxuw(uuxwzu,1,0);uuyxvu(uuxwzu,1,0).uuyxyu: IFuuuwvw THENuuyxuz INCR1 ELSEuuuwuz:=uuuwvu+1;uuuwvu:=pos(uuuwux,uuuvvu,uuuwuz);uuyxuz:=uuxyvu+int(subtext(uuuwux
,uuuwuz,uuuwvu-1)) FI;uuyxuu INCR1.uuywyw: INT VARuuyyzv:=getinr(uuxwzu),uuxyvu:=getdnr(uuxwzu),uuyxuz; IFuuyyzv=0 THENuuuwvw:= TRUE;uuyxuz:=uuxyvu+1 ELSEuuuwux:=
zugriff(uuyyzv);uuuwvu:=pos(uuuwux,uuuvvu);uuyxuz:=int(subtext(uuuwux,1,uuuwvu-1))+uuxyvu;uuuwvw:= FALSE FI.uuyzwy: IFuuuwvw THEN(uuyxuz-uuxyvu)=anzkey(uuxyvu) ELSE
uuuwvu=length(uuuwux) FI.uuywyy: INT VARuuyxuu:=1; IFuuuwuy=uuuvuu THENuuyxuu:=0 FI.uuyxyv:uuyyux(uuxwzu,uuyzwy CAND(uuyxuu>0));uuyyuz(uuxwzu,uuyxuu). ENDPROCsetzeschluessel
; PROCuuyxvu( INT CONSTuuxwzu,uuzuux,uuyxuz):uuuyuy.uuuuxx[uuxwzu].uuuuyx[uuzuux].uuuuxy:=uuyxuz ENDPROCuuyxvu; PROCuuyxuw( INT CONSTuuxwzu,uuzuux,uuyxuz):uuuyuy.
uuuuxx[uuxwzu].uuuuyx[uuzuux].uuuuxz:=uuyxuz ENDPROCuuyxuw; INT PROCgetswvonfld( INT CONSTuuxwzu,uuzuux):uuuyuy.uuuuxx[uuxwzu].uuuuyx[uuzuux].uuuuxy ENDPROCgetswvonfld
; INT PROCgetswnachfld( INT CONSTuuxwzu,uuzuux):uuuyuy.uuuuxx[uuxwzu].uuuuyx[uuzuux].uuuuxz ENDPROCgetswnachfld; PROCuuywzy( INT CONSTuuxwzu,uuzuux, TEXT CONSTuuzvwu
):uuuyuy.uuuuxx[uuxwzu].uuuuyx[uuzuux].wert:=uuzvwu ENDPROCuuywzy; TEXT PROCgetswfwert( INT CONSTuuxwzu,uuzuux):uuuyuy.uuuuxx[uuxwzu].uuuuyx[uuzuux].wert ENDPROCgetswfwert
; PROCuuyyux( INT CONSTuuxwzu, BOOL CONSTuuzvzv):uuuyuy.uuuuxx[uuxwzu].uuuuyu:=uuzvzv ENDPROCuuyyux; BOOL PROCgetswallefelder( INT CONSTuuxwzu):uuuyuy.uuuuxx[uuxwzu
].uuuuyu ENDPROCgetswallefelder; PROCuuyyuz( INT CONSTuuxwzu,uuzwvz):uuuyuy.uuuuxx[uuxwzu].uuuuyv:=uuzwvz ENDPROCuuyyuz; INT PROCgetswanzfld( INT CONSTuuxwzu):uuuyuy
.uuuuxx[uuxwzu].uuuuyv ENDPROCgetswanzfld; PROCquery( TEXT CONSTuuzwyw): INT VARuuuzuz;uuuyzz(uuzwyw); FORuuuzuz FROM1 UPTOgetanzahlverbunde REPsetzeschluessel(uuuzuz
) PER;listeschluessel ENDPROCquery; OP:=( SCHLUESSELWERTE VARuuuwww, SCHLUESSELWERTE CONSTuuuwwx): CONCR(uuuwww):= CONCR(uuuwwx) ENDOP:=; OP:=( SWERT VARuuuwww, SWERT
 CONSTuuuwwx): CONCR(uuuwww):= CONCR(uuuwwx) ENDOP:=; OP:=( SCHLUESSEL VARuuuwww, SCHLUESSEL CONSTuuuwwx): CONCR(uuuwww):= CONCR(uuuwwx) ENDOP:=; PROClisteschluessel
: IF NOTmittestausgaben THEN LEAVElisteschluessel FI; INT VARuuuzuz,uuywuv; FORuuuzuz FROM1 UPTOgetanzahlverbunde REPnoteline;note("Verbund : "+text(uuuzuz));noteline
;note("=============");noteline;noteline;note("ANZAHL FLD: "+text(getswanzfld(uuuzuz)));noteline;note("ALLE      : "+uuzxxx);noteline;noteline; FORuuywuv FROM1 UPTO
getswanzfld(uuuzuz) REPnote("   VON : "+text(getswvonfld(uuuzuz,uuywuv)));noteline;note("   NACH: "+text(getswnachfld(uuuzuz,uuywuv)));noteline;note("   WERT: "+getswfwert
(uuuzuz,uuywuv));noteline; PER PER.uuzxxx: IFgetswallefelder(uuuzuz) THEN"vollständiger Schlüssel" ELSE"unvollständiger Schlüssel" FI. ENDPROClisteschluessel; BOOL
 PROCselektionerfuellt( INT CONSTuuzyux):werteselektionaus(uuuyuy.uuuuxv,uuzyux) ENDPROCselektionerfuellt; PROCuuuxyz( SCHLUESSEL VARuuzyvx): FORuuuwvy FROM1 UPTO
uuuuwv REP FORuuuwvz FROM1 UPTOuuuuyw REPuuzyvx[uuuwvy].uuuuyx[uuuwvz].wert:="" PER PER ENDPROCuuuxyz; ENDPACKETqueryparser;#$ FI#

