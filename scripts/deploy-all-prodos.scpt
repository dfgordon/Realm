set pause to 1
set realm_path to "/Users/dan/Documents/appleii/Realm/"
set bas_pro_folder to realm_path & "basic-prodos/"
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
			type line "BSAVE " & a2_path & ",A" & addr & ",L" & len & ",S7,D1"
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

on findAndReplaceInText(theText, theSearchString, theReplacementString)
    set AppleScript's text item delimiters to theSearchString
    set theTextItems to every text item of theText
    set AppleScript's text item delimiters to theReplacementString
    set theText to theTextItems as string
    set AppleScript's text item delimiters to ""
    return theText
end findAndReplaceInText

on prodos(theText)
	set protext to findAndReplaceInText(theText," ",".")
	set protext to item 1 of splitText(protext,"#")
	return protext
end prodos

tell application "Virtual ]["
	activate
	close every machine saving no
	open disk folder & "omni.vii"
	set theMachine to front machine
	delay 0.5
	set dsk1 to disk folder & "prodos-basic.po"
	set dsk2 to disk folder & "realm-prodos.po"
	tell theMachine
		set monochrome screen to false
		set scanlines to true
		set caps lock to true
		set speed to maximum
		eject device "S6D1"
		eject device "S7D1"
		insert dsk1 into device "S6D1"
		insert dsk2 into device "S7D1"
		type line "PR#6"
	end tell
end tell

set choices to {"clean first", "binaries", "monsters", "maps", "xmaps", "BASIC", "init/clean for distribution"}
set dres to choose from list choices with title "Tasks" with prompt "Select" with multiple selections allowed

tell application "Finder"
	set mclist to {"MAP.INTRP#06163e","SOUND#060300","SDP.INTRP#0615ac"}
	set spritelist to name of every file of entire contents of ((POSIX file sprite_folder) as alias)
	set monslist to name of every file of entire contents of ((POSIX file art_folder) as alias)
	set maplist to name of every file of entire contents of ((POSIX file map_folder) as alias)
	set xmaplist to name of every file of entire contents of ((POSIX file xmap_folder) as alias)
end tell

set binlist to mclist & spritelist

set s1 to {{"ALCHEMIST", 2048}, {"ARCHWIZ", 2816}, {"BARON", 2048}}
set s2 to {{"-CHAIN", 4096}, {"COMBAT", 16384}, {"-DUNGEON", 16384}}
set s3 to {{"FOOD", 2816}, {"HIGH.PRIEST", 4096}, {"LIBRARY", 2048}}
set s4 to {{"-FINAL", 2048}, {"-OUTSIDE", 16384}, {"PUB", 2816}, {"SAGE", 2816}}
set s5 to {{"-SAVE.GAME", 2048}, {"SHIPYARD", 2816}}
set s6 to {{"TEMPLE", 2048}, {"-TOWN", 16384}, {"WEAPARM", 2048}}
set s7 to {{"-LAUNCH", 9}}
set slist to s1 & s2 & s3 & s4 & s5 & s6 & s7

if dres contains "clean first" then
	tell application "Virtual ]["
		tell front machine
			if dres contains "binaries" then
				repeat with bin in binlist
					type line "DELETE REALM/BIN/" & (my prodos(bin)) & ",S7,D1"
				end repeat
			end if
			if dres contains "monsters" then
				type line "DELETE REALM/MONSTERS/MONSTERS,S7,D1"
				repeat with mons in monslist
					type line "DELETE REALM/MONSTERS/" & (my prodos(mons)) & ",S7,D1"
				end repeat
			end if
			if dres contains "maps" then
				repeat with map in maplist
					type line "DELETE REALM/MAPS/" & (my prodos(map)) & ",S7,D1"
				end repeat
			end if
			if dres contains "xmaps" then
				repeat with xmap in xmaplist
					type line "DELETE REALM/XMAPS/" & (my prodos(xmap)) & ",S7,D1"
				end repeat
			end if
			if dres contains "BASIC" then
				repeat with tuple in slist
					type line "DELETE REALM/PROG/" & (item 1 of tuple) & ",S7,D1"
				end repeat
			end if
		end tell
	end tell
