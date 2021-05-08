 0  FO% = FL%: FL% = 0
 4 WY% = 1: WX% = (ZA%(0) + ZA%(1) + ZA%(2) + ZA%(3)) / 4000
 6 XT = 0: YT = 9
 7 T$ =  B$: A1% = 0: A2% = 0: A3% = 0
 10  GOSUB 9050: GOTO 100

 20  GOSUB 13050: VTAB 20: GET A$: PRINT: AE = AE - .25: IF AE < 0 THEN 50000
 30  IF AE < 100 AND FS% = 0 THEN FS% = -1
 40  GOSUB 5100
 71  IF XT < 0 OR XT > 19 OR YT < 0 THEN 120
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
 100  GOSUB 5010: GOSUB 5001: M = PEEK(768)
 102  IF  PEEK (8186) = 16 THEN 120
 104  IF M = 13 THEN 200: REM SPECIAL
 106  IF M = 12 THEN 12000: REM TRAP
 108  IF M = 9 THEN 13000: REM LAVA
 110  IF M = 14 THEN 10100: REM PRIEST
 112  IF M = 11 THEN 14990: REM MORDOCK
 114  IF M = 15 THEN 290: REM MONSTER
 116  GOTO 20
 120  XT = XT - XK: YT = YT - YK
 122  POKE 768,169: POKE 769,30: POKE 813,5: CALL 768
 124  GOTO 20

 200  WT% = 13: POKE 4,0
 210  POKE 8190,0: POKE 8191,0: POKE 8186,INT(XT/2): POKE 8187,YT
 220  GOSUB 5060: CALL 7128
 230  BY = 34368 + ( PEEK (4) * 80): GM =  INT (3 *  RND (1)) + 4: GOTO 291

 290  WT% = 15: GM =  INT (6 *  RND (1)) + 1
 291  HOME :I =  INT (4 *  RND (1)) + ((WY% - 1) * 3)
 300  D = 2: GOSUB 9110: PRINT CHR$(4);"OPEN MONSTERS"
 301  PRINT CHR$(4);"POSITION MONSTERS,R";I * 10
 302  PRINT CHR$(4);"READ MONSTERS"
 303  INPUT GA: INPUT GB: INPUT GC$: INPUT GD$: INPUT GE: INPUT GF: INPUT GH: INPUT GI$: INPUT GK$: INPUT GO$
 304  PRINT CHR$(4);"CLOSE MONSTERS"
 311 IF GM = 1 THEN GK$ = ""
 312  HOME : VTAB 21: PRINT "YOU HAVE ENCOUNTERED ";GM: PRINT GO$;GK$: GOSUB 30200
 350  PRINT CHR$(4);"BLOAD FRAMEM,A$8C80"
 352  GOSUB 380: CALL 4352
 354  FOR M = 1 TO GM:K =  INT (3 *  RND (1)) + 9:GN(M) = GA * K: NEXT
 360  PRINT CHR$(4);"BLOAD ";GO$;",A$8C80"
 361  GOSUB 380: CALL 4355: GOSUB 381
 370  PG$ = "COM" + "BAT": DG% = 1
 371  PRINT CHR$(4);"BLOAD CHAIN"
 372  POKE 4096,0: POKE 103,1: POKE 104,16: GOTO 10

 380  POKE 768,189: POKE 769,128: POKE 770,140: POKE 771,96: RETURN
 381  POKE 768,169: POKE 770,162: POKE 771,16: RETURN

 600  HOME : VTAB 21 : PRINT "USE THE SURFACING STONE? ": GET A$
 610  PRINT:PRINT:PRINT
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
 783  IF LEFT$(B$,2) = "AM" THEN GOSUB 2200
 784  IF LEFT$(B$,2) = "HE" THEN GOSUB 2300
 785  HOME : VTAB 21: PRINT "-CASTING HEAL-": GOSUB 30000
 786 C =  INT (CA *  RND (1)) + CA
 787 AB%(B) = AB%(B) + C: IF AB%(B) > AC%(B) THEN AB%(B) = AC%(B)
 788  PRINT C;" POINTS HEALED. ";: GET A$: HOME : GOTO 100

 790 SB = 85: N = 8
 810  GOSUB 850
 811  IF PEEK(768)=N THEN 815
 812  HOME: VTAB 21: PRINT "WRONG TARGET.";: GOSUB 30050: HOME: GOTO 100
 815  GOSUB 2300
 816  HOME: VTAB 21: PRINT "-CASTING ";B$;"-": GOSUB 30000
 820  L =  INT (99 *  RND (1)) + 1:  IF SB > L THEN 830
 825  HOME: VTAB 21: PRINT "FAILED! ";: GOSUB 30050: HOME : GOTO 100
 830  N = 7: XT=XT+XK: YT=YT+YK: GOSUB 5201: GOSUB 880: HOME: GOTO 100

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
 1021  IF B$ = "ORB OF STARS" AND RIGHT$(T$,4) = "MINE" THEN 1100
 1023  GOTO 2900


 1050  GOSUB 850
 1055  IF PEEK(768)=8 THEN 1060
 1056  GOTO 812
 1060  GOSUB 2200
 1065  HOME: VTAB 21: PRINT "-USING POTION OF PASSAGE-": GOSUB 30000
 1070  GOTO 830

 1100  IF XT = 4 AND YT = 152 THEN W$ = "FIRE": GOSUB 1199: A1%=1: HOME: GOTO 100
 1110  IF XT = 9 AND YT = 147 THEN W$ = "EARTH": GOSUB 1199: A2%=1: HOME: GOTO 100
 1120  IF XT = 14 AND YT = 152 THEN W$ = "WATER": GOSUB 1199: A3%=1: HOME: GOTO 100
 1130  IF XT = 9 AND YT = 157 AND A1%=1 AND A2%=1 AND A3%=1 THEN 1150
 1140  HOME: VTAB 21: PRINT "NOTHING HAPPENED.";: GOSUB 30050: HOME: GOTO 100
 1150  HOME: VTAB 21: PRINT "-INSCRIBING RUNES-": GOSUB 30000: FOR I = 1 TO 42: POKE 8191,(I / 8) * 10: CALL 912: NEXT I
 1170  FG%(5) = 16: PRINT "YOU CAN NOW MOVE IN THE ETHER!";:GET A$: HOME: GOTO 100
 1199  HOME: VTAB 21: PRINT "-SUMMONING ";W$;" SPIRIT-": GOSUB 30000: RETURN

 1200  HOME: VTAB 21: GOSUB 5001: IF PEEK(768)<>10 THEN PRINT "NOT HERE.";: GOSUB 30050: HOME: GOTO 100
 1202 M =  INT ( RND (1) * 50) + 100
 1203  IF RND(1) > 0.5 THEN 1210
 1205 P =  (1 + WY%) * M / 2
 1206  PRINT "GOLD +";INT(P);:AD% = AD% + P
 1207  IF AD% > 9999 THEN AD% = 9999
 1208  GOTO 1220
 1210  PRINT "FOOD +";M;:AE = AE + M
 1211  IF AE > 9999 THEN AE = 9999
 1220  N = 7: GOSUB 5201: GET A$: HOME: GOTO 100

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
 2216  INVERSE : HOME: VTAB 21:  PRINT DW$(A);" IS EXPENDED ": NORMAL :DW$(A) = "HA" + "NDS"
 2220  GOSUB 30100: RETURN

 2300 P = ZA%(A) / 1000 + AH%(A): IF P/(10+P) >  RND (1) THEN RETURN
 2302 I = 0
 2304  IF AX$(A,I) = DX$(A) THEN 2308
 2306 I = I + 1: GOTO 2304
 2308 AX$(A,I) = ""
 2310 I = I + 1: IF I > 15 THEN 2316
 2312  IF AX$(A,I) = DX$(A) THEN  RETURN
 2314  GOTO 2310
 2316  INVERSE : HOME: VTAB 21:  PRINT DX$(A);" IS EXHAUSTED ": NORMAL :DX$(A) = ""
 2320  GOSUB 30100: RETURN

 2800  HOME : VTAB 21: PRINT "READY WHO (#) ";: GET A$
 2801  A =  VAL (A$) - 1: IF A<0 OR A>3 THEN 2800
 2802  IF AB%(A)=0 THEN 2800
 2810  PRINT:PRINT "(W)EAPON/ITEM, (A)RMOR, (S)PELL- ";: GET A$
 2811  HOME : VTAB 21
 2820  IF A$ = "W" THEN 2830
 2821  IF A$ = "A" THEN 2850
 2822  IF A$ = "S" THEN 2870
 2825  GOTO 2810

 2830  TEXT:HOME: GOSUB 4210: PRINT "H) HANDS": PRINT "WHAT WEAPON:";:GET A$: IF A$="H" THEN DW$(A) = "HA"+"NDS": GOTO 2889
 2831  L = VAL(A$) - 1: IF L<0 OR L>7 THEN 2830
 2840  GOSUB 2950: IF M THEN GOTO 2900
 2841  GOSUB 2920: IF M THEN GOTO 2900
 2849  DW$(A) = AP$(A,L): GOTO 2889

 2850  TEXT:HOME: GOSUB 4210: PRINT "WHAT ARMOUR:";:GET A$
 2851  L = VAL(A$) - 1: IF L<0 OR L>7 THEN 2850
 2860  GOSUB 2950: IF M THEN GOTO 2900
 2861  GOSUB 2920: IF NOT M THEN GOTO 2900
 2869  DV$(A) = AP$(A,L): GOTO 2889

 2870  TEXT:HOME: GOSUB 4310: PRINT "WHAT SPELL:";:GET A$
 2871  L = ASC(A$) - 65: IF L<0 OR L>15 THEN 2870
 2880  DX$(A) = AX$(A,L)
 2889  POKE -16304,0 : HOME : GOTO 100

 2900  HOME : VTAB 21: PRINT "INVALID ITEM! ";: GOSUB 30050: GOTO 2889
 2910  HOME : VTAB 21: PRINT "INVALID SPELL! ";: GOSUB 30050: GOTO 2889

 2920  A$ = LEFT$(AP$(A,L),3)
 2930  M = (A$="LEA" OR A$="CHA" OR A$="PLA")
 2940  RETURN

 2950  A$ = LEFT$(AP$(A,L),3)
 2951  M = (CL$(A)="WIZARD" OR CL$(A)="THIEF" OR CL$(A)="MONK") AND (A$="CHA" OR A$="PLA")
 2952  M = M OR (CL$(A)<>"CLERIC" AND (A$="ROD" OR A$="AMU" OR A$="LIG" OR A$="FIR"))
 2953  M = M OR (CL$(A)<>"WIZARD" AND (A$="WAN" OR A$="STA"))
 2954  RETURN

 4000  TEXT : HOME : PRINT "STATUS FOR WHO (#) ";: GET A$
 4010 A =  VAL (A$) - 1: IF A < 0 OR A > 3 THEN 4000
 4050  HOME: PRINT "PARTY: ";NA$
 4051  PRINT T$;", ";RM$
 4052  PRINT "GOLD COINS: ";AD%
 4053  PRINT "FOOD SUPPLY: "; INT (AE)
 4060  PRINT: PRINT "NAME: ";NM$(A)
 4070  PRINT "CLASS: ";CL$(A)
 4080  PRINT "RACE: ";RA$(A)
 4090  PRINT "MAXIMUM HIT POINTS: ";AC%(A)
 4100  PRINT "CURRENT HIT POINTS: ";AB%(A)
 4130  PRINT "STRENGTH: ";AF%(A)
 4140  PRINT "INTELLIGENCE: ";AG%(A)
 4150  PRINT "WISDOM: ";AH%(A)
 4160  PRINT "AGILITY: ";AI%(A)
 4170  PRINT "STAMINA: ";AJ%(A)
 4180  PRINT "CHARISMA: ";AK%(A)
 4181  PRINT "EXPERIENCE: ";ZA%(A)
 4182  PRINT "LEVEL: "; INT (ZA%(A) / 1000) + 1
 4183  PRINT "MAXIMUM LEVEL: ";WT%(A)
 4184  PRINT : PRINT "WEAPON READY: ";DW$(A)
 4185  PRINT "ARMOUR READY: ";DV$(A)
 4186  PRINT "SPELL READY: ";DX$(A)
 4190  GET A$
 4200  HOME
 4201  GOSUB 4210: GET B$
 4202  HOME : GOSUB 4310
 4203  GET B$
 4205  HOME : POKE  - 16304,0: GOTO 20
 4210  PRINT "ITEMS:": FOR I = 0 TO 7: PRINT I + 1;") ";: PRINT AP$(A,I): NEXT: RETURN
 4310  PRINT "SPELLS:": FOR I = 0 TO 15: PRINT CHR$(65+I);") ";: PRINT AX$(A,I): NEXT: RETURN

 5001  POKE 8189,128: POKE 8188,0: GOSUB 5050: POKE 4,0: POKE 5,0: CALL 7076: RETURN

 5010  POKE 8189,128: POKE 8188,0: POKE 8186,0
 5011  POKE 4,100: POKE 5,46
 5012  POKE 8187,0: IF WY%<=WX% THEN POKE 8187,16
 5013  GOSUB 5050: CALL 6384: RETURN

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

 5201 GOSUB 5001: BY = 32768
 5202 BY = BY + (YT*10) + INT(XT/2)
 5210 Z = 16: IF (XT/2)=INT(XT/2) THEN Z=1
 5220 POKE BY,PEEK(BY) + N*Z - PEEK(768)*Z: RETURN

 7050  HOME : VTAB 21: IF  PEEK (921) = 96 THEN 7080
 7060  POKE 921,96: PRINT "SOUND OFF"
 7061  GOSUB 30100: HOME : GOTO 20
 7080  POKE 921,141: PRINT "SOUND ON": GOTO 7061

 7100 I = 0
 7105  FOR P = 0 TO 7: IF DW$(A) = AP$(A,P) THEN I = 8
 7106  NEXT : IF I = 0 THEN DW$(A) = "HA"+"NDS"
 7109 I = 0
 7110  FOR P = 0 TO 7: IF DV$(A) = AP$(A,P) THEN I = 8
 7111  NEXT : IF I = 0 THEN DV$(A) = "SK"+"IN"
 7115  RETURN

 8000 HOME : VTAB 21: IF FO%=32 THEN FL%=32
 8001  POKE 4610,27
 8010  PG$ = "OUT" + "SIDE" : R%=1
 8020  D = 1: IF RM$="ARRINEA" THEN D = 0
 8030  GOSUB 9110: PRINT CHR$(4);"BLOAD CHAIN"
 8040  POKE 4096,0: POKE 103,1: POKE 104,16: GOTO 10

 9000  GOSUB 5001: M = PEEK(768)
 9005  IF  M = 0 THEN DY = -1
 9006  IF  M = 1 THEN DY = 1
 9007  IF  M > 1 THEN PRINT "NO LADDER! ";: GOSUB 30050: HOME : GOTO 100
 9010  WY% = WY% + DY: YT = YT + 20*DY: IF WY% = 0 THEN 8000
 9020  HOME : VTAB 21: PRINT  TAB( 14);"-LEVEL ";WY%;"-": GOSUB 30100: HOME : GOTO 100

 9050  D = 2: GOSUB 9110: PRINT CHR$(4);"BLOAD FRAMED,A$8C80"
 9051  PRINT CHR$(4);"BLOAD MRC3"
 9052  PRINT CHR$(4);"BLOAD SDP.INTRP,A$1100"
 9053  POKE 4610,28: POKE 7680,173: POKE 7683,96
 9060  GOSUB 380: CALL 4352: GOSUB 381
 9065  HOME : RETURN

 9110  ONERR  GOTO 9200
 9120  PRINT : PRINT : PRINT
 9130  PRINT  CHR$(4);"VERIFY DISK";D;",S";WS%(D);",D";WD%(D);",V";WV%(D)
 9140  POKE 216,0 : RETURN
 9200  HOME : VTAB 21: PRINT "INSERT ";DL$(D);" DISK IN D";WD%(D);"- ";: GET A$
 9210  CALL 938
 9220  PRINT : RESUME

 10100  HOME : VTAB 21: PRINT "THE HIGH PRIEST!": GOSUB 30200
 10110  D = 2: GOSUB 9110: PRINT  CHR$(4);"BLOAD HIGH PRIEST!"
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

 14990  HOME : VTAB 21: PRINT "YOU FACE MORDOCK!": GOSUB 30200
 14992  D = 2: GOSUB 9110: PRINT CHR$(4);"BLOAD FRAMEM,A$8C80"
 14993  GOSUB 380: CALL 4352
 14994  PRINT CHR$(4);"BLOAD MORDOCK,A$8C80"
 14995  GOSUB 380: CALL 4355: GOSUB 381
 14998  PRINT CHR$(4);"BLOAD MORDOCK!"
 14999  POKE 2048,0: POKE 103,1: POKE 104,8: GOTO 5

 30000  POKE 768,169: POKE 769,30: POKE 813,100: CALL 768: RETURN
 30040  POKE 768,169: POKE 769,8: POKE 813,100: FOR I = 1 TO 3: CALL 768: NEXT I: RETURN
 30050  POKE 8191,50: CALL 912: GET A$: RETURN

 30100  FOR P = 0 TO 500+EP: NEXT P: RETURN
 30200  FOR P = 0 TO EP: NEXT P: RETURN

 40000 M = 0: FOR I = 0 TO 3:M = M + AB%(I): NEXT
 40001  IF M > 0 THEN  RETURN
 50000  HOME : VTAB 21: PRINT "YOUR PARTY IS ELIMINATED!"
 50001  GOTO 50001