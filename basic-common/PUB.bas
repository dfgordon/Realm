1  DATA "THE SILVER KEY IS IN THE DEVIL'S HOLE"
2  DATA "THE PLATINUM KEY IS IN THE HELLISH INFERNO"
3  DATA "THE GOLD KEY IS IN THE DUNGEON OF NIHM"
4  DATA "A HOLY BLADE IS IN THE CAVE OF HORROR"
5  DATA "THE CLEAR PRISM IS IN CASTLE LEMPHOCYM"
6  DATA "THE GREEN PRISM IS IN THE GATEWAY TO DEATH"
7  DATA "A VORPAL BLADE IS IN THE CAVE OF HORROR"
8  DATA "A STAFF OF POWER IS IN THE PITS OF PERIL"
9  DATA "A ROD OF RESURRECTION IS IN THE WICKED PIT"
10  DATA "A STAFF OF DEATH IS IN THE DUNGEON OF DARKNESS"
11  DATA "A FIRE ROD IS IN THE PITS OF PERIL"
12  DATA "SEDRIK'S HAMMER IS IN HIS DUNGEON"
13  DATA "A FLYING CARPET IS IN THE DUNGEON OF DARKNESS"
14  DATA "A LIGHTNING ROD IS IN THE DEVIL'S HOLE"
15  DATA "A BERSERKER AXE IS IN THE ABYSS"

8900  REM
8910  M = 0: FOR I = 0 TO 3: IF AK%(I) > M THEN M = AK%(I)
8920  NEXT
8930  RESTORE: I = INT(15 * RND (1)): FOR L = 0 TO I: READ A$: NEXT L: A = FRE(0)
8940  ONERR GOTO 9999

9100  HOME : VTAB 21: PRINT "WELCOME TO THE PUB!": PRINT "BUY A DRINK FOR 2 GOLD (Y/N) ";: GET A$
9105  IF A$ = "Y" THEN 9110
9106  HOME : POKE 216,0: GOTO 25000
9110  HOME : VTAB 21:AD% = AD% - 2
9115  IF AD% < 0 THEN AD% = AD% + 2: PRINT "YOU DON'T HAVE THE GOLD! ";: GOSUB 30050: GOTO 9106
9120  I =  INT (99 *  RND (1)) + M
9125  IF I < 100 THEN PRINT "YOU QUAFF THE MEAD. ";: GET A$: GOTO 9200
9130  READ A$: GOSUB 9300
9135  HTAB 1: VTAB 24: PRINT "(PRESS ESC)";: GET A$: IF A$ <> CHR$(27) THEN 9135

9200  HOME : VTAB 21: PRINT "ANOTHER ? ";: GET A$
9205  IF A$ = "Y" THEN 9110
9206  GOTO 9106

9300  I = 1: L = 1
9301  B$ = ""
9310  IF I > LEN(A$) THEN 9330
9320  IF MID$(A$,I,1) <> " " THEN B$ = B$ + MID$(A$,I,1): I = I + 1: GOTO 9310
9330  L = L + LEN(B$) + 1: IF L > 40 THEN PRINT: L = 1
9340  PRINT B$;" ";: I = I + 1: IF I > LEN(A$) THEN RETURN
9350  GOTO 9301

9999  RESTORE: CALL 768: RESUME

25000  POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 25000

30050  POKE 6,50: POKE 7,25: POKE 8,1: POKE 9,1: POKE 30,1: CALL 852: GET A$: RETURN
