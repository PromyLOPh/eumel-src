 PACKETisparchive DEFINESarchivefiles,archivesize,savetoarchive,fetchfromarchive,initarchive,cleararchive,cleararchivetask,checkarchive,listarchive,formatarchive,
channelfree,logonarchive,logoffarchive,cleareacharchive,writefactor,readafterwrite,kf: LETuuuuuv=1,uuuuuw=2,uuuuux=34,uuuuuy=35,uuuuuz=25,uuuuvu=26,uuuuvv=36,uuuuvw
=37,uuuuvx=39,uuuuvy=40,uuuuvz=41,uuuuwu=42,uuuuwv=43,uuuuww=44,uuuuwx=45,uuuuwy=46,uuuuwz=47,uuuuxu=48,uuuuxv=200,uuuuxw="�",fehlertext="ARCHIVE-Fehler: "; LET ARCHIVECONTROL
= STRUCT( INTuuuuxx, BOOLuuuuxy); BOUND ARCHIVECONTROL VARuuuuxz; INT VARuuuuyu,uuuuyv,uuuuyw,uuuuyx:=1; THESAURUS VARuuuuyy; TEXT VARuuuuyz:=""; BOOL VARuuuuzu:=
 FALSE,uuuuzv:= FALSE,uuuuzw:= FALSE; BOUND STRUCT( INTuuuuzx, ROWuuuuxv TEXTuuuuzz) VARuuuvuu; DATASPACE VARuuuvuv; PROCkf( BOOL CONSTuuuvux):uuuuzw:=uuuvux ENDPROC
kf; PROCreadafterwrite( BOOL CONSTuuuuxy):uuuuzv:=uuuuxy ENDPROCreadafterwrite; BOOL PROCreadafterwrite:uuuuzv ENDPROCreadafterwrite; PROCwritefactor( INT CONSTuuuuxy
):uuuuyx:=uuuuxy ENDPROCwritefactor; INT PROCwritefactor:uuuuyx ENDPROCwritefactor; BOOL PROCcleareacharchive:uuuuzu ENDPROCcleareacharchive; PROCcleareacharchive
( BOOL CONSTuuuvyx):uuuuzu:=uuuvyx ENDPROCcleareacharchive; PROCcleararchivetask:logoffarchive;logonarchive ENDPROCcleararchivetask; THESAURUS PROCarchivefiles:uuuuyy
 ENDPROCarchivefiles; INT PROCarchivesize:archivesize( SOMEmyself) ENDPROCarchivesize; INT PROCarchivesize( THESAURUS CONSTuuuwvu):uuuuyy:=uuuwvu;uuuuyu:=0;uuuuyv
:=1;uuuuyw:=0;get(uuuuyy,uuuuyz,uuuuyu); WHILEuuuuyu>0 REPuuuuyw INCRstorage(old(uuuuyz));uuuuyv INCR1;get(uuuuyy,uuuuyz,uuuuyu) PER;uuuuyw ENDPROCarchivesize; TASK
 PROCuuuwyu:/"isp.archive" ENDPROCuuuwyu; BOUND TEXT VARuuuwyw; BOUND INT VARuuuwyx; DATASPACE VARuuuwyy; INT VARuuuwyz; TASK VARuuuwzu:=niltask; PROCformatarchive
