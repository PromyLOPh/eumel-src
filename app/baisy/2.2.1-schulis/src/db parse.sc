 PACKETdbparse DEFINESparsetupel,buildtupel,buildkey,parsenooffields,reinitparsing,savetupel,restoretupel,istzahl: LETtextfeld=84,intfeld=73,realfeld=82,aktionsfeld
=65,datumfeld=68,editorfeld=69,pointerfeld=80,#dateieintrag=1,#indexeintrag=2;#schluessel=1,daten=2,alles=3;# TEXT VARuuuuuv:=""; INT VARuuuuuw,uuuuux,uuuuuy; INT
 VARuuuuuz,uuuuvu,uuuuvv; TEXT VARuuuuvw:="00",uuuuvx:="",uuuuvy:="",uuuuvz:="",uuuuwu:=""; BOOL VARuuuuwv; BOOL PROCuuuuww( TEXT CONSTuuuuwx):(uuuuwx>"/") AND(uuuuwx
<":") END PROCuuuuww; PROCuuuuxv( INT CONSTuuuuxw):uuuuxv(uuuuxw,uuuuxz) ENDPROCuuuuxv; PROCuuuuxv( INT CONSTuuuuxw,uuuuyx): INT VARuuuuyy:=uuuuxw,uuuuzu:=4,uuuuzv
:=0,uuuuuy:=anzattr(uuuuxw)+uuuuxw; WHILE(uuuuuy>uuuuyy) CANDuuuuzv<=uuuuyx REPuuuuyy INCR1; IF NOTstandardaktion(uuuuyy) THENputzugriff(uuuuyy,uuuvvu(uuuuyy,uuuuzu
)) ELSEuuuuwv:= TRUE FI;uuuuzv INCR1 PER ENDPROCuuuuxv; INT VARuuuuxz:=maxint; PROCparsenooffields( INT CONSTuuuvww):uuuuxz:=uuuvww ENDPROCparsenooffields; INT PROC
parsenooffields:uuuuxz ENDPROCparsenooffields; PROCreinitparsing:uuuuxz:=maxint ENDPROCreinitparsing; TEXT PROCuuuvvu( INT CONSTuuuuyy, INT VARuuuuzu):uuuuuz:=0;uuuuvu
:=2;uuuuvv:=feldtyp(uuuuyy); SELECTuuuuvv OF CASEaktionsfeld,textfeld,pointerfeld,realfeld,editorfeld,datumfeld:#uuuvzw;uuuvzx;#uuuvzy;uuuuwv:=uuuuwv OR(uuuuvv=aktionsfeld
)#change(uuuwuw,1,2+uuuuuz,"")# CASEintfeld:uuuuuz:=2;uuuuvu:=0;uuuvzx;#change(uuuwuw,1,2,"")# ENDSELECT;uuuuzu:=uuuuzu+uuuuuz+uuuuvu;uuuuvx.uuuvzy:uuuuvx:=subtext
(uuuuwu,uuuuzu,uuuuzu+1);#uuuuuz:=wortnachint(uuuuvx);# IFuuuuvx<>"" THENuuuuuz:=uuuuvx ISUB1;uuuuvx:=subtext(uuuuwu,uuuuzu+uuuuvu,uuuuzu+uuuuvu+uuuuuz-1) ELSEuuuuuz
:=0;uuuuvx:="" FI.uuuvzx: IFuuuuuz<>0 THENuuuuvx:=subtext(uuuuwu,uuuuzu+uuuuvu,uuuuzu+uuuuvu+uuuuuz-1) ELSEuuuuvx:="" FI. ENDPROCuuuvvu; PROCuuuxvv( INT CONSTuuuxvw
): INT VARuuuxvx;disablestop; FORuuuxvx FROMuuuxvw+1 UPTOuuuxvw+anzattr(uuuxvw) REP IFfeldtyp(uuuxvx)=aktionsfeld CANDzugriff(uuuxvx)<>"" THEN IFactionlocked(uuuxvx
) THEN#unlockaction(uuuxvx)# ELSEdo(zugriff(uuuxvx)); IFiserror THENactionfailure(uuuxvx, TRUE);clearerror ELSEactionfailure(uuuxvx, FALSE) FI FI FI PER;enablestop
 ENDPROCuuuxvv; PROCparsetupel( INT CONSTuuuxxz, TEXT CONSTuuuxyu):parsetupel(uuuxxz,uuuxyu, FALSE, TRUE) ENDPROCparsetupel; PROCparsetupel( INT CONSTuuuxxz, TEXT
 CONSTuuuxyu, BOOL CONSTuuuxzw,uuuxzx): INT VARuuuxzy:=uuuxxz; IF NOTuuuxzw THENuuuuwu:=uuuxyu;uuuyux FI.uuuyux: IFwas(uuuxxz)=indexeintrag THENuuuxzy:=dateinr(primdatid
(uuuxxz)) FI;uuuuwv:= FALSE;uuuuxv(uuuxzy); IFuuuuwv CANDuuuxzx THENuuuxvv(uuuxzy) FI. ENDPROCparsetupel; PROCbuildtupel( INT CONSTuuuuxw, TEXT VARuuuxyu): INT VAR
uuuuyy:=uuuuxw,uuuuuy:=anzattr(uuuuxw)+uuuuxw;replace(uuuuvw,1,uuuuxw);uuuuwu:="";uuuuwu CAT"D";uuuuwu CATuuuuvw; WHILEuuuuuy>uuuuyy REPuuuuyy INCR1; IFfeldtyp(uuuuyy
)<>intfeld THEN IF NOTstandardaktion(uuuuyy) THENuuuyzz(zugriff(uuuuyy)) FI; ELSEuuuuwu CATzugriff(uuuuyy) FI PER;uuuxyu:=uuuuwu ENDPROCbuildtupel; PROCuuuyzz( TEXT
 CONSTwert):replace(uuuuvw,1,length(wert));uuuuwu CATuuuuvw;uuuuwu CATwert ENDPROCuuuyzz; BOOL PROCistzahl( TEXT CONSTuuuzwv): INT VARuuuzww; FORuuuzww FROM1 UPTO
