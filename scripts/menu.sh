#!/bin/zsh
9menu -label "2bwm"\
      -bg "#0d0b0d"\
      -fg "#f3e7c6"\
      -shell "/bin/zsh"\
      -font "-*-erusfont-medium-r-*-*-11-*-*-*-*-*-*-*"\
      -popup\
      -teleport\
      "urxvt":"urxvtc"\
      "firefox":"firefox"\
      "ncmpc":"urxvtc -name ncmpc -e ncmpc"\
      "mutt":"urxvtc -name mutt -e mutt"\
      "calcurse":"urxvtc -name calcurse -e calcurse"\
      "irc":"urxvtc -name irssi -e irrsi"\
      "w3m":"urxvtc -name w3m -e w3m -cookie google.de"\
      "import":"import -window root ~/pr0n.png"      
