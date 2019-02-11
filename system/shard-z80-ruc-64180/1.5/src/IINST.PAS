PROGRAM installationsnummer_setzen ;
 { M. Staubermann, 8.2.87 }

VAR f : FILE ;
    buffer : ARRAY[0..63] OF INTEGER ;
BEGIN
 assign (f, 'EUMEL.COM') ;
 reset (f) ;
 blockread (f, buffer, 1) ;
 writeln ;
 write ('Lizenznummer (GMD) : ', buffer[$23], #13) ;
 write ('Lizenznummer (GMD) : ') ;
 readln (buffer[$23]) ;
 buffer[$24] := succ (buffer[$24]) ;
 write ('Installationsnummer: ', buffer[$24], #13) ;
 write ('Installationsnummer: ') ;
 readln (buffer[$24]) ;
 seek (f, 0) ;
 blockwrite (f, buffer, 1) ;
 close (f) ;
END.