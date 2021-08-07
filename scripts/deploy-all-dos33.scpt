set pause to 1
set realm_path to "/Users/dan/Documents/appleii/Realm/"
set bas_dos_folder to realm_path & "basic-dos33/"
set bas_com_folder to realm_path & "basic-common/"
set text_folder to realm_path & "text-data/"
set script_folder to realm_path & "scripts/"
set art_folder to realm_path & "artwork-squeezed/"
set map_folder to realm_path & "arrinea-maps/"
set xmap_folder to realm_path & "exo-maps/"
set sprite_folder to realm_path & "sprites/"
set mc_folder to realm_path & "assembly/"

on waitForTyping()
	tell application "Virtual ]["
		tell front machine
			type line "VTAB 24: PRINT \"FINISHEDTYPING\""
			repeat
				delay 0.5
				if the last word of line 22 of the screen text = "FINISHEDTYPING" then
					exit repeat
				end if
			end repeat
		end tell
	end tell
end waitForTyping

on enterBinary(mac_path,a2_path,addr0)
	set b2m to my script_folder & "binary2monitor.py"
	set t to do shell script "python3 " & b2m & " \"" & mac_path & "\" " & addr0
	set addr to first paragraph of t as number
	set len to second paragraph of t as number
	set mon_lines to paragraphs 3 through end of t
	tell application "Virtual ]["
		tell front machine
			type line "HOME"
			type line "REM PROCESSING " & a2_path
			delay my pause
			type line "CALL -151"
			repeat with l in mon_lines
				type line l
			end repeat
			type line "3D0G"
			type line "BSAVE " & a2_path & ",A" & addr & ",L" & len & ",D2"
			delay my pause
		end tell
	end tell
	waitForTyping()
end enterBinary

on enterProgram(mac_path)
	set t to text of (read POSIX file mac_path)
	tell application "Virtual ]["
		tell front machine
			type line "NEW"
			type text t
		end tell
	end tell
	waitForTyping()
end enterProgram

on splitText(theText, theDelimiter)
    set AppleScript's text item delimiters to theDelimiter
    set theTextItems to every text item of theText
    set AppleScript's text item delimiters to ""
    return theTextItems
end splitText

on dos33(theText)
	set dos33text to item 1 of splitText(theText,"#")
	return dos33text
end dos33

tell application "Virtual ]["
	activate
	close every machine saving no
	make new AppleIIe
	delay 0.5
	set startDisk to disk folder & "DOS33 Master.DO"
	tell front machine
		set monochrome screen to false
		set speed to maximum
		eject device "S6D1"
		insert startDisk into device "S6D1"
		type line "MAXFILES 1"
		type line "LOMEM: 27904"
		type line "HIMEM: 32767"
	end tell
end tell

set choices to {"clean first", "binaries", "monsters", "maps", "xmaps", "BASIC", "init/clean for distribution"}
set dres to choose from list choices with title "Tasks" with prompt "Select" with multiple selections allowed

tell application "Finder"
	set artlist to name of every file of entire contents of ((POSIX file art_folder) as alias)
	set maplist to name of every file of entire contents of ((POSIX file map_folder) as alias)
	set xmaplist to name of every file of entire contents of ((POSIX file xmap_folder) as alias)
end tell

set monslist to {}
repeat with art in artlist
	if art does not contain "FRAME"
		set monslist to monslist & {art}
	end if
end repeat

set s1 to {{"ALCHEMIST", 2048, 0, 1}, {"ARCHWIZ", 2816, 0}, {"BARON", 2048, 1}}
set s2 to {{"-CHAIN", 4096, 0,1,2}, {"COMBAT", 16384, 0,1,2}, {"-DUNGEON", 16384, 2}}
set s3 to {{"FOOD", 2816, 0,1}, {"HIGH.PRIEST", 4096, 2}, {"LIBRARY", 2048, 0,1}}
set s4 to {{"-FINAL", 2048, 2}, {"-OUTSIDE", 16384, 0,1}, {"PUB", 2816, 0,1}, {"SAGE", 2816, 0}}
set s5 to {{"-SAVE.GAME", 2048, 0}, {"SHIPYARD", 2816, 0,1}}
set s6 to {{"TEMPLE", 2048, 0,1}, {"-TOWN", 16384, 0,1}, {"WEAPARM", 2048, 0,1}}

