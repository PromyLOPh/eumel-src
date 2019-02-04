 PACKETisparchivemanager DEFINESisparchivemanager,archivechannel: LETuuuuuv=128,uuuuuw=100,uuuuux=1,uuuuuy=2,uuuuuz=200,uuuuvu=100,uuuuvv=12,uuuuvw=0,#uuuuvx=1,uuuuvy
=2,#uuuuvz=5,uuuuwu=25,uuuuwv=26,#uuuuww=28,uuuuwx=19,uuuuwy=20,#uuuuwz=34,uuuuxu=35,uuuuxv=36,uuuuxw=37,uuuuxx=39,uuuuxy=40,uuuuxz=41,uuuuyu=42,uuuuyv=43,uuuuyw=
44,uuuuyx=45,uuuuyy=46,uuuuyz=47,uuuuzu=48,uuuuzv=10,uuuuzw=5,uuuuzx=7; LET ARCHIVECONTROL= STRUCT( INTuuuuzy, BOOLuuuuzz); BOUND ARCHIVECONTROL VARuuuvuu; TYPE HEADER
= STRUCT( TEXTname,date, INTtype, TEXTuuuvuv, INTuuuvuw,uuuvux,uuuvuy,uuuvuz); TYPE DSNAMEN= STRUCT( INTuuuvvu, ROWuuuuuz TEXTuuuvvw); ROWuuuuuz DATASPACE VARuuuvvy
;uuuvvz( TRUE); BOUND DSNAMEN VARuuuvwu; TYPE FILEHEADER= STRUCT( TEXTuuuvwv, INTuuuvww,uuuvwx,uuuvwy, ROWuuuuuv INTuuuvxu); BOUND FILEHEADER VARuuuvxv; BOUND TEXT
 VARuuuvxw; BOUND INT VARuuuvxx; BOUND HEADER VARuuuvxy; DATASPACE VARuuuvxz:=nilspace,uuuvyu:=nilspace,uuuvyv:=nilspace,uuuvyw:=nilspace,uuuvyx:=nilspace,uuuvyy:=
nilspace;uuuvyz; INT VARuuuvzu,uuuvzv,uuuvzw,uuuvzx,uuuvzy,uuuvzz,uuuwuu,uuuwuv,uuuwuw,uuuwux,uuuwuy,uuuwuz,uuuwvu,uuuwvv:=1; BOOL VARuuuwvw:= TRUE,uuuwvx:= FALSE
,uuuwvy:= FALSE; INT VARuuuwvz,uuuwwu,uuuwwv,uuuwww,uuuwwx,uuuwwy; TASK VARuuuwwz,uuuwxu:=niltask; BOUND STRUCT( TEXTname,uuuwxv,uuuwxw) VARuuuwxx; FILE VARuuuwxy
; TEXT VARuuuwxz:="",uuuwyu:="",uuuwyv:=""; REAL VARuuuwyw:=clock(1); INT VARuuuwyx:=31; INT PROCarchivechannel:uuuwyx ENDPROCarchivechannel; PROCarchivechannel( INT
 CONSTuuuwzw):uuuwyx:=uuuwzw ENDPROCarchivechannel; PROCuuuvyz:forget(uuuvxz);forget(uuuvyu);forget(uuuvyv);forget(uuuvyw);forget(uuuvyx);forget(uuuvyy); ENDPROCuuuvyz
