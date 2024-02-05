# zsh-trampoline -- Jump to the places that matter to you.
# https://github.com/HerCerM/zsh-trampoline

# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Do not source this script multiple times.
command -v zt_version > /dev/null && return

export ZT_PLUGIN_PATH="${0:h}"
source "$ZT_PLUGIN_PATH/src/configuration.zsh"
source "$ZT_PLUGIN_PATH/src/directories.zsh"
source "$ZT_PLUGIN_PATH/src/widgets.zsh"
