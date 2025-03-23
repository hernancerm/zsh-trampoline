# zsh-trampoline -- Jump to the places that matter to you.
# Homepage: <https://github.com/hernancerm/zsh-trampoline>.

# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

ZT_PATH="${0:h}"
source ${ZT_PATH}/trampoline.zsh
