Legacy Folder
=============

These components were retired starting with version 1.4.  Further notes are in the subfolders.

Original Memory Map
-------------------

Address | Usage | Format
--------|-------|-------
$00-$06 | Used by Machine Code | Binary Data
$100-$1FF | Stack | System
$200-$2FF | Input Buffer | System
$300-$3B7 | Sound, `S2` | Machine Code
$400-$7FF | Text Screen | System
$800-$9B0 | Outdoor Sprites | Binary Data
$800-$AE8 | Town Sprites | Binary Data
$800-$FFB | Dungeon Sprites + Brushes | Binary Data
$B00-???? | Town Back Buffer | Binary Data
$801-$10FF | Large Merchant Programs | AppleSoft BASIC
$B01-$10FF | Small Merchant Programs | AppleSoft BASIC
$801-$3FFF | Character Utilities | AppleSoft BASIC
$1000-???? | Dungeon Back Buffer | Binary Data
$1000-$1504 | `CHAIN` | AppleSoft BASIC
$1100-$11FF | Artwork Painter, `SDP.INTRP` | Machine Code
$1200-$136D | Calculations, `MRC3` | Machine Code
$1400-???? | Dungeon Back Buffer | Binary Data
$178E-$1FF5 | Terrain Painters | Machine Code
$2000-$3FFF | Graphics Screen | Binary Data
$4000-$6CFF | Main Programs | AppleSoft BASIC
$6D00-$7FFF | BASIC Variables | AppleSoft BASIC
$8000-$8C7F | Map Data(4) | Binary Data
$8C80-$9A98 | Monster Artwork | Binary Data
$9AA5-$BFFF | `DOS 3.3` | System
$C000-$CFFF | Input/Output | System
$D000-$FFFF | Apple \]\[ ROM | System

Binary Party Data
-----------------

In the original code, some binary flags were used in place of ordinary variables (perhaps in order to make it harder to cheat).  The 5 flags starting at $6CF0 were saved in the file `CK:PARTYNAME`.  These are now replaced with `FL%` and `FG%(0)` through `FG%(5)`.

Address | Decimal | Value | Meaning
--------|---------|------|------
$1FFB | 8187 | 0 | walking
| | 16 | sailing
| | 32 | flying
$6CF0 | 27888 | 0 | pyramid 1 not entered
| | 8 | key 1 used
| | 16 | prism 1 used
$6CF1 | 27889 | 0 | pyramid 2 not entered
| | 8 | key 2 used
| | 16 | prism 2 used
$6CF2 | 27890 | 0 | pyramid 3 not entered
| | 8 | key 3 used
| | 16 | prism 3 used
$6CF3 | 27891 | binary | enlightened
$6CF4 | 27892 | binary | power of light
$6CF5 | 27893 | binary | altar 1
$6CF6 | 27894 | binary | altar 2
$6CF7 | 27895 | binary | altar 3
