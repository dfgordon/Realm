 1  IF  PEEK (104) <> 64 THEN  PRINT "MUST RUN AT $4001": END
 10  PT$ = "/PRODOS322MG/REALM/"
 12 GOSUB 2000
 15 X =  INT (LX / 2):Y =  INT (LY / 2)
 20  PRINT  CHR$ (4);"BLOAD MAP.INTRP"
 21  PRINT  CHR$ (4);"BLOAD ";PT$;MP$
 22  PRINT  CHR$ (4);"BLOAD ";SP$

 30  HGR
 40  POKE 8186,0: REM  HOSTILE
 50  POKE 8187,0: REM  TRAVEL
 60  OH% = OF%/256: OL% = OF%-OH%*256
 61  POKE 8174,OL%: POKE 8175,OH%: REM  DMAP OFFSET
 70  POKE 8183,0: POKE 8184,8: REM  SPRITE ADDR
 80  POKE 8188,0: POKE 8189,110: REM  MAP ADDR
 90  POKE 8176,LY: POKE 8177,LX

 100 DX = 18 - 2 * RG:DY = 6 - RG
 101  POKE 8181,RG
 102  POKE 8182,DY + 16 * DX
 103  CALL 5577 : REM DRAW FRAME

 120  POKE 8190,X: POKE 8191,Y
 125  CALL 5334
 130  HOME : VTAB 21: PRINT "ARROWS,Q,R,G: ";: GET A$
 131  IF A$ = "G" THEN 300
 140  IF A$ =  CHR$ (11) OR A$ = "-" THEN Y = Y - 1
 141  IF A$ =  CHR$ (8) OR A$ = "P" THEN X = X - 1
 142  IF A$ =  CHR$ (21) OR A$ = "[" THEN X = X + 1
 143  IF A$ =  CHR$ (10) OR A$ = ";" THEN Y = Y + 1
 144  IF A$ = "Q" THEN  END
 145  IF A$ = "R" THEN 160
 146  GOSUB 1000
 150  GOTO 120

 160  HOME : VTAB 21: PRINT "RANGE: ";: GET A$
 170 RG =  VAL (A$)
 180  HGR : GOTO 100

 300  CALL 5516: TC = PEEK(7936)
 310  HOME: VTAB 21: PRINT "TERRAIN CODE IS ";TC
 320  GET B$: GOTO 100

 1000  IF X<0 THEN X = 0
 1010  IF X=LX THEN X = LX-1
 1020  IF Y<0 THEN Y = 0
 1030  IF Y=LY THEN Y = LY-1
 1040 RETURN

 2000 TEXT:HOME
 2010 PRINT "(T)OWN, (D)UNGEON, (O)UTSIDE ";: GET A$
 2020 IF A$ = "T" THEN LX=40:LY=40:RG=4:SP$="TWNSPS":MP$="MAPS/TOWNPIC.45.15":OF%=850
 2030 IF A$ = "D" THEN LX=20:LY=160:RG=2:SP$="DNGNSPS":MP$="XMAPS/DNGPIC.74.5":OF%=0
 2040 IF A$ = "O" THEN LX=80:LY=80:RG=4:SP$="OUTSPS":MP$="MAPS/ARRINEA":OF%=0
 2050 RETURN
