10  PRINT CHR$(4);"BLOAD TITLE.PIC,A$4000"
20  HOME: POKE -16299,0: POKE  - 16304,0: POKE  - 16302,0: PRINT CHR$(4);"BLOAD SOUND": GET A$
30  CLEAR : RESTORE : GOSUB 8000: GOSUB 5300: TEXT

100  HOME: PRINT "REALM V1.4.0": VTAB 24: PRINT "PLEASE USE CAPS LOCK";
101  PN$(0) = "CONFIGURE": PN$(1) = "GENERATE PARTY": PN$(2) = "DEPLOY/RECALL": PN$(3) = "LIST PARTIES"
102  PN$(4) = "RENAME PARTY": PN$(5) = "DELETE PARTY": PN$(6) = "IMPORT PARTY": PN$(7) = "EXPORT PARTY": PN$(8) = "HELP"
110  L = 3: P = 8: B$ = CHR$(13): W$ = "SELECT- ": GOSUB 150: ON M+1 GOTO 5000,1000,6000,2000,3000,4000,6400,6500,7500

150  REM MENU SUBROUTINE
151  N = 0: M = 0: HTAB 1: VTAB L: PRINT "1) ";: INVERSE: PRINT PN$(0): NORMAL: IF P>0 THEN FOR I = 1 TO P: PRINT I+1;") ";PN$(I): NEXT
152  HTAB 1: VTAB L+P+2: PRINT W$;: GET A$: IF A$ = CHR$(13) OR A$ = B$ THEN RETURN
153  IF VAL(A$)>=1 AND VAL(A$)<=P+1 THEN M = VAL(A$)-1: RETURN
154  IF A$ = CHR$(8) OR A$ = CHR$(11) THEN N = M: M = M - 1: IF M<0 THEN M = P
155  IF A$ = CHR$(10) OR A$ = CHR$(21) THEN N = M: M = M + 1: IF M>P THEN M = 0
156  HTAB 4: VTAB N+L: PRINT PN$(N): INVERSE: HTAB 4: VTAB M+L: PRINT PN$(M): NORMAL: GOTO 152

200  HOME: PRINT "WHAT CLASS SHOULD ";NM$(A);" BE?"
201  PN$(0) = "FIGHTER": PN$(1) = "WIZARD": PN$(2) = "CLERIC": PN$(3) = "THIEF": PN$(4) = "MONK": PN$(5) = "PALADIN": PN$(6) = "RANGER"
202  L = 3: P = 6: B$ = CHR$(13): W$ = "SELECT- ": GOSUB 150: CL$(A) = PN$(M): RETURN

250  HOME: PRINT "WHAT RACE SHOULD ";NM$(A);" BE?"
251  PN$(0) = "HUMAN": PN$(1) = "ELF": PN$(2) = "DWARF": PN$(3) = "HOBBIT"
252  L = 3: P = 3: B$ = CHR$(13): W$ = "SELECT- ": GOSUB 150: RA$(A) = PN$(M)
260  IF M = 1 AND CL$(A) = "CLERIC" THEN 290
261  IF M = 1 AND CL$(A) = "PALADIN" THEN 290
262  IF M = 1 AND CL$(A) = "THIEF" THEN 290
263  IF M = 2 AND CL$(A) = "MONK" THEN 290
264  IF M = 2 AND CL$(A) = "WIZARD" THEN 290
265  IF M = 2 AND CL$(A) = "PALADIN" THEN 290
266  IF M = 2 AND CL$(A) = "CLERIC" THEN 290
267  IF M = 3 AND CL$(A) = "MONK" THEN 290
268  IF M = 3 AND CL$(A) = "PALADIN" THEN 290
269  IF M = 3 AND CL$(A) = "WIZARD" THEN 290
270  IF M = 3 AND CL$(A) = "RANGER" THEN 290
280  RETURN
290  PRINT: PRINT CL$(A);" CANNOT BE A ";RA$(A): GET A$: GOTO 250

