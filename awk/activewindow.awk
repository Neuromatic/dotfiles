#!/usr/bin/awk -f


function ActiveWindow() {
    while("xprop -root _NET_ACTIVE_WINDOW"|getline) {
        if(/0x/) {
            sprintf("xprop WM_NAME -id %s", $5)|getline;
            gsub("\"", "",$3);
        }
        for(i = 3; i<=NF;i++) 
            printf  $i" "
    }
}

BEGIN {
    ActiveWindow()
}