set s7 to {{"-AUTOSTART", 9, 0}, {"-GUTEN TAG", 9, 0, 3}, {"-LAUNCH", 9, 3}}
set s8 to {{"-DISK0", 9, 0}, {"-DISK1", 9, 1}, {"-DISK2", 9, 2}, {"-DISK3", 9, 3}}

set slist to s1 & s2 & s3 & s4 & s5 & s6 & s7 & s8

set disk_name to {"realm-dos33-master.DO", "realm-dos33-dungeon.DO", "realm-dos33-monster.DO", "realm-dos33-setup.DO"}

set machine_code to {{mc_folder,"SOUND#060300",0,3},{mc_folder,"SDP.INTRP#0615ac",0,1},{mc_folder,"MAP.INTRP#06163e",0,1}}
set sprites to {{sprite_folder,"OUTSPS#060800",0,1},{sprite_folder,"TWNSPS#060800",0,1},{sprite_folder,"DNGNSPS#060800",2}}
set frames to {{art_folder,"FRAMEM#064c00",2},{realm_path,"TITLE.PIC#062000",3}}
set blist to machine_code & sprites & frames

repeat with ndisk from 0 to 3

	tell application "Virtual ]["
		set depDisk to disk folder & (item (ndisk + 1) of disk_name)
		tell front machine
			eject device "S6D2"
			insert depDisk into device "S6D2"
		end tell
	end tell

	if dres contains "clean first" then
		tell application "Virtual ]["
			tell front machine
				if dres contains "binaries" then
					repeat with tuple in blist
						if tuple contains ndisk then
							set src to item 2 of tuple
								type line "DELETE " & (my dos33(src)) & ",D2"
						end if
					end repeat
				end if
				if dres contains "monsters" and ndisk = 2 then
					type line "DELETE MONSTERS,D2"
					repeat with mons in monslist
						type line "DELETE " & (my dos33(mons)) & ",D2"
					end repeat
				end if
				if dres contains "maps" and ndisk = 0 then
					repeat with map in maplist
						type line "DELETE " & (my dos33(map)) & ",D2"
					end repeat
				end if
				if dres contains "xmaps" and ndisk = 1 then
					repeat with xmap in xmaplist
						type line "DELETE " & (my dos33(xmap)) & ",D2"
					end repeat
				end if
				if dres contains "BASIC" then
					repeat with tuple in slist
						if tuple contains ndisk then
							set src to item 1 of tuple
								type line "DELETE " & src & ",D2"
						end if
					end repeat
				end if
			end tell
		end tell
	end if

	if dres contains "monsters" and ndisk = 2 then

		repeat with mons in monslist
			set mac_path to art_folder & mons
			set a2_path to my dos33(mons)
			enterBinary(mac_path,a2_path,35968)
		end repeat

		set mac_path to text_folder & "MONSTERS.TXT"
		set t to text of (read POSIX file mac_path)
		tell application "Virtual ]["
			tell front machine
				type line "NEW"
				type line "10 PRINT CHR$(4);\"OPEN MONSTERS,D2\""
				type line "20 PRINT CHR$(4);\"WRITE MONSTERS\""
				set l to 21
				repeat with dat in paragraphs of t
					type line " " & l & " PRINT \"" & dat & "\""
					set l to l + 1
				end repeat
				type line "9999 PRINT CHR$(4);\"CLOSE MONSTERS\""
				type line "RUN"
			end tell
		end tell
		waitForTyping()
	end if

	if dres contains "maps" and ndisk = 0 then
		repeat with map in maplist
			set mac_path to map_folder & map
			set a2_path to my dos33(map)
			enterBinary(mac_path,a2_path,32768)
		end repeat
	end if

	if dres contains "xmaps" and ndisk = 1 then
		repeat with xmap in xmaplist
			set mac_path to xmap_folder & xmap
			set a2_path to my dos33(xmap)
			enterBinary(mac_path,a2_path,32768)
		end repeat
	end if

	if dres contains "maps" and ndisk = 3 then
		set mac_path to map_folder & "ARRINEA#068000"
		enterBinary(mac_path,"ARRINEA",32768)
	end if

	if dres contains "xmaps" and ndisk = 3 then
		set mac_path to xmap_folder & "ABYSS#068000"
		enterBinary(mac_path,"ABYSS",32768)
		set mac_path to xmap_folder & "FONKRAKIS#068000"
		enterBinary(mac_path,"FONKRAKIS",32768)
		set mac_path to xmap_folder & "WORNOTH#068000"
		enterBinary(mac_path,"WORNOTH",32768)
	end if

	repeat with tuple in blist
		if dres contains "binaries" and tuple contains ndisk then
			set src to item 2 of tuple
			set mac_path to (item 1 of tuple) & src
			enterBinary(mac_path,dos33(src),0)
		end if
	end repeat

	repeat with tuple in slist
		if dres contains "BASIC" and tuple contains ndisk then

			set src to item 1 of tuple
			set addr0 to item 2 of tuple
			set addr to addr0 + 1
			set page to (addr / 256) as integer
			if character 1 of src = "-" then
				set src to character 2 through end of src as string
				set str to bas_dos_folder & src & ".bas"
			else
				set str to bas_com_folder & src & ".bas"
			end if

			tell application "Virtual ]["
				tell front machine
					type line "HOME: PRINT \"Processing " & src & "\""
					if addr0 > 10 then
						type line "POKE " & addr0 & ",0"
						type line "POKE 103," & addr - page * 256
						type line "POKE 104," & page
					end if
					delay pause
				end tell
			end tell
			enterProgram(str)
			tell application "Virtual ]["
				tell front machine
					if addr0 = 9 then
						type line "SAVE " & src & ",D2"
					else
						type line "VTAB 24: PRINT PEEK(175);\" \";PEEK(176)"
						delay 1
						set lb to word 1 of line 22 of the screen text
						set hb to word 2 of line 22 of the screen text
						set len to hb * 256 + lb - addr + 1
						type line "BSAVE " & src & ",A" & addr & ",L" & len & ",D2"
						if addr0 = 2816 and len > 1279 or addr0 = 2048 and len > 2047 or addr0 = 16384 and len > 11519 or addr0 = 4096 and len > 1451 then
							if src is not "FINAL"
								display dialog "WARNING: program " & src & " is too long"
							end if
						end if
					end if
					delay pause
				end tell
			end tell

		end if
	end repeat