length(uuuzwv) REP IF NOTuuuuww(uuuzwv SUBuuuzww) THEN LEAVEistzahl WITH FALSE FI PER; TRUE ENDPROCistzahl; PROCbuildkey( INT CONSTuuuuxw, TEXT VARuuuzyu,uuuzyv, BOOL
 CONSTuuuzyw,uuuzyx): INT VARuuuzyy:=1,uuuzyz,uuuuyy:=uuuuxw,uuuzzw; BOOL VARuuuzzx:=phonetic(uuuuxw),uuuzzz:=(was(uuuuxw)=indexeintrag);uuuuvy:="";uuuzyu:=""; IF
uuuzyx THENuuuzyv:="";buildkey(dateinr(primdatid(uuuuxw)),uuuzyu,uuuzyv, FALSE, FALSE);uuuzyu:="";uuuuvy:="" FI; IFuuuzzz THENuuvuwu ELSEuuvuwv FI; IFuuuzzx THENuuuzyu
 CATcode(0) FI; IFuuuzzz THEN IF#uuvuwz ORuuvuxu ORuuvuxv???#uuuzyw THENuuuzyu CATuuuzyv FI ELSEuuuzyv:=uuuzyu; FI.uuvuwv:uuuuuy:=anzkey(uuuuxw)+uuuuxw; WHILEuuuuyy
