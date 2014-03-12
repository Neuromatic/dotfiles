#!/usr/bin/env bash

var1=$(ls $HOME/Mail/web/Unbekannt/new/ | wc -l)
var2=$(ls $HOME/Mail/riseup/INBOX/new/ | wc -l)

while true 
do
	offlineimap 2&1> /dev/null
	sleep 5m
done
