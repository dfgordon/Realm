*Realm* Overview
=================

*Realm* is an adventure game written in the 1980's for Apple \]\[, but never released until 2021. Today it can be played on emulators or vintage computers.  It was inspired mainly by [Ultima](https://en.wikipedia.org/wiki/Ultima_I:_The_First_Age_of_Darkness) and [D&D](https://en.wikipedia.org/wiki/Dungeons_%26_Dragons).

Story Synopsis
===============

Mordock, former Archwizard of Lemphocym, has re-discovered the secrets of the pyramid gates, and taken up his abode in cryptic Wornoth.  From his ethereal stronghold he sends forth the rays of nightmare, and troubles all the Realms.  I, Xavier Francis, eighteenth Baron Lemphocym, attempted an assault on the Iron Tower, and failed.  Find me in the Black Fortress, in unpeopled Fonkrakis, and we will make a last desperate attempt to end the reign of the nightmare dreamer.

Recovery Project
=================

During the COVID pandemic of 2020/21, a recovery project was initiated.  With release 1.2 the original objectives were met.

Motivation
----------

This project is nostalgic and personal, but any wider interest is appreciated.  With this in mind, documentation covers code internals, deployment, installation, and gameplay.

Objective
---------

Create a release targeting Apple \]\[ plus and //e.  The release should take the form of floppy disk images, and should be tested on two or more emulators.  It should also be tested on vintage hardware, to the extent possible.

Scope
-----

1. Cleanup the BASIC taking advantage of modern editors and scripting capabilities.
2. Rediscover workings of machine code.
3. Fill out the story elements, and produce a manual.
4. Write wiki pages discussing details.
5. Gameplay enhancements or add-ons (v1.3.0 and later)

Boundaries
----------

1. Do not disturb any of the original artwork.
2. Do not disturb any of the original sprites.
3. Do not disturb any of the original maps.
4. Do not change fundamentals of game mechanics.

Conclusion
----------

As expected, the BASIC code benefits greatly from the ability to use a modern editor.  Readability and compactness are the main improvements.  The primary new feature is support for ProDOS.

Machine code documentation is given in broad strokes.  Detailed exposition of how these codes work would be onerous.

Story elements are filled in by way of the monologue system.  The wiki and documentation are complete.

The only change in the artwork is a tiny patch to Mordock's face, which had a color bit conflict that looked quite bad on a modern screen.  The sprites are all exactly as they were found, except that I decided to make special denizens differ from ordinary ones by a single pixel.  Maps are unchanged except for correcting a bad nibble in one dungeon which led to a crash under certain circumstances.  

Game mechanics are changed only in interface details, and in balancing of spells and weapons.  The main interface improvement is automatic combat-resolution.
