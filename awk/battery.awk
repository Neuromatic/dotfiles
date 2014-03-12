#!/usr/bin/awk -f

function Bat0() {
	while("acpi"|getline)
		gsub(",","",$4);
		printf $4;
}

BEGIN {
	Bat0()
}

