* REALM MAP PAINTER

         ORG   $1200

* ZERO PAGE USAGE

FAC1     EQU   $06        ; FACTOR IN MUL8
FAC2     EQU   $07        ; FACTOR IN MUL8
PROD     EQU   $08        ; PRODUCT IN MUL8 $08,$09
DELTA    EQU   $1E
SPTR     EQU   $CE        ; BACKING SUBMAP $CE,$CF
IDX      EQU   $D7        ; OUTER LOOP INDEX 1
IDY      EQU   $E3        ; OUTER LOOP INDEX 2
SCRPTR   EQU   $EB        ; SCREEN POINTER $EB,$EC
DX       EQU   $ED
DY       EQU   $EE
TEMP     EQU   $EF
MPTR     EQU   $FA        ; INPLACE SUBMAP $FA,$FB
SROW1    EQU   $FC        ; ROW IN SPRITE
SROW2    EQU   $FD        ; ROW IN SPRITE
ZPTR     EQU   $FE        ; GENERAL USE POINTER

* VARIABLES

STAB     EQU   $1FC0      ; TABLE OF SPRITE PTRS
DOFF     EQU   $1FEE      ; OFFSET TO DENIZEN MAP
ROWS     EQU   $1FF0      ; MAP ROWS
COLS     EQU   $1FF1      ; MAP COLUMNS
YPIX     EQU   $1FF2
XPIX7    EQU   $1FF3
SPAN     EQU   $1FF4      ; 2*RNG+1
RNG      EQU   $1FF5      ; MAP VISIBLE RANGE
OFFSET   EQU   $1FF6      ; TILE OFFSETS, 2 NIBBLES
SADDR    EQU   $1FF7      ; PTR TO SPRITE TABLE
SCRATCH  EQU   $1FF9
HOSTILE  EQU   $1FFA
TRAVEL   EQU   $1FFB
MAP0     EQU   $1FFC      ; MAP POINTER
X0       EQU   $1FFE
Y0       EQU   $1FFF

SCREEN0  EQU   $2000      ; SCREEN ADDRESS
BUFFER   EQU   $1F00      ; SUBMAP BUFFER

* OFFSETS TO ALL SPRITES

SOFFSET  HEX   0000,1800,3000,4800
         HEX   6000,7800,9000,A800
         HEX   C000,D800,F000,0801
         HEX   2001,3801,5001,6801
         HEX   8001,9801,B001,C801
         HEX   E001,F801,1002,2802
         HEX   4002,5802,7002,8802
         HEX   A002,B802,D002,E802
         HEX   0003,1803,3003,4803

WALKING  EQU   $0980
FLYING   EQU   $0998      ; IN DNGSPS THIS IS WALKING
SAILING  EQU   $0908

* ARRAY OF FORBIDDEN TERRAIN CODES
* FIRST BYTE IS ARRAY COUNT
FORBT    HEX   060405060A0B0C000000000000000000
FORBD    HEX   0E000102030405060708090A0B0C0D00

* MOBILE DENIZEN CODES
MOBILE   HEX   11,19

* ROM ROUTINES

SETCOLOR EQU   $F6F0            ; ARG=X
BEGLINE  EQU   $F411            ; X,Y=HOR A=VER
ENDLINE  EQU   $F53A            ; A,X=HOR Y=VER
COUT     EQU   $FDED

* MACROS TO DO SIMPLE MATH
* THESE PRESERVE X AND Y

         DO    0

INC16    MAC
         INC   ]1
         BNE   CONT
         INC   ]1+1
CONT
         <<<

DEC16    MAC
         SEC
         LDA   ]1
         SBC   #$01
         STA   ]1
         LDA   ]1+1
         SBC   #$00
         STA   ]1+1
         <<<

NEGB     MAC
         LDA   ]1
         EOR   #$FF
         STA   ]1
         INC   ]1
         <<<

NEGW     MAC
         LDA   ]1
         EOR   #$FF
         STA   ]1
         LDA   ]1+1
         EOR   #$FF
         STA   ]1+1
         INC16 ]1
         <<<

DIV64    MAC
         LSR
         LSR
         LSR
         LSR
         LSR
         LSR
         <<<

MOD64    MAC
         AND   #$3F
         <<<