350  ON I+1 GOTO 351,352,353,354,355,356
351  PRINT "STRENGTH";: RETURN
352  PRINT "INTELLIGENCE";: RETURN
353  PRINT "WISDOM";: RETURN
354  PRINT "AGILITY";: RETURN
355  PRINT "STAMINA";: RETURN
356  PRINT "CHARISMA";: RETURN

360  C = 0: FOR I = 0 TO 5: A%(I) = 12: NEXT
361  HOME: PRINT "ADJUST ABILITIES:": PRINT: FOR I = 0 TO 5: GOSUB 350: PRINT ": ";A%(I): NEXT: PRINT: PRINT "UNUSED: ";C
364  M = 0: N = 0: P = 5: GOSUB 380: HTAB 1: VTAB 14: IF C > 0 THEN PRINT "UNUSED POINTS! ";: GET A$: GOTO 361
365  PRINT "ACCEPTABLE (ESC=NO) ? ";: GET A$: IF A$ = CHR$(27) THEN 361
366  AF%(A) = A%(0): AG%(A) = A%(1): AH%(A) = A%(2): AI%(A) = A%(3): AJ%(A) = A%(4): AK%(A) = A%(5): RETURN

370  L = 0: IF A$ = CHR$(8) THEN L = - 1
371  IF A$ = CHR$(21) THEN L = 1
372  IF A$ = "A" OR A$ = CHR$(11) THEN N = M: M = M - 1: IF M<0 THEN M = P
373  IF A$ = "Z" OR A$ = CHR$(10) THEN N = M: M = M + 1: IF M>P THEN M = 0
374  RETURN

380  VTAB 12: PRINT "LR-ARROWS ADJUST (REDUCE FIRST)": PRINT "UD-ARROWS/A/Z SELECT, ENTER FINISHES"
381  HTAB 1: VTAB N+3: I=N: GOSUB 350: PRINT ": ";A%(I);TAB(38): INVERSE: HTAB 1: VTAB M+3: I=M: GOSUB 350: NORMAL: PRINT ": ";A%(I);TAB(38)
382  HTAB 9: VTAB 10: PRINT C;TAB(38): HTAB 1: VTAB 14: GET A$: GOSUB 370: IF A$ = CHR$(13) THEN RETURN
383  A%(M) = A%(M) + L: C = C - L: IF A%(M) < 5 OR A%(M) > 20 OR C < 0 THEN L = L*-1: GOTO 383
384  GOTO 381

400  REM PICK PARTY
410  GOSUB 2100: IF M = 0 THEN GET A$: RETURN
420  L = 5: P = M-1: B$ = CHR$(27): HTAB 1: VTAB L+P+2: W$ = "ESC CANCELS- ": GOSUB 150: L = M
430  IF A$ = CHR$(27) THEN M = 0: RETURN
440  NA$ = PN$(L): M = 1: RETURN

500  REM LOAD
510  PRINT : PRINT CHR$(4);"OPEN D:";NA$
520  PRINT CHR$(4);"READ D:";NA$
525  FOR A = 0 TO 3
530  INPUT NM$(A)
531  INPUT RA$(A)
532  INPUT CL$(A)
533  INPUT ZA%(A)
534  INPUT AB%(A)
535  INPUT AC%(A)
536  INPUT AF%(A)
537  INPUT AG%(A)
538  INPUT AH%(A)
539  INPUT AI%(A)
540  INPUT AJ%(A)
541  INPUT AK%(A)
542  INPUT DV$(A)
543  INPUT DW$(A)
544  INPUT DX$(A)
545  INPUT WT%(A)
546  FOR M = 0 TO 7: INPUT AP$(A,M): NEXT
547  FOR M = 0 TO 15: INPUT AX$(A,M): NEXT
548  NEXT
565  INPUT X
566  INPUT Y
570  INPUT AD%: INPUT AE: INPUT FL%: INPUT RM$
571  FOR I = 0 TO 5: INPUT FG%(I): NEXT I
575  PRINT CHR$(4);"CLOSE D:";NA$
590  RETURN

