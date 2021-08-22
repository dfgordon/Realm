0  FO% = FL%: FL% = 0
1 WY% = 1: WX% = (ZA%(0) + ZA%(1) + ZA%(2) + ZA%(3)) / 4000
2 XT = 0: YT = 9
3 T$ =  B$: A1% = 0: A2% = 0: A3% = 0
5  POKE 8185,2: POKE 8174,0: POKE 8175,0
6  POKE 8176,160: POKE 8177,20: POKE 8181,2: POKE 8182,4+12*16
10  HGR: HOME: GOTO 100

20  GOSUB 150: VTAB 20: GET A$: PRINT: AE = AE - .25: IF AE < 0 THEN 50000
30  IF AE < 100 AND FS% = 0 THEN FS% = -1
40  GOSUB 5100
71  IF XT < 0 OR XT > 19 OR YT < 0 OR YT > 159 THEN 120
73  IF A$ = "Z" THEN 4000
75  IF A$ = "S" THEN 600
76  IF A$ = "C" THEN 700
78  IF A$ = "R" THEN 2800
80  IF A$ = "K" THEN 9000
81  IF A$ = "I" THEN 2000
83  IF A$ = "U" THEN 1000
84  IF A$ = "F" THEN HOME: FS% = -ABS(FS%) - 1: IF FS%<-3 THEN FS% = 0
85  IF A$ = "G" THEN 1200
95  IF A$ = CHR$(16) THEN A = RND(1): HOME: VTAB 21: PRINT "DISCARDING ONE FATE CARD";: GET A$: HOME
99  IF A$ = CHR$(19) THEN 7050
100  POKE 8186,1: IF WY%<=WX% THEN POKE 8186,255
101  POKE 8187,0: POKE 8190,XT: POKE 8191,YT: CALL 7545: IF PEEK(6) = 255 THEN 120
102  GOSUB 5000: M = PEEK(6)
104  IF M = 13 THEN 200: REM SPECIAL
106  IF M = 12 THEN 12000: REM TRAP
108  IF M = 9 THEN 13000: REM LAVA
110  IF M = 14 THEN 10100: REM PRIEST
112  IF M = 11 THEN 14990: REM MORDOCK
114  IF M = 15 THEN 290: REM MONSTER
116  GOTO 20
120  XT = XT - XK: YT = YT - YK: GOSUB 30070: GOTO 20

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

200  WT% = 13: N = 3: GOSUB 5001: GM =  INT (3 *  RND (1)) + 4
210  POKE 8190,XT: POKE 8191,YT: CALL 7783: BY = PEEK(254) + PEEK(255)*256: TV$ = ""
220  A$ =  CHR$ ( PEEK (BY)): TV$ = TV$ + A$: BY = BY + 1
230  IF A$ = "." THEN GOTO 291
240  GOTO 220

290  WT% = 15: N = 7: GOSUB 5001: GM =  INT (6 *  RND (1)) + 1
291  HOME: I =  INT (4 *  RND (1)) + ((WY% - 1) * 3)
300  D = 2: GOSUB 9110: PRINT CHR$(4);"OPEN MONSTERS"
301  PRINT CHR$(4);"POSITION MONSTERS,R";I * 10
302  PRINT CHR$(4);"READ MONSTERS"
303  INPUT GA: INPUT GB: INPUT GC$: INPUT GD$: INPUT GE: INPUT GF: INPUT GH: INPUT GI$: INPUT GK$: INPUT GO$
304  PRINT CHR$(4);"CLOSE MONSTERS"
310  IF GM = 1 THEN A$ = GO$
311  IF GM > 1 AND LEN(GK$)<3 THEN A$ = GO$ + GK$
312  IF GM > 1 AND LEN(GK$)>2 THEN A$ = GK$
313  HOME : VTAB 21: PRINT "YOU HAVE ENCOUNTERED ";GM: PRINT A$: GOSUB 30200
350  PRINT CHR$(4);"BLOAD FRAMEM,A$8C80"
352  POKE 6,128: POKE 7,140: CALL 5548
354  FOR M = 1 TO GM:K =  INT (3 *  RND (1)) + 9:GN(M) = GA * K: NEXT
355  A$ = "": FOR I = 1 TO LEN(GO$): B$ = MID$(GO$,I,1)
356  IF B$ = " " THEN A$ = A$ + "."
357  IF B$ <> " " THEN A$ = A$ + B$
358  NEXT
360  PRINT CHR$(4);"BLOAD ";A$;",A$8C80"
361  POKE 6,128: POKE 7,140: CALL 5551
370  PG$ = "COM" + "BAT": DG% = 1
372  POKE 4096,0: POKE 103,1: POKE 104,16: GOTO 10

