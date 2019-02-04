 PACKETdbmanager DEFINESgeneratedbmanager: LETuuuuuv=0,uuuuuw=1,uuuuux=2,#uuuuuy=3,uuuuuz=4,#uuuuvu=5,uuuuvv=12,uuuuvw=30,uuuuvx=31,uuuuvy=32,uuuuvz=33,uuuuwu=100
; DATASPACE VARuuuuwv:=nilspace,uuuuww:=nilspace; TASK VARuuuuwx:=niltask,uuuuwy:=niltask; INT VARuuuuwz,uuuuxu:=0,uuuuxv; BOOL VARuuuuxw:= FALSE; BOUND TEXT VARuuuuxx
; BOUND STRUCT( TEXTname,uuuuxy,uuuuxz) VARuuuuyu; TEXT VARuuuuyv:=""; PROCuuuuyw: IFiserror THENforget(uuuuwv);uuuuwv:=nilspace;uuuuxx:=uuuuwv; CONCR(uuuuxx):=errormessage
;clearerror;send(uuuuwx,uuuuux,uuuuwv) FI ENDPROCuuuuyw; PROCgeneratedbmanager:break;setautonom;disablestop; REPwait(uuuuwv,uuuuwz,uuuuwx);#continue(2);write("Order :"
+text(uuuuwz)+" O-Task :"+name(uuuuwx));pause;break;# IFuuuuxw CANDuuuuwx<>uuuuwy THENuuuvvx ELSEcontrol FI;uuuvvy PER.uuuvvy: IFheapsize>uuuuxu+2 THENcollectheapgarbage
;uuuuxu:=heapsize FI. ENDPROCgeneratedbmanager; PROCcontrol:commanddialogue( FALSE);#enablestop;# SELECTuuuuwz OF CASEuuuuvw:uuuvwz CASEuuuuvx:uuuvxv CASEuuuuvz:uuuvxx
 CASEuuuuvy:uuuvxz CASEuuuuvu,uuuuvv:uuuvyw OTHERWISE: IFuuuuwz>=uuuuwu ANDuuuuwx=supervisor THENforget(uuuuwv);uuuvzv ELSEerrorstop("Falscher Auftrag fuer EUMELbase-Manager-Task ""MM""!"
);uuuuyw FI; END SELECT.uuuvxz:uuuuww:=uuuuwv;forget(uuuuwv); IFuuuwuv<>niltask THENerrorstop("Datenbank-Server bereits vorhanden");uuuuyw ELSEuuuwux;uuuuxw:= TRUE
;uuuwuz FI.uuuvxv:uuuuww:=uuuuwv;forget(uuuuwv); IFuuuwuv<>niltask THENend(uuuwuv) FI;uuuwuz.uuuvwz:uuuuxw:= FALSE;send(uuuwuv,uuuuuv,uuuuww,uuuuxv); IFuuuuxv<>uuuuuv
 THENforget(uuuuww) FI.uuuvyw: IF NOTuuuuxw THENuuuuyu:=uuuuwv;uuuuyv:=uuuuyu.name; IFexists(uuuuyv) THENforget(uuuuyv,quiet) FI;uuuuwy:=uuuuwx;send(uuuuwx,uuuuvu
,uuuuwv);uuuuxw:= TRUE ELSEuuuuxw:= FALSE;copy(uuuuwv,uuuuyv);uuuwuz FI.uuuvxx:uuuuww:=uuuuwv;forget(uuuuwv); IFuuuwuv<>niltask THEN REPsend(uuuwuv,uuuuvz,uuuuww,
uuuuxv) UNTILuuuuxv=uuuuuv PER; ELSEuuuvxz FI;uuuwuz. END PROCcontrol; TASK PROCuuuwuv: TASK VARuuuxxu;disablestop;clearerror;uuuxxu:=task(uuuxxw); IFiserror THEN
uuuxxu:=niltask FI;clearerror;enablestop;uuuxxu ENDPROCuuuwuv; TEXT PROCuuuxxw:forget("X",quiet);copy(uuuuww,"X"); IFdbopen("X") THENname(1) ELSE"???" FI ENDPROCuuuxxw
; PROCuuuwux:begin(uuuxxw, PROCautonomserver,uuuuwy) END PROCuuuwux; PROCuuuwuz:forget(uuuuwv);uuuuwv:=nilspace;send(uuuuwx,uuuuuv,uuuuwv) END PROCuuuwuz; PROCuuuvvx
:forget(uuuuwv);uuuuwv:=nilspace;send(uuuuwx,uuuuuw,uuuuwv) END PROCuuuvvx; TEXT VARuuuyvx:=""; PROCuuuvzv:enablestop;continue(uuuuwz-uuuuwu);disablestop; REPcommanddialogue
( TRUE);getcommand("Gib DB-Kommando (NUR AUTHORISIERTES PERSONAL !):",uuuyvx);do(uuuyvx) UNTIL NOTonline PER;commanddialogue( FALSE);break(quiet);setautonom END PROC
uuuvzv; BOOL OP<>( TASK CONSTuuuywy,uuuywz): NOT(uuuywy=uuuywz) ENDOP<>; ENDPACKETdbmanager;

