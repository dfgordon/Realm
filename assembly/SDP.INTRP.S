* SDP INTEPRETER
* THIS PROGRAM IS RELOCATABLE

         ORG   $15AC      ; JUST BELOW MAP.INTRP

* ZERO PAGE USAGE ********************

ART      EQU   $06        ; ARTWORK POINTER IN $06,$07
X1       EQU   $EB        ; X1 COORD AS WORD
X2       EQU   $ED        ; X2 COORD AS WORD
Y1       EQU   $EF
Y2       EQU   $FA
COLOR    EQU   $FB

* ROM ROUTINES ***********************

SETCOLOR EQU   $F6F0      ; ARG=X
BEGLINE  EQU   $F411      ; X,Y=HOR A=VER
ENDLINE  EQU   $F53A      ; A,X=HOR Y=VER
COUT     EQU   $FDED
CLEAR    EQU   $F3E2
SETSHP   EQU   $F730      ; IS IT?
DRWSHP   EQU   $F601      ; IS IT?

* PROGRAM ****************************
* IN: ART, POINTER TO SDP ARTWORK FILE

CPAINT   JSR   CLEAR
PAINT    LDY   #$00
         LDA   (ART),Y
         PHA
:LDLOOP  INY
         LDA   (ART),Y
         STA   X1-1,Y
         CPY   #$05
         BMI   :LDLOOP
         INY
         LDA   (ART),Y
         STA   Y2
         INY
         LDA   (ART),Y
         STA   COLOR
         PLA
         CMP   #$00
         BEQ   :SHAPE
         CMP   #$01
         BEQ   :LINE
         CMP   #$02
         BEQ   :FILL
         RTS
:NEXT    ADC   ART        ; A MUST HAVE STRIDE
         STA   ART
         LDA   #$00
         ADC   ART+1
         STA   ART+1
         CLC
         BCC   PAINT
:SHAPE   LDX   X1         ; COLOR
         JSR   SETCOLOR
         LDX   X2
         LDY   X2+1
         LDA   Y1
         JSR   BEGLINE
         LDX   X1+1       ; SHAPE INDEX
         JSR   SETSHP
         LDX   $1A
         LDY   $1B
         JSR   DRWSHP
         LDA   #$06
         CLC
         BCC   :NEXT
:LINE    LDX   COLOR
         JSR   SETCOLOR
         LDX   X1
         LDY   X1+1
         LDA   Y1
         JSR   BEGLINE
         LDA   X2
         LDX   X2+1
         LDY   Y2
         JSR   ENDLINE
:FINLN   LDA   #$08
         CLC
         BCC   :NEXT
:FILL    LDX   COLOR
         JSR   SETCOLOR
:FLOOP   DEC   Y2
         BEQ   :FINLN
         LDX   X1
         LDY   X1+1
         LDA   Y1
         JSR   BEGLINE
         LDA   X2
         LDX   X2+1
         LDY   Y1
         JSR   ENDLINE
         INC   Y1
         CLC
         BCC   :FLOOP