DIV8     MAC
         LSR
         LSR
         LSR
         <<<

MOD8     MAC
         AND   #$07
         <<<

MUL      MAC              ; PROD = V1 * V2
         LDA   ]1
         STA   FAC1
         LDA   ]2
         STA   FAC2
         JSR   MUL8
         <<<

MULA     MAC              ; PROD = V1 * A
         STA   FAC1
         LDA   ]1
         STA   FAC2
         JSR   MUL8
         <<<

MUL40    MAC              ; ONLY FOR 8 BITS
         STA   FAC1
         ASL
         ASL
         ASL
         ASL
         ASL
         STA   FAC2       ; FAC2=A*32
         LDA   FAC1
         ASL
         ASL
         ASL              ; A=A*8
         CLC
         ADC   FAC2
         <<<

MUL128   MAC
         STA   PROD
         LDA   #$00
         STA   PROD+1
         ASL   PROD
         ROL   PROD+1
         ASL   PROD
         ROL   PROD+1
         ASL   PROD
         ROL   PROD+1
         ASL   PROD
         ROL   PROD+1
         ASL   PROD
         ROL   PROD+1
         ASL   PROD
         ROL   PROD+1
         ASL   PROD
         ROL   PROD+1
         <<<

ADDAW    MAC              ; ADD A TO WORD1
         CLC
         ADC   ]1
         STA   ]1
         LDA   #$00
         ADC   ]1+1
         STA   ]1+1
         <<<

ADDBW    MAC              ; ADD BYTE1 TO WORD2
         CLC
         LDA   ]1
         ADC   ]2
         STA   ]2
         LDA   #$00
         ADC   ]2+1
         STA   ]2+1
         <<<

SUBBW    MAC              ; SUB BYTE1 FROM WORD2
         SEC
         LDA   ]2
         SBC   ]1
         STA   ]2
         LDA   ]2+1
         SBC   #$00
         STA   ]2+1
         <<<

ADDWW    MAC              ; ADD WORD1 TO WORD2
         CLC
         LDA   ]1
         ADC   ]2
         STA   ]2
         LDA   ]1+1
         ADC   ]2+1
         STA   ]2+1
         <<<

SUBWW    MAC              ; SUB WORD1 FROM WORD2
         SEC
         LDA   ]2
         SBC   ]1
         STA   ]2
         LDA   ]2+1
         SBC   ]1+1
         STA   ]2+1
         <<<

COPYW    MAC
         LDA   ]1
         STA   ]2
         LDA   ]1+1
         STA   ]2+1
         <<<

INITXY   MAC
         SEC
         LDA   X0
         SBC   RNG
         STA   X0
         SEC
         LDA   Y0
         SBC   RNG
         STA   Y0
         LDA   RNG
         ASL
         STA   SPAN
         INC   SPAN
         <<<

RESTXY   MAC
         CLC
         LDA   X0
         ADC   RNG
         STA   X0
         CLC
         LDA   Y0
         ADC   RNG
         STA   Y0
         <<<

PHX      MAC
         TXA
         PHA
         <<<

PHY      MAC
         TYA
         PHA
         <<<

PLX      MAC
         PLA
         TAX
         <<<

PLY      MAC
         PLA
         TAY
         <<<

LONIB    MAC
         AND   #$0F
         <<<

HINIB    MAC
         AND   #$F0
         LSR
         LSR
         LSR
         LSR
         <<<

         DO    1

* MULTIPLY TWO BYTES TO FORM A WORD

MUL8     LDA   #$00       ; MULTIPLY 8 BIT FACTORS
         STA   PROD
         STA   PROD+1
         PHX
         LDX   #$08       ; 8 BITS PER BYTE
:START   LSR   FAC1
         BCC   :CLEAR
         CLC
         LDA   PROD+1
         ADC   FAC2
         STA   PROD+1
:CLEAR   ROR   PROD+1
         ROR   PROD
         DEX
         BNE   :START
         PLX
         RTS

* GET SCREEN ADDRESS OF ANY 7 PIXEL SEGMENT
* IN: YPIX = PIXEL ROW, XPIX7 = PIXEL COLUMN / 7
* OUT: SCRPTR = POINTER TO 7 PIXEL SEGMENT
* ADDR = 8192 + 1024 * (Y%8) + 128 * (Y%64)/8 + 40 * Y/64
* NOTE: 128*(Y%64)/8 IS NOT 16*(Y%64) DUE TO TRUNCATION

