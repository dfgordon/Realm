* REALM SOUND GENERATOR
* SIMPLE TONES AND CHIRPS

         ORG   $300

* ZERO PAGE USAGE ********************

PERIOD1  EQU   $06
PERIOD2  EQU   $07
CYCLES   EQU   $08

* ROM / IO ***************************

WAIT     EQU   $FCA8
SPKR     EQU   $C030

* SUBROUTINES ************************

* STACK REPAIR FOR ONERR-RESUME
* FROM APPLESOFT REFERENCE MANUAL

RPRSTK   PLA
         TAY
         PLA
         LDX   $DF
         TXS
         PHA
         TYA
         PHA
         RTS

TONE     LDY   CYCLES
:CLOOP   LDX   PERIOD1
:PLOOP   DEX
         BNE   :PLOOP
         STA   SPKR
         DEY
         BNE   :CLOOP
         RTS

FATTONE  LDY   CYCLES
:CLOOP   LDA   PERIOD1
         JSR   WAIT
         STA   SPKR
         DEY
         BNE   :CLOOP
         RTS

UPCHIRP  JSR   TONE
         DEC   PERIOD1
         LDA   PERIOD1
         CMP   PERIOD2
         BNE   UPCHIRP
         RTS

DNCHIRP  JSR   TONE
         INC   PERIOD1
         LDA   PERIOD1
         CMP   PERIOD2
         BNE   DNCHIRP
         RTS

UPFAT    JSR   FATTONE
         DEC   PERIOD1
         LDA   PERIOD1
         CMP   PERIOD2
         BNE   UPFAT
         RTS

DNFAT    JSR   FATTONE
         INC   PERIOD1
         LDA   PERIOD1
         CMP   PERIOD2
         BNE   DNFAT
         RTS
