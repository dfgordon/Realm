10  PRINT: PRINT CHR$(4);"MAXFILES 1": PRINT CHR$(4);"PR#0": PRINT CHR$(4);"IN#0"
20  CLEAR : RESTORE
30  LOMEM: 27904
40  HIMEM: 32767
50  GOSUB 8000 : REM GLOBAL ARRAYS
60  GOSUB 6300 : REM DRIVE MAPPINGS

100  REM ENTER THE GAME
110  TEXT : HOME : FS% = 0 : MD% = 0
120  PRINT CHR$(4);"BLOAD SOUND"
130  D = 0 : GOSUB 9000 : GOSUB 900 : REM GET PARTY LIST
140  NA$ = PN$(0) : REM EXPECT ONLY ONE AND IN FIRST POSITION
150  GOSUB 10000 : GOSUB 500 : REM LOAD DATA
170  IF RM$ <> "ARRINEA" THEN D = 1
180  GOSUB 9000: PRINT CHR$(4);"BLOAD ";RM$
290  PRINT CHR$(4);"BLOAD OUTSIDE,A$4001"
298  POKE 8183,0: POKE 8184,8: POKE 8188,0: POKE 8189,128: REM ASSUME CONSTANT
299  POKE 16384,0: POKE 103,1: POKE 104,64: POKE 175,255: POKE 176,108: GOTO 1

500  REM LOAD
510  HOME: VTAB 10: PRINT TAB(20-LEN(NA$)/2);NA$
515  PRINT CHR$(4);"OPEN D:";NA$
520  PRINT CHR$(4);"READ D:";NA$
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
575  PRINT CHR$(4);"CLOSE D:";NA$
580  GOSUB 8200
590  RETURN

900  REM LOAD LIST
901  GOSUB 9900
905  PRINT : PRINT : PRINT : PRINT CHR$(4);"OPEN PLIST"
910  PRINT CHR$(4);"READ PLIST"
925  FOR I = 0 TO 9
930  INPUT PN$(I)
935  NEXT I
940  PRINT CHR$(4);"CLOSE PLIST"
949  RETURN

6300  REM READ DRIVES
6310  PRINT : PRINT CHR$(4);"OPEN DD"
6320  PRINT CHR$(4);"READ DD"
6330  FOR I = 0 TO 3
6340  INPUT DL$(I)
6350  INPUT WS%(I)
6360  INPUT WD%(I)
6370  INPUT WV%(I)
6380  NEXT I
6381  INPUT ES
6382  INPUT EP
6390  PRINT CHR$(4);"CLOSE DD"
6399  RETURN

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
8150  DIM AX$(3,16): DIM AP$(3,9): DIM DR%(3,2)
8199  RETURN

8200  FOR L = 0 TO 3
8210  IF CL$(L) = "CLERIC" THEN CL%(L) = 0
8220  IF CL$(L) = "FIGHTER" THEN CL%(L) = 1
8230  IF CL$(L) = "MONK" THEN CL%(L) = 2
8240  IF CL$(L) = "PALADIN" THEN CL%(L) = 3
8250  IF CL$(L) = "RANGER" THEN CL%(L) = 4
8260  IF CL$(L) = "THIEF" THEN CL%(L) = 5
8270  IF CL$(L) = "WIZARD" THEN CL%(L) = 6
8271  AP$(L,8) = "HA"+"NDS": AP$(L,9) = "SK"+"IN": AX$(L,16) = "NO"+"NE": IF DX$(L) = "" THEN DX$(L) = AX$(L,16)
8272  FOR M = 9 TO 0 STEP -1: P = P*(DW$(L)<>AP$(L,M)) + M*(DW$(L)=AP$(L,M)): NEXT: DR%(L,0) = P
8273  FOR M = 9 TO 0 STEP -1: P = P*(DV$(L)<>AP$(L,M)) + M*(DV$(L)=AP$(L,M)): NEXT: DR%(L,1) = P
8274  FOR M = 16 TO 0 STEP -1: P = P*(DX$(L)<>AX$(L,M)) + M*(DX$(L)=AX$(L,M)): NEXT: DR%(L,2) = P
8280  NEXT
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
9200  HOME : PRINT "INSERT ";DL$(D);" DISK IN D";WD%(D);"- ";: GET A$: CALL 768: PRINT : RESUME

9900  REM VERIFY PARTY LIST
9910  ONERR  GOTO 9950
9920  PRINT : PRINT CHR$(4);"VERIFY PLIST"
9930  RETURN
9950  HOME : PRINT "BOOT FROM SETUP DISK."
9955  PRINT "YOU CAN BOOT FROM THIS DISK AFTER": PRINT "A PARTY HAS BEEN DEPLOYED."
9960  CALL -3288: REM CLEAR THE STACK
9970  POKE 216,0
9980  END

10000  REM VERIFY PARTY
10100  IF NA$ = "EMPTY" THEN 9950
10110  ONERR  GOTO 10200
10120  PRINT : PRINT : PRINT
10130  PRINT  CHR$(4);"VERIFY D:";NA$
10140  POKE 216,0: RETURN
10200  HOME : PRINT "'";NA$;"' NOT ON THIS DISK. "
10210  CALL -3288: REM CLEAR THE STACK
10220  POKE 216,0
10230  PRINT "DISK IS CORRUPTED."
10240  PRINT "WE EXPECTED TO FIND ";NA$: PRINT "BUT THEY ARE NOT HERE."
10250  END