GETSCR   LDA   #SCREEN0
         STA   SCRPTR
         LDA   #>SCREEN0
         STA   SCRPTR+1
         LDA   YPIX
         DIV64
         MUL40            ; EXPECT 8 BITS
         STA   PROD
         LDA   #$00
         STA   PROD+1
         ADDWW PROD;SCRPTR ; ADD 40*Y/64
         LDA   YPIX
         MOD64
         DIV8
         MUL128
         ADDWW PROD;SCRPTR ; ADD 128*(Y%64)/8
         LDA   YPIX
         MOD8
         STA   PROD+1     ; EFFECTIVE ASL*8
         LDA   #$00
         STA   PROD
         ASL   PROD+1
         ASL   PROD+1
         ADDWW PROD;SCRPTR ; ADD 1024*Y%8
         ADDBW XPIX7;SCRPTR
         RTS              ; ADDRESS IS IN SCRPTR

* ADVANCE PIXEL ROW
* BEATS DIRECT GETSCR CALL 7 OUT OF 8 TIMES

ADVPROW  INC   YPIX
         CLC
         LDA   SCRPTR+1
         ADC   #$04
         STA   SCRPTR+1
         CMP   #$40
         BPL   :RECALC
         RTS
:RECALC  JSR   GETSCR
         RTS

* CHECK Y BOUNDS (SPOILS X)
* IN: IDY
* RETURN: A
* NB DUNGEONS CANNOT RELY ON N FLAG
* THEREFORE MUST CHECK EACH CASE

YBOUNDS  LDX   #$FF
:NLOOP   CPX   IDY
         BEQ   :NEG
         DEX
         CPX   #$F9
         BNE   :NLOOP

         LDX   ROWS
         TXA
         CLC
         ADC   #$06
         STA   FAC1
:PLOOP   CPX   IDY
         BEQ   :POS
         INX
         CPX   FAC1
         BNE   :PLOOP

         LDA   #$00
         RTS
:NEG     LDA   #$FF
         RTS
:POS     LDA   #$01
         RTS

* INITIALIZE MAP ROW POINTERS
* IN: Y0, MAP0, DOFF, COLS

INIMPTR  LDA   Y0
         STA   IDY
         JSR   YBOUNDS
         CMP   #$FF
         BEQ   :NEG

:POS     LDA   Y0
         MULA  COLS
         COPYW PROD;MPTR
         LSR   MPTR+1
         ROR   MPTR
         ADDWW MAP0;MPTR ; MPTR = TERRAIN SUBMAP
         JMP   :DEN

:NEG     NEGB  Y0
         MUL   Y0;COLS
         COPYW PROD;ZPTR
         LSR   ZPTR+1
         ROR   ZPTR
         COPYW MAP0;MPTR
         SUBWW ZPTR;MPTR
         NEGB  Y0

:DEN     COPYW MPTR;ZPTR
         ADDWW DOFF;ZPTR ; ZPTR = DENIZEN SUBMAP
         RTS

* LOAD SUBMAP BUFFER
* IN: MPTR, ZPTR, X0, Y0, SPAN

LDSUB    LDA   #BUFFER
         STA   SPTR
         LDA   #>BUFFER
         STA   SPTR+1
         LDA   Y0
         STA   IDY
         LDY   SPAN
         DEY
:YLOOP   PHY
         JSR   YBOUNDS
         STA   TEMP
         LDX   SPAN
         DEX
:XLOOP   TXA
         CLC
         ADC   X0
         STA   IDX
         LSR
         TAY
         LDA   TEMP
         BNE   :OUT
         LDA   IDX
         BMI   :OUT
         CMP   COLS
         BPL   :OUT
         LDA   IDX
         AND   #$01
         BNE   :ODD
         LDA   (MPTR),Y
         LONIB
         STA   FAC1
         LDA   (ZPTR),Y
         LONIB
         STA   FAC2
         JMP   :SEL
:ODD     LDA   (MPTR),Y
         HINIB
         STA   FAC1
         LDA   (ZPTR),Y
         HINIB
         STA   FAC2
         JMP   :SEL
