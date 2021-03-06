5 GM = 1: GN(1) = 2000
6 GA = 20: GB = 100:GE = 120
7 GC$ = "NIGHTMARE SWARM":GD$="U":GO$ = "MORDOCK"

10  GOSUB 100
20  FOR A = 0 TO 3: GOSUB 200: NEXT
30  GOSUB 90: IF M = 0 THEN 10000
40  FOR A = 1 TO GM: GOSUB 3200: NEXT
50  GOTO 20

80  M = GP%(0) + GP%(1) + GP%(2) + GP%(3): RETURN
90  M = 0: FOR I = 1 TO GM: M = M + GN(I): NEXT I: RETURN

100  FOR I = 1 TO 8:PM%(I) = 0: NEXT
110  FOR I = 0 TO 3:PC%(I) = 0: NEXT
120  FOR I = 0 TO 3:GP%(I) = 8: IF AB%(I) < 1 THEN GP%(I) = 0
130  NEXT
140  RETURN

200  GOSUB 90: IF M = 0 OR AB%(A) = 0 THEN RETURN
202  ZA% =  INT (ZA%(A) / 1000): IF PC%(A) > 0 THEN PC%(A) = PC%(A) - 1
204  HOME : VTAB 21: IF PC%(A) > 0 THEN PRINT NM$(A);" RECOVERS IN ";PC%(A);" TURN";: IF PC%(A)>1 THEN PRINT "S";
205  IF PC%(A)>0 THEN GOSUB 30050: RETURN
208  PRINT "ACTION PHASE FOR ";NM$(A): PRINT "HIT POINTS: ";AB%(A): PRINT "POSITION: ";: IF GP%(A) = 0 THEN PRINT "REAR": GOTO 220
209  PRINT "FRONT"
220  HTAB 1: VTAB 24: PRINT "COMMAND: ";: GET A$
230  IF A$ = " " THEN RETURN
240  IF A$ = "W" THEN 500
250  IF A$ = "A" THEN 600
260  IF A$ = "C" THEN 2000
270  IF A$ = "R" THEN 2800
280  GOTO 204

300  IF W$ = "SWT" AND FG%(4)>0 THEN C = 4:WA = 60:WB = 85
310  IF W$ = "HOE" AND FG%(4)>0 AND CL$(A) = "PALADIN" THEN C = 4:WA = 25:WB = 80
320  RETURN

500  IF GP%(A) = 8 THEN GOSUB 80: IF M > 16 THEN GP%(A) = 0: RETURN
510  IF GP%(A) = 0 THEN GP%(A) = 8: RETURN
520  HOME : VTAB 21: PRINT "INVALID MOVE! ";: GOSUB 30050: GOTO 204

600 MA = 1: WB = 0: W$ = LEFT$(DW$(A),2) + RIGHT$(DW$(A),1): GOSUB 300
601  IF WB = 0 THEN HOME: VTAB 21: PRINT "WEAPON INEFFECTIVE! ";: GOSUB 30050: RETURN
602  IF GP%(A) = 0 THEN 2920
610  HOME : VTAB 21: GS = 1
620  PRINT "ATTACK WITH ";: PRINT DW$(A)
630  WC = (WB - GA + AI%(A) + ZA%*2)*WU%(CL%(A),C)/9: WC = 100*WC/(80+0.4*WC)
670  IF 100 * RND (1) > WC THEN PRINT "A MISS! ";: GOSUB 30050: GOTO 720
700  PRINT "A HIT: ";: DM =  INT (WA -  RND (1) * 6 + AF%(A) / 3): GOSUB 30040: PRINT "DAMAGE ";DM;" ";
710  GN(GS) = GN(GS) - DM: IF GN(GS) < 1 THEN 10000
715  GET A$: GOSUB 90: IF M<1 THEN RETURN
720  MA = MA - 1: IF MA < 1 THEN RETURN
730  GOTO 610

2000  HOME: VTAB 21: PRINT "SPELL INEFFECTIVE! ";: GOSUB 30050: RETURN

2800  HOME: VTAB 21: PRINT LEFT$(NM$(A),13);" (ARROWS,A,Z,ENT,ESC)": FOR C=0 TO 2: DT%(C) = DR%(A,C): NEXT: C = 0
2803  PRINT "ITEM:  ";CHR$(DT%(0)+65);") ";LEFT$(DW$(A),24)
2804  PRINT "ARMOR: ";CHR$(DT%(1)+65);") ";DV$(A)
2805  PRINT "SPELL: ";CHR$(DT%(2)+65);") ";DX$(A);
2806  L = DT%(C): P = 9: IF C = 2 THEN P = 16