; PROCuuuvvz( BOOL CONSTuuuxvx): INT VARuuuwvz; FORuuuwvz FROM1 UPTOuuuuuz REP IFuuuxvx THENuuuvvy[uuuwvz]:=nilspace FI;forget(uuuvvy[uuuwvz]) PER ENDPROCuuuvvz; PROC
uuuxxv( DATASPACE VARuuuvyw, INT CONSTpage, INT CONSTuuuwuv): INT VARuuuxxy:=0,uuuxxz:=0,uuuxyu; REPblockin(uuuvyw,page,0,uuuwuv,uuuxxy); IFuuuxxy<>0 THENuuuxxz INCR
1;uuuxzu FI UNTILuuuxxy<>2 ORuuuxxz=uuuuzv PER;uuuxzy(uuuxxy,uuuwuv).uuuxzu: IFuuuxxz=uuuuzw THENblockin(uuuvyw,page,0,0,uuuxxy);uuuxxy:=2 FI;. ENDPROCuuuxxv; PROC
uuuyvw( DATASPACE VARuuuvyw, INT CONSTpage, INT CONSTuuuwuv): INT VARuuuxxy:=0,uuuxxz:=0,uuuxyu; REP FORuuuwvz FROM1 UPTOuuuwvv REPblockout(uuuvyw,page,0,uuuwuv,uuuxxy
); UNTILuuuxxy<>0 PER; IFuuuwvy CANDuuuxxy=0 THENblockin(uuuvyw,page,0,uuuwuv,uuuxxy); FI; IFuuuxxy<>0 THENuuuxxz INCR1;uuuxzu FI UNTILuuuxxy<>2 ORuuuxxz=uuuuzv PER
;uuuxzy(uuuxxy,uuuwuv).uuuxzu: IFuuuxxz=uuuuzw THENdisablestop;uuuvyy:=nilspace;blockin(uuuvyy,2,0,0,uuuxxy);forget(uuuvyy);clearerror;enablestop;uuuxxy:=2 FI;. ENDPROC
uuuyvw; PROCuuuxzy( INT CONSTuuuxxy,uuuzvx): SELECTuuuxxy OF CASE0: CASE1:errorstop("Schreiben/Lesen des Archives unmöglich") CASE2:errorstop("Schreib/Lese-Fehler:"
+text(uuuzvx)) CASE3:errorstop("Archive-Overflow") OTHERWISE:errorstop("Unbekannter Archive-Fehler:"+text(uuuxxy)+"/"+text(uuuzvx)) ENDSELECT ENDPROCuuuxzy; PROCuuuzwx
: INT VARuuuwvz:=1,uuuxxy;forget(uuuvyy);uuuvyy:=nilspace;uuuzxw( TRUE);uuuzxx(text(uuuwvz)); FORuuuwvz FROM1 UPTOarchiveblocks-1 REP IF(uuuwvz MOD50)=0 THENuuuzxx
(text(uuuwvz)); FI;blockin(uuuvyy,1,0,uuuwvz,uuuxxy);uuuxzy(uuuxxy,uuuwvz) PER;uuuzxx(text(uuuwvz));forget(uuuvyy) ENDPROCuuuzwx; PROCuuvuuv:uuuzxw( TRUE);forget(
uuuvxy.name,quiet);uuuwxy:=sequentialfile(output,uuuvxy.name); IFuuuwvw THENuuvuvv ELSEuuvuvw FI;forget(uuuvyw);forget(uuuvyu);uuuvyu:=old(uuuvxy.name);uuuvyw:=uuuvyu
;forget(uuuvyu);forget(uuuvxy.name,quiet);.uuvuvv:uuvuvw; REPuuvuxv;putline(uuuwxy,"! "+text(uuuvxv.uuuvwv,27)+"!     "+text(text(uuuvxv.uuuvww),10)+"!   "+text(text
(uuuwuw),7)+"!     "+text(text(uuuvxv.uuuvwx),11)+"!");uuvuyy;uuuwuw:=uuuwuw+uuuwuz+1;uuuwuv:=uuuwuw+1 UNTILuuvuzy PER.uuvuvw:uuvvuu;putline(uuuwxy,"");putline(uuuwxy
,"     ARCHIVE: "+text(uuuvxy.name,20)+"erstellt am : "+text(uuuvxy.date,10));putline(uuuwxy,"");putline(uuuwxy,10*" "+" Disketten-Nr. : "+uuvvvv);putline(uuuwxy,
10*" "+" vorige Diskette der Sicherung : "+uuvvvx);putline(uuuwxy,10*" "+" nächste Diskette der Sicherung: "+uuvvvz);putline(uuuwxy,"");putline(uuuwxy,10*" "+" Blöcke insgesamt : "
+text(archiveblocks-1));putline(uuuwxy,10*" "+" Erster freier Block: "+text(uuuvxy.uuuvuw));putline(uuuwxy,"");putline(uuuwxy,"");uuvvxv.uuvvxv:putline(uuuwxy,"! Filename                   ! Anzahl Blöcke ! ab Block ! erste DS-Seite !"
);putline(uuuwxy,"+----------------------------+---------------+----------+----------------+");uuvuyy.uuvuyy:putline(uuuwxy,"!                            !               !          !                !"
);.uuvvvv:text(uuuvxy.uuuvuz).uuvvvz:text(uuuvxy.uuuvuy).uuvvvx:text(uuuvxy.uuuvux).uuvuzy:uuuwuv>=uuuvxy.uuuvuw.uuvuxv:uuvwuy;. ENDPROCuuvuuv; PROCuuvwuy:forget(
uuuvxz);uuuvxz:=nilspace;uuuxxv(uuuvxz,1,uuuwuw);uuuvxv:=uuuvxz;uuuwuz:=uuuvxv.uuuvww;uuuwvu:=uuuvxv.uuuvwx ENDPROCuuvwuy; PROCuuvwxx( TEXT CONSTuuvwxy):forget(uuuvyv
);uuuvyv:=nilspace;uuuvxy:=uuuvyv;uuuvxy.name:=uuvwxy;uuuvxy.uuuvuz:=0;uuuvxy.uuuvuy:=0;uuuvxy.uuuvux:=0;uuuvxy.uuuvuw:=-1;uuuvxy.date:=date;uuvxuw ENDPROCuuvwxx;
 PROCuuvxuy:uuvvuu;uuuvxy.uuuvuz:=0;uuuvxy.uuuvuy:=0;uuuvxy.uuuvux:=0;uuuvxy.uuuvuw:=-1;uuuvxy.date:=date;uuvxuw ENDPROCuuvxuy; PROCuuuzxw( BOOL CONSTuuvxxu):uuuwvw
