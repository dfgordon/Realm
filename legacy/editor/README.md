Notes on Legacy Editor Programs
===============================

These are the programs that were originally used to create and manipulate maps and text files (n.b. maps have text embedded in them).  This is not necessarily an exhaustive set, just what was found on the Sider.

None of these programs were used during the recovery project. Instead we use a python script to convert everything to `JSON` format, make any edits using a modern text editor, and use another script to convert back to the original format.

In July 2021 a project was started to redesign all the machine code using the MERLIN assembler.  The test program `WALK.ALL` serves as an editor compatible with the new machine code.

This folder also contains the original `MONSTERS` text file, which includes several monsters that were passed over by the encounter handler, and which in the modern version are simply deleted. The decision to eliminate them was made in the retro-era, based on the fact that the artwork was not going to fit on the monster disk. Note there is a half-finished `DEMON` in `artwork-editable`, so apparently he, at least, was going to be included (as of this writing he is still left out).
