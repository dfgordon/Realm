Realm Scripts
================

These scripts are used to edit, error-check, and deploy the *Realm* files to working disk images.

Some of the scripts depend on `a2kit` being installed and in the path.

Error checking the maps
-----------------------

1. Run `realm-map-reader.py` to put all the map data into three `JSON` files
2. Run `realm-map-checker.py` to verify the map files
3. Repair any errors by editing the `JSON` files
4. If there were repairs, run `realm-map-writer.py` to write the changes to the binaries

Error checking the BASIC programs
---------------------------------

1. Use the [Applesoft language server](https://github.com/dfgordon/vscode-language-applesoft) to verify syntax while editing

    * Ignore branching errors to do with inter-program branching

2. Run `verify.py`.  This carries out the following checks:

    * Verify that line numbers are in order
    * Verify that branches exist
    * Check for consistency of repeated code sections
    * Verifies the uniqueness of short-hand strings used in `COMBAT.bas`

3. Run `diffrealm` once for each program that is maintained as a separate version for DOS 3.3 and ProDOS.  This simply performs a `diff` of the two files as a manual consistency check.  The argument of `diffream` is the name of the program.

    * Example invocation: `./scripts/diffrealm TOWN.bas`

Renumbering BASIC
-----------------

When renumbering BASIC programs (to save space), the inter-program branching scheme used by *Realm* has to be taken into account; in particular any `GOTO` that branches to another program has to be handled specially.

Deploy to Disk Images
---------------------

All disk images can be deployed in seconds using `deploy-release.py`.  This calls `deploy-dos33.py`, `deploy-prodos.py`, and `deploy-installer`.  These in turn make heavy use of `a2kit`.  The script generates both WOZ and DO/PO versions of the distribution.