100  POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 100

8910  REM
9214  HOME : VTAB 21: PRINT "WELCOME TO THE FOOD SHOP:               HOW MUCH GOLD (*10) ";: GET A$:C =  VAL (A$) * 10
9215  IF C = 0 THEN  HOME : GOTO 100
9216 AD% = AD% - C
9217  IF AD% < 0 THEN 9270
9218 F = C * (AK%(0)+AK%(1)+AK%(2)+AK%(3)) / 40
9220 AE = AE + F
9221  IF AE > 9999 THEN AE = 9999
9225  PRINT : PRINT "FOOD +";INT(F);" ";: GET A$: GOTO 9214
9270 AD% = AD% + C
9275  HOME : VTAB 21: PRINT "YOU DON'T HAVE THE GOLD! ";: GOSUB 30050: HOME : GOTO 100

30050  POKE 6,50: POKE 7,25: POKE 8,1: POKE 9,1: POKE 30,1: CALL 852: GET A$: RETURN
