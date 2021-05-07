set pause to 1
set clean_first to 1
set realm_path to "/Users/dan/Documents/appleii/Realm/"
set src_folder to realm_path & "source/"
set map_folder to realm_path & "arrinea-maps/"
set xmap_folder to realm_path & "exo-maps/"
set binary_folder to realm_path & "machine-code/"
set art_folder to realm_path & "artwork-squeezed/"

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
	end tell
end tell

set s1 to {{"ALCHEMIST", 2048, 1, 1, 0, 0}, {"ARCHWIZ", 2816, 1, 0, 0, 0}, {"BARON", 2048, 0, 1, 0, 0}}
set s2 to {{"CHAIN", 4096, 1, 1, 1, 0}, {"COMBAT", 16384, 1, 1, 1, 0}, {"DUNGEON", 16384, 0, 0, 1, 0}}
set s3 to {{"FOOD", 2816, 1, 1, 0, 0}, {"HIGH PRIEST!", 4096, 0, 0, 1, 0}, {"LIBRARY", 2048, 1, 1, 0, 0}}
set s4 to {{"MORDOCK!", 2048, 0, 0, 1, 0}, {"OUTSIDE", 16384, 1, 1, 0, 0}, {"PUB", 2816, 1, 1, 0, 0}, {"SAGE", 2816, 1, 0, 0, 0}}
set s5 to {{"SAVE GAME", 2048, 1, 0, 0, 0}, {"SHIPYARD", 2816, 1, 1, 0, 0}}
set s6 to {{"TEMPLE", 2048, 1, 1, 0, 0}, {"TOWN", 16384, 1, 1, 0, 0}, {"WEAPARM", 2048, 1, 1, 0, 0}}

set s7 to {{"AUTOSTART", 0, 1, 0, 0, 0}, {"GUTEN TAG", 0, 1, 0, 0, 1}, {"LAUNCH", 0, 0, 0, 0, 1}}
set s8 to {{"DISK0", 0, 1, 0, 0, 0}, {"DISK1", 0, 0, 1, 0, 0}, {"DISK2", 0, 0, 0, 1, 0}, {"DISK3", 0, 0, 0, 0, 1}}

set slist to s1 & s2 & s3 & s4 & s5 & s6 & s7 & s8

set disk_list to {0, 1, 2, 3}

set disk_name to {"realm-master.DO", "realm-dungeon.DO", "realm-monster.DO", "realm-setup.DO"}

set do_all to 0
repeat with ndisk in disk_list

	set do_this to 0
	if do_all = 0 then
		set theDialogText to "Deploy Disk " & ndisk & " (" & item (ndisk + 1) of disk_name & ") ? "
		display dialog theDialogText buttons {"Yes", "No", "All"}
		set dres to button returned of result
		if dres = "All" then
			set do_all to 1
		end if
		if dres = "Yes" then
			set do_this to 1
		end if
	end if

	if do_this = 1 or do_all = 1 then

		tell application "Virtual ]["
			set depDisk to disk folder & (item (ndisk + 1) of disk_name)
			tell front machine
				eject device "S6D2"
				insert depDisk into device "S6D2"
			end tell
		end tell

		if clean_first = 1 then
			repeat with tuple in slist
				if item (ndisk + 3) of tuple = 1 then
					set src to item 1 of tuple
					tell application "Virtual ]["
						tell front machine
							type line "DELETE " & src & ",D2"
						end tell
					end tell
				end if
			end repeat
		end if

		repeat with tuple in slist
			if item (ndisk + 3) of tuple = 1 then

				set src to item 1 of tuple
				set addr0 to item 2 of tuple
				set addr to addr0 + 1
				set page to (addr / 256) as integer
				set str to src_folder & src & ".bas"
				set t to text of (read POSIX file str)

				tell application "Virtual ]["
					tell front machine
						type line "HOME: PRINT \"Processing " & src & "\""
						#type line "DELETE " & src
						if addr0 = 0 then
							delay pause
							type line "NEW"
							type text t
							type line "SAVE " & src & ",D2"
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
							type line "BSAVE " & src & ",A" & addr & ",L" & len & ",D2"
							if addr0 = 2816 and len > 1279 or addr0 = 2048 and len > 2047 and not src = "MORDOCK!" or addr0 = 16384 and len > 11519 or addr0 = 4096 and len > 1933 then
								display dialog "WARNING: program " & src & " is too long"
							end if
							delay pause
						end if
					end tell
				end tell

			end if
		end repeat

	end if
end repeat
