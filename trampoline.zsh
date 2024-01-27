# zsh-trampoline -- Jump to the places that matter to you.
# https://github.com/HerCerM/zsh-trampoline

# Do not source this script multiple times.
command -v zt_version > /dev/null && return

source ${0:a:h}/src/configuration.zsh
source ${0:a:h}/src/completions.zsh
source ${0:a:h}/src/widgets.zsh
