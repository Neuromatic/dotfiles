#!/usr/bin/env zsh

id=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')

import -window $id active_window.png
