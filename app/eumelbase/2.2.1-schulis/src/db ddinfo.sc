 PACKETddinfopacket DEFINESddinfo: REAL PROCuuuuuv( INT CONSTuuuuuw):records(uuuuuw) ENDPROCuuuuuv; PROCddinfo( TEXT CONSTuuuuvu):ddinfo(uuuuvu,"") ENDPROCddinfo;
 PROCddinfo( TEXT CONSTuuuuvu,uuuuwu): INT VARuuuuwv,uuuuww:=1,uuuuwx; TEXT VARuuuuwy; IFuuuuvu="" ORuuuuvu="screen" THENpage ELSEforget(uuuuvu+".dd",quiet);sysout
(uuuuvu+".dd"); IFuuuuvu="printer" THENputline("#type("""+uuuuwu+""")#") FI FI;uuuuxz;putline(" Datenbank:  <"+name(1)+">");putline("     Anzahl Dateien    erster Index   Max DatID  1. Freier Eintrag"
);putline("              "+text(anzdateien)+"            "+text(firstindex)+"              "+text(maxdatid)+"              "+text(firstfree));uuuuyu;uuuuwv:=2; WHILE
uuuuwv<firstfree REP IFwas(uuuuwv)=dateieintrag THENuuuuyy ELIFwas(uuuuwv)=indexeintrag THENuuuuzu ELSEuuuuwv INCR1 FI END REP;uuuuzw;uuuuzx;uuuuzy;uuuuzz; IFuuuuvu
="" ORuuuuvu="screen" THENout("<RETURN>");pause;page ELSEsysout(""); IFuuuuvu="printer" THENprint(uuuuvu+".dd");forget(uuuuvu+".dd",quiet); FI FI.uuuuyy:uuuuxz;putline
(" Datei:  "+name(uuuuwv)+" (DatID: "+text(datid(uuuuwv))+")");uuuuwy:=compress(text(uuuuuv(uuuuwv),15,0));uuuuwy:=subtext(uuuuwy,1,length(uuuuwy)-1);putline("     Anzahl Schlüsselfelder: "
+text(anzkey(uuuuwv))+"   Befugnis: "+text(befugnis(uuuuwv))+"   Datensätze: "+uuuuwy);putline("         Feld                   Typ Länge XN YN XF YF Befug 1234567890123456"
);uuuuwv INCR1;uuuuwx:=1; WHILEuuuuwv<firstfree CANDistfeld(was(uuuuwv)) REPuuuuxz;uuuvxz; IFlength(name(uuuuwv))>23 THENwrite(text(name(uuuuwv),23)+"<") ELSEwrite
(text(name(uuuuwv),23)+" ") FI;write(code(feldtyp(uuuuwv))+"  "); IFfeldtyp(uuuuwv)=realfeld THENuuuuwy:=text(einglaenge(uuuuwv))+"."+text(nachkomma(uuuuwv));write
(text("",5-length(uuuuwy)));write(uuuuwy+" ") ELSEwrite(text(einglaenge(uuuuwv),5)+" ") FI;write(text(posxname(uuuuwv),2)+" ");write(text(posyname(uuuuwv),2)+" ")
;write(text(posxfeld(uuuuwv),2)+" ");write(text(posyfeld(uuuuwv),2)+" ");write(text(befugnis(uuuuwv),5)+" ");uuuwuy;line;uuuuwv INCR1; END REP;uuuuyu.uuuwvv:3*" "
.uuuuzw:uuuuyu;line;write("INITIALISIERUNGEN");line;line;uuuuwv:=3; WHILEuuuuwv<firstfree REP IFinitialisierung(uuuuwv)<>"" CANDuuuwwv(uuuuwv) THENputline(text(uuuwvv
+"zu Feld "+text(text(uuuuwv),4)+": "+initialisierung(uuuuwv),76)) FI;uuuuwv INCR1 PER;line.uuuuzx:uuuuyu;line;write("PLAUSIBILITÄTEN");line;line;uuuuwv:=3; WHILE
uuuuwv<firstfree REP IFplausi(uuuuwv)<>"" CANDuuuwwv(uuuuwv) THENputline(text(uuuwvv+"zu Feld "+text(text(uuuuwv),4)+": "+plausi(uuuuwv),76)) FI;uuuuwv INCR1 PER;
line.uuuuzy:uuuuyu;line;write("HILFSTEXTNUMMERN");line;line;uuuuwv:=3; WHILEuuuuwv<firstfree REP IFhilfstextnr(uuuuwv)>0 THENputline(uuuwvv+"zu Feld "+text(text(uuuuwv
),4)+": "+text(hilfstextnr(uuuuwv))) FI;uuuuwv INCR1 PER;line.uuuuzz:uuuuyu;line;write("STANDARD-AKTIONEN");line;line;uuuuwv:=3; WHILEuuuuwv<firstfree REP IFstandardaktion
(uuuuwv) CANDuuuwwv(uuuuwv) THENputline(text(uuuwvv+"zu Feld "+text(text(uuuuwv),4)+": "+zugriff(uuuuwv),76)) FI;uuuuwv INCR1 PER;line.uuuwuy: INT VARuuuxwx; FORuuuxwx
 FROM1 UPTO16 REP IFswitch(uuuuwv,uuuxwx) THENwrite("*") ELSEwrite("-") FI PER.uuuuzu: TEXT VARuuuxxw:=""; WHILEuuuuwv<firstfree REPuuuuxz; IFphonetic(uuuuwv) THEN
uuuxxw:=" Phon-Index: " ELSEuuuxxw:=" Index     : " FI;putline(uuuxxw+name(uuuuwv)+" (DatID: "+text(datid(uuuuwv))+")");putline("     zu Datei   : "+name(dateinr(
primdatid(uuuuwv))));putline("     über Felder: "+text(zugriff(uuuuwv),25));uuuuwv INCR1; PER.uuuuxz: TEXT VARindex:=text(uuuuww);write((3-length(index))*" ");write
(index+")");uuuuww INCR1.uuuvxz:index:=text(uuuuwx);write((3-length(index))*" ");write(index+". ");uuuuwx INCR1.uuuuyu:write(6*"-------------");line. END PROCddinfo
; BOOL PROCuuuwwv( INT CONSTuuuyuz):uuuyuz<>1 CANDwas(uuuyuz)<>dateieintrag CANDwas(uuuyuz)<>indexeintrag ENDPROCuuuwwv; ENDPACKETddinfopacket;

