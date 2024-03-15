# @param $1 Configuration file: 'main', 'local'.
function zt_get_configuration_file_path {
  case "$1" in
    'main')  local config_file=$(eval echo "$ZT_HOME/config.csv");;
    'local') local config_file=$(eval echo "$ZT_HOME/config_local.csv");;
  esac
  echo "$config_file"
}

# @param $1 Raw directories to return; accepts 'main', 'local' or 'all'.
function zt_get_raw_directories {
  local get_raw_dirs_main="cat $(zt_get_configuration_file_path 'main')"
  local get_raw_dirs_local="cat $(zt_get_configuration_file_path 'local') 2> /dev/null"
  case "$1" in
    'main') eval "$get_raw_dirs_main";;
    'local') eval "$get_raw_dirs_local";;
    'all') eval "$get_raw_dirs_main" && eval "$get_raw_dirs_local";;
  esac
}

# @stdout Function name with args which when evaluated returns raw directories.
function zt_get_raw_directories_function {
  local raw_directories_function='zt_get_raw_directories main'
  if [[ $ZT_LIST_DIRECTORIES_LOCAL -eq 1 ]]; then
    local raw_directories_function='zt_get_raw_directories all'
  fi
  echo "$raw_directories_function"
}

# @stdin Raw lines from the directories config file.
# @stdout Pretty-printed directories. Mock-up: *~/dev/gc    -- Git cloned repos.
function zt_pretty_print {
  local stdin="$(cat -)"
  local longest_path_length="$(echo "$stdin" \
      | gawk -i trampoline.gawk -F, '{ print(length(zt::trim($1))) }' \
      | sort -rn \
      | head -1)"
  echo "$stdin" | gawk -i trampoline.gawk \
      -v longest_path_length=$longest_path_length -v expand=$1 '{
          zt::pretty_print($0, longest_path_length, expand) }'
}

# @stdin Prettified lines of lines from the directories config file.
# @stdout The trimmed value of the field.
function zt_get_path_from_pretty {
  while IFS='\n$' read -r; do
    if [[ "$REPLY" = *[-][-]* ]]; then
      local path_without_description="${${(s:--:)REPLY}[1]}"
    else
      local path_without_description="$REPLY"
    fi
    local path_whitespace_trimmed="${(*)${(*)${path_without_description}##[ ]##}%%[ ]##}"
    echo "${path_whitespace_trimmed##${ZT_DIRECTORY_DECORATOR}}"
  done
}
