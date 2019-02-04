 PACKETphonpacket DEFINESphoneticcode,gross,allesgross:#$ IFmitphonetic THEN# LETa=65,uuuuuv=66,uuuuuw=67,uuuuux=68,e=69,uuuuuy=70,uuuuuz=71,uuuuvu=72,uuuuvv=73,uuuuvw
=74,uuuuvx=75,uuuuvy=76,uuuuvz=77,uuuuwu=78,uuuuwv=79,uuuuww=80,uuuuwx=81,uuuuwy=82,uuuuwz=83,uuuuxu=84,uuuuxv=85,uuuuxw=86,uuuuxx=87,uuuuxy=88,uuuuxz=89,uuuuyu=90
,uuuuyv=214,uuuuyw=215,uuuuyx=216,uuuuyy=251; TEXT VARuuuuyz:="",uuuuzu:="";#$ FI# TEXT PROCgross( TEXT CONSTuuuuzw): IFcode(uuuuzw)>96 CANDcode(uuuuzw)<123 THENcode
(code(uuuuzw)-32) ELIFcode(uuuuzw)>216 CANDcode(uuuuzw)<220 THENcode(code(uuuuzw)-3) ELSEuuuuzw FI END PROCgross; TEXT PROCallesgross( TEXT CONSTword): TEXT VARuuuvvu
:=""; INT VARuuuuvv; FORuuuuvv FROM1 UPTOlength(word) REPuuuvvu CATgross(word SUBuuuuvv); PER;uuuvvu END PROCallesgross; PROCchange( TEXT VARuuuvww, TEXT CONSTuuuvwx
, INT CONSTpos):change(uuuvww,pos,pos,uuuvwx) ENDPROCchange; TEXT PROCphoneticcode( TEXT CONSTuuuvxv): TEXT VARuuuvxw:="";#$ IFmitphonetic THEN# INT VARuuuvxx:=1;
 WHILEuuuvxx<=length(uuuvxv) REP SELECTcode(gross(uuuvxv SUBuuuvxx)) OF CASEuuuuvu:uuuvyy CASEa:uuuvxw CAT"6";uuuvzu CASEuuuuvv:uuuvxw CAT"8";uuuvzx CASEuuuuwv:uuuvxw
 CAT"9";uuuwuu CASEuuuuxv:uuuvxw CAT"0";uuuwux CASEuuuuwz:uuuvxw CAT"2";uuuwvu CASEuuuuyv,uuuuyw,e:uuuvxw CAT"7" CASEuuuuvw,uuuuyx,uuuuxz:uuuvxw CAT"8" CASEuuuuuv
,uuuuuy,uuuuww,uuuuxw,uuuuxx:uuuvxw CAT"1" CASEuuuuuw,uuuuuz,uuuuvx,uuuuwx,uuuuxy,uuuuyu,uuuuyy:uuuvxw CAT"2" CASEuuuuux,uuuuxu:uuuvxw CAT"3" CASEuuuuvy,uuuuwy:uuuvxw
 CAT"4" CASEuuuuvz,uuuuwu:uuuvxw CAT"5" ENDSELECT;uuuvxx INCR1; IFlength(uuuvxw)>1 CAND(uuuvxw SUBlength(uuuvxw))=(uuuvxw SUB(length(uuuvxw)-1)) THENchange(uuuvxw
,"",length(uuuvxw)) FI PER;#$ FI#uuuvxw.#$ IFmitphonetic THEN#uuuvyy:.uuuvzu: IFuuuvxx<length(uuuvxv) THENuuuuzu:=gross(uuuvxv SUB(uuuvxx+1)); IFuuuuzu="E" THENchange
(uuuvxw,"7",length(uuuvxw));uuuvxx INCR1; ELSE IFuuuuzu="I" ORuuuuzu="Y" THENchange(uuuvxw,"7",length(uuuvxw));uuuvxw CAT"8";uuuvxx INCR1; FI FI FI.uuuwuu:uuuvzu;
 IF(uuuvxw SUBlength(uuuvxw))="8" THENchange(uuuvxw,"0",length(uuuvxw)); FI.uuuvzx: IFuuuvxx<length(uuuvxv) THENuuuuzu:=gross(uuuvxv SUB(uuuvxx+1)); IFuuuuzu="H" THEN
change(uuuvxw,"7",length(uuuvxw));uuuvxx INCR1; FI FI.uuuwux: IFuuuvxx<length(uuuvxv) THENuuuuzu:=gross(uuuvxv SUB(uuuvxx+1)); IFuuuuzu="E" THENchange(uuuvxw,"8",
length(uuuvxw));uuuvxx INCR1; FI FI.uuuwvu: IFuuuvxx<length(uuuvxv)-1 THENuuuuzu:=gross(uuuvxv SUB(uuuvxx+1));uuuuyz:=gross(uuuvxv SUB(uuuvxx+2)); IFuuuuzu="C" AND
uuuuyz="H" THENuuuvxx INCR2; FI FI.#$ FI# ENDPROCphoneticcode; ENDPACKETphonpacket;