end repeat

if dres contains "init/clean for distribution" then
	set str to script_folder & "CLEAN33.bas"
	tell application "Virtual ]["
		set disk0 to disk folder & (item 1 of disk_name)
		set disk1 to disk folder & (item 2 of disk_name)
		set disk3 to disk folder & (item 4 of disk_name)
		tell front machine
			eject device "S6D1"
			eject device "S6D2"
			insert disk3 into device "S6D1"
			insert disk0 into device "S6D2"
		end tell
	end tell
	enterProgram(str)
	tell application "Virtual ]["
		tell front machine
			type line "VERIFY DISK3,D1"
			type line "RUN"
			type line "VERIFY DISK0,D2"
			type line "RUN"
			type line "BLOAD ARRINEA,A$8000,D1"
			type line "BSAVE ARRINEA,A$8000,L3200,D2"
		end tell
	end tell
	waitForTyping()
	tell application "Virtual ]["
		tell front machine
			eject device "S6D2"
			insert disk1 into device "S6D2"
			delay pause
			type line "BLOAD ABYSS,A$8000,D1"
			type line "BSAVE ABYSS,A$8000,L3200,D2"
			type line "BLOAD FONKRAKIS,A$8000,D1"
			type line "BSAVE FONKRAKIS,A$8000,L3200,D2"
			type line "BLOAD WORNOTH,A$8000,D1"
			type line "BSAVE WORNOTH,A$8000,L3200,D2"
		end tell
	end tell
end if
