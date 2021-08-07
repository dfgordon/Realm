
Original Machine Language
=========================

These machine language programs were built using the Monitor ROM in the mid 1980's.  They were replaced with MERLIN assembly language in 2021.

Program `S2`
------------

Address space: $300-$3B7

This is the code that produces the sounds.  It also contains the stack repair program from the AppleSoft BASIC reference manual.

These read and write to a few bytes of storage just below high resolution graphics page 1, in particular, $1FFD, $1FFE, and $1FFF (8189,8190,8191).

Address | Decimal | Subroutine | Parameters
--------|---------|------------|------------
$0300 | 768 | Up Chirp | 769,813
$033D | 829 | Down Chirp | 830,881,886
$037D | 893 | Single Bootfall
$0390 | 912 | Oops Noise | $1FFF/8191=50
$0399 | 921 | Pulse Speaker
$039D | 925 | Double Bootfall
$03AA | 938 | Stack Fixer

The graphics interpreter `SDP.INTRP` uses locations $0300-$0303 for a callback.  As a result, whenever *Realm* calls `SDP.INTRP`, data is swapped in and out of locations $0300-$0303 before and after.

Program `MRC3`
--------------

Address space: $1200-$136D

This is called from the terrain intepreters `DNGN.INTRP`, `TOWN.INTRP2`, and `OUTSIDE.INTRP`.  This is not called directly from BASIC. Perhaps this was an acronym for "Mordock's Realm Calculations."  The subroutine at $1342 is no more than multiplying two bytes and putting the product in a word.

Address | Decimal | Subroutine | Parameters
--------|---------|------------|------------
$1200 | 4608 | Map row to screen address | in: $1BFF=1-9
||| out: $13DE,$13DF=screen address
$1342 | 4930 | Get sprite address | in: $00,$01=sprite size,sprite code
||| out: $02,$03=offset to sprite

Program `OUTSIDE.INTRP`
----------------------

Address space: $18F0-1BDF

The outside interpreter is the simplest, all it has to do is paint the screen and allow or block movement.  There are no monsters, denizens, troves, or monologues.

Address | Decimal | Subroutine | Parameters
--------|---------|------------|------------
$18F0 | 6384 | Display Terrain | in: $1FFB=walk(0), sail($10), fly($20)
||| in: $1FFC,$1FFD=map address
||| in: $1FFE,$1FFF=X/2,Y
||| out: $1FFA=moved(0), blocked($10)
$1955 | | part of main, paint screen
$1A24 | | LDA terrain code, map aligned to page |
$1BA4 | 7076 | Get Terrain | in: $1FFE,$1FFF=X/2,Y
||| in: $1FFC,$1FFD=map address
||| in: $1FF9=is X odd
||| out: $0300=terrain code

Notes:
* Map address is hard coded, but still must be input
* Start of sprites hard coded as $800
* Remember there are two columns per byte in the map
* Locations $18FF and $1903 both hold the ether terrain code.  To block flight over mountains (e.g. in the Abyss) we can replace one of these with the mountain code.  The Astral spell can put any value greater than 15 in both places to allow ethereal travel.

Rough pseudocode for call 6384:
* load terrain code, if blocked exit
* Decrement X and Y by 4
* Set columns/2 and rows, $1BFE=#$05, $1BFF=#$09
* Move $04, $05 to $13E0, $13E2 - unnecessary?
* Loop on $1BFF
* MRC3.$1200 (put screen address in $13DE,$13DF, using row stored in $1BFF)
* Loop on $1BFE
* Sprite size to $00, Terrain code to $01
* MRC3.$1342 (store sprite offset in $02,$03)
* Paint sprite onto screen

Program `DNGN.INTRP`
----------------------

Address space: $1868-$1FED

This interprets the dungeon map and paints the dungeon environment. It handles adjusting the map so that monsters either flee from the party or move toward them.  It finds the index to the treasure trove guarded by a special monster.

