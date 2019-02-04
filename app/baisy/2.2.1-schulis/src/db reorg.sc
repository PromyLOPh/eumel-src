PACKET dbreorgDEFINES reorgdb:LET uuuuuv=".temporary";TEXT VAR uuuuuw:="";
INT VAR uuuuux,uuuuuy;PROC reorgdb:enablestop;uuuuuw:=name(1);uuuuvv;uuuuvw;
uuuuvx;BOOL VAR uuuuvy:=dbopen(uuuuuw)ENDPROC reorgdb;TYPE DD =STRUCT (TEXT 
name,wert,initialisierung,plausi,INT was,uuuuwv,nachkomma,uuuuww,uuuuwx,
uuuuwy,uuuuwz,uuuuxu,hilfstextnr,descript);LET uuuuxv=2978;TYPE DDROW =ROW 
uuuuxvDD ;BOUND DDROW VAR newdd;PROC uuuuxx(INT CONST uuuuux):newdd[uuuuux].
name:=name(uuuuux);newdd[uuuuux].wert:=zugriff(uuuuux);newdd[uuuuux].was:=was
(uuuuux);newdd[uuuuux].uuuuwv:=anzattr(uuuuux);newdd[uuuuux].nachkomma:=
nachkomma(uuuuux);newdd[uuuuux].uuuuww:=anzkey(uuuuux);newdd[uuuuux].uuuuwx:=
datid(uuuuux);newdd[uuuuux].uuuuwy:=posxfeld(uuuuux);newdd[uuuuux].uuuuwz:=
posyfeld(uuuuux);newdd[uuuuux].uuuuxu:=befugnis(uuuuux);newdd[uuuuux].
descript:=descript(uuuuux);newdd[uuuuux].initialisierung:=initialisierung(
uuuuux);newdd[uuuuux].plausi:=plausi(uuuuux);newdd[uuuuux].hilfstextnr:=
hilfstextnr(uuuuux)ENDPROC uuuuxx;PROC uuuuvv:forget(uuuuuw+uuuuuv,quiet);
rename(uuuuuw,uuuuuw+uuuuuv);newdd:=new(uuuuuw);FOR uuuuuxFROM 1UPTO 
firstfree-1REP uuuuxx(uuuuux)PER ;forget(uuuuuw+uuuuuv,quiet)ENDPROC uuuuvv;
LET uuuvzz=8192,uuuwuu=150;LET DATATABLE =ROW uuuvzzTEXT ;LET DINFOENTRIES =
STRUCT (BOOL uuuwuw,uuuwux,INT firstfree,uuuwuy,uuuwuz,REAL uuuwvu);LET 
DINFOTABLE =ROW uuuwuuDINFOENTRIES ;BOUND DINFOTABLE VAR uuuwvw;BOUND 
DATATABLE VAR uuuwvx,uuuwvy;TEXT PROC uuuwvz(INT CONST uuuwwu):uuuuuw+".data"
+text(uuuwwu)END PROC uuuwvz;PROC uuuuvw:uuuwvw:=old(uuuwvz(0));FOR uuuuux
FROM 1UPTO uuuwuuREP IF uuuwvw[uuuuux].uuuwuwTHEN uuuwyu;forget(uuuwvz(uuuuux
)+uuuuuv,quiet)FI PER .uuuwyu:forget(uuuwvz(uuuuux)+uuuuuv,quiet);rename(
uuuwvz(uuuuux),uuuwvz(uuuuux)+uuuuuv);uuuwvx:=new(uuuwvz(uuuuux));uuuwvy:=old
(uuuwvz(uuuuux)+uuuuuv);FOR uuuuuyFROM 1UPTO uuuwvw[uuuuux].firstfree-1REP 
uuuwvx[uuuuuy]:=uuuwvy[uuuuuy]PER .ENDPROC uuuuvw;LET uuuxwy=#21,#48,uuuxwz=#
250;96;#160;LET BINFOENTRIES =STRUCT (BOOL uuuwuw,INT firstfree,uuuwuy,uuuwuz
);LET BINFOTABLE =ROW uuuwuuBINFOENTRIES ;BOUND BINFOTABLE VAR uuuxxy;TYPE 
ENTRY =STRUCT (TEXT uuuxxz,INT uuuxyu,uuuxyv);TYPE BLOCK =STRUCT (INT uuuxyw,
uuuxyx,uuuxyy,uuuxyz,ROW uuuxwyBOOL map,ROW uuuxwyINT pointer,ROW uuuxwy
ENTRY entry);LET BLOCKTABLE =ROW uuuxwzBLOCK ;BOUND BLOCKTABLE VAR uuuxzy,
uuuxzz;TEXT PROC uuuyuu(INT CONST uuuwwu):uuuuuw+".tree"+text(uuuwwu)END 
PROC uuuyuu;PROC uuuuvx:uuuxxy:=old(uuuyuu(0));FOR uuuuuxFROM 1UPTO uuuwuu
REP IF uuuxxy[uuuuux].uuuwuwTHEN uuuywv;forget(uuuyuu(uuuuux)+uuuuuv,quiet)
FI PER .uuuywv:forget(uuuyuu(uuuuux)+uuuuuv,quiet);rename(uuuyuu(uuuuux),
uuuyuu(uuuuux)+uuuuuv);uuuxzz:=new(uuuyuu(uuuuux));uuuxzy:=old(uuuyuu(uuuuux)
+uuuuuv);#note("TREE "+text(uuuuux));noteline;note("first free:"+text(uuuxxy[
uuuuux].firstfree));noteline;note("unused    :"+text(uuuxxy[uuuuux].uuuwuy));
noteline;note("free      :"+text(uuuxxy[uuuuux].uuuwuz));noteline;#FOR uuuuuy
FROM 1UPTO uuuxxy[uuuuux].firstfree-1REP uuuxzz[uuuuuy]:=uuuxzy[uuuuuy]PER .
ENDPROC uuuuvx;OP :=(ENTRY VAR uuuzww,ENTRY CONST uuuzwx):CONCR (uuuzww):=
CONCR (uuuzwx)ENDOP :=;OP :=(BLOCK VAR uuuzww,BLOCK CONST uuuzwx):INT VAR 
uuuzxw;uuuzww.uuuxyw:=uuuzwx.uuuxyw;uuuzww.uuuxyx:=uuuzwx.uuuxyx;uuuzww.
uuuxyy:=uuuzwx.uuuxyy;uuuzww.uuuxyz:=uuuzwx.uuuxyz;FOR uuuzxwFROM 1UPTO min(
uuuzwx.uuuxyy-1,uuuxwy)REP uuuzww.entry[uuuzwx.pointer[uuuzxw]]:=uuuzwx.entry
[uuuzwx.pointer[uuuzxw]]PER ;uuuzww.map:=uuuzwx.map;uuuzww.pointer:=uuuzwx.
pointerENDOP :=;ENDPACKET dbreorg;

