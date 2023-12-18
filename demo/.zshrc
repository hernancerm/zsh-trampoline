# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2> /dev/null)"

# Starship
eval "$(starship init zsh)"

# zsh-trampoline
eval "$(sheldon source)"
zt_setup_widget_jump_to_directory

# Fzf
export FZF_DEFAULT_OPTS='--layout=reverse --height=~55%'