:OUT     COPYW MAP0;PROD
         LDY   #$00
         LDA   (PROD),Y
         LONIB
         STA   FAC1
         LDA   #$0F
:SEL     CMP   #$0E
         BPL   :TERR
         LDA   DOFF+1
         BEQ   :TERR
         LDA   FAC2
         ADC   #$11
         JMP   :SAVE
:TERR    LDA   FAC1
:SAVE    STA   FAC1
         TXA
         TAY
         LDA   FAC1
         STA   (SPTR),Y
         DEX
         BPL   :XLOOP
         INC   IDY
         ADDBW SPAN;SPTR
         LDA   COLS
         LSR
         ADDAW MPTR
         LDA   COLS
         LSR
         ADDAW ZPTR
         PLY
         DEY
         BMI   :FIN
         JMP   :YLOOP
:FIN     LDA   #BUFFER    ; RESET SPTR
         STA   SPTR
         LDA   #>BUFFER
         STA   SPTR+1
         RTS

* IS TILE FORBIDDEN

CKFORB   PHX

         LDX   FORBT      ; COUNT
:TLOOP   BEQ   :FINT
         LDA   FORBT,X
         CMP   FAC1
         BEQ   :YES
         DEX
         JMP   :TLOOP

:FINT    LDX   FORBD      ; COUNT
:DLOOP   BEQ   :FIND
         LDA   FORBD,X
         CMP   FAC2
         BEQ   :YES
         DEX
         JMP   :DLOOP

:FIND    PLX
         LDA   #$00
         RTS

:YES     PLX
         LDA   #$01
         RTS

* GET TERRAIN AND DENIZEN
* IN: MPTR, ZPTR, IDX, DX, DY
* DY MUST BE ONE OF (-1,0,1)

GETTILE  LDA   COLS
         LSR
         STA   PROD
         LDA   #$00
         STA   PROD+1     ; PROD IS ROW OFFSET
         LDA   DY
         BEQ   :NONE
         BMI   :DECY
         JMP   :CONT
:NONE    LDA   #$00
         STA   PROD
         JMP   :CONT
:DECY    NEGW  PROD
:CONT    ADDWW PROD;MPTR  ; SIGNED ADD
         ADDWW PROD;ZPTR
         LDA   IDX
         CLC
         ADC   DX
         LSR
         TAY
         LDA   IDX
         CLC
         ADC   DX
         AND   #$01
         BNE   :ODD
         LDA   (MPTR),Y
         LONIB
         STA   FAC1
         LDA   (ZPTR),Y
         LONIB
         STA   FAC2
         JMP   :FIN
:ODD     LDA   (MPTR),Y
         HINIB
         STA   FAC1
         LDA   (ZPTR),Y
         HINIB
         STA   FAC2
:FIN     SUBWW PROD;MPTR  ; SIGNED SUB
         SUBWW PROD;ZPTR
         RTS

* SET ANY MAP TILE
* IN: A, ZPTR, IDX, DX, DY
* DY MUST BE ONE OF (-1,0,1)

SETTILE  STA   TEMP
         LDA   COLS
         LSR
         STA   PROD
         LDA   #$00
         STA   PROD+1     ; PROD IS ROW OFFSET
         LDA   DY
         BEQ   :NONE
         BMI   :DECY
         JMP   :CONT
:NONE    LDA   #$00
         STA   PROD
         JMP   :CONT
:DECY    NEGW  PROD
:CONT    ADDWW PROD;ZPTR  ; SIGNED ADD
         LDA   IDX
         CLC
         ADC   DX
         LSR
         TAY
         LDA   IDX
         CLC
         ADC   DX
         AND   #$01
         BNE   :ODD
         LDA   (ZPTR),Y
         AND   #$F0
         ORA   TEMP
         STA   (ZPTR),Y
         JMP   :FIN
:ODD     ASL   TEMP
         ASL   TEMP
         ASL   TEMP
         ASL   TEMP
         LDA   (ZPTR),Y
         AND   #$0F
         ORA   TEMP
         STA   (ZPTR),Y
:FIN     SUBWW PROD;ZPTR  ; SIGNED SUB
         RTS

* DENIZEN MOVEMENT
* IN: MPTR, ZPTR, X0, SPAN
* GUARDS MUST MOVE IN SEQUENCE ALONG X THEN Y
* THIS GIVES THE PLAYER AN ADVANTAGE

