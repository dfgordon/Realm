* REALM MAP INTERPRETER

         ORG   $163E      ; ALLOWS BUFFER AT $1F00

* ZERO PAGE USAGE

FAC1     EQU   $06        ; FACTOR IN MULBB
FAC2     EQU   $07        ; FACTOR IN MULBB
PROD     EQU   $08        ; PRODUCT IN MULBB $08,$09
YEND     EQU   $1E
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
ZPTR     EQU   $FE        ; DENIZEN SUBMAP, GENERAL USE

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
MAPTYP   EQU   $1FF9      ; $00,$01,$02
HOSTILE  EQU   $1FFA
TRAVEL   EQU   $1FFB      ; $00,$10,$20
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

* OFFSETS TO PARTY SPRITES (PADDED)
* ADDR = WALKING + MAPTYP*2 + TRAVEL/2
WALKING  HEX   9801,8001,9801,0000
SAILING  HEX   0801,0801,0801,0000
FLYING   HEX   8001,8001,8001,0000

* ARRAYS OF FORBIDDEN TERRAIN CODES
* ADDR = FRBOUT + MAPTYP*24 + TRAVEL/2
* FIRST BYTE OF EACH ROW IS ARRAY SIZE
* NEGATIVE FIRST BYTE FLIPS TO ALLOWED
* NB ORDER CAN MATTER TO BASIC PROGS
FRBOUT   HEX   06,02,04,06,08,09,05,00
         HEX   FD,04,07,0E,00,00,00,00
         HEX   02,05,02,00,00,00,00,00
FRBTWN   HEX   04,04,05,06,0A,00,00,00
         HEX   FF,04,00,00,00,00,00,00
         HEX   00,00,00,00,00,00,00,00
FRBDNG   HEX   05,02,04,05,06,08,00,00
         HEX   FF,04,00,00,00,00,00,00
         HEX   00,00,00,00,00,00,00,00
FRBGRD   HEX   06,04,05,06,0A,0B,0C,00

* MOBILE DENIZEN CODES
* ACCESS AS MOBILE,X OR MOBILE+3,X WHERE X = MAPTYP
MOBILE   HEX   FF,11,0F,FF,19,0F
* ACESS AS DERASE,X WHERE X = MAPTYP
DERASE   HEX   00,0F,07

* DENIZENS FOR AN ORDERED COUNT
* FIRST BYTE IS ARRAY SIZE
TWNCOUNT HEX   06,09,0A,0B,0C,0D,0E
DNGCOUNT HEX   02,03,0D

* ROM ROUTINES

COUT     EQU   $FDED


* MACROS *****************************

         DO    0

* SIMPLE MATH

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
         JSR   MULBB
         <<<

MULA     MAC              ; PROD = V1 * A
         STA   FAC1
         LDA   ]1
         STA   FAC2
         JSR   MULBB
         <<<

MUL24    MAC              ; ONLY FOR 8 BITS
         ASL
         ASL
         ASL
         STA   FAC1
         ASL
         CLC
         ADC   FAC1
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

* MEMORY MANIPULATIONS

COPYW    MAC
         LDA   ]1
         STA   ]2
         LDA   ]1+1
         STA   ]2+1
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

SELNIB   MAC              ; X SELECTS NIBBLE
         STA   PROD+1
         LONIB
         STA   PROD
         LDA   PROD+1
         HINIB
         STA   PROD+1
         LDA   PROD,X
         <<<

* PARAMETER MANIPULATIONS

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

RESETXY  MAC
         CLC
         LDA   X0
         ADC   RNG
         STA   X0
         CLC
         LDA   Y0
         ADC   RNG
         STA   Y0
         <<<

ADVMROW  MAC
         ADDBW SPAN;SPTR
         LDA   COLS
         LSR
         ADDAW MPTR
         LDA   COLS
         LSR
         ADDAW ZPTR
         <<<

         DO    1


* SUBROUTINES ************************


* MULTIPLY TWO BYTES TO FORM A WORD