:= TRUE;uuvvuu;uuvxxx.uuvxxx: IFuuuvxy.uuuvuw<=0 THENuuuwvw:= FALSE;uuuvxy.uuuvuw:=uuuuuy FI; IFuuvxxu THENuuuwuw:=uuuuuy;uuuvxy.date:=date ELSEuuuwuw:=uuuvxy.uuuvuw
 FI;uuuwuv:=uuuwuw+1#;note("Erster freier Block : "+text(uuuvxy.uuuvuw));noteline;note("Startblock : "+text(uuuwuw));noteline;#. ENDPROCuuuzxw; PROCuuvvuu:forget(
uuuvyv);uuuvyv:=nilspace;uuuxxv(uuuvyv,1,uuuuux);uuuvxy:=uuuvyv ENDPROCuuvvuu; PROCuuvxuw:uuuyvw(uuuvyv,nextdspage(uuuvyv,-1),uuuuux) ENDPROCuuvxuw; PROCuuvyxx:uuuwxz
:=uuuuuw*code(0);uuvyyu(1) ENDPROCuuvyxx; PROCuuvyyw:uuuwyu:=uuuuuw*code(0) ENDPROCuuvyyw; PROCuuvyzu( INT CONSTuuvyzv):uuvyzw(uuuwyu,uuvyzv) ENDPROCuuvyzu; INT PROC
uuvzuu( INT CONSTuuvyzv):uuvyzv MOD8 ENDPROCuuvzuu; INT PROCuuvzuy( INT CONSTuuvyzv):(uuvyzv DIV8)+1 ENDPROCuuvzuy; PROCuuvyyu( INT CONSTuuvyzv):uuvyzw(uuuwxz,uuvyzv
) ENDPROCuuvyyu; BOOL PROCuuvzww:uuuwyu=uuuwxz ENDPROCuuvzww; PROCuuvyzw( TEXT VARuuvzxv, INT CONSTuuvyzv): INT VARuuvzxx,bit,uuvzxy;uuvzxx:=uuvzuy(uuvyzv);bit:=uuvzuu
(uuvyzv);uuvzxy:=code(uuvzxv SUBuuvzxx);setbit(uuvzxy,bit);change(uuvzxv,uuvzxx,uuvzxx,code(uuvzxy)) ENDPROCuuvyzw; PROCuuwuuv: IFuuwuuw THENuuwuux ELSEuuwuuy FI.
uuwuuw:uuuwwx=uuuuwz.uuwuux:#uuuwux:=1;#uuuvuu:=uuuvyw;uuuwvv:=uuuvuu.uuuuzy;uuuwvy:=uuuvuu.uuuuzz;uuuwwy:=archiveblocks-1;uuuwwu:=0;uuuwww:=0;uuuwwv:=nextdspage(
uuuvyu,-1);uuwuxz; IFuuuwuv>uuuwwu THENerrorstop("Archive voll!") FI;uuwuyw.uuwuuy:uuuwwy:=archiveblocks-1;uuwuxz;uuwuzu;uuwuzv;uuwuyw.uuwuyw: WHILEuuuwwv>=0 REPuuwuzz
;uuwuzv PER;uuwvuv;uuwvuw;uuvxuw;forget(uuuvyu);uuwvuz.uuwuzz: IFuuuwuv>uuuwwu THENuuwvvx FI;uuwuzu.uuwuzu:#uuuzxx("Block "+text(uuuwuv)+" wird geschrieben !");#uuuyvw
(uuuvyu,uuuwwv,uuuwuv);uuuwww INCR1;uuuvxy.uuuvuw INCR1;uuwvxx;uuuwuv INCR1.uuwvxx:uuwvyu;uuwvyv.uuwvyu:uuuvzu:=uuuwwv-uuuvxv.uuuvwx+1;uuuvzw:=(uuuvzu DIV16)+1;uuuvzv
:=(uuuvzu) MOD16#;note("Seite : "+text(uuuwwv));noteline;note("    rel. Seite : "+text(uuuvzu));noteline;note("    Zeichen    : "+text(uuuvzw));noteline;note("    Bit        : "
+text(uuuvzv));noteline;#.uuwvyv:setbit(uuuvxv.uuuvxu[uuuvzw],uuuvzv).uuwuzv:uuuwwv:=nextdspage(uuuvyu,uuuwwv).uuwvuw:uuuwwv:=nextdspage(uuuvxz,-1);uuwwwx.uuwwwx:
uuuyvw(uuuvxz,1#uuuwwv#,uuuwuw);uuuvxy.uuuvuw INCR1.uuwwxz:forget(uuuvxz);uuuvxz:=nilspace;uuuvxv:=uuuvxz;uuuvxv.uuuvwy:=type(uuuvyu);uuuvxv.uuuvwx:=uuuwwv;uuuwww
:=0;#note("Erste Seite : "+text(uuuwwv));# FORuuuwvz FROM1 UPTOuuuuuv REPuuuvxv.uuuvxu[uuuwvz]:=0 PER.uuwvuv:uuuvxv.uuuvwv:=uuuwyv;#uuuzxx(uuuwyv+" wird archiviert !"
);#uuuvxv.uuuvww:=uuuwww;#note("Weggeschr. Seiten : "+text(uuuwww));noteline#.uuwvvx:uuwxwy;uuwxwz;#uuwuxz#.uuwxwz:uuwxxw; LEAVEuuwuuv.uuwxwy:uuwvuv;uuwwwx;uuuwux
 INCR1;uuuvxy.uuuvuy:=uuuwux;uuvxuw.uuwuxz:uuuzxw( FALSE); IFuuwuuw THENuuwxzx FI;uuuvxy.uuuvuz:=uuuwux;uuuvxy.uuuvux:=uuuwux-1;uuuvxy.uuuvuy:=0;uuuwwu:=archiveblocks
