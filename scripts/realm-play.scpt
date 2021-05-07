tell application "Virtual ]["
	activate
	close every machine saving no
	make new AppleIIe
	delay 0.5
	set dsk1 to disk folder & "realm-master.DO"
	set dsk2 to disk folder & "realm-monster.DO"
	tell front machine
		set monochrome screen to false
		set scanlines to true
		set caps lock to true
		set speed to maximum
		eject device "S6D1"
		eject device "S6D2"
		insert dsk1 into device "S6D1"
		insert dsk2 into device "S6D2"
	end tell
end tell
