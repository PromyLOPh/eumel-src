#$ IFmitinternerquery THEN# PACKETqueryref DEFINESputref,getreftext,anzahlrefs,listerefs,clearrefs: LETuuuuuv=50,uuuuuw=1,uuuuux=2; LET REFELEMENT= ROW2 TEXT; TYPE
 REFINEMENT= STRUCT( INTuuuuuy, ROWuuuuuv REFELEMENTuuuuvu); REFINEMENT VARuuuuvv; PROCputref( TEXT CONSTuuuuvw,uuuuvx): INT VARuuuuvy; FORuuuuvy FROM1 UPTOuuuuvv
.uuuuuy REP IFuuuuvv.uuuuvu[uuuuvy][uuuuuw]=uuuuvw THENuuuuvv.uuuuvu[uuuuvy][uuuuuw]:=uuuuvx; LEAVEputref FI PER; IFuuuuvv.uuuuuy=uuuuuv THENerrorstop("Zuviele Refinements!"
) FI;uuuuvv.uuuuuy INCR1;uuuuvv.uuuuvu[uuuuvv.uuuuuy][uuuuuw]:=uuuuvw;uuuuvv.uuuuvu[uuuuvv.uuuuuy][uuuuux]:=uuuuvx ENDPROCputref; TEXT PROCgetreftext( TEXT CONSTuuuuvw
): INT VARuuuuvy; FORuuuuvy FROM1 UPTOuuuuvv.uuuuuy REP IFuuuuvv.uuuuvu[uuuuvy][uuuuuw]=uuuuvw THEN LEAVEgetreftext WITHuuuuvv.uuuuvu[uuuuvy][uuuuux] FI PER;uuuuvw
 ENDPROCgetreftext; PROCclearrefs: INT VARuuuuvy; FORuuuuvy FROM1 UPTOuuuuvv.uuuuuy REPuuuuvv.uuuuvu[uuuuvy][uuuuuw]:="";uuuuvv.uuuuvu[uuuuvy][uuuuux]:="" PER;uuuuvv
.uuuuuy:=0 ENDPROCclearrefs; INT PROCanzahlrefs:uuuuvv.uuuuuy ENDPROCanzahlrefs; PROClisterefs: INT VARuuuwuu;note("Liste der Refinements :");noteline;note("======================="
);noteline;noteline; FORuuuwuu FROM1 UPTOanzahlrefs REPnote(text(uuuuvv.uuuuvu[uuuwuu][uuuuuw],30)+":"+uuuuvv.uuuuvu[uuuwuu][uuuuux]);noteline PER ENDPROClisterefs
; ENDPACKETqueryref;#$ FI#

