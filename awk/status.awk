#!/usr/bin/awk -f

function CurrentWorkspace() {
    while("xprop -root _NET_CURRENT_DESKTOP"|getline) {
        t = $3+1
    }
    return t
}

function TotalWorkspaces() {
    while("xprop -root _NET_NUMBER_OF_DESKTOPS"|getline) {
        t = $3+1
    }
    return t
}

function WorkspaceViewer() {
    CWI[1]=""
    CWI[2]=""
    CWI[3]=""
    CWI[4]=""
    CWI[5]=""
    #TWS = TotalWorkspaces() 
    # You might want to enter this as a constant.
    TWS = 5
    CW  = CurrentWorkspace()
    for(i = 1; i<=TWS; i++) {
        if(i == CW) {
            buffer=buffer"\\u0\\b0 "CWI[i]" \\u2\\b2"
        } else {
            buffer=buffer " "CWI[i]" "
        }
    }
    printf buffer
}

BEGIN {
    WorkspaceViewer()
}