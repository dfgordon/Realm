 0 FO% = FL%: FL% = 0: XT = 2: YT = 20
 7 WY% = 0:WX% = 0
 8 T$ = B$
 10  PRINT CHR$(4);"BLOAD MRC3": HOME : GOTO 100

 20  GOSUB 13050: VTAB 20: GET A$: PRINT: AE = AE - .25: IF AE < 0 THEN 50000
 30  IF AE < 100 AND FS% = 0 THEN FS% = -1
 40  GOSUB 5100
 71  IF XT < 2 OR XT > 37 OR YT < 2 OR YT > 37 THEN 8000
 73  IF A$ = "Z" THEN 4000
 74  IF A$ = "B" THEN 500
 75  IF A$ = "X" THEN 600
 76  IF A$ = "C" THEN 700
 78  IF A$ = "R" THEN 2800
 81  IF A$ = "T" THEN 7400
 82  IF A$ = "U" THEN 1000
 83  IF A$ = "S" THEN 1100
 84  IF A$ = "F" THEN HOME: FS% = -ABS(FS%) - 1: IF FS%<-3 THEN FS% = 0
 85  IF A$ = "I" THEN 2000
 86  IF A$ = "A" THEN 200
 95  IF A$ = CHR$(16) THEN A = RND(1): HOME: VTAB 21: PRINT "DISCARDING ONE FATE CARD";: GET A$: HOME
 99  IF A$ = CHR$(19) THEN 7050
 100  GOSUB 5010
 102  IF  PEEK (8186) = 16 THEN 114
 104  IF  PEEK (768) = 12 THEN 13000
 106  IF WX% = 0 THEN 20
 108  A =  PEEK (769)
 110  IF A = 0 OR A = 7 OR A = 8 THEN 250
 112  GOTO 20
 114  XT = XT - XK : YT = YT - YK
 116  POKE 768,169: POKE 769,30: POKE 813,5: CALL 768: GOTO 20

 200  IF  FL% = 16 THEN 7599
 210  HOME: VTAB 21: PRINT "ATTACK DIRECTION: ";: GET A$
 220  GOSUB 5100: GOSUB 5000: A = PEEK(768)
 230  IF  A > 13 THEN XT = XT - XK: YT = YT - YK: GOTO 7599
 240  HOME: POKE 6439,11: WX% = 1: GOSUB 5010
 250  GOSUB 370: GC$ = "": GD$ = "": GI$ = "": A = A + 1
 260  ON A GOTO 300,310,310,310,310,320,330,340,350,310,310,310,310,350

 300 GA = 9:GB = 24:GE = 85: GM = 4: GOTO 360
 310 GA = 2:GB = 10:GE = 70: GM = 1: GOTO 360
 320 GA = 6:GB = 20:GE = 80: GM = 4: GOTO 360
 330 GA = 9:GB = 20:GE = 90: GM = 4: GOSUB 380: GOTO 360
 340 GA = 10:GB = 30:GE = 90: GM = 8: GOTO 360
 350 GA = 15:GB = 30:GE = 90: GM = 4: GC$ = "FIRE " + "BREATH": GD$ =  LEFT$ (GC$,1): GOTO 360

 360  FOR I = 1 TO GM: GN(I) =  GA*(INT (3 *  RND (1)) + 9): NEXT I
 361  HOME : PG$ = "COM" + "BAT": WT% = A - 1: DG% = 0
 362  PRINT: ONERR GOTO 9250
 363  PRINT CHR$(4);"BLOAD CHAIN"
 364  POKE 216,0: POKE 4096,0: POKE 103,1: POKE 104,16: GOTO 10

 370  IF A = 0 THEN GO$ = "GUA"+"RD": RETURN
 371  IF A = 1 OR A = 9 THEN GO$ = "HUM"+"AN": RETURN
 372  IF A = 2 OR A = 10 THEN GO$ = "EL"+"F": RETURN
 373  IF A = 3 OR A = 11 THEN GO$ = "DWA"+"RF": RETURN
 374  IF A = 4 OR A = 12 THEN GO$ = "HOB"+"BIT": RETURN
 375  IF A = 5 THEN GO$ = "ADV"+"ENTURER": RETURN
 376  IF A = 6 THEN GO$ = "WIZ"+"ARD": RETURN
 377  IF A = 7 THEN GO$ = "MAR"+"INE": RETURN
 378  IF A = 8 OR A = 13 THEN GO$ = "DRA"+"GON": RETURN

 380  M =  INT (3 *  RND (1))
 381  IF M = 0 THEN GF = 20:GH = 4:GI$ = "MAGIC " + "MISSILE": RETURN
 382  IF M = 1 THEN GF = 40:GH = 1:GI$ = "FIRE" + "BALL": RETURN
 383  GF =  - 4:GH = 1:GI$ = "PARA" + "LYZE": RETURN

 500  GOSUB 5001: IF  PEEK (768) <> 11 THEN 8070
 510  GOSUB 5000: IF  PEEK (768) = 7 AND WY% = 0 THEN HOME: VTAB 21: PRINT "BLOCKED BY MARINE. ";: GOSUB 30050: HOME : GOTO 100
 520  N = 15: GOSUB 5200: N = 4: GOSUB 5201: FL% = 16: GOTO 100

 600  GOSUB 5001
 610  IF  FL% <> 16 OR PEEK(768) <> 4 THEN 8070
 620  FL% = 0: N = 11: GOSUB 5201: GOTO 100

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
 725  IF B$ = "PASSWALL" THEN 800
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
 783  IF LEFT$(B$,2) = "AM" THEN GOSUB 2200
 784  IF LEFT$(B$,2) = "HE" THEN GOSUB 2300
 785  HOME : VTAB 21: PRINT "-CASTING HEAL-": GOSUB 30000
 786 C =  INT (CA *  RND (1)) + CA
 787 AB%(B) = AB%(B) + C: IF AB%(B) > AC%(B) THEN AB%(B) = AC%(B)
 788  PRINT C;" POINTS HEALED. ";: GET A$: HOME : GOTO 100

 790 SB = 85: N = 10: GOTO 810
 800 SB = 95: N = 5
 810  GOSUB 850
 811  IF PEEK(768)=N THEN 815
 812  HOME: VTAB 21: PRINT "WRONG TARGET.";: GOSUB 30050: HOME: GOTO 100
 815  GOSUB 2300
 816  HOME: VTAB 21: PRINT "-CASTING ";B$;"-": GOSUB 30000
 820  L =  INT (99 *  RND (1)) + 1:  IF SB > L THEN 830
 825  HOME: VTAB 21: PRINT "FAILED! ";: GOSUB 30050: HOME : GOTO 100
 830  N = 13: XT=XT+XK: YT=YT+YK: GOSUB 5201: GOSUB 880: HOME: GOTO 100

 850  HOME : VTAB 21: PRINT "WHICH DIRECTION: ";: GET A$: PRINT
 860  GOSUB 5100
 870  GOSUB 5001
 880  XT = XT - XK: YT = YT - YK
 890  RETURN

 1000  HOME : VTAB 21: PRINT "WHO WILL USE (#) ";: GET A$
 1001 A =  VAL (A$) - 1: IF A < 0 OR A > 3 THEN 1000
 1004  IF AB%(A) = 0 THEN 1000
 1005 B$ = DW$(A)
 1010  IF B$ = "POTION OF PASSAGE" THEN 1050
 1015  IF B$ = "ROD OF RESURRECTION" THEN 750
 1020  IF B$ = "AMULET OF HEALING" THEN 770
 1021  IF  LEFT$ (B$,3) = "GEM" THEN 1030
 1023  GOTO 2900

 1030  IF XT = 31 AND YT = 19 AND LEFT$(T$,2) = "IN" THEN 1035
 1031  GOTO 8070
 1035  HOME : VTAB 21: PRINT "-ENLIGHTENING-": GOSUB 30000: POKE 769,100: CALL 768
 1036  IF AG%(A) > 49 THEN 1040
 1037  PRINT NM$(A);" COULD NOT": PRINT "COMPREHEND AND IS DEAD! ";:AB%(A) = 0: GET A$: HOME : GOTO 100
 1040  FG%(3)=16: PRINT NA$;" ARE ENLIGHTENED! ";: GET A$: HOME : GOTO 100

 1050  GOSUB 850
 1055  IF PEEK(768)=5 OR PEEK(768)=10 THEN 1060
 1056  GOTO 812
 1060  GOSUB 2200
 1065  HOME: VTAB 21: PRINT "-USING POTION OF PASSAGE-": GOSUB 30000
 1070  GOTO 830

 1100  HOME: VTAB 21: GOSUB 5001: M = PEEK(768): IF M <>0 AND M <> 9 AND M <> 14 THEN PRINT "NOTHING TO STEAL. ";: GOSUB 30050: HOME: GOTO 100
 1101  HOME: VTAB 21: PRINT "CHARACTER TO ATTEMPT THEFT (#) ";: GET A$: A =  VAL (A$) - 1: IF A<0 OR A>3 THEN 1101
 1102  IF AB%(A) = 0 THEN 1101
 1106 I = 0: IF RA$(A) = "HOBBIT" THEN I = I + 15
 1107 I = I + AI%(A) + AG%(A) / 3
 1108  IF CL$(A) = "THIEF" THEN I = I + 50
 1109  IF CL$(A) = "MONK" THEN I = I + 30
 1110  IF I > 95 THEN I = 95
 1115  IF I < 99 * RND(1) OR WX% = 1 THEN HOME: VTAB 21: PRINT "UNSUCCESSFUL! ";: GOSUB 30050: WX% = 1: POKE 6439,11: HOME: GOTO 100
 1120  HOME: VTAB 21: PRINT "SUCCESSFUL!!": FOR I = 1 TO 7: POKE 768,169: POKE 769,20: POKE 813,30: CALL 768: NEXT
 1130  IF  M = 9 THEN GOSUB 1400: GOTO 1300
 1140  IF  M = 14 THEN GOSUB 1450: GOTO 1300

 1200  PRINT "FOOD +50 ";:AE = AE + 50: GET A$
 1210  IF AE > 9999 THEN AE = 9999
 1220  HOME : GOTO 100

 1300  C = VAL(B$): IF C > 3 THEN 1330
 1310  PRINT "YOU GOT: ";B$;" ";: GET A$
 1320  C = 0: GOSUB 3720: GOTO 2040
 1330  PRINT "YOU GOT ";C;" GOLD ";: AD% = AD% + C: IF AD%>9999 THEN AD%=9999
 1340  GET A$: HOME: GOTO 100

 1400  I =  INT (99 *  RND (1)) + 1
 1402  IF I<4 THEN B$ = "2H SWORD"
 1403  IF I>3 AND I<10 THEN B$ = "BROADSWORD"
 1404  IF I>9 AND I<19 THEN B$ = "LONGSWORD"
 1405  IF I>18 AND I<90 THEN B$ = "50"
 1406  IF I>89 THEN B$ = "100"
 1410  RETURN

 1450  I =  INT (99 *  RND (1)) + 1
 1451  B$ = "50"
 1452  IF I<6 THEN B$ = "PLATE"
 1453  IF I>5 AND I<20 THEN B$ = "100"
 1460  RETURN

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
 2220  FOR P = 0 TO 500+EP: NEXT P: RETURN

 2300 P = ZA%(A) / 1000 + AH%(A): IF P/(10+P) >  RND (1) THEN RETURN
 2302 I = 0
 2304  IF AX$(A,I) = DX$(A) THEN 2308
 2306 I = I + 1: GOTO 2304
 2308 AX$(A,I) = ""
 2310 I = I + 1: IF I > 15 THEN 2316
 2312  IF AX$(A,I) = DX$(A) THEN  RETURN
 2314  GOTO 2310
 2316  INVERSE : HOME: VTAB 21:  PRINT DX$(A);" IS EXHAUSTED ": NORMAL :DX$(A) = ""
 2320  FOR P = 0 TO 500+EP: NEXT P: RETURN

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

 3720  TEXT: HOME: PRINT "PLACING: ";B$: GOSUB 4210
 3730  PRINT: PRINT "USE ARROWS TO CHANGE CHARACTER": PRINT "1-8 REPLACES, ESC ABORTS ": GET A$
 3740  IF A$ = CHR$(27) THEN PRINT: PRINT "ABORTED! ";: GET A$: RETURN
 3741  IF A$ = CHR$(8) THEN A = A - 1: GOTO 3790
 3742  IF A$ = CHR$(21) THEN A = A + 1: GOTO 3790
 3743  I = VAL(A$) - 1: IF I<0 OR I>7 THEN 3790
 3760 AP$(A,I) =  LEFT$ (B$ + " ", LEN (B$)): AD% = AD% - C: GOSUB 7100: RETURN
 3790  IF A<0 THEN A = 0
 3791  IF A>3 THEN A = 3
 3792  GOTO 3720

 4000  TEXT: HOME: M = 1: A = 0
 4010  ON M GOSUB 4100,4150,4210,4310
 4020  VTAB 23: PRINT "SPACE=NEXT ESC=QUIT ";: IF M>1 THEN PRINT "ARROWS=CHARACTER ";
 4030  GET A$: IF A$ = CHR$(27) THEN HOME: POKE -16304,0: GOTO 20
 4040  IF A$ = CHR$(8) THEN A = A - 1: IF A<0 THEN A = 0
 4050  IF A$ = CHR$(21) THEN A = A + 1: IF A>3 THEN A = 3
 4060  IF A$ = " " THEN M = M + 1: IF M>4 THEN M = 1
 4070  HOME: GOTO 4010
 4100  PRINT "PARTY: ";NA$: PRINT T$;", ";RM$: PRINT "GOLD COINS: ";AD%: PRINT "FOOD SUPPLY: "; INT (AE)
 4110  PRINT: PRINT "ACHIEVEMENTS:"
 4111  IF FG%(0)=16 THEN PRINT "FONKRAKIS"
 4112  IF FG%(1)=16 THEN PRINT "ABYSS"
 4113  IF FG%(2)=16 THEN PRINT "WORNOTH"
 4114  IF FG%(3)>0 THEN PRINT "ENLIGHTENED"
 4115  IF FG%(4)>0 THEN PRINT "BLESSED"
 4116  IF FG%(5)>0 THEN PRINT "ETHEREAL"
 4120  RETURN
 4150  PRINT "NAME: ";NM$(A): PRINT "CLASS: ";CL$(A): PRINT "RACE: ";RA$(A): PRINT "HIT POINTS: ";AB%(A);"/";AC%(A)
 4160  PRINT "STRENGTH: ";AF%(A): PRINT "INTELLIGENCE: ";AG%(A): PRINT "WISDOM: ";AH%(A): PRINT "AGILITY: ";AI%(A): PRINT "STAMINA: ";AJ%(A): PRINT "CHARISMA: ";AK%(A)
 4170  PRINT "EXPERIENCE: ";ZA%(A): PRINT "LEVEL: "; INT (ZA%(A) / 1000) + 1;"/";WT%(A)
 4180  PRINT : PRINT "WEAPON READY: ";DW$(A): PRINT "ARMOUR READY: ";DV$(A): PRINT "SPELL READY: ";DX$(A)
 4190  RETURN
 4210  PRINT NM$(A);"'S ITEMS:": FOR I = 0 TO 7: PRINT I + 1;") ";: PRINT AP$(A,I): NEXT: RETURN
 4310  PRINT NM$(A);"'S SPELLS:": FOR I = 0 TO 15: PRINT CHR$(65+I);") ";: PRINT AX$(A,I): NEXT: RETURN

 5000  POKE 8189,131: POKE 8188,82: GOSUB 5050: CALL 7076: RETURN
 5001  POKE 8189,128: POKE 8188,0: GOSUB 5050: CALL 7076: RETURN

 5010  POKE 8189,128: POKE 8188,0
 5011  POKE 4,72: POKE 5,22: POKE 8183,WX%*16
 5013  POKE 8187,FL%: GOSUB 5050: CALL 6400: RETURN

 5050  POKE 8190, INT (XT / 2): POKE 8191,YT
 5060  POKE 8185,1
 5070  IF (XT / 2) =  INT (XT / 2) THEN POKE 8185,0
 5080  RETURN

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

 5200 GOSUB 5000: BY = 33618: GOTO 5202
 5201 GOSUB 5001: BY = 32768
 5202 BY = BY + (YT*20) + INT(XT/2)
 5210 Z = 16: IF (XT/2)=INT(XT/2) THEN Z=1
 5220 POKE BY,PEEK(BY) + N*Z - PEEK(768)*Z: RETURN

 7000  REM INPUT
 7002 B$ = "": HTAB 1: PRINT ">";: CALL -868
 7004  GET CH$: CH = ASC(CH$): IF CH = 13 THEN RETURN
 7008  IF CH = 8 OR CH = 127 THEN 7014
 7010  IF CH<32 OR CH>126 OR CH=44 OR LEN(B$)>30 THEN 7004
 7012  PRINT CH$;: B$ = B$ + CH$: GOTO 7004
 7014  IF LEN (B$) < 2 THEN 7000
 7016 B$ =  LEFT$ (B$, LEN (B$) - 1): POKE 36, PEEK (36) - 1: CALL  - 868: GOTO 7004

 7050  HOME : VTAB 21: IF  PEEK (921) = 96 THEN 7080
 7060  POKE 921,96: PRINT "SOUND OFF"
 7061  FOR P = 0 TO 500+EP: NEXT P: HOME : GOTO 20
 7080  POKE 921,141: PRINT "SOUND ON": GOTO 7061

 7100 I = 0
 7105  FOR P = 0 TO 7: IF DW$(A) = AP$(A,P) THEN I = 8
 7106  NEXT : IF I = 0 THEN DW$(A) = "HA"+"NDS"
 7109 I = 0
 7110  FOR P = 0 TO 7: IF DV$(A) = AP$(A,P) THEN I = 8
 7111  NEXT : IF I = 0 THEN DV$(A) = "SK"+"IN"
 7115  RETURN

 7400  HOME: VTAB 21: GOSUB 5000: A = PEEK(768)
 7410  IF  A > 13 THEN 7500
 7420  IF  A > 8 THEN 7600
 7430  GOSUB 370: PRINT "A ";GO$;" SAYS- HELLO! ";
 7440  GET A$: HOME : GOTO 100

 7500  GOSUB 5001
 7510  IF WX% <> 0 OR LEFT$(T$,6)="CASTLE" THEN 7599
 7520 M =  PEEK (768) + 1
 7530  ON M GOTO 7700,7599,7702,7704,7599,7599,7599,7706,7708,7710,7599,7599,7599,7599,7712
 7599  HOME: VTAB 21: PRINT "NOBODY HERE! ";: GOSUB 30050: HOME : GOTO 100

 7600 POKE 4,0: POKE 8184,0
 7610  POKE 8190,1: POKE 8191,1: POKE 8187,YT: POKE 8186, INT (XT / 2)
 7620  GOSUB 5060: CALL 7312: A =  PEEK(34418 + (PEEK(4) * 120))
 7630  CALL 7459: PRINT " ";
 7660  IF A = 1 THEN 7714
 7661  IF A = 2 THEN 7720
 7662  IF A = 5 THEN 7716
 7663  IF A = 6 THEN 7718
 7664  IF A = 9 THEN 7730
 7665  IF A = 12 THEN 7719
 7666  IF A = 14 THEN 7740
 7667  IF A = 15 THEN 7760
 7668  IF A = 16 THEN 7750
 7669  IF A = 18 THEN 7770
 7699  GET A$: HOME : GOTO 100

 7700  PRINT : PRINT CHR$(4);"BLOAD FOOD": GOTO 8910
 7702  PRINT : PRINT CHR$(4);"BLOAD PUB": GOTO 8910
 7704  PRINT : PRINT CHR$(4);"BLOAD SHIPYARD": GOTO 8910
 7706  PRINT : PRINT CHR$(4);"BLOAD LIBRARY": GOTO 8900
 7708  PRINT : PRINT CHR$(4);"BLOAD TEMPLE": GOTO 8900
 7710  PRINT : PRINT CHR$(4);"BLOAD WEAPARM": GOTO 8900
 7712  PRINT : PRINT CHR$(4);"BLOAD WEAPARM": GOTO 8900

 7714  PRINT : PRINT CHR$(4);"BLOAD SAGE": GOTO 8910
 7716  PRINT : PRINT CHR$(4);"BLOAD ARCHWIZ": GOTO 8910
 7718  PRINT : PRINT CHR$(4);"BLOAD ALCHEMIST": GOTO 8900
 7719  PRINT : PRINT CHR$(4);"BLOAD BARON": GOTO 8900

 7720  GOSUB 7000: IF B$ = "GEM OF ENLIGHTENMENT" THEN 7722
 7721  HOME : VTAB 21: PRINT "BE OFF! ";: GOSUB 30050: HOME : GOTO 100
 7722  HOME : VTAB 21: PRINT "2000 GOLD, TAKE IT OR LEAVE IT (Y/N) ";: GET A$
 7724  IF A$ = "N" THEN 7721
 7725  C = 2000: AD% = AD% - C: IF AD% < 0 THEN 7999
 7726  A = 0: GOSUB 3720: GOTO 2040

 7730  GET A$:B$ = "RED " + "PRISM": A = 0: GOTO 1320
 7740  GET A$:B$ = "CLEAR " + "PRISM": A = 0: GOTO 1320

 7750  PRINT : GOSUB 7000: IF  LEFT$ (B$,5) <> "SOULS" THEN 7721
 7751  HOME : VTAB 21: PRINT "-CASTING SWIM-": GOSUB 30000: POKE 6423,5: HOME : GOTO 100

 7760  PRINT : GOSUB 7000
 7763  IF B$ = "YFJ" THEN 7765
 7764  HOME : VTAB 21: PRINT "WRONG! ";: GOSUB 30050: HOME : GOTO 100
 7765 XT = XT + 6: HOME : GOTO 100

 7770  PRINT : GOSUB 7000: IF B$ = "SROTCES EERF" THEN 7772
 7771  HOME : VTAB 21: PRINT "BE OFF, FOOLISH MORTAL! ";: GOSUB 30050: HOME : GOTO 100
 7772  HOME: PG$ = "DUN"+"GEON": R%=2: GOTO 8020

 7999 AD% = AD% + C: HOME : VTAB 21: PRINT "YOU DON'T HAVE THE GOLD! ";: GOSUB 30050: HOME : GOTO 100

 8000 HOME : VTAB 21: IF FO%=32 AND FL%=0 THEN FL%=32
 8010  PG$ = "OUT"+"SIDE" : R%=1
 8020  PRINT: ONERR GOTO 9250
 8030  PRINT CHR$(4);"BLOAD CHAIN"
 8040  POKE 216,0: POKE 4096,0: POKE 103,1: POKE 104,16: GOTO 10

 8070  HOME: VTAB 21: PRINT "NOT HERE. ";: GOSUB 30050: HOME : GOTO 100

 8900 POKE 2048,0: POKE 103,1: POKE 104,8: GOTO 8900
 8910 POKE 2816,0: POKE 103,1: POKE 104,11: GOTO 8910

 9250  HOME: VTAB 21: PRINT "PLEASE RESTORE DISK- ";: GET A$: CALL 938: PRINT: RESUME

 13000  M = 40: FOR I = 0 TO 3: IF DX$(I) = "PROTECTION 1" THEN M = 0
 13010  NEXT
 13020  FOR I = 0 TO 3: AB%(I) = AB%(I) - M: IF AB%(I) < 1 THEN AB%(I) = 0
 13030  NEXT
 13040  IF M > 0 THEN GOSUB 30040: GOSUB 40000: HOME: FS% = -ABS(FS%): IF FS% > -2 THEN FS% = -2
 13049  GOTO 20

 13050  IF FS% = 0 THEN RETURN
 13051  IF PEEK(1616) = 160 THEN FS% = -ABS(FS%)
 13052  IF AE<100 THEN INVERSE
 13053  VTAB 21: PRINT "FOOD": NORMAL: PRINT "    ";: HTAB 1: PRINT  INT (AE): IF FS% = -1 OR FS% > 0 THEN FS% = ABS(FS%): RETURN
 13054  FS% = ABS(FS%): PRINT "GOLD": PRINT AD%;
 13055  FOR I = 0 TO 3: VTAB 21 + I: HTAB 6
 13056  IF FS% = 2 THEN PRINT LEFT$(DW$(I),12);
 13057  IF FS% = 3 THEN PRINT LEFT$(DV$(I),12);
 13058  HTAB 19: PRINT LEFT$(DX$(I),12);: HTAB 32: PRINT AB%(I);"/";AC%(I);: NEXT
 13060  RETURN

 25000  PRINT:PRINT CHR$(4);"BLOAD TWNSPS":GOTO 100

 30000  POKE 768,169: POKE 769,30: POKE 813,100: CALL 768: RETURN
 30040  POKE 768,169: POKE 769,8: POKE 813,100: FOR I = 1 TO 3: CALL 768: NEXT I: RETURN
 30050  POKE 8191,50: CALL 912: GET A$: RETURN

 40000 M = 0: FOR I = 0 TO 3:M = M + AB%(I): NEXT
 40001  IF M > 0 THEN  RETURN
 50000  HOME : VTAB 21: PRINT "YOUR PARTY IS ELIMINATED!"
 50001  GOTO 50001