-1;uuwwxz;.uuwxzx: IFuuuvxy.uuuvuz<=0 THENuuuwux:=1 ELSEuuuwux:=uuuvxy.uuuvuz FI. ENDPROCuuwuuv; PROCuuwywy( INT CONSTuuwywz): IFuuwywz=1 THENuuwyxv ELSEuuwyxw FI
.uuwyxv:uuuwxx:=uuuvyw;uuuwyv:=uuuwxx.name;uuwyyw.uuwyxw:forget(uuuwyv,quiet);forget(uuuvyu);uuuvyu:=uuuvyw;uuwyzw. ENDPROCuuwywy; PROCuuwyzy: INT VARuuwyzz,uuwzuu
; SELECTuuuwwx OF CASEuuuuxz:uuwzux CASEuuuuyu:uuwzuz CASEuuuuyv:uuwzvv ENDSELECT.#uuwuuw:uuuwwx=uuuuxz.#uuwzux:uuuwwy:=archiveblocks-1;uuuvzx:=1;uuuvzy:=-1;uuuvzz
:=0;forget(uuuvyx);uuuvyx:=nilspace;uuuvwu:=uuuvyx;uuuwuu:=0;uuvyxx;uuvyyw;uuwuyw.uuwzuz:uuuwwy:=archiveblocks-1;uuwuyw.uuwuyw:uuuzxw( TRUE);uuwzyz; REP REPuuvuxv
;uuwzzv; FORuuuwvz FROM1 UPTOuuuwuz REPuuwzzy PER;uuuwuw:=uuuwuv;uuuwuv:=uuuwuw+1 UNTILuuxuux PER; UNTILuuxuuy PER;uuxuuz;uuxuvu;uuwvuz.uuxuvu:uuuvwu.uuuvvu:=uuuvzz
;forget(uuuvyw);uuuvyw:=uuuvyx;forget(uuuvyx).uuwzvv:uuuvxx:=uuuvyw;uuuwuy:=uuuvxx;forget(uuuvyw);uuuvyw:=uuuvvy[uuuwuy];forget(uuuvvy[uuuwuy]);uuwvuz.uuxuuy: IF NOT
uuvzww THENuuwxwz; FALSE ELSE TRUE FI.uuwxwz:uuwxxw; LEAVEuuwyzy.uuxuux:uuuwuv>=uuuvxy.uuuvuw.uuwzzy:uuuxxv(uuuvvy[uuuwuu],uuxvvu,uuuwuv);uuuwuv INCR1.uuxvvu: REP
 FORuuwyzz FROMuuuvzy+1 UPTO15 REP IFbit(uuuvxv.uuuvxu[uuuvzx],uuwyzz) THENuuuvzy:=uuwyzz;#;note("gelesene Seite : "+text(uuxvxu)+"Bit : "+text(uuwyzz));note("    akt. Zeichen    : "