Address | Decimal | Subroutine | Parameters
--------|---------|------------|------------
$18F0 | 6384 | Display Terrain | in: $1FFB=monsters aggressive(0),fearful($10)
||| in: $1FF9=is X odd
||| in: $04,$05 = ?
$1A24 | | LDA terrain code, map aligned to page |
$1BA4 | 7076 | Get Terrain | in: $1FFE,$1FFF=X/2,Y
$1BD8 | 7128 | Find Trove | in: $1FFA,$1FFB=current X/2,Y
||| in: $1FFE,$1FFF=start search at X/2,Y
||| in: $1FF9=is X odd
||| in/out: $04=index to trove, init to 0
||| in/out: $05=completion flag, init to 0

Notes:
* Must set `MRC3` $1202 to $1C, because vertical index is $1CFF instead of $1BFF.
* There may be a bug where fleeing monsters sometimes disappear near edges of the map.  I can recall trying to figure this out in the retro-era, but at this point choose to regard it as part of the game.

Program `TOWN.INTRP2`
----------------------

Address space: $178E-$1FF5

This interprets the town map and the town denizens map and paints the town environment.  It handles causing the guards to pursue a party that runs afoul of the law.  It finds the monologue of a special denizen.

It appears this routine makes use of a back buffer of the map at location $0B00, in connection with hostile guards.  I don't remember why this was done.

Address | Decimal | Subroutine | Parameters
--------|---------|------------|------------
$17D8 | | get back buffer address | in: $1FFC,$1FFD=main address
||| out: $1AFD,$1AFE=backing address
$1900 | 6400 | Display Terrain | in: $1FFE,$1FFF=X/2,Y
||| in: $1FF9=is X odd
||| in: $1FFC,$1FFD=map address
||| in: $1FFB=walking (0) or sailing ($10)
||| in: $1FF7=peaceful (0) or hostile ($10)
||| out: $1FFA=moved(0) or blocked($10)
$1A24 | | LDA terrain code, map aligned to page |
$1AF8 | | load sprite byte | in: $1AF9,$1AFA
$1AFC | | paint screen | in: $1AFD,$1AFE=screen address
$1BA4 | 7076 | Get Terrain | in: $1FFE,$1FFF=X/2,Y
||| in: $1FFC,$1FFD=map address
||| in: $1FF9=is X odd
||| out: $0300=terrain code
$1BAD | | Out of bounds handler | out: LDA terrain
$1C90 | 7312 | Find Monologue | in : $1FFE,$1FFF=start search at X/2,Y
||| in : $1FFA,$1FFB=current X/2,Y
||| in: $1FFC,$1FFD=map address
||| in: $1FF9=is X odd
||| in/out: $04=index to monologue, init to 0
||| in/out: $05=completion flag, init to 0
$1D23 | 7459 | Display Monologue | in : $04=index to monologue
||| note: map address appears hard coded
$1D69 | | LDA terrain code, arbitrary map address | in: $1FF9=is X odd
||| in: $1FFC,$1FFD=map address
||| in: $1FFE,$1FFF=X/2,Y
$1FD5 | | Set map address $8352 |
$1FE0 | | Set map address $8000 |

Notes:
* Map address is hard coded, but still must be input
* Start of sprites hard coded as $800
* Remember there are two columns per byte in the map

Rough pseudocode for call 6400:
* load terrain code, if blocked exit
* load people code, if blocked exit
* check hostility, if yes branch elsewhere
* Decrement X and Y by 4
* Set columns/2 and rows, $1BFE=#$05, $1BFF=#$09
* Loop on $1BFF
* MRC3.$1200 (put screen address in $13DE,$13DF, using row stored in $1BFF)
* Loop on $1BFE
* MRC3.$1342 (store sprite offset in $02,$03)
* Paint sprite onto screen

Program `SDP.INTRP`
-------------------

Address space: $4B00-$4BFE

