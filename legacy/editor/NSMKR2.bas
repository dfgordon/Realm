 0  GOTO 1000
 1 M = 8232
 10 B =  INT (Y / 8):Q = 9
 11 B = B + 1
 20  IF B < 9 THEN 100
 30  IF B > 16 THEN 200
 40 BY = M + ((B - Q) * 128)
 50  IF (Y / 8) =  INT (Y / 8) THEN 60
 55  GOTO 70
 60 BY = BY +  INT (X / 7): GOTO 300
 70 Z = (Y / 8) -  INT (Y / 8)
 75 Z = Z * 10
 80 Z =  INT (Z)
 85  IF Z > 3 THEN Z = Z - 1
 90 BY = BY + (Z * 1024) +  INT (X / 7): GOTO 300
 100 M = 8192:Q = 0:B = B - 1: GOTO 40
 200 M = 8272:Q = 17: GOTO 40
 300  RETURN 
 1000 I = 3
 1001  INPUT A
 1010  HCOLOR= A
 1020  REM 
 1030  REM 
 1040 X = 70:Y = 22
 1041 MA = 0
 1050  GOSUB 1
 1060 AR =  PEEK (BY)
 1070  POKE 2048 + ((I - 1) * 24) + MA,AR
 1080  POKE BY,255 - AR
 1090 Y = Y + 1
 1100 MA = MA + 1
 1101  IF MA = 12 THEN 2000
 1102  IF MA = 24 THEN 3000
 1105  GOTO 1050
 2000 X = 78:Y = 0
 2001  GOTO 1050
 3000  NEXT I
 3001  END 