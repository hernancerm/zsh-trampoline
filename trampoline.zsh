# zsh-trampoline -- Jump to the places that matter to you.
# https://github.com/hernancerm/zsh-trampoline

# Do not source this script multiple times.
command -v zt_version > /dev/null && return

# CONFIGURATION

function zt_version {
  echo '0.1.1-dev'
}

# Global configuration.
typeset ZT_KEY_MAP_JUMP='^j'

# WIDGETS

# List files in fzf and open the selected one.
function zt_widget_jump_to_file {
  # Verify a configuration source is provided.
  if [[ ${+ZT_CONFIG} -eq 0 ]]; then
    printf 'No configuration source. Export the Zsh parameter `ZT_CONFIG`.' 1>&2
    zle accept-line
    return 1
  fi
  local fzf_selection="$(${ZT_PATH}/cmd/zt_print_files ${ZT_CONFIG}\
  | fzf --tiebreak=index --prompt "> " \
    --bind "*:transform:[[ ! {fzf:prompt} =~ \\> ]] &&
      echo 'change-prompt(> )+reload(${ZT_PATH}/cmd/zt_print_files ${ZT_CONFIG})' ||
      echo 'change-prompt(< )+reload(${ZT_PATH}/cmd/zt_print_files_flat ${ZT_CONFIG})'")"
  if [[ -z "${fzf_selection}" ]]; then
    zle reset-prompt
    return
  fi
  # Expand the tilde symbol (~) and environment variables.
  local file_path="$(eval echo ${fzf_selection})"
  if [[ -d "${file_path}" ]]; then
    BUFFER="cd ${file_path}"
    # When the file path has a whitespace char, surround it with single quotes.
    if [[ ${file_path[(i) ]} -le ${#file_path} ]] BUFFER="cd '${file_path}'"
  fi
  if [[ -f "${file_path}" ]] BUFFER="${EDITOR:-vim} ${file_path}"
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
