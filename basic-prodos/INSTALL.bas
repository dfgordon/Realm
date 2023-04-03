1  LOMEM: 24576: PRINT: PRINT CHR$(4);"PR#0": PRINT CHR$(4);"IN#0"
2  ONERR GOTO 6000
3  CLEAR : RESTORE : POKE -16370,0
4  DIM VO$(16): DIM CAP(16): DIM PN$(63): DIM PLNGTH(63)
5  POKE 8,0: POKE 1013,76: POKE 1014,0: POKE 1015,64
8  PRINT: PRINT CHR$(4);"BLOAD /REALM.INSTALL1/ITEMS/DISKLIB"
9  GOTO 1000

10  REM GET VOLUMES AND CAPACITIES
20  HOME: PRINT "SCANNING...": COUNT = 0: &("VOLS",VO$,CAP,COUNT): IF COUNT=0 THEN PRINT "NO VOLUMES FOUND": GOTO 9999
30  FOR I = 0 TO COUNT-1: PN$(I) = VO$(I) + " (" + STR$(CAP(I)) + ")": NEXT: HOME: RETURN

100  REM TEST FOR A$ IN B$
101  TST = 1
102  IF TST>LEN(B$) THEN TST = 0: RETURN
103  IF A$=MID$(B$,TST,1) THEN RETURN
104  TST = TST + 1: GOTO 102

110  REM PROMPT
111  W$ = ""
112  A$ = CHR$(13): GOSUB 100: IF TST THEN W$ = W$ + "RET = GO IN SUBDIR" + CHR$(13)
113  A$ = CHR$(9): GOSUB 100: IF TST THEN W$ = W$ + "TAB = MORE SUBDIRS" + CHR$(13)
114  A$ = CHR$(27): GOSUB 100: IF TST THEN W$ = W$ + "ESC = GO BACK UP" + CHR$(13)
115  A$ = " ": GOSUB 100: IF TST THEN W$ = W$ + "SPC = INSTALL IN CURRENT PATH" + CHR$(13)
119  RETURN

120  REM SPLIT KEY=VAL
121  J = 0: FOR I = 1 TO LEN(A$): IF MID$(A$,I,1) = "=" THEN J = I
122  NEXT: IF J = 0 THEN PRINT "PARSING ERROR (";A$;")": GOTO 9999
123  S1$ = MID$(A$,1,J-1): S2$ = MID$(A$,J+1,LEN(A$)): RETURN

140  REM NOMENU SUBROUTINE
141  HTAB 1: VTAB L: PRINT "NO ITEMS": PRINT: PRINT W$;: GET A$: GOSUB 100: IF TST>0 THEN M=-1: RETURN
142  GOTO 141

150  REM MENU SUBROUTINE
151  REM IN: PN$()=ITEMS, I1=FIRST, I2=LAST, L=FIRST ROW, B$=TERMINATOR KEYS, W$=PROMPT
152  REM OUT: A$=KEYSTROKE, M=ITEM INDEX, PN$(M)=ITEM NAME
153  IF I2<I1 THEN GOSUB 140: RETURN
154  N = I1: M = I1: HTAB 1: VTAB L: PRINT "1) ";: INVERSE: PRINT PN$(I1): NORMAL: IF I2>I1 THEN FOR I = I1+1 TO I2: PRINT I-I1+1;") ";PN$(I): NEXT
155  HTAB 1: VTAB L+I2-I1+2: PRINT W$;: GET A$: GOSUB 100: IF TST>0 THEN RETURN
156  IF VAL(A$)>=1 AND VAL(A$)<=I2-I1+1 THEN M = I1+VAL(A$)-1: RETURN
157  IF A$ = CHR$(8) OR A$ = CHR$(11) THEN N = M: M = M - 1: IF M<I1 THEN M = I2
158  IF A$ = CHR$(10) OR A$ = CHR$(21) THEN N = M: M = M + 1: IF M>I2 THEN M = I1
159  HTAB 4: VTAB N+L-I1: PRINT PN$(N): INVERSE: HTAB 4: VTAB M+L-I1: PRINT PN$(M): NORMAL: GOTO 155

