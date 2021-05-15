tell application "Virtual ]["
	activate
	close every machine saving no
	make new AppleIIe
	delay 0.5
	set dsk1 to disk folder & "realm-dos33-setup.DO"
	tell front machine
		set monochrome screen to false
		set scanlines to true
		set caps lock to true
		set speed to maximum
		eject device "S6D1"
		insert dsk1 into device "S6D1"
	end tell
end tell
