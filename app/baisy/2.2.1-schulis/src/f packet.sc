 PACKETfpacket DEFINESfetchfast,savefast: LETuuuuuv=50,uuuuuw=51,uuuuux=47,uuuuuy=66,uuuuuz=0,uuuuvu=1; INT VARuuuuvv; DATASPACE VARuuuuvw; BOUND TEXT VARuuuuvx; TASK
 VARuuuuvy; TEXT VARuuuuvz:=""; PROCfetchfast( TEXT CONSTuuuuwv): TASK VARuuuuww;uuuuvy:=/uuuuwv;forget(uuuuvw);uuuuvw:=nilspace;call(/uuuuwv,uuuuux,uuuuvw,uuuuvv
); IFuuuuvv=uuuuuz THENuuuuyv FI.uuuuyv: REPforget(uuuuvw);wait(uuuuvw,uuuuvv,uuuuww); SELECTuuuuvv OF CASEuuuuuv:uuuuvx:=uuuuvw;uuuuvz:=uuuuvx;uuuvuv CASEuuuuuw:
forget(uuuuvz,quiet);copy(uuuuvw,uuuuvz);uuuvuv OTHERWISE:uuuvvv ENDSELECT PER.uuuvvv: IFuuuuww=uuuuvy CANDuuuuvv=uuuuuy THEN LEAVEuuuuyv ELSEuuuvww FI.uuuvww:send
(uuuuww,uuuuvu,uuuuvw).uuuvuv:send(uuuuww,uuuuuz,uuuuvw). ENDPROCfetchfast; PROCsavefast( TASK CONSTuuuvyv): THESAURUS VARuuuvyw:= ALLmyself; INT VARuuuvyx;uuuvyy
;uuuvyz;uuuvzu.uuuvyy:forget(uuuuvw);uuuuvw:=nilspace;send(uuuvyv,uuuuuz,uuuuvw).uuuvyz:uuuvyx:=0;get(uuuvyw,uuuuvz,uuuvyx); WHILEuuuvyx>0 REPuuuwvv;get(uuuvyw,uuuuvz
,uuuvyx) PER;.uuuwvv:uuuwwu;uuuwwv.uuuwwu:forget(uuuuvw);uuuuvw:=nilspace;uuuuvx:=uuuuvw;uuuuvx:=uuuuvz;call(uuuvyv,uuuuuv,uuuuvw,uuuuvv).uuuwwv:forget(uuuuvw);uuuuvw
:=old(uuuuvz);call(uuuvyv,uuuuuw,uuuuvw,uuuuvv).uuuvzu:forget(uuuuvw);uuuuvw:=nilspace;send(uuuvyv,uuuuuy,uuuuvw). ENDPROCsavefast; ENDPACKETfpacket;