700  REM SAVE
705  PRINT : PRINT CHR$(4);"OPEN D:";NA$
710  PRINT CHR$(4);"WRITE D:";NA$
715  FOR A = 0 TO 3
720  PRINT NM$(A)
725  PRINT RA$(A)
730  PRINT CL$(A)
735  PRINT ZA%(A)
740  PRINT AB%(A)
745  PRINT AC%(A)
750  PRINT AF%(A)
755  PRINT AG%(A)
760  PRINT AH%(A)
765  PRINT AI%(A)
770  PRINT AJ%(A)
775  PRINT AK%(A)
780  PRINT DV$(A)
785  PRINT DW$(A)
790  PRINT DX$(A)
795  PRINT WT%(A)
800  FOR M = 0 TO 7: PRINT AP$(A,M): NEXT
805  FOR M = 0 TO 15: PRINT AX$(A,M): NEXT
810  NEXT
815  PRINT X
820  PRINT Y
825  PRINT AD%: PRINT AE: PRINT FL%: PRINT RM$
826  FOR I = 0 TO 5: PRINT FG%(I): NEXT I
830  PRINT CHR$(4);"CLOSE D:";NA$
850  RETURN

900  REM LOAD LIST
901  PRINT : PRINT CHR$(4);"OPEN PLIST"
902  PRINT CHR$(4);"READ PLIST"
903  FOR I = 0 TO 9: INPUT PN$(I): NEXT
904  PRINT CHR$(4);"CLOSE PLIST"
905  GOSUB 910: RETURN

910  REM PACK LIST
911  FOR I = 0 TO 8
912  IF PN$(I) = "EMPTY" OR PN$(I) = "" THEN L = I + 1: GOTO 920
913  NEXT: RETURN
920  IF PN$(L) <> "EMPTY" AND PN$(L) <> "" THEN 930
921  L = L + 1: IF L>9 THEN 913
922  GOTO 920
930  PN$(I) = PN$(L): PN$(L) = "EMPTY": GOTO 913

950  REM SAVE LIST
955  PRINT : PRINT CHR$(4);"OPEN PLIST"
960  PRINT CHR$(4);"WRITE PLIST"
975  FOR I = 0 TO 9
980  PRINT PN$(I)
985  NEXT I
990  PRINT CHR$(4);"CLOSE PLIST"
999  RETURN

1000  REM CREATE PARTY
1010  D = 3 : GOSUB 9000: GOSUB 900: GOSUB 1900: IF M=1 THEN HOME: PRINT "THERE IS NO ROOM ";:GET A$: GOTO 100

1100  X = 45 : Y = 18 : RM$="ARRINEA": AE = 100: AD% = 100: FL% = 0
1101  FOR I = 0 TO 5: FG%(I) = 0: NEXT I
1110  FOR A = 0 TO 3
1120  HOME
1121 ZA%(A) = 0
1122 AP$(A,0) = "DAGGER":AP$(A,1) = "LEATHER": FOR I = 2 TO 7: AP$(A,I) = "": NEXT I
1123 CL$(A) = "":RA$(A) = "": FOR I = 0 TO 15: AX$(A,I) = "": NEXT I
1124 DV$(A) = "LEATHER":DW$(A) = "DAGGER":DX$(A) = ""
1130  PRINT "THIS IS CHARACTER #";A+1
1140  PRINT "WHAT SHOULD THIS CHARACTERS NAME BE?"
1150  GOSUB 7000: NM$(A) = A$
1160  IF A$ = "" THEN 1150
1170  GOSUB 200: GOSUB 250: GOSUB 360
1200  IF RA$(A) = "ELF" THEN AG%(A) = AG%(A) + 5
1210  IF RA$(A) = "DWARF" THEN AJ%(A) = AJ%(A) + 5
1220  IF RA$(A) = "HOBBIT" THEN AI%(A) = AI%(A) + 5
1230  IF RA$(A) = "HUMAN" THEN AG%(A) = AG%(A) + 5
1240  IF RA$(A) = "HUMAN" THEN AK%(A) = AK%(A) + 5
1250  IF CL$(A) = "MONK" THEN AI%(A) = AI%(A) + 5
1260  IF CL$(A) = "CLERIC" THEN AB%(A) = 60: WT%(A) = 20
1270  IF CL$(A) = "FIGHTER" THEN AB%(A) = 100: WT%(A) = 20
1280  IF CL$(A) = "MONK" THEN AB%(A) = 80: WT%(A) = 10
1290  IF CL$(A) = "PALADIN" THEN AB%(A) = 80: WT%(A) = 10
1300  IF CL$(A) = "RANGER" THEN AB%(A) = 80: WT%(A) = 10
1310  IF CL$(A) = "THIEF" THEN AB%(A) = 60: WT%(A) = 20
1320  IF CL$(A) = "WIZARD" THEN AB%(A) = 50: WT%(A) = 25
1330 AB%(A) = AB%(A) + AJ%(A)
1340 AB%(A) = AB%(A) * 2
1350 AC%(A) = AB%(A)
1390  NEXT

