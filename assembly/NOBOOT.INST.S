* Program to print message if the user tries to boot a
* non-bootable disk.  Object code has to be zapped
* into the boot sector (track 0, sector 0).
         ORG   $800
CH       =     $24
CV       =     $25
SLOT     =     $2B
COUT1    =     $FDF0
HOME     =     $FC58
VTAB     =     $FC22
WAITRET  =     $FD5A

PRTAB    MAC
         LDA   #]1
         STA   CH
         LDA   #]2
         STA   CV
         JSR   VTAB
         LDY   #$00
]loop    LDA   ]3,Y
         BEQ   done
         JSR   COUT1
         INY
         JMP   ]loop
done     EOM

         HEX   01
         JSR   HOME
         PRTAB 12;10;MESS1
         PRTAB 1;12;MESS2
         LDX   SLOT
         LDA   $C08A,X    ; drive 1
         LDA   $C088,X    ; motor off
         JSR   WAITRET
         LDA   #$00
         STA   $00
         LDA   SLOT
         LSR
         LSR
         LSR
         LSR
         ORA   #$C0
         STA   $01
         JMP   ($0000)    ; JMP $Cs00 where s=slot

MESS1    ASC   "REALM INSTALLER",00
MESS2    ASC   "INSERT INSTALL DISK 1 AND PRESS RETURN",00