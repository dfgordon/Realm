 0  GOSUB 700
 10  HOME: VTAB 21: PRINT NA$;": PROGRESS IS SAVED."
 11  PRINT "EXIT TO MENU (Y/N) ? ": GET A$: IF A$ <> "Y" AND A$ <> "N" THEN 10
 12  IF A$ = "Y" THEN PRINT: PRINT CHR$(4);"RUN PROG/LAUNCH"
 20  POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 5

 700  REM SAVE
 705  PRINT : PRINT CHR$(4);"OPEN PARTIES/D.";NA$
 710  PRINT CHR$(4);"WRITE PARTIES/D.";NA$
 715  FOR A = 0 TO 3
 720  PRINT NM$(A)
 725  PRINT RA$(A)
 730  PRINT CL$(A)
 735  PRINT ZA%(A)
 740  PRINT AB%(A)
 745  PRINT AC%(A)
 750  PRINT AF%(A)
 755  PRINT AG%(A)
 760  PRINT AH%(A)
 765  PRINT AI%(A)
 770  PRINT AJ%(A)
 775  PRINT AK%(A)
 780  PRINT DV$(A)
 785  PRINT DW$(A)
 790  PRINT DX$(A)
 795  PRINT WT%(A)
 800  FOR M = 0 TO 7: PRINT AP$(A,M): NEXT
 805  FOR M = 0 TO 15: PRINT AX$(A,M): NEXT
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