1500  HOME : REM REVIEWING WHOLE PARTY
1501  FOR A = 0 TO 3
1502  HOME : PRINT "REVIEWING CHARACTER ";A+1
1503  PRINT "NAME: ";NM$(A)
1504  PRINT "CLASS: ";CL$(A)
1505  PRINT "RACE: ";RA$(A)
1506  PRINT "STRENGTH: ";AF%(A)
1507  PRINT "INTELLIGENCE: ";AG%(A)
1508  PRINT "WISDOM: ";AH%(A)
1509  PRINT "AGILITY: ";AI%(A)
1510  PRINT "STAMINA: ";AJ%(A)
1511  PRINT "CHARISMA: ";AK%(A)
1512  PRINT "MAXIMUM LEVEL: ";WT%(A)
1513  PRINT "HIT POINTS: ";AB%(A)
1514  GET A$
1515  NEXT
1516  HOME : PRINT "SAVE THIS PARTY (Y/N) ";: GET A$
1520  IF A$<>"Y" AND A$<>"N" THEN 1516
1530  IF A$ = "N" THEN 100

1600  HOME : PRINT "ENTER YOUR PARTY'S NAME-": GOSUB 7100
1610  GOSUB 1800: IF M = 0 THEN 1600
1620  IF M = 1 THEN PRINT: PRINT A$;" ALREADY USED";: GET A$: GOTO 1600
1630  NA$ = A$

1700  REM SAVE ALL DATA
1710  D = 3: GOSUB 9000: GOSUB 900: GOSUB 1950: REM ADD TO LIST
1780  GOSUB 700 : REM SAVE PARTY DATA
1790  GOSUB 950 : REM SAVE PARTY LIST
1799  GOTO 100

1800  REM VALID NEW NAME
1810  IF A$ = "" OR A$ = "EMPTY" THEN M = 0: RETURN
1820  I = 0
1830  IF A$ = PN$(I) THEN M = 1: RETURN
1840  I = I + 1: IF I = 10 THEN M = 2: RETURN
1850  GOTO 1830

1900  REM ROOM
1910  I = 0
1920  IF PN$(I) = "" OR PN$(I) = "EMPTY" THEN M = 0: RETURN
1930  I = I + 1 : IF I = 9 THEN M = 1: RETURN
1940  GOTO 1920

1950  REM ADD
1960  I = 0
1970  IF PN$(I) = "" OR PN$(I) = "EMPTY" THEN PN$(I) = NA$: RETURN
1980  I = I + 1 : GOTO 1970

2000  REM LIST
2010  D = 3 : GOSUB 9000 : GOSUB 900: HOME: GOSUB 2100: PRINT: PRINT "PRESS ANY KEY ";: GET A$ : GOTO 100