MULBB    LDA   #$00       ; MULTIPLY 8 BIT FACTORS
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
* RETURN: SCRPTR = POINTER TO 7 PIXEL SEGMENT
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

* PREVENT MOVING OFF MAP IN X
* IN: IDX, DX, COLS
* RETURN: A

XPREVENT CLC
         LDA   IDX
         ADC   DX
         BMI   :NEG
         CMP   COLS
         BPL   :POS
         LDA   #$00
         RTS
:NEG     LDA   #$FF
         RTS
:POS     LDA   #$01
         RTS

* PREVENT MOVING OFF MAP IN Y
* IN: IDY, DY, ROWS
* RETURN: A
* NB DUNGEONS CANNOT RELY ON N FLAG

YPREVENT CLC
         LDA   IDY
         ADC   DY
         CMP   #$FF
         BEQ   :NEG
         CMP   ROWS
         BEQ   :POS
         LDA   #$00
         RTS
:NEG     LDA   #$FF
         RTS
:POS     LDA   #$01
         RTS

* CHECK Y BOUNDS
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
:XLOOP   PHX
         TXA
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
         TAX              ; X = PARITY
         LDA   (MPTR),Y
         SELNIB
         STA   FAC1
         LDA   DOFF+1     ; IF 0 NO DENIZENS
         PHP
         LDA   FAC1
         PLP
         BEQ   :SAVE
         LDA   (ZPTR),Y
         SELNIB
         ADC   #$11
         CMP   #$1F
         BPL   :SAVE
         STA   FAC1
         JMP   :SAVE
:OUT     COPYW MAP0;PROD
         LDY   #$00
         LDA   (PROD),Y
         LONIB
         STA   FAC1
:SAVE    PLX
         TXA
         TAY
         LDA   FAC1
         STA   (SPTR),Y
         DEX
         BPL   :XLOOP
         INC   IDY
         ADVMROW
         PLY
         DEY
         BMI   :FIN
         JMP   :YLOOP
:FIN     LDA   #BUFFER    ; RESET SPTR
         STA   SPTR
         LDA   #>BUFFER
         STA   SPTR+1
         RTS

* IS TILE FORBIDDEN TO PARTY
* IN: FAC1,FAC2

CHKTIL   LDA   #FRBOUT
         STA   PROD
         LDA   #>FRBOUT
         STA   PROD+1
         LDA   TRAVEL
         LSR
         ADDAW PROD
         LDA   FAC1
         PHA
         LDA   MAPTYP
         MUL24
         ADDAW PROD
         PLA
         STA   FAC1
         LDY   #$00
         LDA   (PROD),Y   ; COUNT
         BMI   :FLIP      ; NEG COUNT FLIPS MEANING
         TAY
:TLOOP   BEQ   :TERROK
         LDA   (PROD),Y
         CMP   FAC1
         BEQ   :FORBID
         DEY
         JMP   :TLOOP
:TERROK  LDA   DOFF+1
         BEQ   :ALLOW
         LDA   HOSTILE
         BNE   :ALLOW
         LDA   FAC2
         BEQ   :FORBID
:ALLOW   LDA   #$00
         RTS
:FORBID  LDA   #$01
         RTS
:FLIP    EOR   #$FF
         TAY
         INY
:ALOOP   BEQ   :FORBID
         LDA   (PROD),Y
         CMP   FAC1
         BEQ   :TERROK
         DEY
         JMP   :ALOOP

* IS TILE FORBIDDEN TO DENIZENS
* IN: FAC1,FAC2

CHKDEN   LDA   MAPTYP
         CMP   #$02
         BEQ   :DNGN
         LDX   FRBGRD     ; COUNT
:TLOOP   BEQ   :TERROK
         LDA   FRBGRD,X
         CMP   FAC1
         BEQ   :FORBID
         DEX
         JMP   :TLOOP
:TERROK  LDA   FAC2
         CMP   #$0E
         BMI   :FORBID
         LDA   #$00
         RTS
:FORBID  LDA   #$01
         RTS
