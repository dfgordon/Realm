 10  AA% = 0: GOSUB 100
 20  FOR L = 0 TO 3: GOSUB 200: NEXT L
 30  GOSUB 90: IF M = 0 THEN 3600
 40  FOR L = 1 TO GM: GOSUB 3200: NEXT L
 50  GOTO 20

 70  IF AA% = 0 THEN GET A$
 71  RETURN
 80  M = GP%(0) + GP%(1) + GP%(2) + GP%(3): RETURN
 90  M = 0: FOR I = 1 TO GM: M = M + GN(I): NEXT I: RETURN

 100  FOR I = 1 TO 9:PM%(I) = 0: NEXT
 110  FOR I = 0 TO 3:PC%(I) = 0: NEXT
 120  FOR I = 0 TO 3:GP%(I) = 8: IF AB%(I) < 1 THEN GP%(I) = 0
 130  NEXT
 140  RETURN

 200  GOSUB 90: IF M = 0 OR AB%(L) = 0 THEN RETURN
 202  ZA% =  INT (ZA%(L) / 1000): IF PC%(L) > 0 THEN PC%(L) = PC%(L) - 1
 204  HOME : VTAB 21
 206  IF PC%(L) > 0 THEN  PRINT NM$(L);" UNDER PARALYSIS! ";: GOSUB 30050: RETURN
 207  IF AA% = 1 THEN 600
 208  PRINT "ACTION PHASE FOR ";NM$(L): PRINT "HIT POINTS LEFT: ";AB%(L);
 210  IF GP%(L) = 0 THEN HTAB 31: PRINT "WITHDRAWN";
 220  PRINT: PRINT "COMMAND: ";: GET A$
 230  IF A$ = " " THEN RETURN
 240  IF A$ = "W" THEN 500
 250  IF A$ = "A" THEN 600
 255  IF A$ = CHR$(1) THEN AA% = 1: HOME: HTAB 7: VTAB 21: INVERSE: PRINT "AUTO-RESOLVING TO THE DEATH!": GOSUB 2320: NORMAL: GOTO 600
 260  IF A$ = "C" THEN 2000
 270  IF A$ = "R" THEN 2800
 280  HTAB 1: VTAB 23: PRINT "COMMAND: (A,C,SPC,R,W,CTRL-A) ";: GET A$: GOTO 230

 300  IF W$ = "AX+" THEN C = 1: WA = 25:WB = 90:WR = -1
 301  IF W$ = "MA+" THEN C = 2: WA = 20:WB = 95
 302  IF W$ = "MO+" THEN C = 2: WA = 40:WB = 70
 303  IF W$ = "DA+" THEN C = 0: WA = 20:WB = 80:WR = -1
 304  IF W$ = "LO+" THEN C = 4: WA = 35:WB = 80
 305  IF W$ = "BR+" THEN C = 4: WA = 40:WB = 80
 306  IF W$ = "2H+" THEN C = 5: WA = 50:WB = 80
 307  IF W$ = "BO+" THEN C = 3: WA = 25:WB = 90:WR = 1
 308  IF W$ = "AXE" THEN C = 1: WA = 15:WB = 60:WR = -1
 309  IF W$ = "MAE" THEN C = 2: WA = 10:WB = 60
 310  IF W$ = "MOR" THEN C = 2: WA = 20:WB = 50
 311  IF W$ = "DAR" THEN C = 0: WA = 10:WB = 40:WR = -1
 312  IF W$ = "LOD" THEN C = 4: WA = 25:WB = 70
 313  IF W$ = "BRD" THEN C = 4: WA = 30:WB = 70
 314  IF W$ = "2HD" THEN C = 5: WA = 40:WB = 70
 316  IF W$ = "BOW" THEN C = 3: WA = 15:WB = 50:WR = 1
 317  IF W$ = "DER" THEN C = 4: WA = 50:WB = 70
 318  IF W$ = "HAS" THEN C = 0: WA = 6: WB = 35: IF CL$(L) = "MONK" THEN WA = 10 + ZA%: WB = ZA%*10 + 50: MA = INT(2 + ZA%/3)
 319  IF W$ = "SWT" THEN C = 4: WA = 60:WB = 85
 320  IF W$ = "HOE" THEN C = 4: WA = 50:WB = 80: IF RND(1) > 0.60 AND CL$(L) = "PALADIN" AND GD$ = "U" THEN MA = 2: WB = 1000: SC$ = "P": SD$ = "DISPEL"+"LED"
 321  IF W$ = "VOE" THEN C = 4: WA = 50:WB = 80: IF RND(1) > 0.75 THEN WB = 1000: SC$ = "P": SD$ = "DECAP"+"ITATED"
 322  IF W$ = "BEE" THEN C = 1: WA = 50:WB = 80: IF RND(1) > 0.89 THEN MA = 4: WB = 1000: SC$ = "P": SD$ = "CLEAV"+"ED"
 323  IF W$ = "HAK" THEN C = 2: WA = 75:WB = 70: IF RND(1) > 0.75 THEN WB = 1000: SC$ = "T": SD$ = "STUN"+"NED"
 330  IF DW$(L) = "WAND OF FIRE" THEN WA =  - 40:WB = 90:WR = 1:SC$ = "I":SE$ = "F"
 331  IF DW$(L) = "WAND OF ICE" THEN WA =  - 40:WB = 90:WR = 1:SC$ = "I":SE$ = "I"
 332  IF W$ = "WAS" THEN WA =  - 20:WB = 90:WR = 1:SC$ = "I":MA = 3
 333  IF DW$(L) = "WAND OF STONE" THEN WB = 45:WR = 1:SC$ = "P":SD$ = "TURNED"+" TO STONE"
 334  IF W$ = "STG" THEN WA =  - 50:WB = 90:SC$ = "I"
 335  IF W$ = "STR" THEN WA =  - 65:WB = 90:WR = 1:SC$ = "I"
 336  IF W$ = "STH" THEN WB = 55:SC$ = "P":SD$ = "KIL"+"LED":MA = -2
 337  IF W$ = "LID" THEN WA =  - 50:WB = 80:WR = 1:SC$ = "I":SE$ = "L"
 338  IF W$ = "FID" THEN WA =  - 50:WB = 80:WR = 1:SC$ = "I":SE$ = "F"
 349  RETURN

 400  IF W$ = "PHW" THEN WA =  - 20:WB = 90:SC$ = "I":MA = INT((ZA% + 1) / 2 + 1)
 401  IF W$ = "FIL" THEN WA = 12:WB = 80:SC$ = "I":SE$ = "F"
 402  IF W$ = "LIT" THEN WA = 12:WB = 80:SC$ = "I":SE$ = "L"
 403  IF W$ = "ICM" THEN WA =  - 40:WB = 100:SC$ = "I":SE$ = "I":MA = -6
 404  IF W$ = "RAE" THEN WA = 16:WB = 85:SC$ = "I":SE$ = "R"
 405  IF W$ = "BOT" THEN WA = 12:WB = 90:SC$ = "I":MA = 4
 406  IF W$ = "SLP" THEN WB = 50:SC$ = "T":SD$ = "PUT TO"+" SLEEP":MA = 3
 407  IF W$ = "STE" THEN WB = 60:SC$ = "P":WR = 0:SD$ = "TURNED TO"+" STONE"
 408  IF W$ = "PAE" THEN WB = 90:SC$ = "T":SD$ = "PARA"+"LYZED"
 409  IF W$ = "DOW" THEN WB = 120:SC$ = "P":SD$ = "KIL"+"LED"
 410  IF W$ = "DIE" THEN WB = 60:SC$ = "P":SD$ = "DISINT"+"EGRATED":MA = -3
 411  IF W$ = "KIL" THEN WB = 60:SC$ = "P":WR = 0:SD$ = "KIL"+"LED":MA = -5
 412  IF W$ = "PUE" THEN WA = 14:WB = 80:SC$ = "I":SE$ = "F"
 413  IF W$ = "CON" THEN WA = 20:WB = 90:SC$ = "I":SE$ = "L"
 449  RETURN

 500  IF GP%(L) = 8 THEN GOSUB 80: IF M > 16 THEN GP%(L) = 0: RETURN
 510  IF GP%(L) = 0 THEN GP%(L) = 8: RETURN
 520  HOME : VTAB 21: PRINT "INVALID MOVE! ";: GOSUB 30050: GOTO 204

 600  MA = 1: WA = 0: WB = 0: WR = 0: SC$ = "": SE$ = "N": W$ = LEFT$(DW$(L),2) + RIGHT$(DW$(L),1): GOSUB 300
 620  IF WB = 0 THEN 700
 621  IF GP%(L) = 0 AND WR = 0 THEN 700
 630  IF AA% = 0 THEN GOSUB 900
 640  IF AA% = 1 THEN GOSUB 950
 650  HOME: VTAB 21: PRINT "ATTACK #";GS;" WITH ";: PRINT DW$(L)
 660  IF SC$ = "I" THEN I = 99*RND(1): GOTO 2040
 670  IF SC$ = "P" OR SC$ = "T" THEN I = 99*RND(1): GOTO 2020
 680  GOTO 1000

 700  AA% = 0: HOME: VTAB 21: PRINT "INVALID WEAPON! ";: GOSUB 30050: GOTO 204

 800 AA% = 0: HOME: VTAB 21: PRINT "THROW ";DW$(L)" (Y/N) ?";: GET A$: IF A$ <> "Y" AND A$ <> "N" THEN 800
 801 PRINT: IF A$ = "N" THEN RETURN
 802 I = 0
 810  IF AP$(L,I) = DW$(L) THEN 830
 820 I = I + 1: GOTO 810
 830 AP$(L,I) = "": DW$(L) = "HA" + "NDS": RETURN

 900  HOME: VTAB 21: PRINT "ATTACK WHICH ";GO$;" ";: GET A$:GS =  VAL (A$): PRINT: IF GS<1 OR GS>GM THEN 900
 910  IF GN(GS) = 0 THEN PRINT GS;" IS DEAD.": GOTO 900
 920  RETURN

 950  GS = 1
 960  IF GN(GS) > 0 THEN RETURN
 970  GS = GS + 1: GOTO 960

 1000  IF GP%(L) = 0 AND WR = -1 THEN GOSUB 800: IF A$ = "N" THEN 204
 1010 I =  RND (1) * 99 + GA - AI%(L) - ZA%*2
 1020  IF I < WB*WU%(CL%(L),C)/9 THEN GOSUB 1100: GOSUB 70: GOTO 1200
 1030  PRINT "A MISS! ";: GOSUB 30050: GOTO 1200

 1100  PRINT "A HIT: ";
 1110 DM =  INT (WA -  RND (1) * 6 + AF%(L) / 3)
 1120  GOSUB 30040: GOSUB 1300
 1130  RETURN

 1200  GOSUB 90: IF M<1 THEN RETURN
 1210  MA = MA - 1: IF MA < 1 THEN RETURN
 1220  GOTO 630

 1300  PRINT "DAMAGE ";DM;" ";: GN(GS) = GN(GS) - DM: IF GN(GS) < 1 THEN GN(GS) = 0
 1301  IF GN(GS) = 0 THEN  GOSUB 1861
 1302  RETURN

 1861 Z = GA + GB + GE + GF + (GH * 4)
 1862  IF GF < 0 THEN Z = Z +  ABS (GF * 5)
 1864  IF GC$ <  > "" THEN Z = Z + 15
 1865 Z =  INT (Z / (ZA% / 2 + 2))
 1870  PRINT: PRINT "  ";NM$(L);" + ";Z;" X.P. ";
 1871 ZA%(L) = ZA%(L) + Z: IF ZA%(L) > (WT%(L) - 1) * 1000 THEN ZA%(L) = (WT%(L) - 1) * 1000
 1875  RETURN

 2000 MA = 1: WA = 0: WB = 0: WR = 1: SE$ = "N": B$ = DX$(L): W$ =  LEFT$ (DX$(L),2) + RIGHT$ (DX$(L),1): GOSUB 400: IF WB = 0 THEN 2910
 2001  IF GP%(L) = 0 AND WR = 0 THEN 2910
 2002  HOME: VTAB 21: GOSUB 2300: IF MA > 8 THEN MA = 8
 2007  HOME: VTAB 21: PRINT "CAST ";B$;" AT": PRINT GO$;"# ";: GET A$:GS =  VAL (A$): PRINT: IF GS < 1 OR GS > GM THEN 2007
 2010  IF GN(GS) = 0 THEN PRINT GS;" IS DEAD.": GOTO 2007

 2014  HOME: VTAB 21: PRINT "-CASTING ";B$;"-": GOSUB 30000
 2016  I = RND(1) * 99 - AH%(L)/4: IF RA$(L) = "ELF" THEN I = I - 10
 2018  IF SC$ = "I" THEN 2040

 2020  I = I + GA
 2022  IF WB < I THEN PRINT "FAILED! ";: GOSUB 30050: RETURN
 2023  IF LEFT$(SD$,3) = "DEC" AND GO$ = "HYDRA" THEN PRINT "HYDRA DECAPITATED BUT HEAD REGROWS! ";: GOSUB 30050: RETURN
 2024  PRINT GO$;" #";GS;" IS ";SD$;" ";: GOSUB 30010
 2026  IF SC$ = "T" THEN PM%(GS) = 4: IF WA>0 THEN DM = WA: PRINT: PRINT "WITH ";: GOSUB 1300
 2028  IF SC$ = "P" THEN GN(GS) = 0: GOSUB 1861
 2030  GOSUB 70: GOSUB 90: IF M = 0 THEN RETURN
 2032  MA = MA - SGN(MA): IF MA = 0 THEN RETURN
 2034  IF MA>0 THEN GOSUB 2100: IF GS = 0 THEN RETURN
 2035  IF MA<0 THEN GS = INT(RND(1)*GM) + 1: IF GN(GS) = 0 THEN 2032
 2036  PRINT: GOTO 2024

 2040  IF SE$ = GD$ THEN PRINT GO$;" IMMUNE! ";: GOSUB 30050: RETURN
 2042  IF WB < I THEN PRINT "FAILED! ";: GOSUB 30050: RETURN
 2044  PRINT "SPELL HIT #";GS;": ";: GOSUB 30030
 2046  IF WA < 0 THEN DM = WA +  INT ( RND (1) * 5):DM = DM *  - 1
 2048  IF WA > 0 THEN DM = (WA -  INT ( RND (1) * 3)) * (ZA% + 1)
 2050  IF GD$ = "F" AND SE$ = "I" OR GD$ = "I" AND SE$ = "F" THEN DM =  INT (DM * 1.5)
 2052  GOSUB 1300: GOSUB 70: GOSUB 90: IF M = 0 THEN RETURN
 2058  MA = MA - SGN(MA): IF MA = 0 THEN RETURN
 2060  IF MA>0 THEN GOSUB 2100: IF GS = 0 THEN RETURN
 2061  IF MA<0 THEN GS = INT(RND(1)*GM) + 1: IF GN(GS) = 0 THEN 2058
 2062  PRINT: GOTO 2044

 2100  M = 0
 2110  IF GN(GS) > 0 AND (SC$ <> "T" OR PM%(GS) = 0) THEN RETURN
 2120  M = M + 1: GS = GS + 1: IF GS > GM THEN GS = 1
 2130  IF M > GM THEN GS = 0: RETURN
 2140  GOTO 2110

 2300 P = ZA% / 1000 + AH%(L): IF P/(10+P) >  RND (1) THEN RETURN
 2302 I = 0
 2304  IF AX$(L,I) = DX$(L) THEN 2308
 2306 I = I + 1: GOTO 2304
 2308 AX$(L,I) = ""
 2310 I = I + 1: IF I > 15 THEN 2316
 2312  IF AX$(L,I) = DX$(L) THEN  RETURN
 2314  GOTO 2310
 2316  INVERSE : HOME: VTAB 21: PRINT DX$(L);" IS EXHAUSTED ": NORMAL :DX$(L) = ""
 2320  FOR P = 0 TO 500+EP: NEXT P: RETURN

 2800  HOME: VTAB 21: PRINT "(W)EAPON/ITEM, (A)RMOR, (S)PELL- ";: GET B$
 2820  IF B$ = "W" OR B$ = "A" THEN 2830
 2822  IF B$ = "S" THEN 2870
 2825  GOTO 2800

 2830  TEXT: HOME: M = L: GOSUB 4210: PRINT "H) HANDS": PRINT "SELECT- ";:GET A$: IF A$=CHR$(27) THEN POKE -16304,0 : GOTO 204
 2831  IF A$="H" AND B$="W" THEN DW$(L) = "HA"+"NDS": GOTO 2860
 2833  I = VAL(A$) - 1: IF I<0 OR I>7 THEN 2830
 2840  POKE -16304,0: GOSUB 2950: IF M THEN GOTO 2900
 2841  GOSUB 2920: IF B$="W" AND M OR B$="A" AND NOT M THEN GOTO 2900
 2850  IF B$="W" THEN DW$(L) = AP$(L,I)
 2851  IF B$="A" THEN DV$(L) = AP$(L,I)
 2860  POKE -16304,0: RETURN

 2870  TEXT:HOME: M = L: GOSUB 4310: PRINT "SELECT- ";:GET A$: IF A$ = CHR$(27) THEN POKE -16304,0 : GOTO 204
 2871  I = ASC(A$) - 65: IF I<0 OR I>15 THEN 2870
 2880  DX$(L) = AX$(L,I): GOTO 2860

 2900  HOME : VTAB 21: PRINT "INVALID ITEM! ";: GOSUB 30050: GOTO 204
 2910  HOME : VTAB 21: PRINT "INVALID SPELL! ";: GOSUB 30050: GOTO 204

 2920  A$ = LEFT$(AP$(L,I),3)
 2930  M = (A$="LEA" OR A$="CHA" OR A$="PLA")
 2940  RETURN

 2950  A$ = LEFT$(AP$(L,I),3)
 2951  M = (CL$(L)="WIZARD" OR CL$(L)="THIEF" OR CL$(L)="MONK") AND (A$="CHA" OR A$="PLA")
 2952  M = M OR (CL$(L)<>"CLERIC" AND (A$="ROD" OR A$="AMU" OR A$="LIG" OR A$="FIR"))
 2953  M = M OR (CL$(L)<>"WIZARD" AND (A$="WAN" OR A$="STA"))
 2954  RETURN

 3100  IF DW$(GS) = "AMULET OF PROTECTION" THEN I = I + 30
 3110  IF DW$(GS) = "HOLY BLADE" AND CL$(GS) = "PALADIN" THEN I = I + 16
 3120  IF DW$(GS) = "DEFENDER" THEN I = I + 26
 3125  IF DX$(GS) = "SHIELD" THEN I = I + 26
 3140  RETURN

 3150  IF AB%(GS) < 1 THEN AB%(GS) = 0
 3160  IF AB%(GS) = 0 THEN  GP%(GS) = 0: PRINT: FLASH: PRINT NM$(GS);" IS DEAD";: NORMAL: PRINT " ";
 3170  GOSUB 40000: GOSUB 80: IF M<16 THEN GOSUB 120
 3180  RETURN

 3190  GS =  INT (4 *  RND (1))
 3191  IF AB%(GS) > 0 AND GP%(GS) > 0 THEN 3194
 3192  GS = GS + 1: IF GS = 4 THEN GS = 0
 3193  GOTO 3191
 3194  RETURN

 3200  HOME : VTAB 21
 3204  IF PM%(L) > 0 THEN PM%(L) = PM%(L) - 1
 3205  IF GN(L) < 1 THEN RETURN
 3206  IF PM%(L) > 0 THEN  PRINT GO$;"# ";L;" UNDER PARALYSIS! ";: GOSUB 30050: RETURN
 3207  IF GD$ = "Z" AND GN(L) < GA * 10 THEN GN(L) = GN(L) + GB
 3210  GOSUB 3190

 3215  IF GI$ <> "" AND INT(5*RND(1))=0 THEN 3300
 3216  IF GC$ <> "" AND INT(5*RND(1))=0 THEN 3400

 3220  PRINT GO$;" #";L;" ATTACKING ";NM$(GS)
 3230  I =  INT (99 *  RND (1)): A$ =  LEFT$ (DV$(GS),5)
 3231  IF A$ = "LEATH" THEN I = I + 10
 3232  IF A$ = "CHAIN" THEN I = I + 18
 3233  IF A$ = "PLATE" THEN I = I + 26
 3234  IF RIGHT$(DV$(GS),1) = "+" THEN I = I + 10
 3240  GOSUB 3100
 3250  IF I > (GE) THEN PRINT "A MISS! ";: GOSUB 30050: RETURN
 3260  PRINT "A HIT: ";: GOSUB 30040: DM =  INT (GB *  RND (1) + GA)
 3270  PRINT "DAMAGE ";DM;" ";: AB%(GS) = AB%(GS) - DM
 3280  GOSUB 3150: GOSUB 70: RETURN

 3300 LS = 1: HOME : VTAB 21
 3310  PRINT GO$;" #";L;" CASTING ";GI$: GOSUB 30000
 3320 I =  INT (99 *  RND (1)) + 1
 3321  GOSUB 3100
 3322 FOR M = 0 TO 3: IF DX$(M) = "DISPEL MAGIC" THEN I = I + 20
 3323  NEXT M: IF DX$(GS) = "DISPEL MAGIC" THEN I = I + 35
 3324  IF RIGHT$(DV$(GS),1) = "+" THEN I = I + 8
 3325  IF I > (GE) THEN PRINT "FAILED! ";: GOSUB 30050: RETURN
 3330  PRINT "SPELL HIT ";NM$(GS);": ";: GOSUB 30030
 3340  IF GF < 0 THEN  PC%(GS) =  ABS (GF) + 1: PRINT ABS(GF);" TURNS ";
 3345  IF GF > 0 THEN  DM =  INT (GF *  RND (1) + GA): PRINT "DAMAGE ";DM;" ";: AB%(GS) = AB%(GS) - DM
 3350  GOSUB 3150: GOSUB 70: LS = LS + 1: IF LS > GH THEN RETURN
 3360  GOSUB 3190: PRINT: GOTO 3330

 3400  WZ% = 99: HOME: VTAB 21: PRINT GO$;"# ";L;" ATTACKING ";NM$(GS): INVERSE: PRINT GC$;: NORMAL: PRINT ": ";: GOSUB 30020
 3403  IF GD$ = "F" OR GD$ = "I" THEN WZ% = 1
 3404  IF GD$ = "L" OR GD$ = "R" THEN WZ% = 2
 3405  IF GD$ = "U" OR GD$ = "M" THEN WZ% = 3
 3406  IF GD$ = "P" OR GD$ = "A" THEN WZ% = 4
 3407  I = 0: FOR M = 0 TO 3
 3408  IF  LEFT$(DX$(M),1) = "P" AND VAL ( RIGHT$ (DX$(M),1)) = WZ% THEN I = 70
 3409  NEXT M
 3410  IF I > RND (1) * 99  THEN PRINT "SAVED BY PROTECTION ";WZ%;" ";: GOSUB 30050: RETURN
 3420  DM = GB * 4: PRINT "DAMAGE ";DM;" ";: AB%(GS) = AB%(GS) - DM: GOSUB 30040: GOSUB 3150: GOSUB 70: RETURN

 3600  IF DG% = 1 AND WT% = 13 THEN BY = 1: GOSUB 3700
 3610  P = (( RND (1) * .5) + .5) * GM * GA * 2
 3620  HOME: VTAB 21: PRINT "YOU ARE VICTORIOUS!": PRINT "YOU FIND "; INT (P);" GOLD ";: GET A$
 3630  AD% = AD% + P: IF AD% > 9999 THEN AD% = 9999
 3640  GOTO 8000

 3700  GOSUB 3800: B$ = A$: M = 0
 3710  IF W$ = "" THEN POKE -16304,0: RETURN
 3720  TEXT: HOME: PRINT "YOU FOUND: ";W$: GOSUB 4210
 3730  PRINT: PRINT "USE ARROWS TO CHANGE CHARACTER": PRINT "PRESS 1-8 TO REPLACE OLD ITEM.": PRINT "PRESS ESC TO LEAVE ";W$: GET A$
 3740  IF A$ = CHR$(27) THEN 3770
 3741  IF A$ = CHR$(8) THEN M = M - 1: GOTO 3790
 3742  IF A$ = CHR$(21) THEN M = M + 1: GOTO 3790
 3743  I = VAL(A$) - 1: IF I<0 OR I>7 THEN 3790
 3750  IF AP$(M,I) = "" THEN 3760
 3751  HOME: PRINT "REPLACE ";AP$(M,I);" (Y/N) ? ";: GET A$: IF A$ <> "Y" AND A$ <> "N" THEN 3751
 3752  IF A$ = "N" THEN 3720
 3760  AP$(M,I) = W$: L = M: GOSUB 7100
 3770  IF B$ = "." THEN POKE -16304,0: RETURN
 3780  GOTO 3700
 3790  IF M<0 THEN M = 0
 3791  IF M>3 THEN M = 3
 3792  GOTO 3720

 3800  W$ = ""
 3810  A$ = MID$(TV$,BY,1)
 3820  IF A$ = "." OR A$ = "/" THEN BY = BY + 1: RETURN
 3830  W$ = W$ + A$: BY = BY + 1: GOTO 3810

 4210  PRINT NM$(M);"'S ITEMS:": FOR I = 0 TO 7: PRINT I + 1;") ";: PRINT AP$(M,I): NEXT: RETURN
 4310  PRINT NM$(M);"'S SPELLS:": FOR I = 0 TO 15: PRINT CHR$(65+I);") ";: PRINT AX$(M,I): NEXT: RETURN

 7100 N = 0
 7105  FOR M = 0 TO 7: IF DW$(L) = AP$(L,M) THEN N = 8
 7106  NEXT : IF N = 0 THEN DW$(L) = "HA" + "NDS"
 7109 N = 0
 7110  FOR M = 0 TO 7: IF DV$(L) = AP$(L,M) THEN N = 8
 7111  NEXT : IF N = 0 THEN DV$(L) = "SK" + "IN"
 7115  RETURN

 8000  PG$ = "DUN" + "GEON" : R% = 1
 8010  IF DG% = 0 THEN PG$ = "TO"+"WN"
 8020  POKE 4096,0: POKE 103,1: POKE 104,16: GOTO 10

 30000  POKE 6,64: POKE 7,2: POKE 8,100: POKE 9,1: POKE 30,2: CALL 806: RETURN
 30010  POKE 6,90: POKE 7,2: POKE 8,10: POKE 9,3: POKE 30,2: CALL 898: RETURN
 30020  POKE 6,140: POKE 7,2: POKE 8,6: POKE 9,3: POKE 30,2: CALL 898: RETURN
 30030  POKE 6,90: POKE 7,2: POKE 8,10: POKE 9,3: POKE 30,2: CALL 829: RETURN
 30040  POKE 6,110: POKE 7,2: POKE 8,6: POKE 9,3: POKE 30,2: CALL 806: RETURN
 30050  POKE 6,50: POKE 7,25: POKE 8,1: POKE 9,1: POKE 30,1: CALL 852: GOSUB 70: RETURN

 40000 M = 0: FOR I = 0 TO 3:M = M + AB%(I): NEXT
 40001  IF M > 0 THEN  RETURN
 50000  HOME : VTAB 21: PRINT "YOUR PARTY IS ELIMINATED!"
 50001  GOTO 50001