600  HOME : VTAB 21 : PRINT "USE THE SURFACING STONE? ": GET A$: PRINT
620  IF A$="Y" THEN 8000
630  GOTO 100

700  HOME : VTAB 21: PRINT "WHO WILL CAST (#) ";: GET A$:A =  VAL (A$) - 1
701  IF A < 0 OR A > 3 THEN 700
703  IF AB%(A) = 0 THEN 700
704  IF DX$(A) = "" THEN 730
705 B$ = DX$(A)
720  IF B$ = "RAISE DEAD" THEN 750
721  IF B$ = "HEAL 1" THEN 760
722  IF B$ = "HEAL 2" THEN 765
723  IF B$ = "HEAL 3" THEN 770
724  IF B$ = "KNOCK" THEN 790
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

790  N = 8
810  GOSUB 850
811  IF PEEK(6)=N THEN 815
812  HOME: VTAB 21: PRINT "WRONG TARGET.";: GOSUB 30050: HOME: GOTO 100
815  GOSUB 2300
816  HOME: VTAB 21: PRINT "-CASTING ";B$;"-": GOSUB 30000
830  N = 7: XT=XT+XK: YT=YT+YK: GOSUB 5001: GOSUB 880: HOME: GOTO 100

850  HOME : VTAB 21: PRINT "WHICH DIRECTION: ";: GET A$: PRINT
860  GOSUB 5100: IF XT<0 OR XT>19 OR YT<0 OR YT>159 THEN GOSUB 880: POKE 6,255: RETURN
870  GOSUB 5000
880  XT = XT - XK: YT = YT - YK
890  RETURN

1000  HOME : VTAB 21: PRINT "WHO WILL USE (#) ";: GET A$
1001 A =  VAL (A$) - 1: IF A < 0 OR A > 3 THEN 1000
1004  IF AB%(A) = 0 THEN 1000
1005 B$ = DW$(A)
1010  IF B$ = "POTION OF PASSAGE" THEN 1050
1011  IF B$ = "POTION OF INFURIATION" THEN M = -1: GOTO 1060
1012  IF B$ = "POTION OF INTIMIDATION" THEN M = 1: GOTO 1060
1013  IF B$ = "POTION OF VISION" THEN 1070
1015  IF B$ = "ROD OF RESURRECTION" THEN 750
1016  IF B$ = "POTION OF HEALING" THEN 760
1020  IF B$ = "AMULET OF HEALING" THEN 770
1021  IF B$ = "ORB OF STARS" AND RIGHT$(T$,4) = "MINE" THEN 1100
1023  GOTO 2900

1050  GOSUB 850: IF PEEK(6) <> 8 THEN 812
1051  GOSUB 2200: GOSUB 1099: GOTO 830

1060  GOSUB 2200: GOSUB 1099: WX% = WX% + M: IF WX%<0 THEN WX% = 0
1061  PRINT "MONSTERS PURSUE STARTING ON LEVEL ";WX%+1;". ";:GET A$: HOME: GOTO 100

1070  IF PEEK(8181) = 4 THEN HOME: VTAB 21: PRINT "REACHED LIMIT.": GOSUB 30050: HOME: GOTO 100
1071  GOSUB 2200: GOSUB 1099: I = PEEK(8181)+1: POKE 8181,I: POKE 8182,262-33*I: HOME: GOTO 100

1099  HOME: VTAB 21: PRINT "-USING ";B$;"-": GOSUB 30000: RETURN

