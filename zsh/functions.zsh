function mkcd(){
mkdir -p "$1" && cd "$1"
}
function getbspwm() {
git clone https://github.com/baskerville/bspwm.git
}
function cdl() {
cd $1; l
}
function remindme(){
sleep $1; echo -e "\nZeitspanne ist vorüber\n"; mplayer ~/musik/Sabaton.mp3
}
function lsd(){
var1=$(ls -l | wc -l)
var2=$(ls -la | wc -l)
calc=$(echo "$var2-$var1-2" | bc -l)
echo "$calc dotfiles"
}
function reload() {
. $HOME/.zshrc
}
function chan() {
export Serv="$1"
export CHAN="$2"
}
function loadaur() {
wget $(aurquery $1 | awk '/URLPath:/ {print $2}')
}
function send() {
echo "$1" > $HOME/irc/$Serv/$CHAN/in
}
