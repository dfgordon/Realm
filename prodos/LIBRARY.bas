 0 REM

 4310  PRINT "LEARNED:";TAB(10);"SPELLS (M.U.):"
 4311  PRINT "--------";TAB(10);"--------------"
 4320  FOR I = 0 TO 15
 4330  ON I+1 GOSUB 20000,20002,20004,20006,20008,20010,20012,20014,20016,20018,20020,20022,20024,20026,20028,20030
 4340  PRINT LEFT$(AX$(A,I),8);TAB(10);CHR$(65+I);") ";A$;" (";C;")"
 4350  NEXT I
 4360  RETURN

 8900  REM
 9300  GOSUB 9600
 9310  TEXT : HOME : PRINT "WELCOME TO THE LIBRARY, ";NM$(A)
 9311  PRINT : PRINT "ONE MOMENT WHILE I FILE THINGS...": FOR P = 0 TO EP: NEXT P
 9312 DX$(A) = "":P = 0:M =  FRE (0)
 9313  GOSUB 20100
 9314 M =  FRE (0):WT% =  INT (ZA%(A) / 1000) * 100 + 100:WT% = WT% + (WT% * (AG%(A) / 100))
 9315  IF CL$(A) = "RANGER" THEN WT% = WT% / 2
 9316  HOME : IF P > 15 THEN 9398
 9320 GOSUB 4310
 9323  VTAB 19: HTAB 1: PRINT "MAGIC UNITS: ";WT%;"- SELECT OR ENTER: ";: GET A$: IF A$ = CHR$(13) THEN 9398
 9324 C =  ASC (A$) - 64: IF C < 1 OR C > 16 THEN 9323
 9328  ON C GOSUB 20000,20002,20004,20006,20008,20010,20012,20014,20016,20018,20020,20022,20024,20026,20028,20030
 9330 WT% = WT% - C
 9331  IF WT% < 0 THEN 9390
 9334 I = P
 9335 P = P + 1
 9338 AX$(A,I) =  LEFT$ (A$ + " ", LEN (A$))
 9345  GOTO 9316
 9390  PRINT : PRINT "NOT ENOUGH MAGIC UNITS! ";: GOSUB 30050:WT% = WT% + C
 9391  GOTO 9316
 9398  POKE  - 16304,0: HOME : GOTO 25000

 9600  HOME : VTAB 21: PRINT "CHARACTER TO TRANSACT (#) ";: GET A$:A =  VAL (A$) - 1: IF A<0 OR A>3 THEN 9600
 9601  IF AB%(A) = 0 THEN 9600
 9602  IF CL$(A) <> "WIZARD" AND CL$(A) <> "RANGER" THEN HOME : VTAB 21: PRINT "NOT A WIZARD OR RANGER. ";: GOSUB 30050: HOME : GOTO 25000
 9604 C = (10 +  INT (ZA%(A) / 1000) * 8) * (1 - AK%(A) / 100):
 9605  PRINT: PRINT "LIBRARY COSTS ";INT(C);" GOLD, OK? (Y/N) ";: GET A$: IF A$ <> "Y" THEN HOME: GOTO 25000
 9610 AD% = AD% - C
 9620  IF AD% < 0 THEN AD% = AD% + C: HOME: VTAB 21: PRINT "YOU DON'T HAVE THE GOLD! ";: GOSUB 30050: HOME : GOTO 25000
 9630  RETURN

 20000 C = 50:A$ = "PHANTOM ARROW": RETURN
 20002 C = 75:A$ = "FIREBALL": RETURN
 20004 C = 75:A$ = "LIGHTNING BOLT": RETURN
 20006 C = 100:A$ = "RADIATION CONE": RETURN
 20008 C = 200:A$ = "ICE STORM": RETURN
 20010 C = 300:A$ = "BOMBARDMENT": RETURN
 20012 C = 60:A$ = "SLEEP": RETURN
 20014 C = 60:A$ = "STONE": RETURN
 20016 C = 80:A$ = "PARALYZE": RETURN
 20018 C = 150:A$ = "DOOM ARROW": RETURN
 20020 C = 250:A$ = "DISINTEGRATE": RETURN
 20022 C = 450:A$ = "KILL": RETURN
 20024 C = 50:A$ = "KNOCK": RETURN
 20026 C = 200:A$ = "PASSWALL": RETURN
 20028 C = 400:A$ = "FLY": RETURN
 20030 C = 100:A$ = "SHIELD": RETURN
 20100  FOR I = 0 TO 15:AX$(A,I) = "": NEXT
 20101  RETURN

 25000  POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 25000

 30050  POKE 8191,50: CALL 912
 30055  GET A$: RETURN
