# zsh-trampoline -- Jump to the places that matter to you.
# https://github.com/hernancerm/zsh-trampoline

# Do not source this script multiple times.
command -v zt_version > /dev/null && return

# CONFIGURATION

function zt_version {
  echo '0.1.0-dev'
}

# Global configuration.
typeset ZT_KEY_MAP_JUMP_TO_DIRECTORY='^j'

# DIRECTORIES

# @stdout Print directories ready to be used in a picker like fzf.
function zt_print_dirs {
  for raw_dir in ${ZT_CONFIG}; do
    local dir_path="${raw_dir%%:*}"
    if [[ ${raw_dir[(i):single]} -le ${#raw_dir} ]]; then
      # No expand
      echo "${dir_path}" | sed "s#${HOME}#~#"
    else
      # Expand
      find "${(e)${dir_path}/[~]/${HOME}}" -maxdepth 1 -type d \
        | sed '1d' | sed "s#${HOME}#~#" | sort | xargs printf '%s\n'
    fi
  done
}

# WIDGETS

# List directories in fzf and cd to the selected directory.
function zt_widget_jump_to_directory {
  # Verify a configuration source is provided.
  if [[ ${+ZT_CONFIG} -eq 0 ]]; then
    printf 'No configuration source. Export the Zsh parameter `ZT_CONFIG`.' 1>&2
    zle accept-line
    return 1
  fi
  local pretty_dirs="$)"
  local selected_directory="$(zt_print_dirs | fzf --tiebreak=index)"
  if [[ -z "$selected_directory" ]]; then
    zle reset-prompt
    return
  fi
  local selected_directory_expanded="$(eval echo ${selected_directory})"
  BUFFER="cd ${selected_directory_expanded}"
  zle accept-line
  zle reset-prompt
}

# Standard widget setup.
function zt_setup_widget_jump_to_directory {
  zle -N zt_widget_jump_to_directory
  bindkey ${ZT_KEY_MAP_JUMP_TO_DIRECTORY} zt_widget_jump_to_directory
}

# Setup widget as per zsh-vi-mode requirements.
# https://github.com/jeffreytse/zsh-vi-mode/tree/master#custom-widgets-and-keybindings
function zt_zvm_setup_widget_jump_to_directory {
  zvm_define_widget zt_widget_jump_to_directory
  zvm_bindkey viins ${ZT_KEY_MAP_JUMP_TO_DIRECTORY} zt_widget_jump_to_directory
}
