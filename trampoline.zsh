# zsh-trampoline. Jump to the places that matter to you.
#
# zsh-trampoline is configured via the file 'directories.csv'. The row format is:
# {path}, {description}, {metadata}
#
# {path} (string):
#     Relative or absolute path to a directory. It can include environment variables and
#     the caret symbol (~).
#
# {description} (string):
#     Short one-line description of the directory.
#
# {metadata} (string):
#     The items are separated by a space. Each item can have a value after a colon. If an
#     item does not have a colon then the assumed value is to be `true`. If the item is
#     not present then the assumed value is `false`. Metadata items:
#     - decorator (string): Prefix of the {path} in the pretty print output. Must be a
#                           single char. Default value: A single whitespace character.
#     - expand (boolean): Whether to list all level-1 subdirectories in the pretty print.
#
# Example:
# ~/dev/gr, Git my remote-backed repos., decorator:* expand

# Do not source this script multiple times.
command -v zt_version > /dev/null && return

# Select the config home location.
typeset -gr ZT_CONFIG_HOME="$(eval echo ${XDG_CONFIG_HOME:-'~/.config'}/zt \
    | xargs realpath)"

# Make the Gawk library available.
AWKPATH="$AWKPATH:${0:a:h}"

# Get the script version.
function zt_version {
  echo '0.1.0-SNAPSHOT'
}

# @param $1 field name, options: 'path', 'description', 'metadata'.
function zt_get_field_index {
  local index
  case "$1" in
    path)        index=1;;
    description) index=2;;
    metadata)    index=3;;
  esac
  echo $index
}

# @return string main directories as-are, no transformations applied to contents.
#         It is required to have this file.
function zt_get_raw_directories {
  local config_file_main=$(eval echo "$ZT_CONFIG_HOME/directories.csv")
  if ! [[ -f "$config_file_main" ]]; then
    echo "Missing configuration file: "$config_file_main"" 1>&2
    return 1
  fi
  cat "$config_file_main"
}

# @return string local directories as-are, no transformations applied to contents.
#         It is not required to have this file.
function zt_get_raw_directories_local {
  local config_file_local=$(eval echo "$ZT_CONFIG_HOME/directories_local.csv")
  if [[ -f "$config_file_local" ]]; then
    cat "$config_file_local"
  fi
}

# @return string all directories as-are, no transformations applied to the files.
#         (the public directories are listed first, then the private ones).
function zt_get_raw_directories_all {
  zt_get_raw_directories
  zt_get_raw_directories_local
}

# @stdin raw lines from the directories config file.
# @param $1 name of field to retrieve: `path`, `description` or `metadata`.
# @return string the trimmed value of the field.
function zt_get_field_from_raw {
  gawk -F',' -i trampoline.gawk -v field_index="$(zt_get_field_index $1)" '{
    print zt::trim($field_index) }'
}

# Pretty print the provided lines of raw lines from the directories config file.
#
# @stdin raw lines from the directories config file.
# @return string pretty-printed directories.
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

# @stdin prettified lines of lines from the directories config file.
# @param $1 name of field to retrieve: `path` or `description`.
# @return string the trimmed value of the field.
function zt_get_field_from_pretty {
  gawk -i trampoline.gawk -v field_index="$(zt_get_field_index $1)" '{
    split($0, fields_array, /\-\-/)
    print(zt::trim(substr(fields_array[field_index], 2)))
  }'
}
