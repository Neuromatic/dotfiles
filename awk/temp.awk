#!/usr/bin/awk -f

function CpuTemp() {
	while ("acpi -t"|getline) {
		print $4
	}
}

function dtandtm() {
	while ("date \"+%d/%H:%M\""|getline) {
		print $0
	}
}

function getall() {
	printf "%f %s",CpuTemp(),dtandtm()
}

BEGIN {
	getall()
}

