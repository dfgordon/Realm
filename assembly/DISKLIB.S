* AMPERSAND COMMANDS TO GET VOLUMES AND COPY FILES
* &("VOLS",VO$,CAP,N)
*    VO$(16) RECEIVES THE NAMES
*    CAP(16) RECEIVES THE AVAILABLE BLOCKS
*    N RECEIVES NUMBER FOUND (N MUST EXIST)
* &("COPY",<EXPR1>,<EXPR2>,<EXPR3>,<EXPR4>)
*    <EXPR1>-<EXPR4> ARE STRING EXPRESSIONS
*    1 = SRC PREFIX, 2 = SRC PATH
*    3 = DST PREFIX, 4 = DST PATH
*    NB NULL PREFIX CLEARS THE PREFIX
* USES FIXED BUFFERS FROM $4600 to $5300
* ONERR HANDLERS MAY RECEIVE MLI CODES
* POKE 8,0 TO SUPPRESS DEBUG MESSAGES

         ORG   $4000

* MY ZERO PAGE

STAT     =     $06        ; PRODOS MLI ERROR CODE
OMAP     =     $07        ; BITMAP OF OPEN FILES
DBG      =     $08        ; DEBUG FLAG
VCOUNT   =     $1E        ; VOLUMES ONLINE
VPTR     =     $CE        ; VOLUME STRING ARRAY
CPTR     =     $EB        ; CAPACITY FP ARRAY
NPTR     =     $FA        ; COUNT VARIABLE
ZPTR     =     $FC        ; GENERAL PTR

* PRODOS MLI AND PARAMS

MLI_ADDR =     $BF00
VOLBUF   =     $4600      ; PREFIX STRINGS WITH LEN
SRC_PRE  =     $4700
SRC_PTH  =     $4740
DST_PRE  =     $4780
DST_PTH  =     $47C0
PATHBUF  =     $4800
SRC_BUF  =     $4900
DST_BUF  =     $4D00
WRKBUF   =     $5100
CREATE   =     $C0
SETFINF  =     $C3
GETFINF  =     $C4
ONLINE   =     $C5
PREFIX   =     $C6
OPEN     =     $C8
READ     =     $CA
WRITE    =     $CB
CLOSE    =     $CC
SETMRK   =     $CE
GETMRK   =     $CF
SETEOF   =     $D0
GETEOF   =     $D1

* ROM POINTERS AND CONSTANTS

ILLQTY   =     $35        ; ILLEGAL QUANTITY
STRLNG   =     $B0        ; STRING TOO LONG
BADSUB   =     $6B        ; BAD SUBSCRIPT
ERRFLG   =     $D8
DSCTMP   =     $9D        ; STRING DESC = LEN,LO,HI
INDEX    =     $5E        ; STR PTR
FAC      =     $9D        ; FP ACCUMULATOR
VARPNT   =     $83
LOWTR    =     $9B
TXTPTR   =     $B8
VALTYP   =     $11        ; $00=NUM, $FF=STR
INTFLG   =     $12        ; $00=NO, $80=YES

* ROM ROUTINES

BELL     =     $FF3A
PRBYTE   =     $FDDA
COUT     =     $FDED
DATA     =     $D995
CHRGET   =     $B1
CHRGOT   =     $B7
CHKCOM   =     $DEBE
CHKOPN   =     $DEBB
CHKCLS   =     $DEB8
PTRGET   =     $DFE3
ARYGET   =     $F7D9
FRMEVL   =     $DD7B
STRINI   =     $E3D5
MOVSTR   =     $E5E2
GETSTR   =     $E6DC      ; CHECKS AND FREES TEMP STR
                          ; STR CAN BE ACCESSED AT (INDEX)
                          ; UNTIL OVERWRITTEN
MOVMF    =     $EB2B
MOVFM    =     $EAF9
FLOAT2   =     $EBA0
INT2FP   =     $E2F2
SNERR    =     $DEC9
DOERR    =     $D412
RESTART  =     $D43C
STKINI   =     $D683

MLI      MAC
         JSR   MLI_ADDR
         DFB   ]1
         DW    ]2
         STA   STAT       ; STORE ERR CODE
         CMP   #$00
         <<<

