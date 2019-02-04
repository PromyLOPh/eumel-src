#$IF mitinternerqueryTHEN #PACKET queryrefDEFINES putref,getreftext,
anzahlrefs,listerefs,clearrefs:LET uuuuuv=50,uuuuuw=1,uuuuux=2;LET 
REFELEMENT =ROW 2TEXT ;TYPE REFINEMENT =STRUCT (INT uuuuuy,ROW uuuuuv
REFELEMENT uuuuvu);REFINEMENT VAR uuuuvv;PROC putref(TEXT CONST uuuuvw,uuuuvx
):INT VAR uuuuvy;FOR uuuuvyFROM 1UPTO uuuuvv.uuuuuyREP IF uuuuvv.uuuuvu[
uuuuvy][uuuuuw]=uuuuvwTHEN uuuuvv.uuuuvu[uuuuvy][uuuuuw]:=uuuuvx;LEAVE putref
FI PER ;IF uuuuvv.uuuuuy=uuuuuvTHEN errorstop("Zuviele Refinements!")FI ;
uuuuvv.uuuuuyINCR 1;uuuuvv.uuuuvu[uuuuvv.uuuuuy][uuuuuw]:=uuuuvw;uuuuvv.
uuuuvu[uuuuvv.uuuuuy][uuuuux]:=uuuuvxENDPROC putref;TEXT PROC getreftext(
TEXT CONST uuuuvw):INT VAR uuuuvy;FOR uuuuvyFROM 1UPTO uuuuvv.uuuuuyREP IF 
uuuuvv.uuuuvu[uuuuvy][uuuuuw]=uuuuvwTHEN LEAVE getreftextWITH uuuuvv.uuuuvu[
uuuuvy][uuuuux]FI PER ;uuuuvwENDPROC getreftext;PROC clearrefs:INT VAR uuuuvy
;FOR uuuuvyFROM 1UPTO uuuuvv.uuuuuyREP uuuuvv.uuuuvu[uuuuvy][uuuuuw]:="";
uuuuvv.uuuuvu[uuuuvy][uuuuux]:=""PER ;uuuuvv.uuuuuy:=0ENDPROC clearrefs;INT 
PROC anzahlrefs:uuuuvv.uuuuuyENDPROC anzahlrefs;PROC listerefs:INT VAR uuuwuu
;note("Liste der Refinements :");noteline;note("=======================");
noteline;noteline;FOR uuuwuuFROM 1UPTO anzahlrefsREP note(text(uuuuvv.uuuuvu[
uuuwuu][uuuuuw],30)+":"+uuuuvv.uuuuvu[uuuwuu][uuuuux]);notelinePER ENDPROC 
listerefs;ENDPACKET queryref;#$FI #

