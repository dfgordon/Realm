0  A%(0) = 0: A%(1) = 1: A%(2) = 2: A%(3) = 3
1  IF R% = 1 THEN GOSUB 100
2  GOSUB 700: IF R% = 1 THEN HOME: VTAB 21: PRINT "REORDER REQUIRES EXIT TO MENU- ";: GET A$: A$ = "Y": GOTO 12

10  HOME: VTAB 21: PRINT NA$;": PROGRESS IS SAVED."
11  PRINT "EXIT TO MENU (Y/N) ? ": GET A$: IF A$ <> "Y" AND A$ <> "N" THEN 10
12  IF A$ = "Y" THEN GOSUB 9000: PRINT CHR$(4);"RUN PROG/LAUNCH"
20  POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 5

100  HOME: FOR A = 0 TO 3
110  HTAB 1: VTAB 21: PRINT "NEW #";A+1;" IS OLD #";: GET A$: A%(A) = VAL(A$)-1: IF A%(A)<0 OR A%(A)>3 THEN 110
111  M = 0: FOR I = 0 TO A: M = M + (A%(I)=A%(A)): NEXT: IF M>1 THEN 110
120  HTAB 20: VTAB 21+A: PRINT A%(A)+1;"->";A+1;") ";LEFT$(NM$(A%(A)),14);: NEXT
130  HTAB 1: VTAB 21: PRINT "ORDER OK (Y/N) ";: GET A$:  IF A$ <> "Y" AND A$ <> "N" THEN 130
140  IF A$ = "N" THEN 100
150  RETURN

700  REM SAVE
705  PRINT : PRINT CHR$(4);"OPEN PARTIES/D.";NA$
710  PRINT CHR$(4);"WRITE PARTIES/D.";NA$
715  FOR A = 0 TO 3
720  PRINT NM$(A%(A))
725  PRINT RA$(A%(A))
730  PRINT CL$(A%(A))
735  PRINT ZA%(A%(A))
740  PRINT AB%(A%(A))
745  PRINT AC%(A%(A))
750  PRINT AF%(A%(A))
755  PRINT AG%(A%(A))
760  PRINT AH%(A%(A))
765  PRINT AI%(A%(A))
770  PRINT AJ%(A%(A))
775  PRINT AK%(A%(A))
780  PRINT DV$(A%(A))
785  PRINT DW$(A%(A))
790  PRINT DX$(A%(A))
795  PRINT WT%(A%(A))
800  FOR M = 0 TO 7: PRINT AP$(A%(A),M): NEXT
805  FOR M = 0 TO 15: PRINT AX$(A%(A),M): NEXT
810  NEXT
815  PRINT X
820  PRINT Y
825  PRINT AD%: PRINT AE: PRINT FL%: PRINT RM$
826  FOR I = 0 TO 5: PRINT FG%(I): NEXT I
830  PRINT CHR$(4);"CLOSE PARTIES/D.";NA$
841  GOSUB 9000: IF MD% = 1 THEN PRINT CHR$(4);"BSAVE PARTIES/";LEFT$(RM$,2);".";NA$;",A$6E00,L3200": MD% = 0
850  RETURN

9000  REM VERIFY DISK
9110  ONERR  GOTO 9200
9120  PRINT: PRINT  CHR$(4);"VERIFY START.REALM": POKE 216,0: RETURN
9200  HOME : VTAB 21: PRINT "PLEASE RESTORE DISK- ";: GET A$: CALL 768: PRINT : RESUME
