 5  REM LOAD THIS PROGRAM AT $4001
 6  REM THEN INSERT A DISK WITH THE MAP, SHAPES, AND INTERPRETER
 7  REM CTRL-C AND SAVE THE MAP MANUALLY WHEN DONE
 10  HGR:HOME:VTAB 21
 11  INPUT "FILE TO EDIT: ";A$
 12  PRINT : PRINT : PRINT : PRINT CHR$(4);"BLOAD ";A$;",A$8000"
 13  PRINT  CHR$ (4);"BLOAD MRC3"
 14  PRINT  CHR$ (4);"BLOAD OUTSPS,A$800": PRINT  CHR$ (4);"BLOAD OUTSIDE.INTRP"
 15 XT = 20:YT = 20
 16  POKE 7680,173: POKE 7683,96
 17  POKE 8187,32: POKE  - 16304,0: POKE  - 16297,0
 18  POKE 8189,128: POKE 8188,0
 19  HOME : VTAB 21: GOTO 100
 20  POKE 8189,128: POKE 8188,0
 38  VTAB 20
 39  GET A$: PRINT
 40  IF A$ =  CHR$ (11) THEN YT = YT - 1
 50  IF A$ =  CHR$ (8) THEN XT = XT - 1
 60  IF A$ =  CHR$ (21) THEN XT = XT + 1
 70  IF A$ =  CHR$ (10) THEN YT = YT + 1
 76  IF A$ = "C" THEN 700
 100 M =  INT (XT / 2)
 101 MM =  FRE (0)
 110  POKE 8191,YT: POKE 8190,M
 115  POKE 4,72: POKE 5,22
 121 M = XT / 2
 122 Z = 1
 123  IF M =  INT (M) THEN Z = 0
 125  POKE 8185,Z
 130  POKE 8189,128: POKE 8188,0
 140  CALL 6384
 141  POKE 8189,128: POKE 8188,0: GOSUB 501
 150  GOTO 20
 155  POKE 4,72: POKE 5,22
 501 M =  INT (X / 2): POKE 8191,Y: POKE 8190,M: POKE 4,0: POKE 5,0
 502 M = X / 2
 503 Z = 0
 504  IF  LEN ( STR$ (M)) > 2 THEN Z = 1
 505  POKE 8185,Z
 509  CALL 7076: RETURN
 700  GET A$
 705  IF  VAL (A$) = 0 THEN 710
 706 A =  VAL (A$)
 707 A = A - 1
 708  GOTO 715
 710 A =  ASC (A$) - 56
 715 BY = 32768 + (YT * 40) +  INT (XT / 2)
 718 Z = 1: IF XT / 2 =  INT (XT / 2) THEN Z = 0
 720  IF Z = 1 THEN 750
 722 M =  PEEK (BY) / 16:M = M -  INT (M):M = M * 16
 724 M =  PEEK (BY) - M:M = M + A
 726  POKE BY,M
 730  GOTO 20
 750 M =  PEEK (BY) / 16:M = M -  INT (M):M = M * 16
 755 M = M + (A * 16)
 757  POKE BY,M
 760  GOTO 20
