# zsh-trampoline -- Jump to the places that matter to you.
# https://github.com/HerCerM/zsh-trampoline

# Do not source this script multiple times.
command -v zt_version > /dev/null && return

# Configuration{{{
# ---

function zt_version {
  echo '0.1.0-SNAPSHOT'
}

# Select the config home location.
export ZT_CONFIG_HOME="$(eval echo ${XDG_CONFIG_HOME:-'~/.config'}/zt \
    | xargs realpath)"

# Make the Gawk library available.
export AWKPATH="$AWKPATH:${0:a:h}"

# Make the zt script available in PATH.
export PATH="$PATH:${0:a:h}"

# Global configuration.
export ZT_LIST_DIRECTORIES_LOCAL=1
export ZT_KEY_MAP_JUMP_TO_DIRECTORY='^j'
typeset -gr ZT_DIRECTORY_DECORATOR='*'
# }}}

# Widgets{{{
# ---

# List directories in fzf and cd to the selected directory.
function zt_widget_jump_to_directory {
  zt validate_main_configuration_file_path
  if [[ $? -ne 0 ]]; then
    printf "Missing configuration file: $(zt get_configuration_file_path 'main')" 1>&2
    zle accept-line
    return 1
  fi
  local zt_raw_directories_function="$(zt get_raw_directories_function)"
  local selected_directory="$(zt $zt_raw_directories_function \
      | zt pretty_print true \
      | fzf --tiebreak=index --prompt "< " \
          --bind "*:transform:[[ ! {fzf:prompt} =~ \\< ]] &&
          echo 'change-prompt(< )+reload(zt $zt_raw_directories_function \
              | zt pretty_print true)' ||
          echo 'change-prompt(> )+reload(zt $zt_raw_directories_function \
              | zt pretty_print false)'" \
      | zt get_path_from_pretty)"
  if [[ -z "$selected_directory" ]]; then
    zle reset-prompt
    return
  fi
  local selected_directory_expanded="$(eval echo $selected_directory)"
  BUFFER="cd $selected_directory_expanded"
  zle accept-line
  zle reset-prompt
}

# Standard widget setup.
function zt_setup_widget_jump_to_directory {
  zle -N zt_widget_jump_to_directory
  bindkey $ZT_KEY_MAP_JUMP_TO_DIRECTORY zt_widget_jump_to_directory
}

# Setup widget as per zsh-vi-mode requirements.
# https://github.com/jeffreytse/zsh-vi-mode/tree/master#custom-widgets-and-keybindings
function zt_zvm_setup_widget_jump_to_directory {
  zvm_define_widget zt_widget_jump_to_directory
  zvm_bindkey viins $ZT_KEY_MAP_JUMP_TO_DIRECTORY zt_widget_jump_to_directory
}
# }}}

# vim: foldmethod=marker foldlevel=0