2810  HTAB 8: VTAB C+22: IF C<2 THEN B$ = AP$(A,L)
2811  IF C = 2 THEN B$ = AX$(A,L)
2814  PRINT CHR$(L+65);") ";: INVERSE: PRINT LEFT$(B$,24);: NORMAL: CALL -868
2820  HTAB 1: VTAB 20: GET A$: IF A$ = CHR$(27) THEN 204
2821  IF A$ = CHR$(13) THEN 2830
2822  IF A$ = CHR$(11) OR A$ = "A" THEN N = -1: GOTO 2850
2823  IF A$ = CHR$(10) OR A$ = "Z" THEN N = 1: GOTO 2850
2825  N = 0: IF A$ = CHR$(8) THEN N = -1
2826  IF A$ = CHR$(21) THEN N = 1
2827  IF N = 0 THEN 2820
2828  GOSUB 2860: DT%(C) = L: GOTO 2810

2830  FOR C=0 TO 2: DR%(A,C) = DT%(C): NEXT: DW$(A)=AP$(A,DT%(0)): DV$(A)=AP$(A,DT%(1)): DX$(A)=AX$(A,DT%(2)): RETURN

2850  HTAB 11: VTAB C+22: PRINT B$;: C = C + N: IF C<0 THEN C = 2
2851  IF C>2 THEN C = 0
2852  GOTO 2806

2860  B$ = LEFT$(CL$(A),1)
2861  L = L + N: IF L<0 THEN L = P
2862  IF L>P THEN L = 0
2866  IF C <> 2 THEN I = LEN(AP$(A,L))
2867  IF C = 2 THEN I = LEN(AX$(A,L))
2868  IF I = 0 THEN 2861
2869  IF C = 2 THEN RETURN
2870  A$ = LEFT$(AP$(A,L),5)
2871  M = A$="SKIN" OR A$="LEATH" OR A$="CHAIN" OR A$="PLATE": M = (C=0 AND M=1) OR (C=1 AND M=0)
2873  M = M OR (B$="W" OR B$="T" OR B$="M") AND (A$="CHAIN" OR A$="PLATE")
2874  M = M OR (B$<>"C" AND (A$="ROD O" OR A$="AMULE" OR A$="LIGHT" OR A$="FIRE "))
2875  M = M OR (B$<>"W" AND (A$="WAND " OR A$="STAFF"))
2876  IF M THEN 2861
2877  RETURN

2920  AA% = 0: HOME: VTAB 21: PRINT "OUT OF RANGE! ";: GOSUB 30050: GOTO 204

3100  A$ =  LEFT$ (DV$(GS),3): IF A$ = "LEA" THEN I = I + 10
3101  IF A$ = "CHA" THEN I = I + 18
3102  IF A$ = "PLA" THEN I = I + 26
3103  IF DW$(GS) = "AMULET OF PROTECTION" THEN I = I + 30
3110  IF DW$(GS) = "HOLY BLADE" AND CL$(GS) = "PALADIN" THEN I = I + 16
3111  IF DW$(GS) = "DEFENDER" THEN I = I + 26
3112  IF DX$(GS) = "SHIELD" THEN I = I + 26
3113  IF RIGHT$(DV$(GS),1) = "+" THEN I = I + 10
3119  RETURN

3130  FOR M = 0 TO 3: IF DX$(M) = "DISPEL MAGIC" THEN I = I + 35
3131  IF DW$(M) = "AMULET OF PROTECTION" THEN I = I + 30
3132  NEXT: IF DX$(GS) = "DISPEL MAGIC" THEN I = I + 30
3139  RETURN

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
3201  GI$ = "STONE": GF = -10: GH = 1
3202  IF INT(2*RND(1))=0 THEN GI$ = "MASSACRE": GF = 100: GH = 4
3210  GOSUB 3190: I = INT(3*RND(1))

3215  IF I=0 THEN 3300
3216  IF I=1 THEN 3400

3220  PRINT GO$;" ATTACKING ";NM$(GS)
3230  I =  INT (99 *  RND (1)): GOSUB 3100
3250  IF I > (GE) THEN PRINT "A MISS! ";: GOSUB 30050: RETURN
3260  PRINT "A HIT: ";: GOSUB 30040: DM =  INT (GB *  (0.5 + RND (1)))
3270  PRINT "DAMAGE ";DM;" ";: AB%(GS) = AB%(GS) - DM
3280  GOSUB 3150: GET A$: RETURN

3300 LS = 1: HOME : VTAB 21
3310  PRINT GO$;" CASTING": PRINT GI$: GOSUB 30000
3320  I =  INT (99 *  RND (1)): GOSUB 3110: GOSUB 3130
3325  IF I > (GE) THEN PRINT "FAILED! ";: GOSUB 30050: RETURN
3330  PRINT "SPELL HIT ";NM$(GS);": ";: GOSUB 30030
3340  IF GF < 0 THEN  PC%(GS) =  ABS (GF) + 1: PRINT ABS(GF);" TURNS ";
3345  IF GF > 0 THEN  DM =  INT (GF *  RND (1) + GA): PRINT "DAMAGE ";DM;" ";: AB%(GS) = AB%(GS) - DM
3350  GOSUB 3150: GET A$: LS = LS + 1: IF LS > GH THEN RETURN
3360  GOSUB 3190: PRINT: GOTO 3330

