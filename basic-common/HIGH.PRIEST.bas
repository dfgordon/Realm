10  TEXT: HOME: IF FG%(4) = 16 THEN 300
20  PRINT "IN A HALTING AND PERTURBED VOICE, ZARIS"
21  PRINT "SPEAKS TO YOU:": PRINT
22  PRINT CHR$(34);"THE POWER OF LIGHT CANNOT BE GIVEN"
30  PRINT "WITHOUT TRIAL. NAY."
40  PRINT "SO FIRST ANSWER ME THIS RIDDLE:"
50  PRINT "THOUGH WITH SILVER AND GOLD THEY FILL": PRINT "  THEIR HALLS"
60  PRINT "ONE THING THERE MUST BE": PRINT "  THEY SEEK ABOVE ALL"
70  PRINT "FOR UPON THEM THEIR TREASURE": PRINT "  A CURSE HATH BROUGHT"
80  PRINT "INSTEAD OF WHAT ONCE THEY MUST": PRINT "  HAVE SOUGHT"
90  PRINT "NOW WHAT IS THIS THING THAT": PRINT "  THEY FORGOT?";CHR$(34)
100  GOSUB 7000: IF B$ = "HAPPINESS" THEN 200
110  PRINT: PRINT CHR$(34);"NAY! NAY! NAY! GO BACK INTO THE WIDE"
120  PRINT "WORLD AND RETURN WHEN YOU CAN ANSWER.";CHR$(34);: GET A$
130  GOTO 25000

200  PRINT: PRINT CHR$(34);"I SEE THAT YOU ARE NOT A FOOL."
201  PRINT "ACCORDINGLY, I SHALL PERFORM THE"
202  PRINT "BLESSING...";CHR$(34);: GET A$
210  PRINT:PRINT:PRINT "-LIGHT ENVELOPS YOU-": GOSUB 30090
220  FG%(4)=16

300  PRINT:PRINT CHR$(34);"NOW YOU HAVE THE POWER, YET MY OWN"
310  PRINT "PENANCE IS NOT COMPLETE. LEAVE ME.";CHR$(34)
320  PRINT: PRINT "YOU SEE THAT HE IS FEY AND QUITE MAD."
330  PRINT "YOU MUST LEAVE HIM TO HIS TRAGIC FATE.";: GET A$
340  GOTO 25000

7000  REM INPUT
7002 B$ = "": HTAB 1: PRINT ">";: CALL -868
7004  GET CH$: CH = ASC(CH$): IF CH = 13 THEN RETURN
7008  IF CH = 8 OR CH = 127 THEN 7014
7010  IF CH<32 OR CH>126 OR CH=44 OR LEN(B$)>30 THEN 7004
7012  PRINT CH$;: B$ = B$ + CH$: GOTO 7004
7014  IF LEN (B$) < 2 THEN 7000
7016 B$ =  LEFT$ (B$, LEN (B$) - 1): POKE 36, PEEK (36) - 1: CALL  - 868: GOTO 7004

25000  POKE -16304,0: HOME: POKE 16384,0: POKE 103,1: POKE 104,64: XT = XT + 3: GOTO 25000

30090  POKE 6,130: POKE 7,2: POKE 8,255: POKE 9,1: POKE 30,2: CALL 806: RETURN
