 1  PRINT: PRINT CHR$(4);"PR#0": PRINT CHR$(4);"IN#0"
 2  CLEAR : RESTORE
 3  LOMEM: 31744

 10  HGR2: PRINT CHR$(4);"BLOAD TITLE.PIC,A$4000"
 20  HOME: POKE -16299,0: POKE  - 16304,0: POKE  - 16302,0: GET A$
 30  CLEAR : RESTORE : GOSUB 8000
 40  GOSUB 5300
 100  TEXT : HOME
 110  PRINT "REALM V1.3.0. SELECT ONE-": PRINT
 120  PRINT "1) CONFIGURE"
 130  PRINT "2) GENERATE PARTY"
 140  PRINT "3) ENTER GAME"
 150  PRINT "4) LIST PARTIES"
 160  PRINT "5) RENAME PARTY"
 170  PRINT "6) DELETE PARTY"
 180  PRINT "7) IMPORT PARTY"
 181  PRINT "8) EXPORT PARTY"
 182  PRINT "9) HELP"
 189  VTAB 24: PRINT "PLEASE USE CAPS LOCK";
 190  HTAB 1: VTAB 12: GET A$: A =  VAL (A$)
 195  ON A GOTO 5000,1000,6000,2000,3000,4000,6400,6500,7500
 199  GOTO 100

 200  HOME
 210  PRINT "WHAT CLASS SHOULD ";NM$(L);" BE?"
 220  PRINT "1) FIGHTER"
 221  PRINT "2) WIZARD"
 222  PRINT "3) CLERIC"
 223  PRINT "4) THIEF"
 224  PRINT "5) MONK"
 225  PRINT "6) PALADIN"
 226  PRINT "7) RANGER"
 230  GET A$
 240  IF A$ = "1" THEN CL$(L) = "FIGHTER"
 241  IF A$ = "2" THEN CL$(L) = "WIZARD"
 242  IF A$ = "3" THEN CL$(L) = "CLERIC"
 243  IF A$ = "4" THEN CL$(L) = "THIEF"
 244  IF A$ = "5" THEN CL$(L) = "MONK"
 245  IF A$ = "6" THEN CL$(L) = "PALADIN"
 246  IF A$ = "7" THEN CL$(L) = "RANGER"
 247  IF CL$(L) = "" THEN 200
 248  RETURN

 250  HOME
 260  PRINT "WHAT RACE SHOULD ";NM$(L);" BE?"
 270  PRINT "1) HUMAN"
 271  PRINT "2) ELF"
 272  PRINT "3) DWARF"
 273  PRINT "4) HOBBIT"
 280  GET A$
 290  IF A$ = "1" THEN RA$(L) = "HUMAN"
 300  IF A$ = "2" THEN RA$(L) = "ELF"
 310  IF A$ = "3" THEN RA$(L) = "DWARF"
 320  IF A$ = "4" THEN RA$(L) = "HOBBIT"
 321  IF RA$(L) = "" THEN 250
 330  IF A$ = "2" AND CL$(L) = "CLERIC" THEN 350
 331  IF A$ = "2" AND CL$(L) = "PALADIN" THEN 350
 332  IF A$ = "2" AND CL$(L) = "THIEF" THEN 350
 333  IF A$ = "3" AND CL$(L) = "MONK" THEN 350
 334  IF A$ = "3" AND CL$(L) = "WIZARD" THEN 350
 335  IF A$ = "3" AND CL$(L) = "PALADIN" THEN 350
 336  IF A$ = "3" AND CL$(L) = "CLERIC" THEN 350
 337  IF A$ = "4" AND CL$(L) = "MONK" THEN 350
 338  IF A$ = "4" AND CL$(L) = "PALADIN" THEN 350
 339  IF A$ = "4" AND CL$(L) = "WIZARD" THEN 350
 340  IF A$ = "4" AND CL$(L) = "RANGER" THEN 350
 345  RETURN
 350  PRINT CL$(L);" CANNOT BE A ";RA$(L): GET A$: GOTO 250

 351  HTAB 1: VTAB 2: PRINT "1) STRENGTH: ";A%(0);TAB(38)
 352  HTAB 1: VTAB 3: PRINT "2) INTELLIGENCE: ";A%(1);TAB(38)
 353  HTAB 1: VTAB 4: PRINT "3) WISDOM: ";A%(2);TAB(38)
 354  HTAB 1: VTAB 5: PRINT "4) AGILITY: ";A%(3);TAB(38)
 355  HTAB 1: VTAB 6: PRINT "5) STAMINA: ";A%(4);TAB(38)
 356  HTAB 1: VTAB 7: PRINT "6) CHARISMA: ";A%(5);TAB(38)
 357  PRINT: RETURN

 360  FOR I = 0 TO 5: A%(I) = 12: NEXT I
 361  HOME: PRINT "ABILITIES:": GOSUB 351
 362  PRINT "ADJUST (Y/N) ?";: GET A$: IF A$="N" THEN 380
 363  HTAB 1: VTAB 10: PRINT "ADJUST WHICH ABILITY: ";: GET A$: A = VAL(A$)-1: IF A<0 OR A>5 THEN 363
 364  HTAB 1: VTAB 11: PRINT "COMPENSATE WITH ABILITY: ";: GET A$: B = VAL(A$)-1: IF B<0 OR B>5 OR A=B THEN 364
 370  HTAB 1: VTAB 12: PRINT "USE ARROWS, ENTER WHEN DONE.";: GET A$
 371  IF A$=CHR$(8) THEN Z = -1
 372  IF A$=CHR$(21) THEN Z = 1
 373  IF A$=CHR$(13) THEN 361
 375  A%(A) = A%(A) + Z: A%(B) = A%(B) - Z
 376  IF A%(A) < 5 OR A%(A) > 20 OR A%(B) < 5 OR A%(B) > 20 THEN Z = Z*-1: GOTO 375
 377  GOSUB 351: GOTO 370
 380  AF%(L) = A%(0): AG%(L) = A%(1): AH%(L) = A%(2): AI%(L) = A%(3): AJ%(L) = A%(4): AK%(L) = A%(5)
 381  RETURN

 400  REM PICK PARTY
 410  GOSUB 2100: IF M = 0 THEN GET A$: RETURN
 420  PRINT: PRINT "SELECT (#) OR ESC- ";: GET A$
 430  IF A$ = CHR$(27) THEN M = 0: RETURN
 440  A = VAL(A$): IF A<1 OR A>M THEN HOME: PRINT "TRY AGAIN:": PRINT: GOTO 410
 450  M = 0: I = 0
 460  IF PN$(I) <> "EMPTY" THEN M = M + 1
 470  IF A = M THEN NA$ = PN$(I): L = I: RETURN
 480  I = I + 1: GOTO 460

 500  REM LOAD
 510  PRINT : PRINT CHR$(4);"OPEN ";B$;"D.";NA$
 520  PRINT CHR$(4);"READ ";B$;"D.";NA$
 525  FOR L = 0 TO 3
 530  INPUT NM$(L)
 531  INPUT RA$(L)
 532  INPUT CL$(L)
 533  INPUT ZA%(L)
 534  INPUT AB%(L)
 535  INPUT AC%(L)
 536  INPUT AF%(L)
 537  INPUT AG%(L)
 538  INPUT AH%(L)
 539  INPUT AI%(L)
 540  INPUT AJ%(L)
 541  INPUT AK%(L)
 542  INPUT DV$(L)
 543  INPUT DW$(L)
 544  INPUT DX$(L)
 545  INPUT WT%(L)
 546  FOR M = 0 TO 7: INPUT AP$(L,M): NEXT
 547  FOR M = 0 TO 15: INPUT AX$(L,M): NEXT
 548  NEXT L
 565  INPUT X
 566  INPUT Y
 570  INPUT AD%: INPUT AE: INPUT FL%: INPUT RM$
 571  FOR I = 0 TO 5: INPUT FG%(I): NEXT I
 575  PRINT CHR$(4);"CLOSE ";B$;"D.";NA$
 600  FOR L = 0 TO 3:WU(L) = 1
 610  IF CL$(L) = "WIZARD" THEN WU(L) = 2
 620  IF CL$(L) = "CLERIC" THEN WU(L) = 1.8
 630  IF CL$(L) = "THIEF" THEN WU(L) = 1.5
 640  IF CL$(L) = "MONK" THEN WU(L) = 1.3
 650  IF CL$(L) = "RANGER" THEN WU(L) = 1.3
 660  IF CL$(L) = "PALADIN" THEN WU(L) = 1.1
 670  NEXT L
 699  RETURN

 700  REM SAVE
 705  PRINT : PRINT CHR$(4);"OPEN ";B$;"D.";NA$
 710  PRINT CHR$(4);"WRITE ";B$;"D.";NA$
 715  FOR L = 0 TO 3
 720  PRINT NM$(L)
 725  PRINT RA$(L)
 730  PRINT CL$(L)
 735  PRINT ZA%(L)
 740  PRINT AB%(L)
 745  PRINT AC%(L)
 750  PRINT AF%(L)
 755  PRINT AG%(L)
 760  PRINT AH%(L)
 765  PRINT AI%(L)
 770  PRINT AJ%(L)
 775  PRINT AK%(L)
 780  PRINT DV$(L)
 785  PRINT DW$(L)
 790  PRINT DX$(L)
 795  PRINT WT%(L)
 800  FOR M = 0 TO 7: PRINT AP$(L,M): NEXT
 805  FOR M = 0 TO 15: PRINT AX$(L,M): NEXT
 810  NEXT L
 815  PRINT X
 820  PRINT Y
 825  PRINT AD%: PRINT AE: PRINT FL%: PRINT RM$
 826  FOR I = 0 TO 5: PRINT FG%(I): NEXT I
 830  PRINT CHR$(4);"CLOSE ";B$;"D.";NA$
 850  RETURN

 900  REM LOAD LIST
 901  FOR I = 0 TO 9: PN$(I) = "EMPTY": NEXT I
 905  PRINT : PRINT CHR$(4);"OPEN PARTIES,TDIR"
 910  PRINT CHR$(4);"READ PARTIES"
 911  INPUT VN$: INPUT A$: INPUT A$: REM STRIP HEADER
 920  I = 0
 925  INPUT A$: IF A$ = "" THEN 940
 930  GOSUB 950: IF I>8 THEN 940
 935  GOTO 925
 940  PRINT CHR$(4);"CLOSE PARTIES"
 949  RETURN

 950  REM EXTRACT PARTY NAME
 960  IF MID$(A$,2,2) <> "D." THEN RETURN
 970  M = 4
 980  IF MID$(A$,M,1) = " " OR M = 17 THEN PN$(I) = MID$(A$,4,M-4): I = I + 1: RETURN
 990  M = M + 1: GOTO 980

 1000  REM CREATE PARTY
 1010  GOSUB 900: GOSUB 1900: IF M=1 THEN HOME: PRINT "THERE IS NO ROOM ";:GET A$: GOTO 100

 1100  X = 45 : Y = 18 : RM$="ARRINEA": AE = 100: AD% = 100: FL% = 0
 1101  FOR I = 0 TO 5: FG%(I) = 0: NEXT I
 1110  FOR L = 0 TO 3
 1120  HOME
 1121 ZA%(L) = 0
 1122 AP$(L,0) = "DAGGER":AP$(L,1) = "LEATHER": FOR I = 2 TO 7: AP$(L,I) = "": NEXT I
 1123 CL$(L) = "":RA$(L) = "": FOR I = 0 TO 15: AX$(L,I) = "": NEXT I
 1124 DV$(L) = "LEATHER":DW$(L) = "DAGGER":DX$(L) = ""
 1130  PRINT "THIS IS CHARACTER #";L+1
 1140  PRINT "WHAT SHOULD THIS CHARACTERS NAME BE?"
 1150  GOSUB 7000: NM$(L) = A$
 1160  IF A$ = "" THEN 1150
 1170  GOSUB 200: GOSUB 250: GOSUB 360
 1200  IF RA$(L) = "ELF" THEN AG%(L) = AG%(L) + 5
 1210  IF RA$(L) = "DWARF" THEN AJ%(L) = AJ%(L) + 5
 1220  IF RA$(L) = "HOBBIT" THEN AI%(L) = AI%(L) + 5
 1230  IF RA$(L) = "HUMAN" THEN AG%(L) = AG%(L) + 5
 1240  IF RA$(L) = "HUMAN" THEN AK%(L) = AK%(L) + 5
 1250  IF CL$(L) = "MONK" THEN AI%(L) = AI%(L) + 5
 1260  IF CL$(L) = "RANGER" THEN AB%(L) = 80
 1270  IF CL$(L) = "WIZARD" THEN AB%(L) = 50
 1280  IF CL$(L) = "CLERIC" THEN AB%(L) = 60
 1290  IF CL$(L) = "FIGHTER" THEN AB%(L) = 100
 1300  IF CL$(L) = "PALADIN" THEN AB%(L) = 80
 1310  IF CL$(L) = "THIEF" THEN AB%(L) = 60
 1320  IF CL$(L) = "MONK" THEN AB%(L) = 80
 1330 AB%(L) = AB%(L) + AJ%(L)
 1340 AB%(L) = AB%(L) * 2
 1350 AC%(L) = AB%(L)
 1360  IF CL$(L) = "FIGHTER" THEN WT%(L) = 20
 1370  IF CL$(L) = "WIZARD" THEN WT%(L) = 25
 1380  IF CL$(L) = "CLERIC" THEN WT%(L) = 20
 1390  IF CL$(L) = "THIEF" THEN WT%(L) = 20
 1400  IF CL$(L) = "PALADIN" THEN WT%(L) = 10
 1410  IF CL$(L) = "MONK" THEN WT%(L) = 10
 1420  IF CL$(L) = "RANGER" THEN WT%(L) = 10
 1430  NEXT L

 1500  HOME : REM REVIEWING WHOLE PARTY
 1501  FOR L = 0 TO 3
 1502  HOME : PRINT "REVIEWING CHARACTER ";L+1
 1503  PRINT "NAME: ";NM$(L)
 1504  PRINT "CLASS: ";CL$(L)
 1505  PRINT "RACE: ";RA$(L)
 1506  PRINT "STRENGTH: ";AF%(L)
 1507  PRINT "INTELLIGENCE: ";AG%(L)
 1508  PRINT "WISDOM: ";AH%(L)
 1509  PRINT "AGILITY: ";AI%(L)
 1510  PRINT "STAMINA: ";AJ%(L)
 1511  PRINT "CHARISMA: ";AK%(L)
 1512  PRINT "MAXIMUM LEVEL: ";WT%(L)
 1513  PRINT "HIT POINTS: ";AB%(L)
 1514  GET A$
 1515  NEXT L
 1516  HOME : PRINT "SAVE THIS PARTY (Y/N) ";: GET A$
 1520  IF A$<>"Y" AND A$<>"N" THEN 1516
 1530  IF A$ = "N" THEN 100

 1600  HOME : PRINT "ENTER YOUR PARTY'S NAME-": GOSUB 7100
 1610  GOSUB 1800: IF M = 0 THEN 1600
 1620  IF M = 1 THEN PRINT: PRINT A$;" ALREADY USED";: GET A$: GOTO 1600
 1630  NA$ = A$

 1700  REM SAVE ALL DATA
 1710  GOSUB 1950: REM ADD TO LIST
 1780  B$ = "PARTIES/": GOSUB 700 : REM SAVE PARTY DATA
 1791  PRINT "PARTY SAVED.": PRINT "COPYING MAP FILES...."
 1792  PRINT CHR$(4);"BLOAD MAPS/ARRINEA,A$6E00": PRINT CHR$(4);"BSAVE PARTIES/AR.";NA$;",A$6E00,L3200"
 1793  PRINT CHR$(4);"BLOAD XMAPS/ABYSS,A$6E00": PRINT CHR$(4);"BSAVE PARTIES/AB.";NA$;",A$6E00,L3200"
 1794  PRINT CHR$(4);"BLOAD XMAPS/FONKRAKIS,A$6E00": PRINT CHR$(4);"BSAVE PARTIES/FO.";NA$;",A$6E00,L3200"
 1795  PRINT CHR$(4);"BLOAD XMAPS/WORNOTH,A$6E00": PRINT CHR$(4);"BSAVE PARTIES/WO.";NA$;",A$6E00,L3200"
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
 2010  GOSUB 900: HOME: GOSUB 2100: PRINT: PRINT "PRESS ANY KEY ";: GET A$ : GOTO 100

 2100  REM DISPLAY PARTIES
 2110  PRINT "PARTIES:": PRINT: M = 0: FOR I = 0 TO 9: IF PN$(I) <> "EMPTY" THEN M = M + 1: PRINT M;") ";PN$(I)
 2130  NEXT I:  IF M = 0 THEN PRINT "NO PARTIES ON THIS DISK."
 2140  RETURN

 3000  REM RENAME
 3001  GOSUB 900: HOME: PRINT "--RENAME--": PRINT: GOSUB 400: IF M = 0 THEN GOTO 100
 3010  PRINT: PRINT "RENAMING ";NA$: PRINT "CONTINUE ? (Y TO PROCEED)- ";: GET A$
 3020  IF A$ <> "Y" THEN 100
 3030  PRINT: PRINT "NEW NAME-": GOSUB 7100: GOSUB 1800: IF M<2 THEN PRINT: PRINT "ALREADY USED OR NOT VALID": GOTO 3030
 3040  PRINT : PRINT  CHR$ (4);"RENAME PARTIES/D.";NA$;",PARTIES/D.";A$
 3041  PRINT  CHR$ (4);"RENAME PARTIES/AR.";NA$;",PARTIES/AR.";A$
 3042  PRINT  CHR$ (4);"RENAME PARTIES/AB.";NA$;",PARTIES/AB.";A$
 3043  PRINT  CHR$ (4);"RENAME PARTIES/FO.";NA$;",PARTIES/FO.";A$
 3044  PRINT  CHR$ (4);"RENAME PARTIES/WO.";NA$;",PARTIES/WO.";A$
 3050  PN$(L) = A$
 3099  GOTO 100

 4000  REM DELETE
 4001  GOSUB 900: HOME: PRINT "--DELETE--": PRINT: GOSUB 400: IF M = 0 THEN GOTO 100
 4010  PRINT: PRINT "DELETING ";NA$: PRINT "CONTINUE ? (Y TO PROCEED)- ";: GET A$
 4020  IF A$ <> "Y" THEN 100
 4040  PRINT : PRINT  CHR$ (4);"DELETE PARTIES/D.";NA$
 4041  PRINT  CHR$ (4);"DELETE PARTIES/AR.";NA$
 4042  PRINT  CHR$ (4);"DELETE PARTIES/AB.";NA$
 4043  PRINT  CHR$ (4);"DELETE PARTIES/FO.";NA$
 4044  PRINT  CHR$ (4);"DELETE PARTIES/WO.";NA$
 4050  PN$(L) = "EMPTY"
 4099  GOTO 100

 5000  REM CONFIGURATION
 5010  HOME: PRINT "--RAM DISK--"
 5015  ONERR GOTO 5050
 5020  RD$ = "PROG" + "/": PRINT:PRINT CHR$(4);"VERIFY /RAM"
 5030  PRINT "RAM DISK FOUND. THIS CAN IMPROVE SPEED": PRINT "ON VINTAGE HARDWARE. USE ? (Y/N) ";: GET A$
 5040  IF A$ = "Y" THEN RD$ = "/RAM" + "/"
 5045  GOTO 5100
 5050  PRINT "NO RAM DISK FOUND. ";: GET A$: CALL -3288
 5100  POKE 216,0
 5170  HOME: PRINT "--PAUSE DURATION--"
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
 5199  GOSUB 5200: GOTO 100

 5200  REM WRITE CONFIG
 5210  PRINT : PRINT CHR$(4);"OPEN DD"
 5220  PRINT CHR$(4);"WRITE DD"
 5281  PRINT ES
 5282  PRINT EP
 5283  PRINT RD$
 5290  PRINT CHR$(4);"CLOSE DD"
 5299  RETURN

 5300  REM READ CONFIG
 5310  PRINT : PRINT CHR$(4);"OPEN DD"
 5320  PRINT CHR$(4);"READ DD"
 5381  INPUT ES
 5382  INPUT EP
 5383  INPUT RD$
 5390  PRINT CHR$(4);"CLOSE DD"
 5399  RETURN

 6000  REM ENTER GAME
 6010  GOSUB 900: HOME: PRINT "--ENTER GAME--": PRINT: GOSUB 400: IF M = 0 THEN 100
 6020  B$ = "PARTIES/": GOSUB 500: FS% = 0: MD% = 0: GOSUB 9000
 6030  PRINT CHR$(4);"BLOAD BIN/S2"
 6040  PRINT CHR$(4);"BLOAD PARTIES/";LEFT$(RM$,2);".";NA$
 6050  PRINT CHR$(4);"BLOAD ";RD$;"OUTSIDE"
 6060  POKE 16384,0: POKE 103,1: POKE 104,64: POKE 175,255: POKE 176,108: GOTO 1

 6400  REM IMPORT
 6401  ONERR GOTO 6600
 6402  GOSUB 900: HOME: PRINT "--IMPORT PARTY--": GOSUB 1900: IF M=1 THEN PRINT: PRINT "THERE IS NO ROOM ";:GET A$: POKE 216,0: GOTO 100
 6410  PRINT CHR$(4);"PREFIX": INPUT P0$
 6420  GOSUB 6550: PD$ = P0$ + "PARTIES/": PS$ = P1$
 6430  PRINT "NAME OF PARTY:": GOSUB 7100: NA$ = A$
 6431  HOME: PRINT "PARTY: ";NA$: PRINT "SOURCE PREFIX:": PRINT " ";PS$: PRINT "DESTINATION PREFIX:": PRINT " ";PD$
 6432  PRINT: PRINT "IF TWO DISKS BOTH MUST BE INSERTED."
 6440  PRINT "PRESS B TO BEGIN, OTHER KEY CANCELS- ";: GET A$: IF A$ <> "B"  THEN GOSUB 6720: POKE 216,0: GOTO 100
 6450  PRINT: PRINT "WORKING..."
 6451  B$ = "": GOSUB 6700: GOSUB 500: GOSUB 6710: GOSUB 700
 6460  GOSUB 6700: PRINT CHR$(4);"BLOAD AR.";NA$;",A$6E00"
 6461  GOSUB 6710: PRINT CHR$(4);"BSAVE AR.";NA$;",A$6E00,L3200"
 6462  GOSUB 6700: PRINT CHR$(4);"BLOAD AB.";NA$;",A$6E00"
 6463  GOSUB 6710: PRINT CHR$(4);"BSAVE AB.";NA$;",A$6E00,L3200"
 6464  GOSUB 6700: PRINT CHR$(4);"BLOAD FO.";NA$;",A$6E00"
 6465  GOSUB 6710: PRINT CHR$(4);"BSAVE FO.";NA$;",A$6E00,L3200"
 6466  GOSUB 6700: PRINT CHR$(4);"BLOAD WO.";NA$;",A$6E00"
 6467  GOSUB 6710: PRINT CHR$(4);"BSAVE WO.";NA$;",A$6E00,L3200"
 6470  GOSUB 6720: HOME: PRINT "FINISHED. PRESS ANY KEY.";: GET A$: POKE 216,0: GOTO 100

 6500  REM EXPORT
 6501  ONERR GOTO 6600
 6510  GOSUB 900: HOME: PRINT "--EXPORT PARTY--": PRINT: GOSUB 400 : IF M = 0 THEN POKE 216,0: GOTO 100
 6520  PRINT CHR$(4);"PREFIX": INPUT P0$
 6530  HOME: PRINT "--EXPORT PARTY--": GOSUB 6550: PRINT "ANY KEY TO CONTINUE- ";: GET A$: PS$ = P0$ + "PARTIES/": PD$ = P1$: GOTO 6431

 6550  HTAB 1: VTAB 3: PRINT "SLOT OF AUXILIARY STORAGE: ";: GET A$: S = VAL(A$): IF S<1 OR S>7 THEN 6550
 6551  PRINT S
 6552  HTAB 1: VTAB 4: PRINT "DRIVE OF AUXILIARY STORAGE: ";: GET A$: D = VAL(A$): IF D<1 OR D>2 THEN 6552
 6553  PRINT D: PRINT "INSERT DISK (ESC CANCELS)- ";:GET A$: IF A$ = CHR$(27) THEN POKE 216,0: CALL -10621: GOTO 100
 6554  PRINT: PRINT CHR$(4);"CAT,S";S;",D";D: PRINT CHR$(4);"PREFIX /": PRINT CHR$(4);"PREFIX": INPUT P1$
 6555  PRINT "WHICH DIRECTORY (ENTER=ROOT): ": GOSUB 7000: IF A$ <> "" THEN P1$ = P1$ + A$
 6556  PRINT: PRINT CHR$(4);"CAT ";P1$
 6560  RETURN

 6600  HOME: PRINT "THERE WAS PROBABLY A DISK ERROR.": PRINT "ERROR ";PEEK(222);" ON LINE ";PEEK(218)+PEEK(219)*256;". "
 6601  PRINT "WE MUST RETURN TO THE MAIN MENU."
 6602  PRINT "RESTORE REALM DISK IF REMOVED- ";: GET A$: CALL -10621: GOSUB 6720: POKE 216,0: GOTO 100

 6700  PRINT: PRINT CHR$(4);"PREFIX ";PS$: RETURN
 6710  PRINT: PRINT CHR$(4);"PREFIX ";PD$: RETURN
 6720  PRINT: PRINT CHR$(4);"PREFIX ";P0$: RETURN

 7000  REM INPUT
 7002 A$ = "": HTAB 1: PRINT ">";: CALL -868
 7004  GET CH$: CH = ASC(CH$): IF CH = 13 THEN RETURN
 7008  IF CH = 8 OR CH = 127 THEN 7014
 7010  IF CH<32 OR CH>126 OR CH=44 OR LEN(A$)>16 THEN 7004
 7012  PRINT CH$;: A$ = A$ + CH$: GOTO 7004
 7014  IF LEN (A$) < 2 THEN 7000
 7016 A$ =  LEFT$ (A$, LEN (A$) - 1): POKE 36, PEEK (36) - 1: CALL  - 868: GOTO 7004

 7100  REM INPUT PRODOS FRIENDLY NAME
 7102 A$ = "": HTAB 1: PRINT ">";: CALL -868
 7104  GET CH$: CH = ASC(CH$): IF CH = 13 THEN RETURN
 7108  IF CH = 8 OR CH = 127 THEN 7114
 7110  IF (CH<65 OR CH>90) AND (CH<48 OR CH>57) AND CH<>46 OR LEN(A$)>11 THEN 7104
 7112  PRINT CH$;: A$ = A$ + CH$: GOTO 7104
 7114  IF LEN (A$) < 2 THEN 7100
 7116 A$ =  LEFT$ (A$, LEN (A$) - 1): POKE 36, PEEK (36) - 1: CALL  - 868: GOTO 7104

 7500  HOME: PRINT "HTTPS://GITHUB.COM/DFGORDON/REALM"
 7510  PRINT: PRINT "MOVEMENT - ARROWS OR 0/-/=/P/[/L/;/'"
 7520  PRINT "A - ATTACK/SCUTTLE": PRINT "B - BOARD SHIP": PRINT "C - CAST": PRINT "E - ENTER"
 7530  PRINT "F - FAST STATUS": PRINT "G - GET CHEST": PRINT "I - INVENTORY SWAP": PRINT "K - CLIMB LADDER"
 7540  PRINT "Q - SAVE/QUIT": PRINT "R - READY": PRINT "S - STEAL/SURFACE": PRINT "T - TRANSACT"
 7550  PRINT "U - USE": PRINT "W - WITHDRAW/ADVANCE": PRINT "X - EXIT SHIP/CRAFT": PRINT "Z - STATUS"
 7560  PRINT "CTRL-A - AUTO-RESOLVE COMBAT": PRINT "CTRL-P - PRAY TO THE ONE": PRINT "CTRL-S - SOUND": GET A$

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
 8040  DIM WU(3): DIM FG%(5)
 8050  DIM NM$(3): DIM RA$(3)
 8060  DIM CL$(3): DIM ZA%(3)
 8070  DIM AB%(3): DIM AC%(3)
 8080  DIM AF%(3): DIM AG%(3)
 8090  DIM AH%(3): DIM AI%(3)
 8100  DIM AJ%(3): DIM AK%(3)
 8110  DIM DV$(3): DIM DW$(3)
 8120  DIM DX$(3): DIM WT%(3)
 8130  DIM GN(9): DIM PM%(9)
 8140  DIM PC%(3): DIM GP%(3)
 8150  DIM AX$(3,15): DIM AP$(3,7)
 8199  RETURN

 9000  REM RAM DISK
 9001  IF RD$ = "PROG/" THEN RETURN
 9010  ONERR GOTO 9900
 9020  HOME: PRINT "SETTING UP RAM DISK..."
 9040  PRINT CHR$(4);"BLOAD PROG/COMBAT": GOSUB 9100: PRINT CHR$(4);"BSAVE /RAM/COMBAT,A";A;",L";L
 9050  PRINT CHR$(4);"BLOAD PROG/OUTSIDE": GOSUB 9100: PRINT CHR$(4);"BSAVE /RAM/OUTSIDE,A";A;",L";L
 9060  PRINT CHR$(4);"BLOAD PROG/TOWN": GOSUB 9100: PRINT CHR$(4);"BSAVE /RAM/TOWN,A";A;",L";L
 9070  PRINT CHR$(4);"BLOAD PROG/DUNGEON": GOSUB 9100: PRINT CHR$(4);"BSAVE /RAM/DUNGEON,A";A;",L";L
 9080  POKE 216,0: RETURN

 9100  A = PEEK(48825)+PEEK(48826)*256: L = PEEK(48840)+PEEK(48841)*256: RETURN

 9900  PRINT "RAM DISK ERROR. PROCEEDING WITHOUT. ";: GET A$: RD$ = "PROG" + "/": POKE 216,0: CALL -3288: RETURN
