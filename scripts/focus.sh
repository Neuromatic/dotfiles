#!/bin/bash
#focus.sh
#requires: wmctrl
#app > 1=app name; 2=Window Class
app=( dwb dwb ) 

if [[ -n $(pgrep ${app[0]}) ]]
then
	$(wmctrl -ax ${app[1]})
else
	exec ${app[0]}
fi