2100  REM DISPLAY PARTIES
2110  PRINT "PARTIES:": PRINT: M = 0: FOR I = 0 TO 9: IF PN$(I) <> "EMPTY" THEN M = M + 1: PRINT M;") ";PN$(I)
2130  NEXT I:  IF M = 0 THEN PRINT "NO PARTIES ON THIS DISK."
2140  RETURN

3000  REM RENAME
3001  D = 3: GOSUB 9000: GOSUB 900: HOME: PRINT "--RENAME--": PRINT: GOSUB 400: IF M = 0 THEN GOTO 100
3010  PRINT: PRINT "RENAMING ";NA$: PRINT "PLEASE DO NOT RENAME A DEPLOYED PARTY.": PRINT "CONTINUE ? (Y TO PROCEED)- ";: GET A$
3020  IF A$ <> "Y" THEN 100
3030  PRINT: PRINT "NEW NAME-": GOSUB 7100: GOSUB 1800: IF M<2 THEN PRINT: PRINT "ALREADY USED OR NOT VALID": GOTO 3030
3040  PRINT : PRINT  CHR$ (4);"RENAME D:";NA$;",D:";A$
3050  PN$(L) = A$
3095  GOSUB 950 : REM SAVE PARTY LIST
3099  GOTO 100

4000  REM DELETE
4001  D = 3: GOSUB 9000: GOSUB 900: HOME: PRINT "--DELETE--": PRINT: GOSUB 400: IF M = 0 THEN GOTO 100
4010  PRINT: PRINT "DELETING ";NA$: PRINT "PLEASE DO NOT DELETE A DEPLOYED PARTY.": PRINT "CONTINUE ? (Y TO PROCEED)- ";: GET A$
4020  IF A$ <> "Y" THEN 100
4040  PRINT : PRINT  CHR$ (4);"DELETE D:";NA$
4050  PN$(L) = "EMPTY"
4095  GOSUB 950 : REM SAVE PARTY LIST
4099  GOTO 100

5000  REM CONFIGURATION
5010  HOME
5020  PRINT TAB(10);"SETUP DRIVE MAPPINGS"
5030  PRINT : PRINT: PRINT
5040  PRINT "# DISK NAME  SLOT   DRIVE  VOLUME"
5050  PRINT "---------------------------------"
5060  FOR I = 0 TO 3
5070  A$ = DL$(I) + "          ": A$ = LEFT$(A$,11)
5080  PRINT I+1;" ";A$;WS%(I);"      ";WD%(I);"      ";WV%(I)
5090  NEXT I
5100  PRINT "#=EDIT, ENTER=FINISH, ESC=CANCEL ";: GET A$: PRINT
5101  IF A$ = CHR$(13) THEN 5170
5102  IF A$ = CHR$(27) THEN 100
5103  I = VAL(A$): IF I<1 OR I>4 THEN 5000
5110  I = I - 1
5130  HTAB 1: VTAB 12: PRINT "ENTER SLOT (1-7): ";: GET B$
5131  WS%(I) = VAL(B$): IF WS%(I)<1 OR WS%(I)>7 THEN 5130
5132  PRINT WS%(I)
5140  HTAB 1: VTAB 13: PRINT "ENTER DRIVE (1-9): ";: GET B$
5141  WD%(I) = VAL(B$): IF WD%(I)<1 OR WD%(I)>9 THEN 5140
5142  PRINT WD%(I)
5150  HTAB 1: VTAB 14: INPUT "ENTER VOLUME (1-255, USUALLY 254): ";B$
5151  WV%(I) = VAL(B$): IF WV%(I)<1 OR WV%(I)>255 THEN 5150
5160  GOTO 5000
5170  HOME: PRINT TAB(8);"SET PAUSE DURATION"
5171  PRINT:PRINT "IF USING AN EMULATOR, PLEASE SET SPEED": PRINT "OPTIONS NOW."
5172  PRINT "THEN TRY A LOOP COUNT: ": GOSUB 7000: EP = VAL(A$): IF EP<1 THEN EP = 1
5173  PRINT: PRINT "STARTING PAUSE LOOP...";
5174  FOR P = 0 TO 500+EP: NEXT P
5175  PRINT "FINISHED."
5176  PRINT "THE PAUSE SHOULD BE 1 - 2 SECONDS.": PRINT "(ENOUGH TIME TO READ A FEW WORDS)"
5177  PRINT "DO WE NEED TO ADJUST (Y/N) ";: GET A$
5178  IF A$ <> "N" THEN 5170
5190  ES = EP: HOME: PRINT "SAVE CONFIGURATION (Y/N) ";: GET A$
5191  IF A$ <> "Y" AND A$ <> "N" THEN 5190
5192  IF A$ = "N" THEN 100
5197  D = 0: GOSUB 9000: GOSUB 5200
5198  D = 3: GOSUB 9000: GOSUB 5200
5199  GOTO 100