3400  WZ% = 99: HOME: VTAB 21: PRINT GO$;" ATTACKING ";NM$(GS): INVERSE: PRINT GC$;: NORMAL: PRINT ": ";: GOSUB 30020
3408  I = 0: IF  FG%(3)>0 THEN I = 70
3410  IF I > RND (1) * 99  THEN PRINT "SAVED BY ENLIGHTENMENT";: GOSUB 30050: RETURN
3420  DM = GB * 4: PRINT "DAMAGE ";DM;" ";: AB%(GS) = AB%(GS) - DM: GOSUB 30040: GOSUB 3150: GET A$: RETURN

4210  PRINT "ITEMS:": FOR I = 0 TO 7: PRINT I + 1;") ";: PRINT AP$(M,I): NEXT: RETURN
4310  PRINT "SPELLS:": FOR I = 0 TO 15: PRINT CHR$(65+I);") ";: PRINT AX$(M,I): NEXT: RETURN

9000  REM VERIFY DISK
9110  ONERR  GOTO 9200
9120  HTAB 1: PRINT  CHR$(4);"VERIFY START.REALM": POKE 216,0: RETURN
9200  HTAB 1: VTAB 15: PRINT "PLEASE RESTORE DISK- ";: GET A$: CALL 768: PRINT : RESUME

10000  TEXT: HOME
10020  PRINT "AS THE NIGHTMARE DREAMER BREATHES HIS"
10030  PRINT "LAST, HE UTTERS THESE PARTING WORDS:"
10050  PRINT: PRINT CHR$(34);"YOU DEEM THE REALMS ARE SAVED."
10060  PRINT "BUT YOU ONLY DELAY THE DARKNESS FOR"
10070  PRINT "A SHORT TIME. FOR ANOTHER REMAINS, ONE"
10080  PRINT "WHO IS GREATER THAN I.";CHR$(34)
10090  PRINT: PRINT "THEN HE EXPIRES.": PRINT: PRINT "IT SEEMS YOU HAVE BROUGHT PEACEFUL"
10100  PRINT "DREAMS BACK TO ARRINEA, BUT ONLY FOR A"
10110  PRINT "LITTLE WHILE."
10120  FG%(5) = 32: FL% = 32
10130  GOSUB 9000: GOSUB 11000
10145  HTAB 1: VTAB 15: PRINT "ACHIEVEMENT SAVED. GAME OVER, YOU WIN!";: CALL -868
10150  GOTO 10150

11000  REM SAVE
11005  PRINT : PRINT CHR$(4);"OPEN PARTIES/D.";NA$
11010  PRINT CHR$(4);"WRITE PARTIES/D.";NA$
11015  FOR A = 0 TO 3
11020  PRINT NM$(A)
11025  PRINT RA$(A)
11030  PRINT CL$(A)
11035  PRINT ZA%(A)
11040  PRINT AB%(A)
11045  PRINT AC%(A)
11050  PRINT AF%(A)
11055  PRINT AG%(A)
11060  PRINT AH%(A)
11065  PRINT AI%(A)
11070  PRINT AJ%(A)
11075  PRINT AK%(A)
11080  PRINT DV$(A)
11085  PRINT DW$(A)
11090  PRINT DX$(A)
11095  PRINT WT%(A)
11100  FOR M = 0 TO 7: PRINT AP$(A,M): NEXT
11105  FOR M = 0 TO 15: PRINT AX$(A,M): NEXT
11110  NEXT
11115  PRINT X
11120  PRINT Y
11125  PRINT AD%: PRINT AE: PRINT FL%: PRINT RM$
11126  FOR I = 0 TO 5: PRINT FG%(I): NEXT I
11130  PRINT CHR$(4);"CLOSE PARTIES/D.";NA$
11150  RETURN

30000  POKE 6,64: POKE 7,2: POKE 8,100: POKE 9,1: POKE 30,2: CALL 806: RETURN
30010  POKE 6,90: POKE 7,2: POKE 8,10: POKE 9,3: POKE 30,2: CALL 898: RETURN
30020  POKE 6,140: POKE 7,2: POKE 8,6: POKE 9,3: POKE 30,2: CALL 898: RETURN
30030  POKE 6,90: POKE 7,2: POKE 8,10: POKE 9,3: POKE 30,2: CALL 829: RETURN
30040  POKE 6,110: POKE 7,2: POKE 8,6: POKE 9,3: POKE 30,2: CALL 806: RETURN
30050  POKE 6,50: POKE 7,25: POKE 8,1: POKE 9,1: POKE 30,1: CALL 852: GET A$: RETURN

40000 M = 0: FOR I = 0 TO 3:M = M + AB%(I): NEXT
40001  IF M > 0 THEN  RETURN
50000  HOME : VTAB 21: PRINT "YOUR PARTY IS ELIMINATED!"
50001  GOTO 50001
