# List directories in fzf and cd to the selected directory.
function zt_widget_jump_to_directory {
  # Validate main configuration file path.
  if ! [[ -f "$(zt get_configuration_file_path 'main')" ]]; then
    return 1
  fi
  if [[ $? -ne 0 ]]; then
    printf "Missing configuration file: $(zt get_configuration_file_path 'main')" 1>&2
    zle accept-line
    return 1
  fi
  local zt_raw_directories_function="$(zt get_raw_directories_function)"
  local selected_directory="$(zt $zt_raw_directories_function \
      | zt pretty_print true \
      | fzf --tiebreak=index --prompt "< " \
          --bind "${ZT_KEY_MAP_TOGGLE_EXPAND}:transform:[[ ! {fzf:prompt} =~ \\< ]] &&
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