( TEXT CONSTuuuwzw):formatarchive(0,uuuwzw) ENDPROCformatarchive; PROCformatarchive( INT CONSTuuuxuv, TEXT CONSTuuuwzw): IFpos("0123",text(uuuxuv))>0 THENuuuxuy(uuuuvy
,code(uuuxuv)+uuuwzw, TRUE) FI ENDPROCformatarchive; PROCsavetoarchive( THESAURUS CONSTuuuwvu): IFuuuuzu THENcleararchive; FI;do( PROC( TEXT CONST)uuuxwv,uuuwvu);
 ENDPROCsavetoarchive; PROCfetchfromarchive:uuuxwz;uuuxxu;uuuxxv.uuuxwz:uuuxxx;call(uuuwyu,uuuuvz,uuuwyy,uuuwyz).uuuxxu: INT VARuuuxyx:=uuuuvz; WHILEuuuwyz<>uuuuvx
 REPuuuxzv; IFuuuwyz=uuuuvw THENuuuxzy ELSEuuuxxx;call(uuuwyu,uuuxyx,uuuwyy,uuuwyz) FI PER.uuuxzv: SELECTuuuwyz OF CASEuuuuuw:uuuwyw:=uuuwyy;enablestop;errorstop(
fehlertext+uuuwyw) CASEuuuuvw: IFcommanddialogue THENuuuyvz;uuuwyw:=uuuwyy;out(uuuwyw) FI CASEuuuuvv:uuuyvz; IFuuuywz THENerrorstop("Archivieren inkonsistent abgebrochen"
) FI;uuuxyx:=uuuuwu ENDSELECT.uuuxxv: INT VARuuuyxx;forget(uuuvuv);uuuvuv:=uuuwyy;uuuvuu:=uuuvuv; FORuuuyxx FROM1 UPTOuuuvuu.uuuuzx REP#out("<"+uuuvuu.uuuuzz[uuuyxx
]+">");uuuyvz;#uuuyzy PER;forget(uuuvuv).uuuyzy:uuuxxx;uuuwyx:=uuuwyy;uuuwyx:=uuuyxx;call(uuuwyu,uuuuwv,uuuwyy,uuuwyz);forget(uuuvuu.uuuuzz[uuuyxx],quiet);copy(uuuwyy
,uuuvuu.uuuuzz[uuuyxx]). ENDPROCfetchfromarchive; BOOL PROCuuuywz: REPuuuyvz; IFonline THENout(2*uuuuxw) FI; IFyes("Nachfolgende Archive-Diskette eingelegt") THEN
 LEAVEuuuywz WITH FALSE FI UNTILuuuuzw COR( NOTuuuuzw CANDyes("Sicherung wirklich abbrechen")) PER; TRUE ENDPROCuuuywz; PROCuuuxwv( TEXT CONSTuuuzyw#, BOOL PROCuuuzyx
#):save(uuuzyw,uuuwyu); IFcommanddialogue THENuuuyvz;out(""""+uuuzyw+""" wird gesichert!");#uuuyvz# FI;uuuzzx;uuuzzy.uuuzzx:uuuxxx;uuuuxz:=uuuwyy;uuuuxz.uuuuxx:=uuuuyx
;uuuuxz.uuuuxy:=uuuuzv;call(uuuwyu,uuuuux,uuuwyy,uuuwyz);uuvuwv.uuvuwv: WHILEuuuwyz<>uuuuvv REPuuuxzv;uuuxzy PER.uuuzzy: REP IFuuuwyz=uuuuvv THENuuuyvz; IFuuuywz THEN
errorstop("Sichern eventuell inkonsistent abgebrochen!"); LEAVEuuuxwv ELSE IFuuuuzu THENcleararchive; FI;out(""""+uuuzyw+""" wird gesichert!"); FI ELSEuuuxzv FI;uuuxxx
; IF NOTuuvuzu THENcall(uuuwyu,uuuuuy,uuuwyy,uuuwyz) ELSEuuuxzy FI; PER.uuvuzu:uuuwyz=uuuuvw.uuuxzv: SELECTuuuwyz OF CASEuuuuuw:uuuwyw:=uuuwyy;enablestop;errorstop
(fehlertext+uuuwyw) CASEuuuuvx: LEAVEuuuxwv CASEuuuuvw: IFcommanddialogue THENuuuwyw:=uuuwyy;uuuyvz;out(uuuwyw); FI ENDSELECT. ENDPROCuuuxwv; PROCinitarchive( TEXT
 CONSTuuvvxu):uuuxuy(uuuuwz,uuvvxu, TRUE) ENDPROCinitarchive; PROCcheckarchive:uuuxuy(uuuuxu) ENDPROCcheckarchive; PROCcleararchive:uuuxuy(uuuuuz) ENDPROCcleararchive
; PROClistarchive:uuuxuy(uuuuvu);forget("ISP-Archive",quiet);type(uuuwyy,1003);copy(uuuwyy,"ISP-Archive");show("ISP-Archive");forget("ISP-Archive",quiet) ENDPROClistarchive
; PROClogonarchive:uuuxuy(uuuuwx,"", FALSE) ENDPROClogonarchive; PROClogoffarchive:uuuxuy(uuuuwy,"", FALSE) ENDPROClogoffarchive; PROCuuuxuy( INT CONSTuuvwvy):uuuxuy
(uuvwvy,"", FALSE) ENDPROCuuuxuy; PROCuuuxuy( INT CONSTuuvwvy, TEXT CONSTuuvwwy, BOOL CONSTuuvwwz):uuvwxu; WHILEuuvwxv REPuuvwxw;uuuxzy PER.uuvwxv:uuuwyz<>uuuuvx.
uuvwxu:uuuxxx; IFuuvwwz THENuuuwyw:=uuuwyy;uuuwyw:=uuvwwy FI;call(uuuwyu,uuvwvy,uuuwyy,uuuwyz).uuvwxw: IFuuuwyz=uuuuvw THEN IFcommanddialogue THENuuuwyw:=uuuwyy;uuuyvz
;out(uuuwyw) FI ELIFuuuwyz=uuuuuw THENuuuwyw:=uuuwyy;enablestop;errorstop(fehlertext+uuuwyw) FI. ENDPROCuuuxuy; PROCuuuxzy: REPforget(uuuwyy);wait(uuuwyy,uuuwyz,uuuwzu
); IF NOT(uuuwzu=uuuwyu) THEN#note("IN WARTE: "+text(uuuwyz)+"/"+name(uuuwzu));noteline;#uuvxxy FI UNTILuuuwzu=uuuwyu PER ENDPROCuuuxzy; PROCuuvxxy:send(uuuwzu,uuuuuv
,uuuwyy) ENDPROCuuvxxy; PROCchannelfree: DATASPACE VARuuvxzw:=nilspace;send(uuuwyu,uuuuww,uuvxzw);forget(uuvxzw) ENDPROCchannelfree; PROCuuuxxx:forget(uuuwyy);uuuwyy
:=nilspace ENDPROCuuuxxx; PROCuuuyvz: IFonline THENline; FI ENDPROCuuuyvz; ENDPACKETisparchive;