:DNGN    LDA   #$07
         CMP   FAC1
         BNE   :FORBID
         LDA   #$00
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
         PHA
         LSR
         TAY
         LDA   (MPTR),Y
         STA   FAC1
         LDA   (ZPTR),Y
         STA   FAC2
         SUBWW PROD;MPTR  ; SIGNED SUB
         SUBWW PROD;ZPTR
         PLA
         AND   #$01
         TAX              ; X = PARITY
         LDA   FAC1
         SELNIB           ; NB SPOILS PROD
         STA   FAC1
         LDA   FAC2
         SELNIB
         STA   FAC2
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
         PHA
         LSR
         TAY
         PLA
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

* ARTIFICIAL UNINTELLIGENCE (AU)
* IN: RNG, A = THE RELATIVE TILE INDEX
* IN: HOSTILE = $01,$FF (AGGRESSIVE,FEARFUL)
* RETURN: A = TILES TO MOVE (SIGNED BYTE)

DELTA    SEC
         SBC   RNG
         PHP
         BEQ   :TEST
:GO      PLP
         BMI   :GOPL
         LDA   HOSTILE
         EOR   #$FF
         CLC
         ADC   #$01
         RTS
:GOPL    LDA   HOSTILE
         RTS
:TEST    LDA   HOSTILE
         CMP   #$01
         BEQ   :NOGO
         JMP   :GO
:NOGO    PLP
         LDA   #$00
         RTS

* DENIZEN MOVEMENT (TOWN OR DUNGEON)
* IN: MPTR, ZPTR, X0, Y0, RNG, SPAN, HOSTILE
* DENIZENS MUST MOVE IN SEQUENCE ALONG X THEN Y
* THIS GIVES THE PLAYER AN ADVANTAGE

DMOVE    LDA   #BUFFER
         STA   SPTR
         LDA   #>BUFFER
         STA   SPTR+1
         LDA   Y0
         STA   IDY
         CLC
         ADC   SPAN
         STA   YEND
:YLOOP   LDX   SPAN
         DEX
:XLOOP   PHX
         TXA
         CLC
         ADC   X0
         STA   IDX
         TXA
         TAY
         LDA   (SPTR),Y
         LDY   MAPTYP
         CMP   MOBILE,Y
         BEQ   :MOVEX
         CMP   MOBILE+3,Y
         BEQ   :MOVEX
:NEXTX   PLX
         DEX
         BPL   :XLOOP
         JMP   :NEXTY
:MOVEX   LDA   #$00
         STA   DY
         TXA
         JSR   DELTA
         STA   DX
         BEQ   :MOVEY
:DX      JSR   XPREVENT
         BNE   :NOGOX
         JSR   GETTILE
         JSR   CHKDEN
         BNE   :NOGOX
         LDA   DX
         PHA
         LDA   #$00
         STA   DX
         JSR   GETTILE
         LDY   MAPTYP
         LDA   DERASE,Y
         JSR   SETTILE
         PLA
         STA   DX
         LDA   FAC2
         JSR   SETTILE
         JMP   :MOVEY
:NOGOX   LDA   #$00
         STA   DX
:MOVEY   SEC
         LDA   IDY
         SBC   Y0
         JSR   DELTA
         STA   DY
         BEQ   :NEXTX
:DY      JSR   YPREVENT
         BNE   :NEXTX
         JSR   GETTILE
         JSR   CHKDEN
         BNE   :NEXTX
         LDA   DY
         PHA
         LDA   #$00
         STA   DY
         JSR   GETTILE
         LDY   MAPTYP
         LDA   DERASE,Y
         JSR   SETTILE
         PLA
         STA   DY
         LDA   FAC2
         JSR   SETTILE
         JMP   :NEXTX
