100  TEXT: HOME
110  PRINT "YOU FOUND THE BARON! AFTER SUITABLE"
120  PRINT "GREETINGS, AND GLASSES OF THE MELLOW"
130  PRINT "MEAD, HE SPEAKS:"
140  PRINT CHR$(34);"DEAR FRIENDS, MY ENCHANTERS DEVISED"
150  PRINT "A BLADE, THE SWORD OF LIGHT, WHICH YOU"
160  PRINT "WILL USE TO ASSAULT MORDOCK HIMSELF."
170  PRINT "THIS WEAPON, WIELDED BY ONE WHO HAS THE"
180  PRINT "THE POWER OF LIGHT, IS, WE DEEM, THE"
190  PRINT "LAST HOPE OF VANQUISHING OUR FOE."
200  PRINT "YOU MUST FIND THE HIGH PRIEST, WHO HAS"
210  PRINT "DISAPPEARED INTO THE ABYSS, AND GAIN"
220  PRINT "THE BLESSING OF THE LIGHT."
230  PRINT "AS FOR THE SWORD, IT IS, ALAS, FOR SALE"
250  PRINT "(TO RAISE GOLD FOR THE WAR, YOU SEE)."
270  PRINT "NOW GO AND SEE MASTER TEKNIUS, AND SEEK"
280  PRINT "OUT THE HIGH PRIEST!";CHR$(34)
290  PRINT "AFTER A PAUSE HE ADDS: ";CHR$(34);"I ALMOST FORGOT,";
300  PRINT "WE HAVE THE RED PRISM. IT IS IN OUR"
310  PRINT "SECRET BASE TO THE NORTH. RETURN HERE"
320  PRINT "WHEN YOU HAVE THE BLESSING.";CHR$(34);
330  GET A$: RETURN

1000  TEXT: HOME
1010  PRINT CHR$(34);"WELL MET AGAIN! YOU HAVE THE LIGHT!"
1020  PRINT "YET THIS IS NOT ENOUGH FOR A DIRECT"
1030  PRINT "ASSAULT ON THE IRON TOWER, OR SURVIVAL"
1040  PRINT "IN THE ETHEREAL SEA THAT SURROUNDS IT."
1050  PRINT "WITH AN ARMY WE FAILED IN THIS. THIS"
1060  PRINT "TIME WE USE DECEPTION. YOU SHALL BECOME"
1070  PRINT "ETHEREAL YOURSELVES! THE ARCHWIZARD,"
1080  PRINT "WHO REMAINS IN CASTLE LEMPHOCYM, HOLDS"
1090  PRINT "THE ORB OF STARS, WHICH MAY BE USED FOR"
1100  PRINT "OUR PURPOSE. THE ORB MUST BE TAKEN TO"
1110  PRINT "THE BURIED TEMPLE, AT THE BOTTOM OF THE"
1120  PRINT "FORSAKEN MINE, IN THE LAVA FIELDS OF"
1130  PRINT "CRYPTIC WORNOTH. USE THE ORB AT THE"
1140  PRINT "FOUR ALTARS YOU WILL FIND THERE."
1150  PRINT "THEN YOU WILL BE ABLE TO ENTER THE IRON"
1160  PRINT "TOWER WITHOUT OPPOSITION. WHAT YOU WILL"
1170  PRINT "FIND WITHIN WE DO NOT KNOW. ONE LAST"
1180  PRINT "WARNING: THE ARCHWIZARD IS ARROGANT AND"
1190  PRINT "ILL TEMPERED, AND MAY DEMAND SOMETHING"
1200  PRINT "IN EXCHANGE FOR THE ORB.";CHR$(34);
1210  GET A$: RETURN

2000  HOME: VTAB 21: PRINT "GO AND VANQUISH MORDOCK!"
2010  PRINT "REVIEW THE PLAN (Y/N) ? ";: GET A$: IF A$ = "Y" THEN GOSUB 100: GOSUB 1000: RETURN
2011  RETURN

8900  IF FG%(4)=0 THEN GOSUB 100: GOTO 25000
8910  IF FG%(5)=0 THEN GOSUB 1000: GOTO 25000
8920  GOSUB 2000

25000  L=1: POKE -16304,0: POKE 16384,0: POKE 103,1: POKE 104,64: GOTO 25000