MKPTR    MAC
         LDA   #<]1
         STA   ]2
         LDA   #>]1
         STA   ]2+1
         <<<

ADPTR    MAC
         CLC
         LDA   ]1
         ADC   ]2
         STA   ]2
         LDA   #$00
         ADC   ]2+1
         STA   ]2+1
         <<<

CP16     MAC
         LDA   ]1
         STA   ]2
         LDA   ]1+1
         STA   ]2+1
         <<<

CP24     MAC
         LDA   ]1
         STA   ]2
         LDA   ]1+1
         STA   ]2+1
         LDA   ]1+2
         STA   ]2+2
         LDA   ]1+3
         STA   ]2+3
         <<<

PATH     MAC
         LDY   #$00
]LOOP    LDA   ]1,Y
         STA   PATHBUF,Y
         INY
         CPY   #$40
         BNE   ]LOOP
         <<<

* MAIN AMPERSAND COMMAND DISPATCHER
* KEEP THIS AS THE FIRST ADDRESSABLE ITEM
DISPATCH LDA   #$00
         STA   STAT
         JSR   CHKOPN
         CMP   #'"'
         BEQ   :CONT
         JMP   SNERR
:CONT    JSR   DEBUGT
         MKPTR AMPCPY;ZPTR
         JSR   TRYCMD
         BNE   :COPY
         MKPTR AMPVOL;ZPTR
         JSR   TRYCMD
         BNE   :GETVOL
         JMP   SNERR

:COPY    MKPTR SRC_PRE;ZPTR
         JSR   SX2ZPTR
         MKPTR SRC_PTH;ZPTR
         JSR   SX2ZPTR
         MKPTR DST_PRE;ZPTR
         JSR   SX2ZPTR
         MKPTR DST_PTH;ZPTR
         JSR   SX2ZPTR
         JSR   CHKCLS
         JSR   DBGPTHS
         JSR   COPY
         JMP   :FIN

:GETVOL  JSR   CHKCOM
         JSR   DEBUGT
         JSR   ARYGET
         JSR   CHKSTR
         JSR   CHKARY
         CP16  LOWTR;VPTR
         JSR   CHKCOM
         JSR   DEBUGT
         JSR   ARYGET
         JSR   CHKFP
         JSR   CHKARY
         CP16  LOWTR;CPTR
         JSR   CHKCOM
         JSR   DEBUGT
         JSR   PTRGET
         JSR   CHKFP
         CP16  VARPNT;NPTR
         JSR   DEBUGT
         JSR   CHKCLS
         JSR   GETVOL

:FIN     LDA   STAT
         BNE   :DSKERR
         JMP   DATA       ; NEXT APPLESOFT STATEMENT
:DSKERR  BIT   ERRFLG
         BMI   :ONERR
         JSR   BELL       ; TAKE OVER PRINTING ERROR MSG
         LDY   #$00
:PR      LDA   GENERR,Y
         CMP   #$00
         BEQ   :PRCODE
         JSR   COUT
         INY
         JMP   :PR
:PRCODE  LDA   STAT
         JSR   PRBYTE
         JSR   STKINI
         JMP   RESTART
:ONERR   LDX   STAT       ; MLI CODE TO ONERR HANDLER
         JMP   DOERR

* PRINT PREFIXED STR AT ZPTR
DEBUGS   LDA   DBG
         BEQ   :FIN
         LDY   #$00
         LDA   (ZPTR),Y
         BEQ   :NULL
         TAX
:LOOP    INY
         LDA   (ZPTR),Y
         ORA   #$80
         JSR   COUT
         DEX
         BEQ   :CR
         JMP   :LOOP
:NULL    LDA   #"*"
         JSR   COUT
:CR      LDA   #$8D
         JSR   COUT
:FIN     RTS

* PRINT PATH BUFFERS
DBGPTHS  MKPTR SRC_PRE;ZPTR
         JSR   DEBUGS
         MKPTR SRC_PTH;ZPTR
         JSR   DEBUGS
         MKPTR DST_PRE;ZPTR
         JSR   DEBUGS
         MKPTR DST_PTH;ZPTR
         JSR   DEBUGS
         RTS

