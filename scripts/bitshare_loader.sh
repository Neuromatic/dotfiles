#/bin/bash

xclip -o | xclip --selection primary
wget "$(xclip -o)"

uri="$(/usr/bin/cat *.html | grep -e "bitshare.com/stream" | awk '{print $2}' | tr -d "'")"

wget "$uri"
rm *.html