:NEXTY   ADVMROW
         INC   IDY
         LDA   IDY
         CMP   YEND
         BEQ   :FIN
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
:PARTY   PHY
         LDA   MAPTYP
         ASL
         STA   TEMP
         LDA   TRAVEL
         LSR
         CLC
         ADC   TEMP
         TAY
         LDA   WALKING,Y
         STA   ZPTR
         LDA   WALKING+1,Y
         STA   ZPTR+1
         ADDWW SADDR;ZPTR
         LDA   RNG
         ASL
         TAX
         LDA   ZPTR
         STA   STAB,X
         LDA   ZPTR+1
         STA   STAB+1,X
         PLY
         PLX
         RTS

* MAIN PAINT ROUTINE
* ASSUMES X0,Y0 ALREADY OFFSET

PAINT    JSR   INIMPTR
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

* PARTY MOVEMENT (MAIN ROUTINE)

PMOVE    JSR   GET
         JSR   CHKTIL
         BNE   :FORBID
         INITXY
         LDA   HOSTILE
         BEQ   :PAINT
         JSR   INIMPTR
         JSR   LDSUB
         JSR   INIMPTR
         JSR   DMOVE
:PAINT   JSR   PAINT
         RESETXY
         LDA   #$00
         STA   FAC1
         RTS
:FORBID  LDA   #$FF
         STA   FAC1
         RTS

* COUNT DENIZENS UP TO POSITION
* IN: X0,Y0,ROWS,COLS,MAP0,SCRPTR
* SCRPTR = PTR TO ARRAY OF COUNTABLE CODES
* RETURN: YEND HAS THE COUNT

CNTDEN   COPYW MAP0;MPTR
         COPYW MAP0;ZPTR
         ADDWW DOFF;ZPTR
         LDA   #$00
         STA   DX
         STA   DY
         STA   YEND       ; COUNTER

         LDA   #$00
         STA   IDY
:YLOOP   LDA   #$00
         STA   IDX
:XLOOP   LDA   IDX
         CMP   X0
         BNE   :READ
         LDA   IDY
         CMP   Y0
         BEQ   :STOP
:READ    JSR   GETTILE
         LDY   #$00
         LDA   (SCRPTR),Y
         TAY
:CLOOP   BEQ   :CONT
         LDA   (SCRPTR),Y
         CMP   FAC2
         BEQ   :COUNT
         DEY
         JMP   :CLOOP
:COUNT   INC   YEND
:CONT    INC   IDX
         LDA   IDX
         CMP   COLS
         BNE   :XLOOP
         ADVMROW
         INC   IDY
         LDA   IDY
         CMP   ROWS
         BNE   :YLOOP
:STOP    RTS


* FIND TREASURE TROVE ADDRESS
* IN: X0,Y0,ROWS,COLS,MAP0
* RETURN: ZPTR HAS ADDRESS, YEND HAS INDEX

TROVE    LDA   #DNGCOUNT
         STA   SCRPTR
         LDA   #>DNGCOUNT
         STA   SCRPTR+1
         JSR   CNTDEN
         COPYW MAP0;ZPTR
         LDA   #$40
         STA   PROD
         LDA   #$06
         STA   PROD+1
         ADDWW PROD;ZPTR  ; ADD 1600
         MUL   YEND;#$32
         ADDWW PROD;ZPTR  ; ADD 50*INDEX
         RTS

* FIND AND DISPLAY MONOLOGUE
* IN: X0,Y0,ROWS,COLS,MAP0
* RETURN: YEND HAS FIRST CHAR

MONO     LDA   #TWNCOUNT
         STA   SCRPTR
         LDA   #>TWNCOUNT
         STA   SCRPTR+1
         JSR   CNTDEN
         COPYW MAP0;ZPTR
         LDA   #$72
         STA   PROD
         LDA   #$06
         STA   PROD+1
         ADDWW PROD;ZPTR  ; ADD 1650
         MUL   YEND;#$78
         ADDWW PROD;ZPTR  ; ADD 120*INDEX
         LDY   #$00
         LDA   (ZPTR),Y
         STA   YEND       ; RETURN FIRST CHARACTER
:CLOOP   INY
         LDA   (ZPTR),Y
         BEQ   :FIN
         ORA   #$80
         JSR   COUT
         JMP   :CLOOP
:FIN     RTS