* PRINT Y DEBUG BYTES AT ZPTR IN REVERSE ORDER
* Y MUST NOT EXCEED $7F
DEBUGY   LDA   DBG
         BEQ   :FIN
         LDA   #"<"
         JSR   COUT
         DEY
:LOOP    LDA   (ZPTR),Y
         JSR   PRBYTE
         DEY
         BPL   :LOOP
         LDA   #">"
         JSR   COUT
         LDA   #$8D
         JSR   COUT
:FIN     RTS

* PRINT CURRENT PARSING CHARACTER
DEBUGT   PHA
         LDA   DBG
         BEQ   :FIN
         TYA
         PHA
         LDY   #$00
         LDA   (TXTPTR),Y
         ORA   #$80
         JSR   COUT
         PLA
         TAY
:FIN     PLA
         RTS

* CHECK FOR COMMAND, PATTERN AT (ZPTR) MUST END IN QUOTE
* IF NO MATCH TXTPTR IS REWOUND
TRYCMD   LDA   TXTPTR
         PHA
         LDA   TXTPTR+1
         PHA
         LDY   #$01       ; FIRST QUOTE ALREADY GOT
:LOOP    JSR   CHRGET
         JSR   DEBUGT
         CMP   (ZPTR),Y
         BEQ   :MATCH
         PLA
         STA   TXTPTR+1
         PLA
         STA   TXTPTR
         LDA   #$00
         RTS
:MATCH   CMP   #$22
         BEQ   :FIN
         INY
         JMP   :LOOP
:FIN     PLA
         PLA
         JSR   CHRGET     ; ADVANCE TO NEXT
         LDA   #$01
         RTS

* LOAD STRING EXPR INTO ZPTR
* JMP TO ERR IF NOT STRING OR STRING TOO LONG
SX2ZPTR  JSR   CHKCOM
         JSR   FRMEVL
         JSR   GETSTR
         TAX              ; DECREASING LOOP VAR
         LDY   #$00       ; INCREASING LOOP VAR
         STA   (ZPTR),Y   ; LEN PREFIX
:LOOP    LDA   (INDEX),Y
         INY
         STA   (ZPTR),Y
         CPY   #$3F
         BNE   :OK
         LDX   #STRLNG
         JMP   DOERR
:OK      DEX
         BEQ   :FIN
         JMP   :LOOP
:FIN     RTS

* LOAD STR AT ZPTR INTO ARRAY ELEMENT AT VPTR
LDSTR    LDY   #$00
         LDA   (ZPTR),Y
         AND   #$0F
         PHA              ; STRING LEN TO STACK
         JSR   STRINI
         LDY   #$00
         LDA   DSCTMP
         STA   (VPTR),Y
         INY
         LDA   DSCTMP+1
         STA   (VPTR),Y
         INY
         LDA   DSCTMP+2
         STA   (VPTR),Y
         PLA
         LDX   ZPTR
         LDY   ZPTR+1
         INX              ; EXPECT TO STAY ON PAGE
         JSR   MOVSTR
         RTS

* GET AVAILABLE BLOCKS OF VOLUME WITH NAME AT ZPTR
* PUT RESULT IN CPTR, ERR RETURNED IN STAT
LDFP     LDY   #$00
         LDA   (ZPTR),Y
         AND   #$0F
         STA   PATHBUF    ; LENGTH
         INC   PATHBUF    ; SLASH ADDS 1
         LDA   #'/'
         STA   PATHBUF+1
:LOOP    INY
         CPY   #$10
         BEQ   :READY
         LDA   (ZPTR),Y
         STA   PATHBUF+1,Y
         JMP   :LOOP
:READY   LDA   #$0A
         STA   FPARMS
         MLI   GETFINF;FPARMS
         BEQ   :OK
         RTS              ; ERR
:OK      SEC
         LDA   AUX
         SBC   USED
         PHA
         LDA   AUX+1
         SBC   USED+1
         STA   FAC+1
         PLA
         STA   FAC+2      ; BE-UNSIGNED IS IN FAC+1
         LDX   #$90       ; EXPONENT
         SEC              ; POSITIVE NUMBER FLAG
         JSR   FLOAT2     ; CAPACITY IS IN FAC
         LDX   CPTR
         LDY   CPTR+1
         JSR   MOVMF
         RTS