160  PRINT " (Y/N) ? ";: REM BINARY CHOICE SUBROUTINE
161  GET A$: IF A$ <> "Y" AND A$ <> "y" AND A$ <> "N" AND A$ <> "n" THEN 161
162  IF A$="y" THEN A$="Y"
163  IF A$="n" THEN A$="N"
164  RETURN

170  REM GET SUBDIRS
171  PRINT CHR$(4);"OPEN ";PTH$;",TDIR"
172  PRINT CHR$(4);"READ ";PTH$
173  FOR I=1 TO 3: INPUT A$: NEXT: COUNT = 0
174  INPUT A$: IF A$="" OR COUNT>63 THEN 181
175  IF LEN(A$) < 20 THEN 174
176  IF MID$(A$,18,3) <> "DIR" THEN 174
178  PN$(COUNT) = "": J = 2
179  IF MID$(A$,J,1)=" " OR J>16 THEN COUNT = COUNT + 1: GOTO 174
180  PN$(COUNT) = PN$(COUNT) + MID$(A$,J,1): J = J + 1: GOTO 179
181  PRINT CHR$(4);"CLOSE ";PTH$
182  RETURN: REM FOUND COUNT SUBDIRS

190  REM SHOW PATH
191  IF RIGHT$(PTH$,6) = "/REALM" THEN 193
192  PRINT "CURRENT PATH:": PRINT PTH$: RETURN
193  GOSUB 200: GOSUB 160: PRINT: IF A$="N" THEN HOME: GOTO 192
194  UPGD = 1: DEPTH = DEPTH - 1: PTH$ = LEFT$(PTH$,PLNGTH(DEPTH)): POP: GOTO 1190

200  REM UPGRADE PROMPT
210  PRINT "UPGRADE WILL OVERWRITE ALL BUT CONFIG"
220  PRINT "AND PARTY DATA. PROCEED";: RETURN

300  REM SMART COPY
310  IF UPGD = 0 OR P2$ <> "DD" THEN &("COPY",P1$,P2$,P3$,P4$): RETURN
320  ONERR GOTO 390
330  PRINT CHR$(4);"PREFIX ";P3$: PRINT CHR$(4);"VERIFY ";P4$
340  ONERR GOTO 6000
350  RETURN
390  PRINT: PRINT "CONFIG FILE EXPECTED BUT NOT FOUND": PRINT "DURING UPGRADE.": GOTO 9999

1000  REM MAIN SEQUENCE
1001  POKE 34,0: HOME: PRINT "REALM HD INSTALLER V1.5.0": POKE 34,2
1002  GOSUB 10: REM ENDS IF NO VOLUMES
1010  L = 3: B$ = CHR$(13) + CHR$(9): W$ = "RET = SELECT VOLUME" + CHR$(13) + "TAB = RESCAN": I1 = 0: I2 = COUNT-1: GOSUB 150
1011  IF A$ = CHR$(9) THEN HOME: GOTO 1002
1020  IF CAP(M) < 1000 THEN PRINT: PRINT "NOT ENOUGH ROOM ON VOLUME ";: GET A$: HOME: GOTO 1010
1030  CAP = CAP(M): PTH$ = "/" + LEFT$(PN$(M),LEN(PN$(M))-LEN(STR$(CAP))-3)
1040  VO$ = PTH$: PLNGTH(0) = LEN(VO$): DEPTH = 0: UPGD = 0

