10 M = FRE(0)
20 IF PG$="TOWN" THEN 100
22 IF PG$="OUTSIDE" THEN 300
24 IF PG$="DUNGEON" THEN 500
25 IF PG$="COMBAT" THEN 600

100  D = 1: IF RM$="ARRINEA" THEN D = 0
105  GOSUB 9000
110  IF R%=1 THEN 160
115  IF MD%=1 THEN PRINT CHR$(4);"BSAVE ";RM$;",A$8000,L3200": MD% = 0
120  PRINT CHR$(4);"BLOAD TOWNPIC.";X;".";Y
130  I = 33568 : GOSUB 8000
140  PRINT CHR$(4);"BLOAD TWNSPS"
160  PRINT CHR$(4);"BLOAD ";PG$
170  IF R%=1 THEN 190
180  POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 0
190  POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 10

300  D = 1: IF RM$="ARRINEA" THEN D = 0
305  GOSUB 9000
310  PRINT CHR$(4);"BLOAD ";RM$
330  PRINT CHR$(4);"BLOAD ";PG$
340  POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 5

500  IF R%=1 THEN D = 2: GOSUB 9000: GOTO 580
501  IF R%=2 OR MD%=0 THEN 530
510  D = 1: IF RM$="ARRINEA" THEN D = 0
520  GOSUB 9000: PRINT CHR$(4);"BSAVE ";RM$;",A$8000,L3200": MD% = 0
530  D = 1: GOSUB 9000: PRINT CHR$(4);"BLOAD DNGPIC.";X;".";Y
540  I = 34768 : GOSUB 8000
550  D = 2 : GOSUB 9000
560  PRINT CHR$(4);"BLOAD DNGNSPS"
580  PRINT CHR$(4);"BLOAD ";PG$
585  IF R%=1 THEN 595
590  POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 0
595  POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 10

600  D = 0: IF DG% = 1 THEN D = 2
610  IF DG% = 0 AND RM$ <> "ARRINEA" THEN D = 1
620  GOSUB 9000: PRINT CHR$(4);"BLOAD COMBAT"
630  POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 10

8000  B$ = ""
8010  IF  PEEK (I) = 0 THEN 8030
8020  B$ = B$ +  CHR$ ( PEEK (I)):I = I + 1: GOTO 8010
8030  A = (40 -  LEN (B$)) / 2: HOME : VTAB 21
8040  PRINT  TAB( A);B$: FOR P = 0 TO EP: NEXT P
8050  RETURN

9000  REM VERIFY DISK
9110  ONERR  GOTO 9200
9120  PRINT: PRINT  CHR$(4);"VERIFY DISK";D;",S";WS%(D);",D";WD%(D);",V";WV%(D): POKE 216,0: RETURN
9200  HOME : VTAB 21: PRINT "INSERT ";DL$(D);" DISK IN S";WS%(D);"D";WD%(D);"- ";: GET A$: CALL 768: PRINT : RESUME