5200  REM WRITE DRIVES
5210  PRINT : PRINT CHR$(4);"OPEN DD"
5220  PRINT CHR$(4);"WRITE DD"
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

5300  REM READ DRIVES
5310  PRINT : PRINT CHR$(4);"OPEN DD"
5320  PRINT CHR$(4);"READ DD"
5330  FOR I = 0 TO 3
5340  INPUT DL$(I)
5350  INPUT WS%(I)
5360  INPUT WD%(I)
5370  INPUT WV%(I)
5380  NEXT I
5381  INPUT ES
5382  INPUT EP
5390  PRINT CHR$(4);"CLOSE DD"
5399  RETURN

6000  REM DEPLOY PARTY
6010  D = 3 : GOSUB 9000: GOSUB 900: HOME: PRINT "--DEPLOY/RECALL--": PRINT: GOSUB 400 : IF M = 0 THEN 100
6020  GOSUB 500
6030  D = 0 : GOSUB 9000: GOSUB 900: IF PN$(0) = NA$ THEN 6100
6040  IF PN$(0) <> "EMPTY" THEN PRINT: PRINT "MUST RECALL ";PN$(0);" FIRST. ";: GET A$: GOTO 100
6050  PN$(0) = NA$ : GOSUB 950: GOSUB 700
6060  HOME: PRINT "TO PLAY ";NA$: PRINT "BOOT FROM MASTER.";: GET A$: GOTO 100

6100  HOME: PRINT NA$;" ALREADY DEPLOYED.": PRINT "RECALL? (Y/N) ";: GET A$: IF A$ <> "Y" AND A$ <> "N" THEN 6100
6110  IF A$ = "N" THEN 100
6120  GOSUB 500
6130  PRINT: PRINT CHR$(4);"DELETE D:";PN$(0): PN$(0) = "EMPTY": GOSUB 950
6140  D = 3: GOSUB 9000: GOSUB 700: PRINT: PRINT NA$;" RECALLED. ";: GET A$: GOTO 100

6400  REM IMPORT
6401  HOME: PRINT "--IMPORT PARTY--"
6410  D = 3: GOSUB 9000: GOSUB 900: GOSUB 1900: IF M=1 THEN PRINT: PRINT "THERE IS NO ROOM ";:GET A$: GOTO 100
6420  ONERR GOTO 6600
6430  GOSUB 6550: PRINT "NAME OF PARTY TO IMPORT (ENTER CANCELS)-": GOSUB 7100: NA$ = A$: GOSUB 1800: IF M = 0 THEN PRINT: PRINT "CANCELED. PRESS ANY KEY.";: GET A$: POKE 216,0: GOTO 100
6440  IF M = 1 THEN PRINT: PRINT NA$;" ALREADY HERE. ";: GET A$: POKE 216,0: GOTO 100
6450  PRINT: PRINT "READING...": GOSUB 500: PRINT: PRINT "SWAP DISK IF NECESSARY- ";: GET A$: PRINT: PRINT "WRITING...": POKE 216,0: GOTO 1700

