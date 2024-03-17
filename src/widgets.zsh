# List directories in fzf and cd to the selected directory.
function zt_widget_jump_to_directory {
  # Verify a configuration source is provided.
  if ! [[ -f "$ZT_CONFIG_FILE_PATH" ]] && [[ ${+zt_config} -eq 0 ]]; then
    printf "No configuration source. One of the following must exist:
    1. CSV configuration file: $ZT_CONFIG_FILE_PATH
    2. Zsh array parameter: zt_config" 1>&2
    zle accept-line
    return 1
  fi
  local raw_dirs="$(zt_get_raw_directories)"
  local pretty_dirs_expanded="$(echo "$raw_dirs" | zt_pretty_print true)"
  local pretty_dirs_not_expanded="$(echo "$raw_dirs" | zt_pretty_print false)"
  local selected_directory="$(echo "$pretty_dirs_expanded" \
      | fzf --tiebreak=index --prompt "< " \
          --bind "${ZT_KEY_MAP_TOGGLE_EXPAND}:transform:[[ ! {fzf:prompt} =~ \\< ]] &&
          echo 'change-prompt(< )+reload(echo \"$pretty_dirs_expanded\")' ||
          echo 'change-prompt(> )+reload(echo \"$pretty_dirs_not_expanded\")'" \
      | zt_get_path_from_pretty)"
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
