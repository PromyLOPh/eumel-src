 PACKETdbarchive DEFINESdbtoarchive,dbfromarchive: TEXT VARuuuuuv:=""; PROCdbtoarchive( TEXT CONSTuuuuux):enablestop;logonarchive;fetchdb(uuuuux);uuuuuz;savetoarchive
(db);uuuuvu;logoffarchive. ENDPROCdbtoarchive; PROCdbfromarchive( TEXT CONSTuuuuux):dbfromarchive(uuuuux,"") ENDPROCdbfromarchive; PROCdbfromarchive( TEXT CONSTuuuuux
, TEXT CONSTuuuuwx):enablestop;logonarchive;uuuuuv:=postfix;postfix(uuuuwx);fetchfromarchive;uuuuuz; IF NOTtaskda(uuuuux) THEN IFyes("Server anlegen") CANDuuuuxw THEN
restoredb(uuuuux);uuuuvu FI ELSErestoredb(uuuuux);uuuuvu FI;uuuuyv.uuuuyv:postfix("");fetchdd(uuuuux); BOOL VARuuuuyy:=dbopen(uuuuux);postfix(uuuuuv);logoffarchive
.uuuuxw: IF NOTexists(uuuuux) THENcopy(uuuuux+uuuuwx,uuuuux) FI;createdb(uuuuux). ENDPROCdbfromarchive; PROCuuuuuz: IFonline THENline; FI ENDPROCuuuuuz; PROCuuuuvu
:commanddialogue( FALSE);forget(db);commanddialogue( TRUE) ENDPROCuuuuvu; ENDPACKETdbarchive;