CHKSTR   LDA   VALTYP
         BMI   :STR
         JMP   SNERR
:STR     RTS

CHKFP    LDA   VALTYP
         BPL   :NUM
         JMP   SNERR
:NUM     LDA   INTFLG
         BPL   :FP
         JMP   SNERR
:FP      RTS

* CHECK ARRAY LEN>15 AND DIMS=1
CHKARY   CP16  LOWTR;ZPTR
         LDY   #$07
         JSR   DEBUGY
         LDY   #$04
         LDA   (LOWTR),Y  ; DIMS
         CMP   #$01
         BEQ   :DIMOK
         LDX   #BADSUB
         JMP   DOERR
:DIMOK   LDY   #$05       ; LEN IS BIG-ENDIAN
                          ; WORDS ALSO REVERSE ORDER
         LDA   (LOWTR),Y
         BNE   :LENOK
         INY
         LDA   (LOWTR),Y
         AND   #$F0
         BNE   :LENOK
         LDX   #BADSUB
         JMP   DOERR
:LENOK   RTS

* GET VOLUME INFO
* LOAD NAMES INTO STR ARRAY AT VPTR
* LOAD BLOCKS INTO FP ARRAY AT CPTR
* LOAD COUNT INTO FP VARIABLE AT NPTR
* ERR IS RETURNED IN STAT
GETVOL   MLI   ONLINE;VPARMS ; 16 BYTE ENTRIES IN STRBUF
         BEQ   :OK
         RTS              ; ERR
:OK      MKPTR VOLBUF;ZPTR
         ADPTR #$07;VPTR
         ADPTR #$07;CPTR
         LDA   #$00
         STA   VCOUNT
:LOOP    LDY   #$00
         LDA   (ZPTR),Y   ; LO-NIB = LEN, HI-NIB = ERR
         BEQ   :FIN       ; NO MORE
         AND   #$0F
         BEQ   :REP       ; SLOT/DRIVE EMPTY
         JSR   LDSTR
         JSR   LDFP
         LDA   STAT
         BEQ   :OK2
         RTS              ;ERR
:OK2     ADPTR #$03;VPTR
         ADPTR #$05;CPTR
         INC   VCOUNT
:REP     ADPTR #$10;ZPTR  ; NEXT SLOT/DRIVE
         JMP   :LOOP
:FIN     LDY   VCOUNT     ; PUT VCOUNT IN LAST ARG
         LDA   #$00
         JSR   INT2FP
         LDX   NPTR
         LDY   NPTR+1
         JSR   MOVMF
         RTS

* COPY FILE INFO --> CREATE INFO
COPYINFO LDA   ACCESS
         STA   CRACCESS
         LDA   FTYP
         STA   CRFTYP
         CP16  AUX;CRAUX
         LDA   STYP
         STA   CRSTYP
         CP24  CRTIME;CRCRTIME
         RTS

* IF MARKER IS EOF RETURN 1, ELSE 0
CHKEOF   MKPTR MPOS;ZPTR
         LDY   #$03
         JSR   DEBUGY
         LDA   MPOS
         CMP   EOF
         BNE   :NOT_EOF
         LDA   MPOS+1
         CMP   EOF+1
         BNE   :NOT_EOF
         LDA   MPOS+2
         CMP   EOF+2
         BNE   :NOT_EOF
         LDA   #$01
         RTS
:NOT_EOF LDA   #$00
         RTS

* COPY FILE, ERR RETURNED IN STAT
COPY     LDA   #$00
         STA   OMAP
         PATH  SRC_PRE
         MLI   PREFIX;PRPARMS
         BEQ   :SPOK
         JMP   :CLS
:SPOK    PATH  SRC_PTH
         LDA   #$0A
         STA   FPARMS
         MLI   GETFINF;FPARMS
         BEQ   :CREATE
         JMP   :CLS
:CREATE  JSR   COPYINFO
         PATH  DST_PRE
         MLI   PREFIX;PRPARMS
         BEQ   :DPOK
         JMP   :CLS
:DPOK    PATH  DST_PTH
         MLI   CREATE;CRPARMS
         BEQ   :SRC_OP    ; NEW
         CMP   #$47       ; DUPLICATE FILENAME
         BEQ   :OVRWRT
         JMP   :CLS
