 1  ROT=0: SCALE=1: POKE 232,0: POKE 233,10
 2  PRINT CHR$(4);"BLOAD PROG/CHAIN"
 3  PRINT CHR$(4);"BLOAD BIN/SDP.INTRP"
 4  PRINT CHR$(4);"BLOAD BIN/MAP.INTRP"
 5  PRINT CHR$(4);"BLOAD BIN/OUTSPS"
 6  GOSUB 300
 7  POKE 8185,0: POKE 8174,0: POKE 8175,0
 8  POKE 8176,80: POKE 8177,80: POKE 8181,5: POKE 8182,1+6*16
 10  HGR: HOME : GOTO 100

 20  GOSUB 150: VTAB 20: GET A$: PRINT: AE = AE - .5 + .012*FL%: IF AE < 0 THEN 50000
 30  IF AE < 100 AND FS% = 0 THEN FS% = -1
 40  GOSUB 5100
 71  IF Y < 0 OR Y > 79 OR X < 0 OR X > 79 THEN 106
 72  IF A$ = "A" THEN 200
 73  IF A$ = "Z" THEN 4000
 74  IF A$ = "B" THEN 500
 75  IF A$ = "X" THEN 600
 76  IF A$ = "C" THEN 700
 78  IF A$ = "R" THEN 2800
 79  IF A$ = "Q" THEN 10000
 80  IF A$ = "E" THEN 8000
 81  IF A$ = "I" THEN 2000
 83  IF A$ = "U" THEN 1000
 84  IF A$ = "F" THEN HOME: FS% = -ABS(FS%) - 1: IF FS%<-3 THEN FS% = 0
 95  IF A$ = CHR$(16) THEN A = RND(1): HOME: VTAB 21: PRINT "DISCARDING ONE FATE CARD";: GET A$: HOME
 97  IF A$ = CHR$(7) THEN AD% = 9999
 99  IF A$ = CHR$(19) THEN 7050
 100  POKE 8187,FL%: POKE 8190,X: POKE 8191,Y: CALL 7545
 102  IF  PEEK (6) = 255 THEN 106
 104  GOTO 20
 106  X = X - XK: Y = Y - YK: GOSUB 30070: GOTO 20

 150  IF FS% = 0 THEN RETURN
 151  IF PEEK(1616) = 160 THEN FS% = -ABS(FS%)
 152  IF AE<100 THEN INVERSE
 153  VTAB 21: PRINT "FOOD": NORMAL: PRINT "    ";: HTAB 1: PRINT  INT (AE): IF FS% = -1 OR FS% > 0 THEN FS% = ABS(FS%): RETURN
 154  FS% = ABS(FS%): PRINT "GOLD": PRINT AD%;
 155  FOR I = 0 TO 3: VTAB 21 + I: HTAB 6
 156  IF FS% = 2 THEN PRINT LEFT$(DW$(I),12);
 157  IF FS% = 3 THEN PRINT LEFT$(DV$(I),12);
 158  A$ = STR$(AB%(I))+"/"+STR$(AC%(I)): HTAB 19: PRINT LEFT$(DX$(I),21-LEN(A$));: HTAB 41-LEN(A$): POKE 35,25: PRINT A$;: POKE 35,24: NEXT
 159  RETURN

 200  HOME: VTAB 21: PRINT "SCUTTLE ADJACENT SHIPS (Y/N) ?";: GET A$
 210  IF A$ <> "Y" THEN HOME: GOTO 100
 220  XK = X: YK = Y
 230  FOR X = XK-1 TO XK+1: FOR Y = YK-1 TO YK+1
 240  IF X=XK AND Y=YK THEN 299
 250  GOSUB 5000: IF PEEK(6)=11 THEN N = 4: GOSUB 5001
 299  NEXT Y: NEXT X: X = XK: Y = YK: MD% = 1: HOME: GOTO 100

 300  POKE 5806,1: IF RM$ = "ABYSS" THEN  POKE 5806,2
 310  IF RM$ = "WORNOTH" AND FG%(5)>0 THEN POKE 5790,5: POKE 5806,0
 320  RETURN

 400  M = PEEK(6)
 410  IF M=1 OR M=3 OR M=15 THEN FL%=0: GOTO 100
 420  GOTO 8070

 500  GOSUB 5000: IF  PEEK (6) <> 11 THEN 8070
 510  MD% = 1: FL%=16: N = 4: GOSUB 5001: GOTO 100

 600  GOSUB 5000: IF FL% = 32 THEN 400
 610  IF  FL% <> 16 OR PEEK(6) <> 4 THEN 8070
 620  MD% = 1: FL% = 0: N = 11: GOSUB 5001: GOTO 100

 700  HOME : VTAB 21: PRINT "WHO WILL CAST (#) ";: GET A$:A =  VAL (A$) - 1
 701  IF A < 0 OR A > 3 THEN 700
 703  IF AB%(A) = 0 THEN 700
 704  IF DX$(A) = "" THEN 730
 705 B$ = DX$(A)
 706  PRINT
 720  IF B$ = "RAISE DEAD" THEN 750
 721  IF B$ = "HEAL 1" THEN 760
 722  IF B$ = "HEAL 2" THEN 765
 723  IF B$ = "HEAL 3" THEN 770
 724  IF B$ = "FLY" THEN 790
 730  GOTO 2910

 747  GOSUB 30050: HOME : GOTO 100

 750  HOME: VTAB 21: PRINT "RAISE WHOM (#) ";: GET A$
 751 B =  VAL (A$) - 1: IF B < 0 OR B > 3 THEN 750
 752  IF AB%(B) > 0 THEN HOME: VTAB 21: PRINT NM$(B);" IS NOT DEAD! ";: GOTO 747
 753  IF B$ <> "RAISE DEAD" THEN GOSUB 2200
 754  IF B$ = "RAISE DEAD" THEN GOSUB 2300
 755 AB%(B) = 10: HOME : VTAB 21: PRINT "-CASTING RAISE DEAD-": GOSUB 30000
 756  PRINT NM$(B);" IS RAISED! ";: GET A$: HOME : GOTO 100

 760 CA = 50: GOTO 780
 765 CA = 100: GOTO 780
 770 CA = 200
 780 HOME: VTAB 21: PRINT "HEAL WHOM (#) ";: GET A$
 781 B =  VAL (A$) - 1: IF B < 0 OR B > 3 THEN 780
 782  IF AB%(B) < 1 THEN HOME: VTAB 21: PRINT NM$(B);" IS DEAD! ";: GOTO 747
 783  IF LEFT$(B$,2) <> "HE" THEN GOSUB 2200
 784  IF LEFT$(B$,2) = "HE" THEN GOSUB 2300
 785  HOME : VTAB 21: PRINT "-CASTING HEAL-": GOSUB 30000
 786 C =  INT (CA *  RND (1)) + CA
 787 AB%(B) = AB%(B) + C: IF AB%(B) > AC%(B) THEN AB%(B) = AC%(B)
 788  PRINT C;" POINTS HEALED. ";: GET A$: HOME : GOTO 100

 790  IF  FL% = 16 THEN 8070
 799  HOME: VTAB 21: PRINT "-CASTING FLY-": FL% = 32: GOSUB 30000: HOME: GOTO 100


 1000  HOME : VTAB 21: PRINT "WHO WILL USE (#) ";: GET A$
 1001 A =  VAL (A$) - 1: IF A < 0 OR A > 3 THEN 1000
 1004  IF AB%(A) = 0 THEN 1000
 1005 B$ = DW$(A)
 1010  IF B$ = "FLYING CARPET" THEN 790
 1013  IF B$ = "POTION OF VISION" THEN 1070
 1015  IF B$ = "ROD OF RESURRECTION" THEN 750
 1016  IF B$ = "POTION OF HEALING" THEN 760
 1020  IF B$ = "AMULET OF HEALING" THEN 770
 1023  GOTO 2900

 1070  IF PEEK(8181) = 6 THEN HOME: VTAB 21: PRINT "REACHED LIMIT.": GOSUB 30050: HOME: GOTO 100
 1071  GOSUB 2200: GOSUB 1099: I = PEEK(8181)+1: POKE 8181,I: POKE 8182,262-33*I: HOME: GOTO 100

 1099  HOME: VTAB 21: PRINT "-USING ";B$;"-": GOSUB 30000: RETURN

 2000  TEXT: A = 0: B$ = "FI"+"RST": GOSUB 2080: IF A$ = CHR$(27) THEN 2040
 2010  B = A: N = M: A = 0: B$ = "SEC"+"OND": GOSUB 2080: IF A$ = CHR$(27) THEN 2040
 2020 B$ = AP$(A,M-1): AP$(A,M-1) = AP$(B,N-1): AP$(B,N-1) = B$
 2030  GOSUB 7100: A = B: GOSUB 7100
 2040  POKE  - 16304,0: HOME : GOTO 100
 2080  HOME: PRINT "--INVENTORY SWAP--":PRINT:PRINT B$;" ITEM (";NM$(A);")": GOSUB 4210
 2081  PRINT "USE ARROWS TO CHANGE CHARACTER": PRINT "#=SELECT, ESC=ABORT ";: GET A$: IF A$ = CHR$(27) THEN RETURN
 2082  IF A$ = CHR$(8) THEN A = A - 1: IF A < 0 THEN A = 0
 2083  IF A$ = CHR$(21) THEN A = A + 1: IF A > 3 THEN A = 3
 2084  M = VAL(A$): IF M > 0 AND M < 9 THEN RETURN
 2085  GOTO 2080

 2200 P = ZA%(A) / 1000 + AH%(A): IF P/(10+P) >  RND (1) THEN RETURN
 2202 I = 0
 2204  IF AP$(A,I) = DW$(A) THEN 2208
 2206 I = I + 1: GOTO 2204
 2208 AP$(A,I) = ""
 2210 I = I + 1: IF I > 7 THEN 2216
 2212  IF AP$(A,I) = DW$(A) THEN  RETURN
 2214  GOTO 2210
 2216  INVERSE : HOME: VTAB 21: PRINT DW$(A);" IS EXPENDED ": NORMAL :DW$(A) = "HA" + "NDS"
 2220  FOR P = 0 TO 500 + EP: NEXT P: RETURN

 2250 I = 0
 2252  IF AP$(A,I) = A$ THEN 2256
 2254 I = I + 1: IF I<8 THEN 2252
 2256  IF I=8 THEN RETURN
 2258  IF DW$(A) = A$ THEN DW$(A) = "HA" + "NDS"
 2260 AP$(A,I) = "": RETURN

 2300 P = ZA%(A) / 1000 + AH%(A): IF P/(10+P) >  RND (1) THEN RETURN
 2302 I = 0
 2304  IF AX$(A,I) = DX$(A) THEN 2308
 2306 I = I + 1: GOTO 2304
 2308 AX$(A,I) = ""
 2310 I = I + 1: IF I > 15 THEN 2316
 2312  IF AX$(A,I) = DX$(A) THEN  RETURN
 2314  GOTO 2310
 2316  INVERSE : HOME: VTAB 21: PRINT DX$(A);" IS EXHAUSTED ": NORMAL :DX$(A) = ""
 2320  FOR P = 0 TO 500 + EP: NEXT P: RETURN

 2800  HOME : VTAB 21: PRINT "READY WHO (#) ";: GET A$: A =  VAL (A$) - 1: IF A<0 OR A>3 THEN 2800
 2802  IF AB%(A)=0 THEN 2800
 2810  HOME: VTAB 21: PRINT "(W)EAPON/ITEM, (A)RMOR, (S)PELL- ";: GET B$
 2820  IF B$ = "W" OR B$ = "A" THEN 2830
 2822  IF B$ = "S" THEN 2870
 2825  GOTO 2810

 2830  TEXT: HOME: GOSUB 4210: PRINT "H) HANDS": PRINT "SELECT- ";:GET A$: IF A$=CHR$(27) THEN 2860
 2831  IF A$="H" AND B$="W" THEN DW$(A) = "HA"+"NDS": GOTO 2860
 2833  L = VAL(A$) - 1: IF L<0 OR L>7 THEN 2830
 2840  POKE -16304,0: GOSUB 2950: IF M THEN 2900
 2841  GOSUB 2920: IF B$="W" AND M OR B$="A" AND NOT M THEN 2900
 2850  IF B$="W" THEN DW$(A) = AP$(A,L)
 2851  IF B$="A" THEN DV$(A) = AP$(A,L)
 2860  POKE -16304,0 : HOME : GOTO 100

 2870  TEXT:HOME: GOSUB 4310: PRINT "SELECT- ";:GET A$: IF A$=CHR$(27) THEN 2860
 2871  L = ASC(A$) - 65: IF L<0 OR L>15 THEN 2870
 2880  DX$(A) = AX$(A,L): GOTO 2860

 2900  HOME : VTAB 21: PRINT "INVALID ITEM! ";: GOSUB 30050: GOTO 2860
 2910  HOME : VTAB 21: PRINT "INVALID SPELL! ";: GOSUB 30050: GOTO 2860

 2920  A$ = LEFT$(AP$(A,L),3)
 2930  M = (A$="LEA" OR A$="CHA" OR A$="PLA")
 2940  RETURN

 2950  A$ = LEFT$(AP$(A,L),3)
 2951  M = (CL$(A)="WIZARD" OR CL$(A)="THIEF" OR CL$(A)="MONK") AND (A$="CHA" OR A$="PLA")
 2952  M = M OR (CL$(A)<>"CLERIC" AND (A$="ROD" OR A$="AMU" OR A$="LIG" OR A$="FIR"))
 2953  M = M OR (CL$(A)<>"WIZARD" AND (A$="WAN" OR A$="STA"))
 2954  RETURN

 4000  TEXT: HOME: M = 1: A = 0
 4010  ON M GOSUB 4100,4150,4210,4310
 4020  VTAB 23: PRINT "SPACE=NEXT ESC=QUIT ";: IF M>1 THEN PRINT "ARROWS=CHARACTER ";
 4030  GET A$: IF A$ = CHR$(27) THEN HOME: POKE -16304,0: GOTO 20
 4040  IF A$ = CHR$(8) THEN A = A - 1: IF A<0 THEN A = 0
 4050  IF A$ = CHR$(21) THEN A = A + 1: IF A>3 THEN A = 3
 4060  IF A$ = " " THEN M = M + 1: IF M>4 THEN M = 1
 4070  HOME: GOTO 4010
 4100  PRINT "PARTY: ";NA$: PRINT "REALM: ";RM$: PRINT "GOLD COINS: ";AD%: PRINT "FOOD SUPPLY: "; INT (AE)
 4110  PRINT: PRINT "ACHIEVEMENTS:": FOR I=8 TO 14: VTAB I: PRINT "<?>": NEXT
 4111  IF FG%(0)=16 THEN VTAB 8: PRINT "FONKRAKIS"
 4112  IF FG%(1)=16 THEN VTAB 9: PRINT "ABYSS"
 4113  IF FG%(2)=16 THEN VTAB 10: PRINT "WORNOTH"
 4114  IF FG%(3)>0 THEN VTAB 12: PRINT "ENLIGHTENED"
 4115  IF FG%(4)>0 THEN VTAB 11: PRINT "BLESSED"
 4116  IF FG%(5)>0 THEN VTAB 13: PRINT "ETHEREAL"
 4117  IF FG%(5)=32 THEN VTAB 14: PRINT "VANQUISHER"
 4120  RETURN
 4150  PRINT "NAME: ";NM$(A): PRINT "CLASS: ";CL$(A): PRINT "RACE: ";RA$(A): PRINT "HIT POINTS: ";AB%(A);"/";AC%(A)
 4160  PRINT "STRENGTH: ";AF%(A): PRINT "INTELLIGENCE: ";AG%(A): PRINT "WISDOM: ";AH%(A): PRINT "AGILITY: ";AI%(A): PRINT "STAMINA: ";AJ%(A): PRINT "CHARISMA: ";AK%(A)
 4170  PRINT "EXPERIENCE: ";ZA%(A): PRINT "LEVEL: "; INT (ZA%(A) / 1000) + 1;"/";WT%(A)
 4180  PRINT : PRINT "WEAPON READY: ";DW$(A): PRINT "ARMOUR READY: ";DV$(A): PRINT "SPELL READY: ";DX$(A)
 4190  RETURN
 4210  PRINT NM$(A);"'S ITEMS:": FOR I = 0 TO 7: PRINT I + 1;") ";: PRINT AP$(A,I): NEXT: RETURN
 4310  PRINT NM$(A);"'S SPELLS:": FOR I = 0 TO 15: PRINT CHR$(65+I);") ";: PRINT AX$(A,I): NEXT: RETURN

 5000  POKE 8190,X: POKE 8191,Y: CALL 7486: RETURN
 5001  POKE 8190,X: POKE 8191,Y: POKE 6,N: POKE 7,255: CALL 7504: RETURN

 5100  XK = 0: YK = 0
 5110  IF A$ =  CHR$ (11) OR A$ = "-" THEN YK = - 1
 5120  IF A$ =  CHR$ (8) OR A$ = "P" THEN XK = - 1
 5130  IF A$ =  CHR$ (21) OR A$ = "[" THEN XK = 1
 5140  IF A$ =  CHR$ (10) OR A$ = ";" THEN YK = 1
 5141  IF A$ = "0" THEN XK=-1: YK=-1
 5142  IF A$ = "=" THEN XK=1: YK=-1
 5143  IF A$ = "L" THEN XK=-1: YK=1
 5144  IF A$ = "'" THEN XK=1: YK=1
 5150  X = X + XK: Y = Y + YK
 5160  RETURN

 7050  HOME : VTAB 21: IF  PEEK (778) = 96 THEN 7080
 7060  POKE 778,96: POKE 792,96: PRINT "SOUND OFF"
 7061  FOR P = 0 TO 500 + EP: NEXT P: HOME : GOTO 20
 7080  POKE 778,164: POKE 792,164: PRINT "SOUND ON": GOTO 7061

 7100 N = 0
 7105  FOR M = 0 TO 7: IF DW$(A) = AP$(A,M) THEN N = 8
 7106  NEXT : IF N = 0 THEN DW$(A) = "HA"+"NDS"
 7109 N = 0
 7110  FOR M = 0 TO 7: IF DV$(A) = AP$(A,M) THEN N = 8
 7111  NEXT : IF N = 0 THEN DV$(A) = "SK"+"IN"
 7115  RETURN

 8000  GOSUB 5000
 8010  HOME : VTAB 21
 8020 B$ = "": M = PEEK(6)
 8030  IF  FL% = 16 THEN 8070
 8040  IF M=7 OR M=12 OR M=14 THEN 8100
 8050  IF M=9 OR M=13 THEN 8200
 8060  IF M=0 THEN 8300
 8070  HOME: VTAB 21: PRINT "NOT HERE. ";: GOSUB 30050: HOME : GOTO 100

 8100  PG$ = "TO"+"WN": R%=0
 8110  POKE 4096,0: POKE 103,1: POKE 104,16: GOTO 10

 8200  PG$ = "DUN"+"GEON": R% = 0
 8210  GOTO 8110

 8300  IF X = 3 THEN M = 0: XT = 30: YT = 59: B$ = "FON" + "KRAKIS"
 8301  IF X = 71 THEN M = 1: XT = 37: YT = 66: B$ = "AB" + "YSS"
 8302  IF X = 10 THEN M = 2: XT = 34: YT = 74: B$ = "WOR" + "NOTH"
 8303  IF RM$<>"ARRINEA" THEN B$ = "ARR" + "INEA"
 8304  IF RM$="FONKRAKIS" THEN XT = 3: YT = 56: GOTO 8350
 8305  IF RM$="ABYSS" THEN XT = 71: YT = 38: GOTO 8350
 8306  IF RM$="WORNOTH" THEN XT = 10: YT = 14: GOTO 8350
 8310  IF FG%(M)=0 THEN 8400
 8320  IF FG%(M)=8 THEN 8500
 8350  A$ = "RIDING THE RAYS : " + B$
 8352  HOME: VTAB 21: PRINT TAB(20-LEN(A$)/2);A$: FOR P = 0 TO EP: NEXT P: IF MD%=0 THEN 8360
 8354  GOSUB 9000: PRINT CHR$(4);"BSAVE PARTIES/";LEFT$(RM$,2);".";NA$;",A$6E00,L3200": MD% = 0
 8360  RM$ = LEFT$(B$+" ",LEN(B$))
 8370  GOSUB 9000: PRINT CHR$(4);"BLOAD PARTIES/";LEFT$(RM$,2);".";NA$;",A$6E00"
 8380  GOSUB 300: X = XT: Y = YT: HOME: GOTO 100

 8400  HOME: VTAB 21: PRINT "ONE OF THE ANCIENT PYRAMID GATES!"
 8410  GOSUB 8600
 8420  IF N = 0 THEN PRINT "YOU DON'T HAVE THE RIGHT KEY.";: GOSUB 30050: HOME: GOTO 100
 8430  PRINT "YOU USE THE ";A$;"...";: GET A$: FG%(M)=8

 8500  HOME : VTAB 21: PRINT "YOU ARE INSIDE!": PRINT "AN INSCRIPTION READS: ";B$: GET A$
 8510  GOSUB 8650: HOME: VTAB 21
 8520  IF N = 0 THEN PRINT "YOU DON'T HAVE THE RIGHT PRISM.";: GOSUB 30050: HOME: GOTO 100
 8530  PRINT "YOU USE THE ";A$;"...";: GET A$: FG%(M)=16: GOTO 8350

 8600  N = 0: FOR A = 0 TO 3: FOR L = 0 TO 7
 8605  A$ = AP$(A,L)
 8610  IF A$ = "PLATINUM KEY" AND B$ = "FONKRAKIS" THEN N = 1: RETURN
 8611  IF A$ = "GOLD KEY" AND B$ = "ABYSS" THEN N = 1: RETURN
 8612  IF A$ = "SILVER KEY" AND B$ = "WORNOTH" THEN N = 1: RETURN
 8630  NEXT L: NEXT A: RETURN

 8650  N = 0: FOR A = 0 TO 3: FOR L = 0 TO 7
 8655  A$ = AP$(A,L)
 8660  IF A$ = "GREEN PRISM" AND B$ = "FONKRAKIS" THEN N = 1: RETURN
 8661  IF A$ = "RED PRISM" AND B$ = "ABYSS" THEN N = 1: RETURN
 8662  IF A$ = "CLEAR PRISM" AND B$ = "WORNOTH" THEN N = 1: RETURN
 8670  NEXT L: NEXT A: RETURN

 9000  REM VERIFY DISK
 9110  ONERR  GOTO 9200
 9120  PRINT: PRINT  CHR$(4);"VERIFY START.REALM": POKE 216,0: RETURN
 9200  HOME : VTAB 21: PRINT "PLEASE RESTORE DISK- ";: GET A$: CALL 768: PRINT : RESUME

 10000  HOME: VTAB 21: PRINT "SAVE GAME ? (Y/N) ";: GET A$: IF A$<>"Y" AND A$<>"N" THEN 10000
 10010  IF A$ = "Y" THEN 10020
 10011  HOME: VTAB 21: PRINT "EXIT TO MENU ? (Y/N) ";: GET A$: IF A$<>"Y" AND A$<>"N" THEN 10011
 10012  IF A$ = "N" THEN HOME: GOTO 100
 10013  PRINT: POKE 2048,0: POKE 103,1: POKE 104,8: PRINT CHR$(4);"RUN PROG/LAUNCH"
 10020  GOSUB 9000
 10030  PRINT CHR$(4);"BLOAD PROG/SAVE.GAME"
 10040  POKE 2048,0: POKE 103,1: POKE 104,8: GOTO 0

 30000  POKE 6,64: POKE 7,2: POKE 8,100: POKE 9,1: POKE 30,2: CALL 806: RETURN
 30050  POKE 6,50: POKE 7,25: POKE 8,1: POKE 9,1: POKE 30,1: CALL 852: GET A$: RETURN
 30070  POKE 6,64: POKE 7,2: POKE 8,5: POKE 9,1: POKE 30,2: CALL 806: RETURN

 50000  HOME : VTAB 21: PRINT "YOUR PARTY IS ELIMINATED! "
 50001  GOTO 50001