1100  IF XT = 4 AND YT = 152 THEN W$ = "FIRE": GOSUB 1199: A1%=1: HOME: GOTO 100
1110  IF XT = 9 AND YT = 147 THEN W$ = "EARTH": GOSUB 1199: A2%=1: HOME: GOTO 100
1120  IF XT = 14 AND YT = 152 THEN W$ = "WATER": GOSUB 1199: A3%=1: HOME: GOTO 100
1130  IF XT = 9 AND YT = 157 AND A1%=1 AND A2%=1 AND A3%=1 THEN 1150
1140  HOME: VTAB 21: PRINT "NOTHING HAPPENED.";: GOSUB 30050: HOME: GOTO 100
1150  HOME: VTAB 21: PRINT "-INSCRIBING RUNES-": GOSUB 30000: GOSUB 30090
1160  IF FG%(5)<16 THEN FG%(5) = 16
1170  PRINT "YOU CAN NOW MOVE IN THE ETHER!";:GET A$: HOME: GOTO 100
1199  HOME: VTAB 21: PRINT "-SUMMONING ";W$;" SPIRIT-": GOSUB 30000: RETURN

1200  HOME: VTAB 21: GOSUB 5000: IF PEEK(6)<>10 THEN PRINT "NOT HERE.";: GOSUB 30050: HOME: GOTO 100
1202 M =  INT ( RND (1) * 50) + 100
1203  IF RND(1) > 0.5 THEN 1210
1205 P =  (1 + WY%) * M / 2
1206  PRINT "GOLD +";INT(P);:AD% = AD% + P
1207  IF AD% > 9999 THEN AD% = 9999
1208  GOTO 1220
1210  PRINT "FOOD +";M;:AE = AE + M
1211  IF AE > 9999 THEN AE = 9999
1220  N = 7: GOSUB 5001: GET A$: HOME: GOTO 100

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

2200  P = ZA%(A) / 1000 + AH%(A): IF P/(10+P) >  RND (1) THEN RETURN
2202  AP$(A,DR%(A,0)) = ""
2204  P = 8: FOR I = 7 TO 0 STEP -1: P = P*(AP$(A,I)<>DW$(A)) + I*(AP$(A,I)=DW$(A)): NEXT: DR%(A,0) = P: IF P<8 THEN RETURN
2206  INVERSE : HOME: VTAB 21: PRINT DW$(A);" IS EXPENDED ": NORMAL: DW$(A) = AP$(A,P): GOSUB 30100: RETURN

2300  P = ZA%(A) / 1000 + AH%(A): IF P/(10+P) >  RND (1) THEN RETURN
2302  AX$(A,DR%(A,2)) = ""
2304  P = 16: FOR I = 15 TO 0 STEP -1: P = P*(AX$(A,I)<>DX$(A)) + I*(AX$(A,I)=DX$(A)): NEXT: DR%(A,2) = P: IF P<16 THEN RETURN
2306  INVERSE : HOME: VTAB 21: PRINT DX$(A);" IS EXHAUSTED ": NORMAL: DX$(A) = AX$(A,P): GOSUB 30100: RETURN

2800  HOME : VTAB 21: PRINT "READY WHO (#) ";: GET A$: A =  VAL (A$) - 1: IF A<0 OR A>3 THEN 2800
2801  IF AB%(A)=0 THEN 2800
2802  C = 0: HOME: VTAB 21: PRINT NM$(A);" (ARROWS,A,Z,ENTER)- "
2803  PRINT "ITEM:  ";CHR$(DR%(A,0)+65);") ";DW$(A)
2804  PRINT "ARMOR: ";CHR$(DR%(A,1)+65);") ";DV$(A)
2805  PRINT "SPELL: ";CHR$(DR%(A,2)+65);") ";DX$(A);
2806  L = DR%(A,C): P = 9: IF C = 2 THEN P = 16

2810  HTAB 8: VTAB C+22: IF C<2 THEN B$ = AP$(A,L)
2811  IF C = 2 THEN B$ = AX$(A,L)
2814  PRINT CHR$(L+65);") ";: INVERSE: PRINT B$;: NORMAL: CALL -868
2820  HTAB 1: VTAB 20: GET A$
2821  IF A$ = CHR$(13) THEN DW$(A)=AP$(A,DR%(A,0)): DV$(A)=AP$(A,DR%(A,1)): DX$(A)=AX$(A,DR%(A,2)): HOME: GOTO 100
2822  IF A$ = CHR$(11) OR A$ = "A" THEN N = -1: GOTO 2850
2823  IF A$ = CHR$(10) OR A$ = "Z" THEN N = 1: GOTO 2850
2825  N = 0: IF A$ = CHR$(8) THEN N = -1
2826  IF A$ = CHR$(21) THEN N = 1
2827  IF N = 0 THEN 2820
2828  GOSUB 2860: DR%(A,C) = L: GOTO 2810

