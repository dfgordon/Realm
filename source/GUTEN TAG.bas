 10  HGR : TEXT : HOME : VTAB 11
 20  PRINT  TAB( 16);"-REALM-"
 30  ONERR GOTO 50
 40  PRINT  CHR$ (4);"RUN LAUNCH"
 50  ONERR GOTO 99
 60  PRINT  CHR$ (4);"RUN AUTOSTART"
 99  PRINT "COULD NOT FIND PROGRAM."
 100  END