<uuuuuy REPuuuuyy INCR1;uuvuzw PER;.uuvuwu:uuuuuv:=zugriff(uuuuxw);uuuuuw:=dateinr(primdatid(uuuuxw));uuuuux:=length(uuuuuv);uuuzyz:=pos(uuuuuv,";");uuuuyy:=int(subtext
(uuuuuv,1,uuuzyz-1))+uuuuuw;uuuzyy:=uuuzyz+1; WHILEuuuzyz>0 REPuuvuzw;uuuzyz:=pos(uuuuuv,";",uuuzyy);uuuuyy:=int(subtext(uuuuuv,uuuzyy,uuuzyz-1))+uuuuuw;uuuzyy:=uuuzyz
+1 PER;.uuvuzw:uuuzzw:=feldtyp(uuuuyy); IFuuuzzw=realfeld CORuuuzzw=datumfeld THENuuuzyu CATzugriff(uuuuyy) ELSE# IFuuuzzw=textfeld ORuuuzzw=intfeld ORuuuzzw=aktionsfeld
 ORuuuzzw=editorfeld ORuuuzzw=pointerfeld THEN#uuvwuu FI; IF NOTuuuzzx THENuuuzyu CATcode(0) FI.uuvwuu: IF NOTstandardaktion(uuuuyy) THEN IFuuuzzx THENuuuzyu CATphoneticcode
(zugriff(uuuuyy)) ELSEuuuuvy:=zugriff(uuuuyy); IFuuuzzw=textfeld CORuuuzzw=editorfeld THEN IFalpharechts(uuuuyy) CANDistzahl(uuuuvy) THENuuvwwx ELSEuuvwwy FI; FI;
uuuzyu CATuuuuvy FI FI.uuvwwy:changeall(uuuuvy,"ß","ss");changeall(uuuuvy,"Ä","Ae");changeall(uuuuvy,"Ü","Ue");changeall(uuuuvy,"Ö","Oe");changeall(uuuuvy,"ä","ae"
);changeall(uuuuvy,"ü","ue");changeall(uuuuvy,"ö","oe").uuvwwx:uuuuvy:=((einglaenge(uuuuyy)-length(uuuuvy))*"0")+uuuuvy. ENDPROCbuildkey; PROCsavetupel( INT CONST
uuuxzy, TEXT VARuuvwzz): INT VARuuuuyy,uuvxuv; BOOL VARuuvxuw:= FALSE; IFwas(uuuxzy)=dateieintrag THENuuvxuv:=uuuxzy ELSEuuvxuv:=dateinr(primdatid(uuuxzy)) FI;uuvwzz
:=""; FORuuuuyy FROM1 UPTOmin(anzattr(uuvxuv),uuuuxz) REPuuvxuw:=feldtyp(uuuuyy+uuvxuv)=pointerfeld; IFuuvxuw CANDlength(wert(uuuuyy+uuvxuv))<>uuvxxu THENuuvwzz CAT
(uuvxxw+uuvxxx) ELSEuuvwzz CAT(wert(uuvxuv+uuuuyy)+uuvxxx) FI PER ENDPROCsavetupel; PROCrestoretupel( INT CONSTuuuxzy, TEXT CONSTuuvwzz): INT VARuuuuyy,uuvxuv,uuvxzw
,uuuzyy:=1; BOOL VARuuvxuw:= FALSE;uuuuvz:=uuvwzz; IFwas(uuuxzy)=dateieintrag THENuuvxuv:=uuuxzy ELSEuuvxuv:=dateinr(primdatid(uuuxzy)) FI; FORuuuuyy FROMuuvxuv+1
 UPTOuuvxuv+min(anzattr(uuvxuv),uuuuxz) REPuuvxuw:=feldtyp(uuuuyy)=pointerfeld; IFuuvxuw THENuuvxzw:=uuuzyy+4 ELSEuuvxzw:=pos(uuuuvz,uuvxxx,uuuzyy) FI;uuuuvy:=subtext
(uuuuvz,uuuzyy,(uuvxzw-1));uuuzyy:=uuvxzw+1; IFuuvxuw CANDuuuuvy=uuvxxw THENuuuuvy:="" FI;putwert(uuuuyy,uuuuvy) PER ENDPROCrestoretupel; LETuuvxxx="�",uuvxxw="0000"
,uuvxxu=4; ENDPACKETdbparse;