:OVRWRT  LDA   #$07
         STA   FPARMS
         MLI   SETFINF;FPARMS
         BEQ   :SRC_OP
         JMP   :CLS
:SRC_OP  PATH  SRC_PRE
         MLI   PREFIX;PRPARMS
         PATH  SRC_PTH
         MLI   OPEN;SRCPARMS
         BEQ   :GETEOF
         JMP   :CLS
:GETEOF  LDA   OMAP
         ORA   #$01       ; SRC IS OPEN
         STA   OMAP
         LDA   SRC_REF
         STA   EREF
         MLI   GETEOF;EPARMS
         BEQ   :DST_OP
         JMP   :CLS
:DST_OP  PATH  DST_PRE
         MLI   PREFIX;PRPARMS
         PATH  DST_PTH
         MLI   OPEN;DSTPARMS
         BEQ   :BEGIN
         JMP   :CLS
:BEGIN   LDA   OMAP
         ORA   #$02       ; DST IS OPEN
         STA   OMAP
         LDA   SRC_REF
         STA   RDREF
         STA   MREF
         LDA   DST_REF
         STA   WRREF
:LOOP    MLI   READ;RDPARMS
         BNE   :CLS
         CP16  RDACTUAL;WRREQ
         MLI   WRITE;WRPARMS
         BNE   :CLS
         MLI   GETMRK;MPARMS
         JSR   CHKEOF
         BEQ   :LOOP
         LDA   DST_REF
         STA   EREF
         MLI   SETEOF;EPARMS
:CLS     LDA   STAT
         PHA              ; SAVE LAST STAT
         LDA   OMAP
         AND   #$02
         BEQ   :CLS2
         LDA   DST_REF
         STA   CLREF
         MLI   CLOSE;CLPARMS
:CLS2    LDA   OMAP
         AND   #$01
         BEQ   :FIN
         LDA   SRC_REF
         STA   CLREF
         MLI   CLOSE;CLPARMS
:FIN     PLA
         STA   STAT       ; RESTORE STAT
         RTS

AMPCPY   ASC   '"COPY"'
AMPVOL   ASC   '"VOLS"'
GENERR   ASC   "PRODOS MLI ERR $",00

* PRODOS MLI PARAMETER BLOCKS

* VOLUME INFO
VPARMS   DFB   2
         DFB   0          ; ALL SLOTS AND DRIVES
         DW    VOLBUF

* OPEN SOURCE FILE
SRCPARMS DFB   3
         DW    PATHBUF
         DW    SRC_BUF       ; 1K
SRC_REF  DFB   0

* OPEN DESTINATION FILE
DSTPARMS DFB   3
         DW    PATHBUF
         DW    DST_BUF       ; 1K
DST_REF  DFB   0

* READ ANY FILE
RDPARMS  DFB   4
RDREF    DFB   0
RDBUF    DW    WRKBUF
RDREQ    DW    $200
RDACTUAL DW    0

* WRITE ANY FILE
WRPARMS  DFB   4
WRREF    DFB   0
WRBUF    DW    WRKBUF
WRREQ    DW    $200
WRACTUAL DW    0

* CLOSE ANY FILE
CLPARMS  DFB   1
CLREF    DFB   0

* SET/GET INFO
FPARMS   DFB   10         ; CHANGE TO 7 FOR SET
                          ; CHANGE TO 10 FOR GET
         DW    PATHBUF
ACCESS   DFB   0
FTYP     DFB   0
AUX      DW    0
STYP     DFB   0
USED     DW    0
MDTIME   DW    0,0
CRTIME   DW    0,0

* PREFIX
PRPARMS  DFB   1
         DW    PATHBUF
                   
* CREATE
CRPARMS   DFB   7
          DW    PATHBUF
CRACCESS  DFB   0
CRFTYP    DFB   0
CRAUX     DW    0
CRSTYP    DFB   0
CRCRTIME  DW    0,0

* MARK
MPARMS   DFB   2
MREF     DFB   0
MPOS     HEX   00,00,00

* EOF
EPARMS   DFB   2
EREF     DFB   0
EOF      HEX   00,00,00