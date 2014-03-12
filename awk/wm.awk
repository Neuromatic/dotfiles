#!/usr/bin/awk -f

function TheWM() {
	while("xprop -root _NET_WM_NAME"|getline) {
		
		gsub("\"","",$3);
	}
	for( i = 3; i<=NF;i++) {
		printf $i" "
		buffer=
     } 
}

BEGIN {
	printf buffer
}