end if

if dres contains "monsters" then

	repeat with mons in monslist
		set mac_path to art_folder & mons
		set a2_path to "REALM/MONSTERS/" & (my prodos(mons))
		enterBinary(mac_path,a2_path,27904)
	end repeat

	set mac_path to text_folder & "MONSTERS.TXT"
	set t to text of (read POSIX file mac_path)
	tell application "Virtual ]["
		tell front machine
			type line "NEW"
			type line "10 PRINT CHR$(4);\"OPEN REALM/MONSTERS/MONSTERS,S7,D1\""
			type line "20 PRINT CHR$(4);\"WRITE REALM/MONSTERS/MONSTERS\""
			set l to 21
			repeat with dat in paragraphs of t
				type line " " & l & " PRINT \"" & dat & "\""
				set l to l + 1
			end repeat
			type line "9999 PRINT CHR$(4);\"CLOSE REALM/MONSTERS/MONSTERS\""
			type line "RUN"
		end tell
	end tell
	waitForTyping()
end if

if dres contains "binaries" then
	repeat with bin in mclist
		set mac_path to mc_folder & bin
		set a2_path to "REALM/BIN/" & (my prodos(bin))
		enterBinary(mac_path,a2_path,0)
	end repeat
	repeat with bin in spritelist
		set mac_path to sprite_folder & bin
		set a2_path to "REALM/BIN/" & (my prodos(bin))
		enterBinary(mac_path,a2_path,0)
	end repeat
	set mac_path to realm_path & "TITLE.PIC#062000"
	set a2_path to "REALM/TITLE.PIC"
	enterBinary(mac_path,a2_path,16384)
end if

if dres contains "maps" then
	repeat with map in maplist
		set mac_path to map_folder & map
		set a2_path to "REALM/MAPS/" & (my prodos(map))
		enterBinary(mac_path,a2_path,28160)
	end repeat
end if

if dres contains "xmaps" then
	repeat with xmap in xmaplist
		set mac_path to xmap_folder & xmap
		set a2_path to "REALM/XMAPS/" & (my prodos(xmap))
		enterBinary(mac_path,a2_path,28160)
	end repeat
end if

if dres contains "BASIC" then

	set str to bas_pro_folder & "STARTUP.bas"
	enterProgram(str)
	tell application "Virtual ]["
		tell front machine
			type line "SAVE STARTUP,S7,D1"
			type line "SAVE REALM/START.REALM,S7,D1"
			delay pause
		end tell
	end tell

	repeat with tuple in slist

		set src to item 1 of tuple
		set addr0 to item 2 of tuple
		set addr to addr0 + 1
		set page to (addr / 256) as integer
		if character 1 of src = "-" then
			set src to character 2 through end of src as string
			set str to bas_pro_folder & src & ".bas"
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
					type line "SAVE REALM/PROG/" & src & ",S7,D1"
				else
					type line "VTAB 24: PRINT PEEK(175);\" \";PEEK(176)"
					delay 1
					set lb to word 1 of line 22 of the screen text
					set hb to word 2 of line 22 of the screen text
					set len to hb * 256 + lb - addr + 1
					type line "BSAVE REALM/PROG/" & src & ",A" & addr & ",L" & len & ",S7,D1"
					if addr0 = 2816 and len > 1279 or addr0 = 2048 and len > 2047 or addr0 = 16384 and len > 11519 or addr0 = 4096 and len > 1451 then
						if src is not "FINAL"
							display dialog "WARNING: program " & src & " is too long"
						end if
					end if
				end if
				delay pause
			end tell
		end tell

	end repeat

end if

if dres contains "init/clean for distribution" then
	set str to script_folder & "CLEANPRO.bas"
	enterProgram(str)
	tell application "Virtual ]["
		tell front machine
			type line "VERIFY REALM,S7,D1"
			type line "RUN"
		end tell
	end tell
end if
