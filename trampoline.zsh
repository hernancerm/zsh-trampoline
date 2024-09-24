# zsh-trampoline -- Jump to the places that matter to you.
# https://github.com/hernancerm/zsh-trampoline

# Do not source this script multiple times.
command -v zt_version > /dev/null && return

# CONFIGURATION

function zt_version {
  echo '0.1.0-dev'
}

# Global configuration.
typeset ZT_KEY_MAP_JUMP='^j'

# DIRECTORIES

# @stdout Print file paths ready to be used in a picker like fzf.
function zt_print_files {
  for raw_file in ${ZT_CONFIG}; do
    local file_path="${raw_file%%:*}"
    if [[ ${raw_file[(i):single]} -le ${#raw_file} ]]; then
      # No expand
      echo "${file_path}" | sed "s#${HOME}#~#"
    else
      # Expand
      find "${(e)${file_path}/[~]/${HOME}}" -maxdepth 1 -type d \
        | sed '1d' | sed "s#${HOME}#~#" | sort | xargs printf '%s\n'
    fi
  done
}

# WIDGETS

# List directories in fzf and cd to the selected directory.
function zt_widget_jump_to_file {
  # Verify a configuration source is provided.
  if [[ ${+ZT_CONFIG} -eq 0 ]]; then
    printf 'No configuration source. Export the Zsh parameter `ZT_CONFIG`.' 1>&2
    zle accept-line
    return 1
  fi
  local pretty_dirs="$)"
  local selected_directory="$(zt_print_files | fzf --tiebreak=index)"
  if [[ -z "$selected_directory" ]]; then
    zle reset-prompt
    return
  fi
  local selected_file_expanded="$(eval echo ${selected_directory})"
  if [[ -d ${selected_file_expanded} ]] BUFFER="cd ${selected_file_expanded}"
  if [[ -f ${selected_file_expanded} ]] BUFFER="${EDITOR} ${selected_file_expanded}"
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
