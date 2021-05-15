tell application "Virtual ]["
	activate
	close every machine saving no
	open disk folder & "omni.vii"
	set theMachine to front machine
	delay 0.5
	set dsk to disk folder & "realm-prodos.po"
	tell theMachine
		set monochrome screen to false
		set scanlines to true
		set caps lock to true
		set speed to maximum
		eject device "S7D1"
		insert dsk into device "S7D1"
		type line "PR#7"
	end tell
end tell