+text(uuuvzx));noteline;note("    akt. Bit        : "+text(uuuvzy));noteline;# LEAVEuuxvvu WITHuuxvxu FI PER;uuuvzy:=-1;uuuvzx INCR1 UNTILuuuvzx>=uuuuuv PER;-1.uuxvxu
:((uuuvzx-1)*16+uuuvzy)+(uuuwvu-1).uuvuxv:uuvwuy;uuxvzy;uuuvwu.uuuvvw[uuuwuu]:=uuuvxv.uuuvwv;uuuzxx(""""+uuuvxv.uuuvwv+""" wird gelesen!").uuwzzv:type(uuuvvy[uuuwuu
],uuuvxv.uuuvwy);uuuvzx:=1;uuuvzy:=-1.uuxvzy: FORuuwzuu FROM1 UPTOuuuvzz REP IFuuuvxv.uuuvwv=uuuvwu.uuuvvw[uuwzuu] THENuuuwuu:=uuwzuu; LEAVEuuxvzy FI PER;uuuvzz INCR
1;uuuvvy[uuuvzz]:=nilspace;uuuwuu:=uuuvzz.uuwzyz:uuvyzu(uuuvxy.uuuvuz); IFuuuvxy.uuuvux>0 THENuuvyyu(uuuvxy.uuuvux) FI; IFuuuvxy.uuuvuy>0 THENuuvyyu(uuuvxy.uuuvuy
) FI. ENDPROCuuwyzy; PROCuuwyzw:send(uuuwwz,uuuuvw,uuuvyw);forget(uuuvyw) ENDPROCuuwyzw; PROCuuwyyw:send(uuuwwz,uuuuvz,uuuvyw);forget(uuuvyw) ENDPROCuuwyyw; PROCuuwvuz
:forget(uuuvyv);forget(uuuvxz);send(uuuwwz,uuuuxx,uuuvyw);forget(uuuvyw) ENDPROCuuwvuz; PROCuuwxxw:send(uuuwwz,uuuuxv,uuuvyw);forget(uuuvyw) ENDPROCuuwxxw; PROCuuuzxx
( TEXT CONSTuuxyuu): DATASPACE VARuuxyuv:=nilspace;uuuvxw:=uuxyuv;uuuvxw:=uuxyuu;send(uuuwwz,uuuuxw,uuxyuv);forget(uuxyuv);pause(5) ENDPROCuuuzxx; PROCuuxyvz: IFchannel
(myself)<>archivechannel THENarchive("");release(archive);continue(archivechannel) FI ENDPROCuuxyvz; PROCisparchivemanager:globalmanager( PROC( DATASPACE VAR, INT
 CONST, INT CONST, TASK CONST)isparchivemanager) ENDPROCisparchivemanager; PROCisparchivemanager( DATASPACE VARuuxyxv, INT CONSTuuxyxw,uuxyxx, TASK CONSTuuxyxy): IF
