* REALM SOUND GENERATOR
* SIMPLE TONES, CHIRPS, SIRENS

         ORG   $300

* ZERO PAGE PARAMETERS ***************
* (HITONE-LOTONE)/RATE MUST BE INTEGRAL

LOTONE   EQU   $06
HITONE   EQU   $07
CYCLES   EQU   $08        ; CYCLES PER TONE
REPS     EQU   $09        ; CHIRP OR SIREN REPS
RATE     EQU   $1E        ; RATE OF CHIRP

* ZERO PAGE VARIABLES ****************

PERIOD   EQU   $CE

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
:CLOOP   LDX   PERIOD
:PLOOP   DEX
         BNE   :PLOOP
         STA   SPKR
         DEY
         BNE   :CLOOP
         RTS

FATTONE  LDY   CYCLES
:CLOOP   LDA   PERIOD
         JSR   WAIT
         STA   SPKR
         DEY
         BNE   :CLOOP
         RTS

UPCHIRP  LDA   LOTONE
         STA   PERIOD
:LOOP    JSR   TONE
         SEC
         LDA   PERIOD
         SBC   RATE
         STA   PERIOD
         CMP   HITONE
         BNE   :LOOP
         DEC   REPS
         BNE   UPCHIRP
         RTS

DNCHIRP  LDA   HITONE
         STA   PERIOD
:LOOP    JSR   TONE
         CLC
         LDA   PERIOD
         ADC   RATE
         STA   PERIOD
         CMP   LOTONE
         BNE   :LOOP
         DEC   REPS
         BNE   DNCHIRP
         RTS

UPFAT    LDA   LOTONE
         STA   PERIOD
:LOOP    JSR   FATTONE
         SEC
         LDA   PERIOD
         SBC   RATE
         STA   PERIOD
         CMP   HITONE
         BNE   :LOOP
         DEC   REPS
         BNE   UPFAT
         RTS

DNFAT    LDA   HITONE
         STA   PERIOD
:LOOP    JSR   FATTONE
         CLC
         LDA   PERIOD
         ADC   RATE
         STA   PERIOD
         CMP   LOTONE
         BNE   :LOOP
         DEC   REPS
         BNE   DNFAT
         RTS

SIREN    LDA   REPS
         PHA
         LDA   #01
         STA   REPS
         JSR   UPCHIRP
         LDA   #01
         STA   REPS
         JSR   DNCHIRP
         PLA
         STA   REPS
         DEC   REPS
         BNE   SIREN
         RTS

FATSIREN LDA   REPS
         PHA
         LDA   #01
         STA   REPS
         JSR   UPFAT
         LDA   #01
         STA   REPS
         JSR   DNFAT
         PLA
         STA   REPS
         DEC   REPS
         BNE   FATSIREN
         RTS
