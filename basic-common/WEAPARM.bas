10  ON I GOTO 11,12,13,14,15,16,17,18,19,20,21,22,23
11 C = 30: B$ = "DAGGER": RETURN
12 C = 80: B$ = "AXE": RETURN
13 C = 80: B$ = "MACE": RETURN
14 C = 100: B$ = "MORNING STAR": RETURN
15 C = 120: B$ = "BOW": RETURN
16 C = 200: B$ = "LONGSWORD": RETURN
17 C = 300: B$ = "BATTLEAXE": RETURN
18 C = 340: B$ = "BROADSWORD": RETURN
19 C = 500: B$ = "2H SWORD": RETURN
20 C = 2000: B$ = "SWORD OF LIGHT": RETURN
21 C = 90: B$ = "LEATHER": RETURN
22 C = 180: B$ = "CHAIN": RETURN
23 C = 400: B$ = "PLATE": RETURN

3720  TEXT: HOME: PRINT "PLACING: ";B$: GOSUB 4210
3730  PRINT: PRINT "USE ARROWS TO CHANGE CHARACTER": PRINT "1-8 REPLACES, ESC ABORTS ": GET A$
3740  IF A$ = CHR$(27) THEN PRINT: PRINT "SALE ABORTED! ";: GET A$: RETURN
3741  IF A$ = CHR$(8) THEN A = A - 1: GOTO 3790
3742  IF A$ = CHR$(21) THEN A = A + 1: GOTO 3790
3743  I = VAL(A$) - 1: IF I<0 OR I>7 THEN 3790
3750  IF AP$(A,I) = "" THEN 3760
3751  HOME: PRINT "REPLACE ";AP$(A,I);" (Y/N) ? ";: GET A$: IF A$ <> "Y" AND A$ <> "N" THEN 3751
3752  IF A$ = "N" THEN 3720
3760 AP$(A,I) =  LEFT$ (B$ + " ", LEN (B$)): AD% = AD% - C: PRINT: PRINT "SALE COMPLETE! ";: GET A$: RETURN
3790  IF A<0 THEN A = 0
3791  IF A>3 THEN A = 3
3792  GOTO 3720

4210  PRINT NM$(A);"'S ITEMS:": FOR I = 0 TO 7: PRINT I + 1;") ";: PRINT AP$(A,I): NEXT: RETURN

4300  PRINT "FOR SALE:"
4310  P = 1: N = 9: IF M = 15 THEN P = 11: N = 13
4320  IF T$="SULPHUR CITY" AND M = 10 THEN P = 1: N = 10
4330  FOR I = P TO N: GOSUB 10: GOSUB 19000: NORMAL: IF I=P THEN INVERSE
4340  PRINT B$;: NORMAL: PRINT " (";C;")": NEXT: RETURN

8900  REM

9500  HOME : VTAB 21: PRINT "CHARACTER TO TRANSACT (#) ";: GET A$:A =  VAL (A$) - 1: IF A < 0 OR A > 3 THEN 9500
9501  IF AB%(A) = 0 THEN 9500
9510  TEXT: HOME: PRINT "WELCOME TO THE ";
9511  IF M = 10 THEN PRINT "WEAPONS SHOP!"
9512  IF M = 15 THEN PRINT "ARMOURY!"
9520  PRINT: GOSUB 4300: I = P
9530  HTAB 1: VTAB 6+N-P: PRINT "GOLD: ";AD%;"- ARROWS, ENTER, ESC: ";: GET A$: IF A$ = CHR$(27) THEN 25000
9540  L = 0: IF A$ = CHR$(13) THEN GOSUB 10: GOSUB 19000: GOTO 9560
9550  IF A$ = CHR$(8) OR A$ = CHR$(11) THEN L = -1
9551  IF A$ = CHR$(10) OR A$ = CHR$(21) THEN L = 1
9552  GOSUB 10: HTAB 1: VTAB 4+I-P: PRINT B$: I = I + L
9553  IF I<P THEN I=N
9554  IF I>N THEN I=P
9555  GOSUB 10: HTAB 1: VTAB 4+I-P: INVERSE: PRINT B$: NORMAL: GOTO 9530

9560  IF AD% < C THEN PRINT: PRINT "YOU DON'T HAVE THE GOLD! ";: GOSUB 30050: GOTO 9510
9670  L = A: GOSUB 3720: A = L: GOTO 9510

19000 C = INT (C * (1 - AK%(A) / 100)): RETURN

25000  POKE -16304,0: POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 25000

30050  POKE 6,50: POKE 7,25: POKE 8,1: POKE 9,1: POKE 30,1: CALL 852: GET A$: RETURN
