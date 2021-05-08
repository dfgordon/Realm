 5 GM = 1: GN(1) = 1500
 6 GA = 20: GB = 100:GE = 120
 7 GC$ = "NIGHTMARE SWARM":GD$="U":GO$ = "MORDOCK"

 10  GOSUB 100
 20  FOR L = 0 TO 3: GOSUB 200: NEXT L
 30  GOSUB 90: IF M = 0 THEN 10000
 40  FOR L = 1 TO GM: GOSUB 3200: NEXT L
 50  GOTO 20

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
 208  PRINT "ACTION PHASE FOR ";NM$(L): PRINT "HIT POINTS LEFT: ";AB%(L);
 210  IF GP%(L) = 0 THEN HTAB 31: PRINT "WITHDRAWN";
 220  PRINT: PRINT "COMMAND: ";: GET A$: PRINT
 230  IF A$ = "P" THEN RETURN
 240  IF A$ = "W" THEN 1580
 250  IF A$ = "A" THEN 1600
 260  IF A$ = "C" THEN 2000
 270  IF A$ = "R" THEN 2800
 280  GOTO 204

 300  IF W$ = "SWT" AND FG%(4)>0 THEN WA = 75:WB = 85
 310  IF W$ = "HOE" AND FG%(4)>0 AND CL$(L) = "PALADIN" THEN WA = 25:WB = 80
 320  RETURN

 1580  IF GP%(L) = 8 THEN GOSUB 80: IF M > 16 THEN GP%(L) = 0: RETURN
 1581  IF GP%(L) = 0 THEN GP%(L) = 8: RETURN
 1590  HOME : VTAB 21: PRINT "INVALID MOVE! ";: GOSUB 30050: GOTO 204

 1600 MA = 1: WB = 0: W$ = LEFT$(DW$(L),2) + RIGHT$(DW$(L),1): GOSUB 300
 1620  HOME : VTAB 21: GS = 1
 1622  PRINT "ATTACK WITH ";: PRINT DW$(L)
 1626  IF WB = 0 THEN 1725
 1632  IF GP%(L) = 8 THEN 1750

 1725  HOME : VTAB 21: PRINT "WEAPON INEFFECTIVE! ";: GOSUB 30050: RETURN

 1750  REM
 1770 I =  RND (1) * 99 - AI%(L) - ZA%*2
 1790  IF I < WB/WU(L) THEN 1810
 1800  PRINT "A MISS! ";: GOSUB 30050: GOTO 1840

 1810  PRINT "A HIT: ";
 1815 DM =  INT (WA -  RND (1) * 6 + AF%(L) / 3)
 1820  GOSUB 30040: PRINT "DAMAGE ";DM
 1825 GN(GS) = GN(GS) - DM: IF GN(GS) < 1 THEN GN(GS) = 0
 1830  IF GN(GS) = 0 THEN  10000
 1831  GET A$: GOSUB 90: IF M<1 THEN RETURN

 1840  MA = MA - 1: IF MA < 1 THEN RETURN
 1850  GOTO 1622

 2000  PRINT "SPELL INEFFECTIVE! ";: GOSUB 30050: RETURN

 2800  PRINT: PRINT "(W)EAPON/ITEM, (A)RMOR, (S)PELL- ";: GET A$
 2811  HOME : VTAB 21
 2820  IF A$ = "W" THEN 2830
 2821  IF A$ = "A" THEN 2850
 2822  IF A$ = "S" THEN 2870
 2825  GOTO 2800

 2830  TEXT:HOME: M = L: GOSUB 4210: PRINT "H) HANDS": PRINT "WHAT WEAPON:";:GET A$: IF A$="H" THEN DW$(L) = "HA"+"NDS": GOTO 2889
 2831  I = VAL(A$) - 1: IF I<0 OR I>7 THEN 2830
 2840  GOSUB 2950: IF M THEN GOTO 2900
 2841  GOSUB 2920: IF M THEN GOTO 2900
 2849  DW$(L) = AP$(L,I): GOTO 2889

 2850  TEXT:HOME: M = L: GOSUB 4210: PRINT "WHAT ARMOUR:";:GET A$
 2851  I = VAL(A$) - 1: IF I<0 OR I>7 THEN 2850
 2860  GOSUB 2950: IF M THEN GOTO 2900
 2861  GOSUB 2920: IF NOT M THEN GOTO 2900
 2869  DV$(L) = AP$(L,I): GOTO 2889

 2870  TEXT:HOME: M = L: GOSUB 4310: PRINT "WHAT SPELL:";:GET A$
 2871  I = ASC(A$) - 65: IF I<0 OR I>15 THEN 2870
 2880  DX$(L) = AX$(L,I)
 2889  POKE -16304,0 : RETURN

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
 3160  IF AB%(GS) = 0 THEN  GP%(GS) = 0: PRINT NM$(GS);" IS DEAD!"
 3170  GOSUB 40000: GOSUB 80: IF M<16 THEN GOSUB 120
 3180  RETURN

 3190  GS =  INT (4 *  RND (1))
 3191  IF AB%(GS) > 0 AND GP%(GS) > 0 THEN 3194
 3192  GS = GS + 1: IF GS = 4 THEN GS = 0
 3193  GOTO 3191
 3194  RETURN

 3200  HOME : VTAB 21
 3201  GI$ = "STONE": GF = -10: GH = 1
 3202  IF INT(2*RND(1))=0 THEN GI$ = "MASSACRE": GF = 100: GH = 1
 3210  GOSUB 3190

 3215  IF GI$ <> "" AND INT(3*RND(1))=0 THEN 3300
 3216  IF GC$ <> "" AND INT(3*RND(1))=0 THEN 3400

 3220  PRINT GO$;" ATTACKING ";NM$(GS)
 3230  I =  INT (99 *  RND (1)): A$ =  LEFT$ (DV$(GS),5)
 3231  IF A$ = "LEATH" THEN I = I + 10
 3232  IF A$ = "CHAIN" THEN I = I + 18
 3233  IF A$ = "PLATE" THEN I = I + 26
 3234  IF RIGHT$(DV$(GS),1) = "+" THEN I = I + 10
 3240  GOSUB 3100
 3250  IF I > (GE) THEN PRINT "A MISS! ";: GOSUB 30050: RETURN
 3260  PRINT "A HIT: ";: GOSUB 30040: DM =  INT (GB *  RND (1)) + 1
 3270  PRINT "DAMAGE ";DMG: AB%(GS) = AB%(GS) - DMG
 3280  GOSUB 3150: GET A$: RETURN

 3300 LS = 1: HOME : VTAB 21
 3310  PRINT GO$;" CASTING": PRINT GI$: GOSUB 30000
 3320 I =  INT (99 *  RND (1)) + 1
 3321  GOSUB 3100
 3322 FOR M = 0 TO 3: IF DX$(M) = "DISPEL MAGIC" THEN I = I + 20
 3323  NEXT M: IF DX$(GS) = "DISPEL MAGIC" THEN I = I + 35
 3324  IF RIGHT$(DV$(GS),1) = "+" THEN I = I + 8
 3325  IF I > (GE) THEN PRINT "FAILED! ";: GOSUB 30050: RETURN
 3330  PRINT "SPELL HIT ";NM$(GS);": ";: GOSUB 30030
 3340  IF GF < 0 THEN  PC%(GS) =  ABS (GF) + 1: PRINT PC%(GS);" TURNS"
 3345  IF GF > 0 THEN  DM =  INT (GF *  RND (1)) + 1: PRINT "DAMAGE ";DM: AB%(GS) = AB%(GS) - DM
 3350  GOSUB 3150: GET A$: LS = LS + 1: IF LS > GH THEN RETURN
 3360  GOSUB 3190: GOTO 3330

 3400  WZ% = 99: HOME: VTAB 21: PRINT GO$;" USING ";GC$: PRINT "AGAINST ";NM$(GS): GOSUB 30020
 3408  I = 0: IF  FG%(3)>0 THEN I = 70
 3410  IF I > RND (1) * 99  THEN PRINT "SAVED BY ENLIGHTENMENT! ";: GET A$: RETURN
 3420  DM = GB * 4: PRINT "DAMAGE: ";DM: AB%(GS) = AB%(GS) - DM: GOSUB 30040: GOSUB 3150: GET A$: RETURN

 4210  PRINT "ITEMS:": FOR I = 0 TO 7: PRINT I + 1;") ";: PRINT AP$(M,I): NEXT: RETURN
 4310  PRINT "SPELLS:": FOR I = 0 TO 15: PRINT CHR$(65+I);") ";: PRINT AX$(M,I): NEXT: RETURN

 10000  HOME: VTAB 21: PRINT "YOU ARE VICTORIOUS! ";: GET A$
 10010  TEXT: HOME
 10020  PRINT "AS THE NIGHTMARE DREAMER BREATHES HIS"
 10030  PRINT "LAST, HE UTTERS THESE PARTING WORDS:"
 10050  PRINT: PRINT CHR$(34);"YOU DEEM THE REALMS ARE SAVED."
 10060  PRINT "BUT YOU ONLY DELAY THE DARKNESS FOR"
 10070  PRINT "A SHORT TIME. FOR ANOTHER REMAINS, ONE"
 10080  PRINT "WHO IS GREATER THAN I.";CHR$(34)
 10090  PRINT: PRINT "THEN HE EXPIRES.": PRINT: PRINT "IT SEEMS YOU HAVE BROUGHT PEACEFUL"
 10100  PRINT "DREAMS BACK TO ARRINEA, BUT ONLY FOR A"
 10110  PRINT "LITTLE WHILE."
 10120  PRINT: PRINT "(GAME IS OVER, YOU WIN!)"
 10130  GOTO 10130

 30000  POKE 768,169: POKE 769,30: POKE 813,100: CALL 768: RETURN
 30010  POKE 768,169: POKE 769,40: POKE 813,10: POKE 830,0: POKE 881,40: POKE 886,10
 30015  FOR I = 1 TO 3: CALL 768: CALL 829: NEXT I: RETURN
 30020  POKE 768,169: POKE 769,60: POKE 813,6: POKE 830,1: POKE 881,60: POKE 886,6: GOTO 30015
 30030  POKE 830,0: POKE 881,35: POKE 886,10: FOR I = 1 TO 3: CALL 829: NEXT I: RETURN
 30040  POKE 768,169: POKE 769,50: POKE 813,6: FOR I = 1 TO 3: CALL 768: NEXT I: RETURN
 30050  POKE 8191,50: CALL 912: GET A$: RETURN
 40000 M = 0: FOR I = 0 TO 3:M = M + AB%(I): NEXT
 40001  IF M > 0 THEN  RETURN
 50000  HOME : VTAB 21: PRINT "YOUR PARTY IS ELIMINATED!"
 50001  GOTO 50001
