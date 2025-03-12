# zsh-trampoline -- Jump to the places that matter to you.
# https://github.com/hernancerm/zsh-trampoline

# Do not source this script multiple times.
command -v zt_version > /dev/null && return

# CONFIGURATION

function zt_version {
  echo '0.1.1-dev'
}

ZT_KEY_MAP_JUMP="${ZT_KEY_MAP_JUMP:-^t}"

# FUNCTIONS

## @stdout:string
function print_configured_files {
  for raw_file in ${ZT_CONFIG}; do
    local file_path="${raw_file%%:*}"
    local file_path_expanded="$(eval echo ${file_path})"
    if [[ -f "${file_path_expanded}" ]] || [[ ${raw_file[(i):0]} -le ${#raw_file} ]]; then
      # Pretty print the items which are:
      # 1. File paths. 2. Env vars pointing to a file path. 3. Items containing ':0'.
      echo "${file_path}" | sed "s#${HOME}#~#"
    elif [[ -d "${file_path_expanded}" ]]; then
      # Print sub-dirs at level-1 the items which are:
      # 1. Dir paths. 2. Env vars pointing to a dir path.
      # Note: The dir path itself is not printed.
      find "${file_path_expanded}" -maxdepth 1 -type d \
        | sed 1d | sed "s#${HOME}#~#" | sort
    fi
  done
}

## Assigns a value to the global Zsh parameter BUFFER. Documentation on this parameter:
## https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#User_002dDefined-Widgets
## @param:string $1 Chosen fs path to jump to. It might contain whitespace.
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
  local fzf_selection="$(print_configured_files | fzf --tiebreak=index)"
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
  bindkey "${ZT_KEY_MAP_JUMP}" zt_widget_jump_to_file
}

# Setup widget as per zsh-vi-mode requirements.
# <https://github.com/jeffreytse/zsh-vi-mode/tree/master#custom-widgets-and-keybindings>.
function zt_zvm_setup_widget_jump_to_file {
  zvm_define_widget zt_widget_jump_to_file
  zvm_bindkey viins "${ZT_KEY_MAP_JUMP}" zt_widget_jump_to_file
}
