set pause to 1
set clean_first to 1
set realm_path to "/Users/dan/Documents/appleii/Realm/"
set src_folder to realm_path & "prodos/"
set map_folder to realm_path & "arrinea-maps/"
set xmap_folder to realm_path & "exo-maps/"
set binary_folder to realm_path & "machine-code/"
set art_folder to realm_path & "artwork-squeezed/"

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

set s1 to {{"ALCHEMIST", 2048}, {"ARCHWIZ", 2816}, {"BARON", 2048}}
set s2 to {{"CHAIN", 4096}, {"COMBAT", 16384}, {"DUNGEON", 16384}}
set s3 to {{"FOOD", 2816}, {"HIGH.PRIEST", 4096}, {"LIBRARY", 2048}}
set s4 to {{"MORDOCK", 2048}, {"OUTSIDE", 16384}, {"PUB", 2816}, {"SAGE", 2816}}
set s5 to {{"SAVE.GAME", 2048}, {"SHIPYARD", 2816}}
set s6 to {{"TEMPLE", 2048}, {"TOWN", 16384}, {"WEAPARM", 2048}}

set s7 to {{"LAUNCH", 0}}

set slist to s1 & s2 & s3 & s4 & s5 & s6 & s7

if clean_first = 1 then
	repeat with tuple in slist
		set src to item 1 of tuple
		tell application "Virtual ]["
			tell front machine
				type line "DELETE REALM/PROG/" & src & ",S7,D1"
			end tell
		end tell
	end repeat
end if

repeat with tuple in slist

	set src to item 1 of tuple
	set addr0 to item 2 of tuple
	set addr to addr0 + 1
	set page to (addr / 256) as integer
	set str to src_folder & src & ".bas"
	set t to text of (read POSIX file str)

	tell application "Virtual ]["
		tell front machine
			type line "HOME: PRINT \"Processing " & src & "\""
			if addr0 = 0 then
				delay pause
				type line "NEW"
				type text t
				type line "SAVE REALM/PROG/" & src & ",S7,D1"
				delay pause
			else
				type line "POKE " & addr0 & ",0"
				type line "POKE 103," & addr - page * 256
				type line "POKE 104," & page
				delay pause
				type line "NEW"
				type text t
				type line "PRINT \"FINISHEDSOURCEENTRY\""
				repeat
					delay 0.5
					if the last word of line 22 of the screen text = "FINISHEDSOURCEENTRY" then
						exit repeat
					end if
				end repeat
				type line "VTAB 24: PRINT PEEK(175);\" \";PEEK(176)"
				delay 1
				set lb to word 1 of line 22 of the screen text
				set hb to word 2 of line 22 of the screen text
				set len to hb * 256 + lb - addr + 1
				type line "BSAVE REALM/PROG/" & src & ",A" & addr & ",L" & len & ",S7,D1"
				if addr0 = 2816 and len > 1279 or addr0 = 2048 and len > 2047 and not src = "MORDOCK" or addr0 = 16384 and len > 11519 or addr0 = 4096 and len > 1933 then
					display dialog "WARNING: program " & src & " is too long"
				end if
				delay pause
			end if
		end tell
	end tell

end repeat