2850  HTAB 11: VTAB C+22: PRINT B$;: C = C + N: IF C<0 THEN C = 2
2851  IF C>2 THEN C = 0
2852  GOTO 2806

2860  L = L + N
2861  IF L<0 THEN L = P
2862  IF L>P THEN L = 0
2866  IF C <> 2 THEN I = LEN(AP$(A,L))
2867  IF C = 2 THEN I = LEN(AX$(A,L))
2868  IF I = 0 THEN 2860
2869  IF C = 2 THEN RETURN
2870  A$ = LEFT$(AP$(A,L),3)
2871  M = (C=0 AND (A$="SKI" OR A$="LEA" OR A$="CHA" OR A$="PLA"))
2872  M = M OR (C=1 AND A$<>"SKI" AND A$<>"LEA" AND A$<>"CHA" AND A$<>"PLA")
2873  M = M OR (CL$(A)="WIZARD" OR CL$(A)="THIEF" OR CL$(A)="MONK") AND (A$="CHA" OR A$="PLA")
2874  M = M OR (CL$(A)<>"CLERIC" AND (A$="ROD" OR A$="AMU" OR A$="LIG" OR A$="FIR"))
2875  M = M OR (CL$(A)<>"WIZARD" AND (A$="WAN" OR A$="STA"))
2876  IF M THEN 2860
2877  RETURN

2900  HOME : VTAB 21: PRINT "INVALID ITEM! ";: GOSUB 30050: HOME: GOTO 100
2910  HOME : VTAB 21: PRINT "INVALID SPELL! ";: GOSUB 30050: HOME: GOTO 100

4000  TEXT: HOME: M = 1: A = 0
4010  ON M GOSUB 4100,4150,4210,4310
4020  VTAB 23: PRINT "SPACE=NEXT ESC=QUIT ";: IF M>1 THEN PRINT "ARROWS=CHARACTER ";
4030  GET A$: IF A$ = CHR$(27) THEN HOME: POKE -16304,0: GOTO 20
4040  IF A$ = CHR$(8) THEN A = A - 1: IF A<0 THEN A = 0
4050  IF A$ = CHR$(21) THEN A = A + 1: IF A>3 THEN A = 3
4060  IF A$ = " " THEN M = M + 1: IF M>4 THEN M = 1
4070  HOME: GOTO 4010
4100  PRINT "PARTY: ";NA$: PRINT T$;", L";WY%;", ";RM$: PRINT "GOLD COINS: ";AD%: PRINT "FOOD SUPPLY: "; INT (AE)
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

5000  POKE 8190,XT: POKE 8191,YT: CALL 7486: RETURN
5001  POKE 8190,XT: POKE 8191,YT: POKE 6,N: POKE 7,255: CALL 7504: RETURN

5100  XK = 0: YK = 0
5110  IF A$ =  CHR$ (11) OR A$ = "-" THEN YK = - 1
5120  IF A$ =  CHR$ (8) OR A$ = "P" THEN XK = - 1
5130  IF A$ =  CHR$ (21) OR A$ = "[" THEN XK = 1
5140  IF A$ =  CHR$ (10) OR A$ = ";" THEN YK = 1
5141  IF A$ = "0" THEN XK=-1: YK=-1
5142  IF A$ = "=" THEN XK=1: YK=-1
5143  IF A$ = "L" THEN XK=-1: YK=1
5144  IF A$ = "'" THEN XK=1: YK=1
5150  XT = XT + XK: YT = YT + YK
5160  RETURN

7050  HOME : VTAB 21: IF  PEEK (778) = 96 THEN 7080
7060  POKE 778,96: POKE 792,96: PRINT "SOUND OFF"
7061  FOR P = 0 TO 500 + EP: NEXT P: HOME : GOTO 20
7080  POKE 778,164: POKE 792,164: PRINT "SOUND ON": GOTO 7061

7100 M = 8: N = 9: FOR I = 7 TO 0 STEP -1: M = M*(DW$(A) <> AP$(A,I)) + I*(DW$(A) = AP$(A,I)): N = N*(DV$(A) <> AP$(A,I)) + I*(DV$(A) = AP$(A,I)): NEXT
7110 DW$(A) = AP$(A,M): DR%(A,0) = M: DV$(A) = AP$(A,N): DR%(A,1) = N: RETURN

