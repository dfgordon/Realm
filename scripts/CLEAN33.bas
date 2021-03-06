10  REM CLEAN FOR DOS33 DISTRIBUTION
20  DIM PN$(9): DIM WS%(3): DIM WD%(3): DIM WV%(3): DIM DL$(3)
30  ONERR GOTO 200: PRINT CHR$(4);"VERIFY PLIST": POKE 216,0
40  GOSUB 900
50  FOR I = 0 TO 9
60  IF PN$(I) <> "EMPTY" THEN GOSUB 800
70  NEXT I
80  GOSUB 950

100  PRINT "RESET CONFIGURATION"
110  DL$(0) = "MASTER": DL$(1) = "DUNGEON": DL$(2) = "MONSTER": DL$(3) = "SETUP"
120  FOR I = 0 TO 3: WS%(I) = 6: WD%(I) = 1: WV%(I) = 254: NEXT I
130  ES = 100: EP = 100: WD%(2) = 2: WD%(3) = 2
140  GOSUB 5200
150  END

200  POKE 216,0: PRINT "NO PLIST - CREATING"
210  FOR I = 0 TO 9: PN$(I) = "EMPTY": NEXT I
220  GOSUB 950
230  GOTO 100

800  PRINT "REMOVING PARTY ";PN$(I)
810  PRINT CHR$(4);"DELETE D:";PN$(I)
820  PN$(I) = "EMPTY"
830  RETURN

900  REM LOAD LIST
905  PRINT : PRINT CHR$(4);"OPEN PLIST"
910  PRINT CHR$(4);"READ PLIST"
925  FOR I = 0 TO 9
930  INPUT PN$(I)
935  NEXT I
940  PRINT CHR$(4);"CLOSE PLIST"
949  RETURN

950  REM SAVE LIST
955  PRINT : PRINT CHR$(4);"OPEN PLIST"
960  PRINT CHR$(4);"WRITE PLIST"
975  FOR I = 0 TO 9
980  PRINT PN$(I)
985  NEXT I
990  PRINT CHR$(4);"CLOSE PLIST"
999  RETURN

5200  REM WRITE CONFIG
5210  PRINT : PRINT CHR$(4);"OPEN DD": PRINT CHR$(4);"CLOSE DD": PRINT CHR$(4);"DELETE DD"
5220  PRINT CHR$(4);"OPEN DD": PRINT CHR$(4);"WRITE DD"
5230  FOR I = 0 TO 3
5240  PRINT DL$(I)
5250  PRINT WS%(I)
5260  PRINT WD%(I)
5270  PRINT WV%(I)
5280  NEXT I
5281  PRINT ES
5282  PRINT EP
5290  PRINT CHR$(4);"CLOSE DD"
5299  RETURN