This is `SDP.INTRP.E` from *SDP*, only loaded at $1100 (4352).  This renders a squeezed *SDP* picture loaded at $8C80.  There are subroutines in `OUTSIDE` and `DUNGEON` that set up the callback at $0300 with the picture address, and restore the sound program `S2`, which overlaps the same memory.  This is not needed in `TOWN` since the frame does not change upon entering or leaving.


ProDOS Machine Code
=======================

Map addresses hard coded into the three retired terrain painters had to change for ProDOS.  This is done by poking in the new addresses from BASIC.  The parameter locations are found by searching for absolute page addresses `#$80` (main map), `#$83` (denizen map), `#$86` (monologues) in the CiderPress disassembly (however they cannot be replaced blindly).  There are also some `SBC` operations that calculate locations in a back buffer.  The old page offset for the `TOWN.INTRP2` back buffer is `#$78`. The old page offset for the `DNGN.INTRP` back buffer seems to be two-fold, `#$6C` and `#$70`.

Address | Decimal | Old Value | New Value | Painter
--------|---------|-----------|-----------|--------
$1977 | 6519 | $80 | $6E | `OUTSIDE.INTRP`,`TOWN.INTRP2`,`DNGN.INTRP`
$199E | 6558 | $80 | $6E | `OUTSIDE.INTRP`,`TOWN.INTRP2`,`DNGN.INTRP`
$19B1 | 6577 | $80 | $6E | `OUTSIDE.INTRP`,`TOWN.INTRP2`,`DNGN.INTRP`
$19D0 | 6608 | $80 | $6E | `OUTSIDE.INTRP`,`TOWN.INTRP2`,`DNGN.INTRP`
$1B7F | 7039 | $80 | $6E | `OUTSIDE.INTRP`,`TOWN.INTRP2`,`DNGN.INTRP`
$1BCD | 7117 | $80 | $6E | `OUTSIDE.INTRP`,`TOWN.INTRP2`,`DNGN.INTRP`
$1C3F | 7231 | $80 | $6E | `TOWN.INTRP2`
$1FE6 | 8166 | $80 | $6E | `TOWN.INTRP2`
$193C | 6460 | $83 | $71 | `TOWN.INTRP2`
$1BE1 | 7137 | $83 | $71 | `TOWN.INTRP2`
$1C1D | 7197 | $83 | $71 | `TOWN.INTRP2`
$1C96 | 7318 | $83 | $71 | `TOWN.INTRP2`
$1CAE | 7342 | $83 | $71 | `TOWN.INTRP2`
$1FDB | 8155 | $83 | $71 | `TOWN.INTRP2`
$1D43 | 7491 | $86 | $74 | `TOWN.INTRP2`
$17E5 | 6117 | $78 | $66 | `TOWN.INTRP2`
$1BDE | 7134 | $80 | $6E | `DNGN.INTRP`
$1BF6 | 7158 | $80 | $6E | `DNGN.INTRP`
$1C92 | 7314 | $80 | $6E | `DNGN.INTRP`
$1D76 | 7542 | $80 | $6E | `DNGN.INTRP`
$1DA6 | 7590 | $80 | $6E | `DNGN.INTRP`
$1E0A | 7690 | $80 | $6E | `DNGN.INTRP`
$1E3A | 7738 | $80 | $6E | `DNGN.INTRP`
$1E7D | 7805 | $80 | $6E | `DNGN.INTRP`
$1EA9 | 7849 | $80 | $6E | `DNGN.INTRP`
$1EEC | 7916 | $80 | $6E | `DNGN.INTRP`
$1F31 | 7985 | $80 | $6E | `DNGN.INTRP`
$1F4A | 8010 | $80 | $6E | `DNGN.INTRP`
$1F6A | 8042 | $80 | $6E | `DNGN.INTRP`
$1F7F | 8064 | $80 | $6E | `DNGN.INTRP`
$1CC8 | 7368 | $6C | $5A | `DNGN.INTRP`
$1FDD | 8157 | $6C | $5A | `DNGN.INTRP`
$1FE5 | 8165 | $70 | $5E | `DNGN.INTRP`
