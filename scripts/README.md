Realm Scripts
================

These scripts are used to edit, error-check, and deploy the *Realm* files to working disk images.  Deploy scripts are described in the wiki.

Error checking the maps
-----------------------

1. Run `realm-map-reader.py` to put all the map data into three `JSON` files
2. Run `realm-map-checker.py` to verify the map files
3. Repair any errors by editing the `JSON` files
4. If there were repairs, run `realm-map-writer.py` to write the changes to the binaries

Error checking the BASIC programs
---------------------------------

1. Run `syntax-checker.py`.  This is not a full syntax checker, it only does the following:

    * Verify that line numbers are in order
    * Verify that branches exist
    * Check for consistency of repeated code sections
    * Verifies the uniqueness of short-hand strings used in `COMBAT.bas`


2. Run `diffrealm` once for each program that is maintained as a separate version for DOS 3.3 and ProDOS.  This simply performs a `diff` of the two files as a manual consistency check.  The argument of `diffream` is the name of the program.

    * Example invocation: `./scripts/diffrealm TOWN.bas`

Renumbering BASIC
-----------------

The program `renumber.py` does something like what the `APA` program does on the Apple \]\[.  The main use of this is to reduce program size, which even after tokenization, depends on the number of digits in the line numbers.  Ordinary branches are updated to be consistent with the new line numbers.  When it comes to *Realm* in particular, however, there are inter-program branches that still have to be maintained by hand.