DMOVE    LDA   #BUFFER
         STA   SPTR
         LDA   #>BUFFER
         STA   SPTR+1
         LDY   SPAN
         DEY
:YLOOP   PHY
         LDX   SPAN
         DEX
:XLOOP   TXA
         CLC
         ADC   X0
         STA   IDX
         TXA
         TAY
         LDA   (SPTR),Y
         CMP   MOBILE
         BEQ   :MOVEX
         CMP   MOBILE+1
         BEQ   :MOVEX
:NEXTX   DEX
         BPL   :XLOOP
         JMP   :NEXTY
:MOVEX   LDA   #$00
         STA   DX
         STA   DY
         CPX   RNG
         BEQ   :MOVEY
         BMI   :XNEG
         LDA   #$FF
         STA   DX
         JMP   :DX
:XNEG    LDA   #$01
         STA   DX
:DX      JSR   GETTILE
         JSR   CKFORB
         BNE   :NOGOX
         LDA   DX
         PHA
         LDA   #$00
         STA   DX
         JSR   GETTILE
         LDA   #$0F
         JSR   SETTILE
         PLA
         STA   DX
         LDA   FAC2
         JSR   SETTILE
         JMP   :MOVEY
:NOGOX   LDA   #$00
         STA   DX
:MOVEY   PLY
         PHY
         CPY   RNG
         BEQ   :NEXTX
         BMI   :YPOS      ; NB REVERSE ORDER
         LDA   #$01
         STA   DY
         JMP   :DY
:YPOS    LDA   #$FF
         STA   DY
:DY      JSR   GETTILE
         JSR   CKFORB
         BNE   :NEXTX
         LDA   DY
         PHA
         LDA   #$00
         STA   DY
         JSR   GETTILE
         LDA   #$0F
         JSR   SETTILE
         PLA
         STA   DY
         LDA   FAC2
         JSR   SETTILE
         JMP   :NEXTX
:NEXTY   ADDBW SPAN;SPTR
         LDA   COLS
         LSR
         ADDAW MPTR
         LDA   COLS
         LSR
         ADDAW ZPTR
         PLY
         DEY
         BMI   :FIN
         JMP   :YLOOP
:FIN     LDA   #BUFFER    ; RESET SPTR
         STA   SPTR
         LDA   #>BUFFER
         STA   SPTR+1
         RTS

* LOAD CURRENT ROW OF SPRITE PTRS INTO STAB
* IN: SPAN, SPTR=CURRENT SUBMAP ROW

LDSTAB   PHX
         PHY
         LDY   SPAN
         DEY
:LOOP    LDA   (SPTR),Y
         ASL
         TAX
         LDA   SOFFSET,X
         STA   ZPTR
         LDA   SOFFSET+1,X
         STA   ZPTR+1
         ADDWW SADDR;ZPTR ; ZPTR HAS ADDR OF SPRITE
         TYA
         ASL
         TAX
         LDA   ZPTR
         STA   STAB,X
         LDA   ZPTR+1
         STA   STAB+1,X
         DEY
         BPL   :LOOP
         PLY
         CPY   RNG
         BEQ   :PARTY
         PLX
         RTS
:PARTY   LDA   RNG
         ASL
         TAX
         LDA   #WALKING
         STA   STAB,X
         LDA   #>WALKING
         STA   STAB+1,X
         PLX
         RTS

* MAIN PAINT ROUTINE

PAINT    INITXY
         JSR   INIMPTR
         JSR   LDSUB
         LDA   HOSTILE
         BEQ   :PAINT
         JSR   INIMPTR
         JSR   DMOVE
         JSR   INIMPTR
         JSR   LDSUB
:PAINT   LDA   OFFSET
         LONIB            ; TILE ROWS
         MULA  #$0C
         LDA   PROD       ; EXPECT 8 BITS
         STA   YPIX       ; STARTING PIX ROW
         LDA   OFFSET
         HINIB            ; TWICE TILE COLS
         STA   XPIX7
         JSR   GETSCR     ; INIT SCRPTR PTR

         LDY   SPAN
         DEY

:YLOOP   PHY              ; LOOP OVER ROWS
         JSR   LDSTAB     ; LOAD SPRITE PTRS
         LDA   #$00
         STA   SROW1
         LDA   #$0C
         STA   SROW2