1050  PAGE = 0
1060  GOSUB 170
1070  HOME: PRINT: GOSUB 190: B$ = " ": L = 7
1080  IF COUNT>0 THEN B$ = B$ + CHR$(13)
1090  IF COUNT>9 THEN B$ = B$ + CHR$(9)
1100  IF DEPTH>0 THEN B$ = B$ + CHR$(27)
1110  GOSUB 110: IF PAGE > (COUNT-1)/9 THEN PAGE = 0
1120  I1 = PAGE*9: I2 = I1 + 8: IF I2>=COUNT THEN I2 = COUNT-1
1130  GOSUB 150
1140  IF A$ = CHR$(9) THEN PAGE = PAGE + 1: GOTO 1070
1150  IF A$ = " " THEN 1190
1160  IF A$ = CHR$(27) THEN DEPTH = DEPTH - 1: PTH$ = LEFT$(PTH$,PLNGTH(DEPTH)): GOTO 1050
1170  IF LEN(PTH$)+LEN(PN$(M)) > 56 THEN PRINT: PRINT "PATH TOO LONG ";: GET A$: GOTO 1070
1180  DEPTH = DEPTH + 1: PTH$ = PTH$ + "/" + PN$(M): PLNGTH(DEPTH) = LEN(PTH$): GOTO 1050

1190  REM START COPYING
1200  HOME: DST$ = PTH$: PRINT "INSTALLING TO": PRINT DST$ + "/REALM": PRINT CHR$(4);"PREFIX ";DST$
1201  REM CHECK EXISTING
1202  ONERR GOTO 6010
1203  PRINT CHR$(4);"VERIFY REALM"
1204  IF UPGD = 1 THEN 1260
1205  UPGD = 1: GOSUB 200: GOSUB 160: PRINT: IF A$="N" THEN GOTO 1000
1206  GOTO 1260
1210  PRINT "PROCEED";: GOSUB 160: PRINT: IF A$="N" THEN GOTO 1000
1220  ONERR GOTO 6000
1230  PRINT CHR$(4);"CREATE REALM": PRINT CHR$(4);"CREATE REALM/MAPS": PRINT CHR$(4);"CREATE REALM/XMAPS"
1240  PRINT CHR$(4);"CREATE REALM/MONSTERS": PRINT CHR$(4);"CREATE REALM/PARTIES": PRINT CHR$(4);"CREATE REALM/BIN"
1250  PRINT CHR$(4);"CREATE REALM/PROG"
1260  ONERR GOTO 6020
1270  READ SUBDIR$: POKE 216,0
1280  READ A$: GOSUB 120: IF S1$ <> "disk" THEN PRINT "PARSING ERROR (";A$;")": GOTO 9999
1290  DSK = VAL(S2$): IF DSK<1 OR DSK>3 THEN PRINT "INVALID DISK ";DSK: GOTO 9999
1300  READ A$: GOSUB 120: IF S1$ <> "files" THEN PRINT "PARSING ERROR (";A$;")": GOTO 9999
1310  FILES = VAL(S2$): IF FILES=0 THEN PRINT "INVALID FILE COUNT ";FILES: GOTO 9999
1320  FOR FCOUNT = 1 TO FILES: READ P2$
1321  ONERR GOTO 6040
1322  PRINT CHR$(4);"VERIFY /REALM.INSTALL";DSK
1323  ONERR GOTO 6050
1324  PRINT CHR$(4);"VERIFY ";VO$
1325  ONERR GOTO 6000
1330  P1$ = "/REALM.INSTALL" + STR$(DSK) + "/ITEMS"
1331  P3$ = DST$: P4$ = SUBDIR$ + "/" + P2$
1332  GOSUB 300
1340  A$ = P3$+"/"+P4$: IF LEN(A$)>39 THEN PRINT "...";RIGHT$(A$,36)
1341  IF LEN(A$)<40 THEN PRINT A$ 
1360  NEXT: GOTO 1260
1370  PRINT: PRINT "INSTALLATION FINISHED.": GOTO 9999

