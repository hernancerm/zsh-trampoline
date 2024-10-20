# zsh-trampoline -- Jump to the places that matter to you.
# https://github.com/hernancerm/zsh-trampoline

# Do not source this script multiple times.
command -v zt_version > /dev/null && return

# CONFIGURATION

function zt_version {
  echo '0.1.1-dev'
}

typeset ZT_KEY_MAP_JUMP='^j'

# FUNCTIONS

## Serialize into a file the current value of the global Zsh parameter ZT_CONFIG.
## Why: This serialization mechanism is used for the purpose of passing the value of
##      ZT_CONFIG to the scripts under the `cmd` directory of this repository. The reason
##      those scripts exist is that fzf executes the command provided in the actions as
##      `zsh -c '<command>'`, therefore functions in the host shell are not available to
##      fzf's actions. For the scripts to read the ZT_CONFIG parameter (which is also not
##      available on actions for the same reason), the parameter definition is serialized.
##      This preserves quotes on array elements which contain whitespace, which does not
##      seem possible when trying to pass the definition as a script string argument.
## @stdout File path of the file which holds the serialization of ZT_CONFIG.
function serialize_zt_config {
  zt_config_serialization_file_path='/tmp/ZT_CONFIG.serialization.zsh'
  typeset -p ZT_CONFIG > "${zt_config_serialization_file_path}"
  echo "${zt_config_serialization_file_path}"
}

## Assigns a value to the global Zsh parameter BUFFER. Documentation on this parameter:
## https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#User_002dDefined-Widgets
## @param $1 Chosen file path to jump to. It might contain whitespace.
function assign_buffer_contents {
  local file_path="${1}"
  if [[ -d "${1}" ]] local cmd='cd'
  if [[ -f "${1}" ]] local cmd="${EDITOR:-vim}"
  # When the file path has a whitespace char, surround it with single quotes.
  if [[ ${1[(i) ]} -le ${#1} ]] file_path="'${1}'"
  BUFFER="${cmd} ${file_path}"
}

# WIDGETS

# List files in fzf and jump to the selected one.
function zt_widget_jump_to_file {
  if [[ ${+ZT_CONFIG} -eq 0 ]]; then
    printf 'No configuration source. Export the Zsh parameter `ZT_CONFIG`.' 1>&2
    zle accept-line
    return 1
  fi
  local serialization_file="$(serialize_zt_config)"
  local fzf_selection="$(${ZT_PATH}/cmd/zt_print_files ${serialization_file} | fzf \
    --tiebreak=index --prompt "> " --bind "*:transform:[[ ! {fzf:prompt} =~ \\> ]] &&
        echo 'change-prompt(> )+reload(
          ${ZT_PATH}/cmd/zt_print_files ${serialization_file})' ||
        echo 'change-prompt(< )+reload(
          ${ZT_PATH}/cmd/zt_print_files_flat ${serialization_file})'")"
  if [[ -z "${fzf_selection}" ]]; then
    zle reset-prompt
    return
  fi
  # Expand the tilde symbol (~) and environment variables.
  local file_path="$(eval echo ${fzf_selection})"
  assign_buffer_contents "${file_path}"
  zle accept-line
  zle reset-prompt
}

# Standard widget setup.
function zt_setup_widget_jump_to_file {
  zle -N zt_widget_jump_to_file
  bindkey ${ZT_KEY_MAP_JUMP} zt_widget_jump_to_file
}

# Setup widget as per zsh-vi-mode requirements.
# https://github.com/jeffreytse/zsh-vi-mode/tree/master#custom-widgets-and-keybindings
function zt_zvm_setup_widget_jump_to_file {
  zvm_define_widget zt_widget_jump_to_file
  zvm_bindkey viins ${ZT_KEY_MAP_JUMP} zt_widget_jump_to_file
}