:PLOOP   LDA   SPAN       ; LOOP OVER PIXEL ROWS
         ASL
         TAX

:XLOOP   LDA   STAB-2,X     ; LOOP OVER COLUMNS
         STA   ZPTR
         LDA   STAB-1,X
         STA   ZPTR+1

         LDY   SROW1
         LDA   (ZPTR),Y
         STA   FAC1
         LDY   SROW2
         LDA   (ZPTR),Y
         STA   FAC2

         TXA
         TAY
         LDA   FAC1
         STA   (SCRPTR),Y ; PAINT LEFT SEGMENT
         INY
         LDA   FAC2
         STA   (SCRPTR),Y ; PAINT RIGHT SEGMENT

         DEX
         DEX
         BNE   :XLOOP

         JSR   ADVPROW    ; ADV SCRPTR 1 ROW
         INC   SROW1
         INC   SROW2

         LDA   SROW1
         CMP   #$0C
         BNE   :PLOOP

         ADDBW SPAN;SPTR  ; ADV SUBMAP PTR 1 ROW
         PLY
         DEY
         BPL   :YLOOP
         RESTXY
         RTS

* GET TILE INFORMATION (NOT FOR INNER LOOPS)
* IN: X0, Y0, MAP0, DOFF, COLS
* RETURN: TERRAIN IN FAC1, DENIZEN IN FAC2

GET      JSR   INIMPTR
         LDA   X0
         STA   IDX
         LDA   #$00
         STA   DX
         STA   DY
         JSR   GETTILE
         RTS

* SET TILE INFORMATION (NOT FOR INNER LOOPS)
* IN: X0, Y0, MAP0, DOFF, COLS, FAC1, FAC2
* NEGATIVE CODES ARE NOT WRITTEN

SET      LDA   FAC1
         PHA
         LDA   FAC2
         PHA
         JSR   INIMPTR
         LDA   X0
         STA   IDX
         LDA   #$00
         STA   DX
         STA   DY
         PLA
         BMI   :TERR
         JSR   SETTILE
:TERR    COPYW MPTR;ZPTR
         PLA
         BMI   :FIN
         JSR   SETTILE
:FIN     RTS


* DRAW A BOX FROM (ZPTR,YPIX) TO (SPTR,IDY)

DRAWBOX  LDX   ZPTR
         LDY   ZPTR+1
         LDA   YPIX
         JSR   BEGLINE

         LDA   SPTR
         LDX   SPTR+1
         LDY   YPIX
         JSR   ENDLINE

         LDA   SPTR
         LDX   SPTR+1
         LDY   IDY
         JSR   ENDLINE

         LDA   ZPTR
         LDX   ZPTR+1
         LDY   IDY
         JSR   ENDLINE

         LDA   ZPTR
         LDX   ZPTR+1
         LDY   YPIX
         JSR   ENDLINE

         RTS

FRAME    LDX   #$06
         JSR   SETCOLOR
         LDA   OFFSET
         LONIB            ; TILE ROWS
         MULA  #$0C
         LDA   PROD       ; EXPECT 8 BITS
         CMP   #$03
         BPL   :CONT
         RTS              ; NO ROOM FOR FRAME
:CONT    STA   YPIX
         DEC   YPIX
         DEC   YPIX       ; TOP
         LDA   OFFSET
         HINIB            ; TWICE TILE COLS
         MULA  #$07
         LDA   #$0A
         ADDAW PROD
         COPYW PROD;ZPTR  ; LEFT

         LDA   RNG
         ASL
         STA   SPAN
         INC   SPAN
         LDA   #$0E
         MULA  SPAN
         LDA   #$06
         ADDAW PROD
         ADDWW ZPTR;PROD
         COPYW PROD;SPTR  ; RIGHT
         LDA   #$0C
         MULA  SPAN
         CLC
         LDA   YPIX
         ADC   PROD
         ADC   #$03
         STA   IDY       ; BOTTOM

         JSR   DRAWBOX
         DEC   YPIX
         INC   IDY
         DEC16 ZPTR
         DEC16 ZPTR
         INC16 SPTR
         INC16 SPTR
         JSR   DRAWBOX
         RTS