5999  REM ERROR HANDLERS
6000  PRINT: PRINT CHR$(7);"UNRECOVERABLE ERROR ";PEEK(222);" ON LINE ";PEEK(218)+PEEK(219)*256: GOTO 9999
6010  REM HANDLE EXISTING
6011  IF (PEEK(222) = 6 OR PEEK(222)=7) AND UPGD = 0 THEN CALL -3288: GOTO 1210
6012  GOTO 6000  
6020  IF PEEK(222) = 42 THEN 1370: REM OUT OF DATA
6030  GOTO 6000
6040  PRINT: PRINT "INSERT INSTALL";DSK;" THEN PRESS ANY KEY- ";: GET A$: PRINT: RESUME
6050  PRINT: PRINT "MOUNT ";VO$;" THEN PRESS ANY KEY- ";:GET A$: PRINT: RESUME

8000  DATA REALM, disk=1, files=3
8001  DATA START.REALM,TITLE.PIC,DD

8008  DATA REALM/BIN, disk=1, files=7
8009  DATA MAP.INTRP,SOUND,SDP.INTRP,DNGNSPS,OUTSPS,TWNSPS,DISKLIB

8010  DATA REALM/MAPS, disk=1, files=21
8011  DATA ARRINEA,TOWNPIC.13.67,TOWNPIC.16.46,TOWNPIC.19.32,TOWNPIC.21.26,TOWNPIC.24.36
8012  DATA TOWNPIC.30.65,TOWNPIC.34.35,TOWNPIC.34.69,TOWNPIC.38.70,TOWNPIC.42.9,TOWNPIC.45.15
8013  DATA TOWNPIC.45.27,TOWNPIC.45.8,TOWNPIC.60.50,TOWNPIC.61.29,TOWNPIC.63.12,TOWNPIC.69.57
8014  DATA TOWNPIC.71.35,TOWNPIC.8.21,TOWNPIC.9.40

8015  DATA REALM/PROG, disk=1, files=8
8016  DATA ALCHEMIST,ARCHWIZ,BARON,CHAIN,FOOD,HIGH.PRIEST,LIBRARY,SHIPYARD

8020  DATA REALM/XMAPS, disk=2, files=29
8021  DATA ABYSS,DNGPIC.20.31,DNGPIC.22.58,DNGPIC.29.49,DNGPIC.31.13,DNGPIC.31.34
8022  DATA DNGPIC.32.0,DNGPIC.39.34,DNGPIC.42.39,DNGPIC.43.38,DNGPIC.47.52,DNGPIC.49.72
8023  DATA DNGPIC.51.18,DNGPIC.66.29,DNGPIC.71.21,DNGPIC.74.5,FONKRAKIS,TOWNPIC.11.24
8024  DATA TOWNPIC.14.35,TOWNPIC.15.50,TOWNPIC.24.22,TOWNPIC.26.64,TOWNPIC.33.48,TOWNPIC.36.48
8025  DATA TOWNPIC.39.34,TOWNPIC.4.3,TOWNPIC.41.2,TOWNPIC.56.34,WORNOTH

8026  DATA REALM/PROG, disk=2, files=9
8027  DATA COMBAT,DUNGEON,FINAL,OUTSIDE,PUB,SAGE,SAVE.GAME,TEMPLE,WEAPARM

8030  DATA REALM/MONSTERS, disk=3, files=28
8031  DATA APHIAN,CAEC,CEPHALOMAGE,CYCLOPS,DISRUPTOR.BEAST,DJINN,EFREET
8032  DATA FRAMEM,GHOUL,GIANT,GIANT.SCORPION,GIANT.SPIDER,GOBLIN,GOLD.DRAGON
8033  DATA HYDRA,ICE.MONSTER,KNIGHT,LICH,MORDOCK,OGRE,ORC
8034  DATA RED.DRAGON,ROC,SPECTRE,TROLL,WHITE.DRAGON,WRAITH.LORD,MONSTERS

8040  DATA REALM/PROG, disk=3, files=2
8041  DATA TOWN,LAUNCH

9999  POKE 34,0: CALL -10621: END

