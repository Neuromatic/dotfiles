#!/usr/bin/awk -f

function CurrentWorkspace() {
	while("xprop -root _NET_CURRENT_DESKTOP"|getline) {
		w = $3+1
	}
	return w
}

function AllWorkspaces() {
	while("xprop -root _NET_NUMBER_OF_DESKTOPS"|getline) {
		w = $3
	}
	return w
}

function Together() {
	TWS = AllWorkspaces()
	CW = CurrentWorkspace()

	buffer=CW"/"TWS
	printf buffer
}

BEGIN {
	Together()
}