uuxyxw>=uuuuvu THENforget(uuxyxv);uuxyyw(uuxyxw) ELSEclearerror;enablestop;uuxyyy;forget(uuuvyy);forget(uuuvyw);uuuvyw:=uuxyxv;forget(uuxyxv);uuuwwx:=uuxyxw;uuuwwz
:=uuxyxy; SELECTuuuwwx OF CASEuuuuwu:uuvxuy;uuwvuz CASEuuuuyz:uuuvxw:=uuuvyw;uuvwxx(uuuvxw);uuwvuz CASEuuuuzu:uuuzwx;uuwvuz CASEuuuuwv:uuvuuv;uuwvuz CASEuuuuvv:uuwywy
(uuxyxx) CASEuuuuwz,uuuuxu:uuwuuv CASEuuuuxz,uuuuyu,uuuuyv:uuwyzy CASEuuuuxy:uuxzyz;uuxzzu;uuwvuz CASEuuuuyw:uuuvvz( FALSE);forget(uuuvyw);break(quiet) CASEuuuuyx
:uuuvvz( FALSE);uuxyvz;uuuwxu:=uuuwwz;uuwvuz CASEuuuuyy:uuuvvz( FALSE);uuuwxu:=niltask;break(quiet);uuwvuz OTHERWISE:errorstop("Falscher Auftrag!") ENDSELECT;uuuwyw
:=clock(1) FI.uuxzzu:break(quiet);archive(uuyuvz);commanddialogue( FALSE);disablestop; SELECTuuyuwu OF CASE0:format(archive) CASE1:format(uuyuwu,archive) CASE2:format
(uuyuwu,archive) CASE3:format(uuyuwu,archive) OTHERWISE:errorstop("Falscher Formatcode: "+text(uuyuwu)) ENDSELECT;uuuwvx:=iserror;clearerror;commanddialogue( TRUE
);release(archive);uuxyvz; IFuuuwvx THENerrorstop(errormessage) FI;enablestop;uuvwxx(uuyuvz).uuyuvz:subtext(uuuvxw,2,length(uuuvxw)).uuyuwu:code(uuuvxw SUB1).uuxzyz
:uuuvxw:=uuuvyw.uuxyyy:uuyuzv;uuyuzw;uuuwyw:=clock(1).uuyuzw: IF NOT(uuuwxu=uuxyxy) CANDuuxyxw<>uuuuyx CANDuuxyxw<>uuuuyy CANDuuxyxw<>uuuuyw THENerrorstop("Archive nicht angemeldet"
) FI.uuyuzv: IF NOTuuyvvw THENerrorstop("EUMELbase-Archive wird von Task "+name(uuuwxu)+" benutzt") FI.uuyvvw:uuxyxy=uuuwxu ORuuuwxu=niltask OR NOTexists(uuuwxu) OR
uuyvwx.uuyvwx:abs(uuuwyw-clock(1))>600.0. ENDPROCisparchivemanager; PROCuuxyyw( INT CONSTuuuwwx): TEXT VARuuyvxx:="";enablestop;break(quiet);continue(uuuwwx-uuuuvu
);disablestop; REPcommanddialogue( TRUE);getcommand("Gib ISP-ARCHIVE-Kommando:",uuyvxx);do(uuyvxx) UNTIL NOTonline PER;commanddialogue( FALSE);break(quiet);setautonom
 END PROCuuxyyw; PROCuuyvyx( TEXT CONSTtext):break(quiet);continue(1);out(text);continue(archivechannel) ENDPROCuuyvyx; PROCuuxuuz:forget(uuuvyw);uuuvyw:=nilspace
 ENDPROCuuxuuz; ENDPACKETisparchivemanager;