8000 HOME : VTAB 21: IF FO%=32 THEN FL%=32
8010  PG$ = "OUT" + "SIDE" : R%=1
8020  POKE 4096,0: POKE 103,1: POKE 104,16: GOTO 10

9000  GOSUB 5000: M = PEEK(6)
9005  IF  M = 0 THEN DY = -1
9006  IF  M = 1 THEN DY = 1
9007  IF  M > 1 THEN HOME: VTAB 21: PRINT "NO LADDER! ";: GOSUB 30050: HOME : GOTO 100
9010  WY% = WY% + DY: YT = YT + 20*DY: IF WY% = 0 THEN 8000
9020  HOME : VTAB 21: PRINT  TAB( 14);"-LEVEL ";WY%;"-": GOSUB 30100: HOME : GOTO 100

9110  ONERR  GOTO 9200
9120  PRINT: PRINT  CHR$(4);"VERIFY DISK";D;",S";WS%(D);",D";WD%(D);",V";WV%(D): POKE 216,0: RETURN
9200  HOME : VTAB 21: PRINT "INSERT ";DL$(D);" DISK IN S";WS%(D);"D";WD%(D);"- ";: GET A$: CALL 768: PRINT : RESUME

10100  HOME : VTAB 21: PRINT "THE HIGH PRIEST!": GOSUB 30200
10110  D = 2: GOSUB 9110: PRINT  CHR$(4);"BLOAD HIGH.PRIEST"
10120  POKE 4096,0: POKE 103,1: POKE 104,16: GOTO 10

12000  HOME : VTAB 21: PRINT "TRAP!"
12001  P = 100: M = 20
12005  FOR I = 0 TO 3: IF RA$(I) = "DWARF" THEN P = P * 0.4: NEXT I
12010  I = 99 * RND(1): IF I<P THEN 13020
12060  PRINT "SAVED BY DWARF! ";: GET A$: HOME: GOTO 20

13000  M = 40: FOR I = 0 TO 3: IF DX$(I) = "PROTECTION 1" THEN M = 0
13010  NEXT
13020  FOR I = 0 TO 3: AB%(I) = AB%(I) - M: IF AB%(I) < 1 THEN AB%(I) = 0
13030  NEXT
13040  IF M > 0 THEN GOSUB 30080: GOSUB 40000: HOME: FS% = -ABS(FS%): IF FS% > -2 THEN FS% = -2
13049  GOTO 20

14990  HOME : VTAB 21: PRINT "YOU FACE MORDOCK!": GOSUB 30200
14992  D = 2: GOSUB 9110: PRINT CHR$(4);"BLOAD FRAMEM,A$8C80"
14993  POKE 6,128: POKE 7,140: CALL 5548
14994  PRINT CHR$(4);"BLOAD MORDOCK,A$8C80"
14995  POKE 6,128: POKE 7,140: CALL 5551
14998  PRINT CHR$(4);"BLOAD FINAL"
14999  POKE 2048,0: POKE 103,1: POKE 104,8: GOTO 5

25000  D = 2: GOSUB 9110: PRINT CHR$(4);"BLOAD CHAIN": GOTO 100

30000  POKE 6,64: POKE 7,2: POKE 8,100: POKE 9,1: POKE 30,2: CALL 806: RETURN
30050  POKE 6,50: POKE 7,25: POKE 8,1: POKE 9,1: POKE 30,1: CALL 852: GET A$: RETURN
30070  POKE 6,64: POKE 7,2: POKE 8,5: POKE 9,1: POKE 30,2: CALL 806: RETURN
30080  POKE 6,50: POKE 7,45: POKE 8,10: POKE 9,5: POKE 30,1: CALL 806: RETURN
30090  POKE 7,0: POKE 8,1: POKE 30,1: FOR I = 1 TO 42: POKE 6,(I/8)*10: POKE 9,1: CALL 852: NEXT

30100  FOR P = 0 TO 500+EP: NEXT P: RETURN
30200  FOR P = 0 TO EP: NEXT P: RETURN

40000 M = 0: FOR I = 0 TO 3:M = M + AB%(I): NEXT
40001  IF M > 0 THEN  RETURN
50000  HOME : VTAB 21: PRINT "YOUR PARTY IS ELIMINATED!"
50001  GOTO 50001