6500  REM EXPORT
6501  D = 3: GOSUB 9000: GOSUB 900: HOME: PRINT "--EXPORT PARTY--": PRINT: PRINT "(PLEASE RECALL FIRST IF DEPLOYED)": PRINT: GOSUB 400 : IF M = 0 THEN 100
6510  ONERR GOTO 6600
6520  PRINT: PRINT "READING...": GOSUB 500
6530  HOME: PRINT "--EXPORT PARTY--": GOSUB 6550: PRINT "CONTINUE? (Y/N) ";: GET A$
6540  IF A$ = "Y" THEN PRINT: PRINT "WRITING...": GOSUB 700
6549  POKE 216,0: GOTO 100

6550  HTAB 1: VTAB 3: PRINT "AUXILIARY DISK SLOT (1-7): ";: GET A$: S = VAL(A$): IF S<1 OR S>7 THEN 6550
6551  PRINT S
6552  HTAB 1: VTAB 4: PRINT "AUXILIARY DISK DRIVE (1-9): ";: GET A$: D = VAL(A$): IF D<1 OR D>2 THEN 6552
6553  PRINT D
6554  HTAB 1: VTAB 5: INPUT "AUXILIARY DISK VOLUME (1-255): ";A$: V = INT(VAL(A$)): IF V<1 OR V>255 THEN 6554
6555  PRINT "INSERT DISK (ESC CANCELS)- ";:GET A$: IF A$ = CHR$(27) THEN POKE 216,0: CALL -10621: GOTO 100
6556  PRINT: PRINT CHR$(4);"CATALOG,S";S;",D";D;",V";V
6560  RETURN

6600  POKE 216,0: HOME: PRINT "THERE WAS PROBABLY A DISK ERROR.": PRINT "ERROR ";PEEK(222);" ON LINE ";PEEK(218)+PEEK(219)*256;". "
6601  PRINT "WE MUST RETURN TO THE MAIN MENU. ";: GET A$: CALL -10621: GOTO 100

7000  REM INPUT
7002 A$ = "": HTAB 1: PRINT ">";: CALL -868
7004  GET CH$: CH = ASC(CH$): IF CH = 13 THEN RETURN
7008  IF CH = 8 OR CH = 127 THEN 7014
7010  IF CH<32 OR CH>126 OR CH=44 OR LEN(A$)>16 THEN 7004
7012  PRINT CH$;: A$ = A$ + CH$: GOTO 7004
7014  IF LEN (A$) < 2 THEN 7000
7016 A$ =  LEFT$ (A$, LEN (A$) - 1): POKE 36, PEEK (36) - 1: CALL  - 868: GOTO 7004

7100  REM SHADOW PRODOS VERS
7101  GOTO 7000

7500  HOME: PRINT "HTTPS://GITHUB.COM/DFGORDON/REALM"
7510  PRINT: PRINT "MOVEMENT - ARROWS OR 0/-/=/P/[/L/;/'"
7520  PRINT "A - ATTACK/SCUTTLE": PRINT "B - BOARD SHIP": PRINT "C - CAST": PRINT "E - ENTER"
7530  PRINT "F - FAST STATUS": PRINT "G - GET CHEST": PRINT "I - INVENTORY SWAP": PRINT "K - CLIMB LADDER"
7540  PRINT "Q - SAVE/QUIT": PRINT "R - READY": PRINT "S - STEAL/SURFACE": PRINT "T - TRANSACT"
7550  PRINT "U - USE": PRINT "W - WITHDRAW/ADVANCE": PRINT "X - EXIT SHIP/CRAFT": PRINT "Z - STATUS"
7560  PRINT "CTRL-A - AUTO-RESOLVE COMBAT": PRINT "CTRL-P - PRAY TO THE ONE": PRINT "CTRL-S - SOUND": GET A$

