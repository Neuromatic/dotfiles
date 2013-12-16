#	PROMPT='%{$fg[blue]%}┌─%{${reset_color}%}[ %{$fg_bold[red]%}%n%{${reset_color}%} ]%{$fg[blue]%}───%{${reset_color}%}[ %U%{$fg[magenta]%}%1~%{${reset_color}%}%u ]%{$fg[blue]%}
#        PROMPT='%{$fg[blue]%}┌─%{${reset_color}%}[ %{$fg[green]%}%n%{${reset_color}%} ]%{$fg[blue]%}───%{${reset_color}%}[ %U%{$fg[blue]%}%1~%{${reset_color}%}%u ]%{$fg[blue]%}
	

if [[ $(whoami) == "root" ]]; then

	PROMPT='%{$fg[red]%}─── %{${reset_color}%}'
	RPROMPT='%1~%'
else
	PROMPT='%{$fg[blue]%}─── %{${reset_colo}%}'
	RPROMPT='%1~%'
fi
PS2=' > '
