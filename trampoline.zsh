# zsh-trampoline -- Jump to the places that matter to you.
# https://github.com/HerCerM/zsh-trampoline

# Do not source this script multiple times.
command -v zt_version > /dev/null && return

# Configuration{{{
# ---

# Select the config home location.
typeset -gr ZT_CONFIG_HOME="$(eval echo ${XDG_CONFIG_HOME:-'~/.config'}/zt \
    | xargs realpath)"

# Make the Gawk library available.
export AWKPATH="$AWKPATH:${0:a:h}"

# Global configuration.
export ZT_DIRECTORY_DECORATOR='*'
export ZT_LIST_DIRECTORIES_LOCAL=1
export ZT_KEY_MAP_JUMP_TO_DIRECTORY='^j'
# }}}

# Functions{{{
# ---

# Get the script version.
function zt_version {
  echo '0.1.0-SNAPSHOT'
}

# @param $1 Field name, options: 'path', 'description', 'expand'.
function zt_get_field_index {
  local index
  case "$1" in
    path)        index=1;;
    description) index=2;;
    expand)      index=3;;
  esac
  echo $index
}

# @param $1 Configuration file: 'main', 'local'.
function zt_get_configuration_file_path {
  case "$1" in
    'main')  local config_file=$(eval echo "$ZT_CONFIG_HOME/config.csv");;
    'local') local config_file=$(eval echo "$ZT_CONFIG_HOME/config_local.csv");;
  esac
  echo "$config_file"
}

# @param $1 Configuration file path.
function zt_validate_main_configuration_file_path {
  if ! [[ -f "$(zt_get_configuration_file_path 'main')" ]]; then
    return 1
  fi
}

# @return string Main directories as-are, no transformations applied to contents.
#         It is required to have this file.
function zt_get_raw_directories_main {
  cat $(zt_get_configuration_file_path 'main')
}

# @return string Local directories as-are, no transformations applied to contents.
#         It is not required to have this file.
function zt_get_raw_directories_local {
  cat $(zt_get_configuration_file_path 'local') 2> /dev/null
}

# @return string All directories as-are, no transformations applied to the files.
#         (the public directories are listed first, then the private ones).
function zt_get_raw_directories_all {
  zt_get_raw_directories_main && zt_get_raw_directories_local
}

# @return string Function name which when invoked returns a list of raw directories.
function zt_get_raw_directories_function {
  local list_local=$ZT_LIST_DIRECTORIES_LOCAL
  local zt_raw_directories_function='zt_get_raw_directories_main'
  if [[ $list_local -eq 1 ]]; then
    local zt_raw_directories_function='zt_get_raw_directories_all'
  fi
  echo "$zt_raw_directories_function"
}

# @stdin Raw lines from the directories config file.
# @param $1 Name of field to retrieve: `path`, `description` or `expand`.
# @return string The trimmed value of the field.
function zt_get_field_from_raw {
  gawk -F',' -i trampoline.gawk -v field_index="$(zt_get_field_index $1)" '{
    print zt::trim($field_index) }'
}

# Pretty print the provided lines of raw lines from the directories config file.
#
# @stdin Raw lines from the directories config file.
# @return string Pretty-printed directories.
function zt_pretty_print {
  local stdin="$(cat -)"
  local longest_path_length="$(echo "$stdin" \
      | zt_get_field_from_raw 'path' \
      | gawk '{ print(length($0)) }' \
      | sort -rn \
      | head -1)"
  echo "$stdin" | gawk -i trampoline.gawk -v longest_path_length=$longest_path_length '{
      zt::pretty_print($0, longest_path_length) }'
}

# @stdin Prettified lines of lines from the directories config file.
# @param $1 Name of field to retrieve: `path` or `description`.
# @return string The trimmed value of the field.
function zt_get_field_from_pretty {
  gawk -i trampoline.gawk -v field_index="$(zt_get_field_index $1)" '{
    split($0, fields_array, /\-\-/)
    field_value = zt::trim(fields_array[field_index])
    if (field_index == 1) {
      sub(ENVIRON["ZT_DIRECTORY_DECORATOR"], "", field_value)
    }
    print(field_value)
  }'
}
# }}}

# Widgets{{{
# ---

# List directories in fzf and cd to the selected directory.
function zt_widget_jump_to_directory {
  zt_validate_main_configuration_file_path
  if [[ $? -ne 0 ]]; then
    printf "Missing configuration file: $(zt_get_configuration_file_path 'main')" 1>&2
    zle accept-line
    return 1
  fi
  local zt_raw_directories_function="$(zt_get_raw_directories_function)"
  local selected_directory="$(eval $zt_raw_directories_function \
      | zt_pretty_print \
      | fzf --height=~55% --tiebreak=index \
      | zt_get_field_from_pretty 'path')"
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