7570  HOME: PRINT "PROFICIENCY TABLE": PRINT: GOSUB 8290
7571  PRINT "        DAGR AXE  M/MS BOW  SWRD 2HSW"
7572  PRINT "        ---- ---- ---- ---- ---- ----"
7573  PRINT "CLERIC   ";: C = 0: GOSUB 7599
7574  PRINT "FIGHTER  ";: C = 1: GOSUB 7599
7575  PRINT "MONK     ";: C = 2: GOSUB 7599
7576  PRINT "PALADIN  ";: C = 3: GOSUB 7599
7577  PRINT "RANGER   ";: C = 4: GOSUB 7599
7578  PRINT "THIEF    ";: C = 5: GOSUB 7599
7579  PRINT "WIZARD   ";: C = 6: GOSUB 7599
7580  GET A$: GOTO 7600
7599  FOR I = 0 TO 5: PRINT WU%(C,I);"    ";: NEXT: PRINT: RETURN

7600  HOME: PRINT "ABRIDGED NOTE FROM THE BARON:": PRINT
7602  PRINT "MORDOCK, FORMER ARCHWIZARD OF LEMPHOCYM,";
7604  PRINT "HAS REDISCOVERED THE SECRETS OF THE"
7606  PRINT "PYRAMID GATES, AND TAKEN UP HIS ABODE IN";
7608  PRINT "CRYPTIC WORNOTH. FROM HIS ETHEREAL"
7610  PRINT "STRONGHOLD, HE SENDS FORTH THE RAYS OF"
7612  PRINT "NIGHTMARE, AND TROUBLES ALL THE REALMS."
7614  PRINT "I, XAVIER FRANCIS, EIGHTEENTH BARON"
7616  PRINT "LEMPHOCYM, ATTEMPTED AN ASSAULT ON THE"
7618  PRINT "IRON TOWER, AND FAILED. FIND ME IN THE"
7620  PRINT "BLACK FORTRESS, IN UNPEOPLED FONKRAKIS,"
7622  PRINT "AND WE WILL MAKE A LAST DESPERATE"
7624  PRINT "ATTEMPT TO END THE REIGN OF THE"
7626  PRINT "NIGHTMARE DREAMER. ";: GET A$: GOTO 100

8000  REM GLOBALS
8010  DIM PN$(9): DIM A%(5)
8020  DIM WS%(3): DIM WD%(3): DIM WV%(3): REM SLOT DRIVE VOLUME
8030  DIM DL$(3): REM DISK LABELS
8040  DIM WU%(6,5): DIM FG%(5)
8050  DIM NM$(3): DIM RA$(3): DIM CL$(3)
8060  DIM CL%(3): DIM ZA%(3)
8070  DIM AB%(3): DIM AC%(3)
8080  DIM AF%(3): DIM AG%(3)
8090  DIM AH%(3): DIM AI%(3)
8100  DIM AJ%(3): DIM AK%(3)
8110  DIM DV$(3): DIM DW$(3)
8120  DIM DX$(3): DIM WT%(3)
8130  DIM GN(8): DIM PM%(8)
8140  DIM PC%(3): DIM GP%(3)
8150  DIM AX$(3,16): DIM AP$(3,9): DIM DR%(3,2): DIM DT%(2)
8199  RETURN

8290  RESTORE: FOR C=0 TO 6: FOR W=0 TO 5: READ WU%(C,W): NEXT: NEXT
8299  RETURN
8300  REM  DA,AX,MA,BO,SW,2H
8310  DATA 5, 5, 8, 5, 5, 5
8320  DATA 9, 9, 9, 9, 9, 9
8330  DATA 8, 7, 7, 8, 7, 5
8340  DATA 7, 8, 8, 7, 9, 7
8350  DATA 9, 9, 7, 9, 7, 6
8360  DATA 9, 7, 7, 9, 7, 5
8370  DATA 7, 4, 4, 4, 4, 2

9000  REM VERIFY DISK
9110  ONERR  GOTO 9200
9120  PRINT: PRINT  CHR$(4);"VERIFY DISK";D;",S";WS%(D);",D";WD%(D);",V";WV%(D): POKE 216,0: RETURN
9200  HOME : PRINT "INSERT ";DL$(D);" DISK IN S";WS%(D);"D";WD%(D);"- ";: GET A$: CALL 768: PRINT : RESUME
