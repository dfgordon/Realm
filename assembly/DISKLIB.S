* USE THE PRODOS MLI TO GET VOLUME INFO
* AND TO COPY FILES

         ORG   $4000
MLI_ADDR =     $BF00
STRBUF   =     $5000      ; PREFIX STRINGS WITH LEN
SRC_PRE  =     $5100
SRC_PTH  =     $5140
DST_PRE  =     $5180
DST_PTH  =     $51C0
IBUF     =     $5400
OBUF     =     $5800
WRKBUF   =     $5C00
STAT     =     $06        ; ERROR STATUS
DBG      =     $08        ; DEBUG FLAG
ZPTR     =     $FE        ; GENERAL PTR
CREATE   =     $C0
GETFINF  =     $C4
ONLINE   =     $C5
PREFIX   =     $C6
OPEN     =     $C8
READ     =     $CA
WRITE    =     $CB
CLOSE    =     $CC
SETMRK   =     $CE
GETMRK   =     $CF
GETEOF   =     $D1
PRBYTE   =     $FDDA
COUT     =     $FDED

MLI      MAC
         JSR   MLI_ADDR
         DFB   ]1
         DW    ]2
         STA   STAT       ; STORE ERR CODE
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
         LDA   #<]1
         STA   ZPTR
         LDA   #>]1
         STA   ZPTR+1
         LDY   #$00
]LOOP    LDA   (ZPTR),Y
         STA   STRBUF,Y
         INY
         CPY   #$40
         BNE   ]LOOP
         <<<

CHKEOF   LDA   DBG
         BEQ   :SKP_DBG
         LDA   #"<"
         JSR   COUT
         LDA   MPOS+2
         JSR   PRBYTE
         LDA   MPOS+1
         JSR   PRBYTE
         LDA   MPOS
         JSR   PRBYTE
         LDA   #">"
         JSR   COUT
         LDA   #$8D
         JSR   COUT
:SKP_DBG LDA   MPOS
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

* GET MOUNTED VOLUME LIST
* RETURNED IN STRBUF, 16 BYTES PER ENTRY
* FIRST BYTE OF ENTRY HAS LENGTH IN LOW NIBBLE
GETVOLS  MLI   ONLINE;VPARMS
         RTS

* GET VOLUME CAPACITY
* VOLUME NAME IS INPUT AT BUF WITH COUNT HEADER
* BLOCKS AVAILABLE RETURNED IN STAT
GETCAP   MLI   GETFINF;FPARMS
         SEC
         LDA   AUX
         SBC   USED
         STA   STAT
         LDA   AUX+1
         SBC   USED+1
         STA   STAT+1
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

* COPY FILE
COPY     PATH  SRC_PRE
         MLI   PREFIX;PRPARMS
         PATH  SRC_PTH
         MLI   GETFINF;FPARMS
         CMP   #$00
         BEQ   :CREATE
         RTS              ; ERR
:CREATE  JSR   COPYINFO
         PATH  DST_PRE
         MLI   PREFIX;PRPARMS
         PATH  DST_PTH
         MLI   CREATE;CRPARMS
         CMP   #$00
         BEQ   :IOPEN
         RTS              ; ERR
:IOPEN   PATH  SRC_PRE
         MLI   PREFIX;PRPARMS
         PATH  SRC_PTH
         MLI   OPEN;IFPARMS
         CMP   #$00
         BEQ   :GETEOF
         RTS              ; ERR
:GETEOF  LDA   IREF
         STA   EREF
         MLI   GETEOF;EPARMS
         CMP   #$00
         BEQ   :OOPEN
         RTS              ; ERR
:OOPEN   PATH  DST_PRE
         MLI   PREFIX;PRPARMS
         PATH  DST_PTH
         MLI   OPEN;OFPARMS
         CMP   #$00
         BEQ   :BEGIN
         LDA   IREF
         STA   CLREF
         MLI   CLOSE;CLPARMS
         RTS              ; ERR
:BEGIN   LDA   IREF
         STA   RDREF
         STA   MREF
         LDA   OREF
         STA   WRREF
:LOOP    MLI   READ;RDPARMS
         CMP   #$00
         BNE   :FIN
         CP16  RDACTUAL;WRREQ
         MLI   WRITE;WRPARMS
         CMP   #$00
         BNE   :FIN
         MLI   GETMRK;MPARMS
         JSR   CHKEOF
         CMP   #$00
         BEQ   :LOOP
:FIN     LDA   STAT
         PHA              ; SAVE LAST STAT     
         LDA   IREF
         STA   CLREF
         MLI   CLOSE;CLPARMS
         LDA   OREF
         STA   CLREF
         MLI   CLOSE;CLPARMS
         PLA
         STA   STAT       ; RESTORE STAT
         RTS


* PRODOS MLI PARAMETER BLOCKS

* VOLUME INFO
VPARMS   DFB   2
         DFB   0          ; ALL SLOTS
         DW    STRBUF

* OPEN INPUT FILE
IFPARMS  DFB   3
         DW    STRBUF     ; PATH
         DW    IBUF       ; 1K
IREF     DFB   0

* OPEN OUTPUT FILE
OFPARMS  DFB   3
         DW    STRBUF     ; PATH
         DW    OBUF       ; 1K
OREF     DFB   0

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

* FILE INFO
FPARMS   DFB   10
         DW    STRBUF     ; PATH
ACCESS   DFB   0
FTYP     DFB   0
AUX      DW    0
STYP     DFB   0
USED     DW    0
MDTIME   DW    0,0
CRTIME   DW    0,0

* PREFIX
PRPARMS  DFB   1
PRPATH   DW    STRBUF
                   
* CREATE
CRPARMS   DFB   7
CRPATH    DW    STRBUF
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