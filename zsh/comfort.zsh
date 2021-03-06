zstyle :compinstall filename '/home/danny/.zshrc'
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:history-words' stop yes                                      
zstyle ':completion:*:history-words' remove-all-dups yes                           
zstyle ':completion:*:history-words' list false                                    
zstyle ':completion:*:history-words' menu yes                                      
zstyle ':completion::complete:*' use-cache 1
