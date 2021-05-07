Realm Deployment Workflow
=========================

This is the workflow for deployment to four 5.25 inch floppy disks, using DOS 3.3.  The workflow requires using `CiderPress` on Windows, and `Virtual ][` on Macintosh.

1. Prepare four disk images on the Windows side as follows:
 * `realm-master` (disk0), bootable with greeting program `GUTEN TAG`
 * `realm-dungeon` (disk1), a blank disk, do not include DOS
 * `realm-monster` (disk2), a blank disk, do not include DOS
 * `realm-setup` (disk3), bootable with greeting program `GUTEN TAG`
2. The content of the greeting program is not important, as it will be overwritten.
3. Run the `deploy-binaries.py` script.  This gathers machine code, map files, and artwork, and puts them into four directories in correspondence with the four disks.
4. Use `CiderPress` to copy the contents of the directories onto the corresponding disk images.  Use multiple selection to copy all the files for a given disk at once.
5. Use `CiderPress` to remove the `.TXT` extension from the text files
6. Move the disk images to the Macintosh, putting them in the `Virtual ][` `disk folder`
7. Run the `deploy-all.scpt` script.  This reads the BASIC programs from the Mac, enters them line by line into the virtual machine, figures out their size, and saves them as binaries onto the appropriate deployment disk images.  The user is prompted for which disks to deploy.  This script may take a couple minutes.
	* For a fresh deployment, there will be several (non-fatal) errors, because the script tries to delete the existing deployed files.  This unfortunately will slow down `Virtual ][`, because it will change speed in response to the bell sound.

Pure Windows Deployment
-----------------------

Due to the fact that, as far as I know, `AppleWin` doesn't have the same type of scripting capability as `Virtual ][`, one has to use a much more painful procedure to deploy the BASIC programs on Windows.  In particular, they must be copied one at a time to a "staging image" via `CiderPress`, and then transferred to the deployment images using vintage computing procedures.  In particular, the BASIC programs `DEPLOY0`, `DEPLOY1`, and `DEPLOY2`, are used to generate `EXEC` scripts, which in turn create the relocatable BASIC "binaries" on the deployment disks.  This process was abandoned early, and the BASIC script generators may not be up to date.

Gotchas
-------

* If you are editing `text.json` in order to change monologues or troves, don't forget to run `realm-map-writer.py` to write the changes back to the native binaries.  This presupposes that the full set of JSON files have been created using `realm-map-reader.py`.
* All modern-side scripts assume the directory structure `~/Documents/appleii/Realm`
* `deploy-all.scpt` has my personal path hard coded, and also assumes disk images are in the `disk folder` that is setup in `Virtual ][`
* `deploy-all.scpt` assumes the DOS 3.3 master disk is in the `disk folder`.  This could be replaced with any bootable disk that presents the `FP` prompt.
