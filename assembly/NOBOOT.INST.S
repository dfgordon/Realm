* Program to print message if the user tries to boot a
* non-bootable disk.  Object code has to be zapped
* into the boot sector (track 0, sector 0).
         ORG   $800
CH       =     $24
CV       =     $25
COUT1    =     $FDF0
HOME     =     $FC58
BOOT     =     $FAA6
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
         JSR   WAITRET
         JMP   BOOT

MESS1    ASC   "REALM INSTALLER",00
MESS2    ASC   "INSERT INSTALL DISK 1 AND PRESS RETURN",00