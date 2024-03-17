# @stdout Raw directories. List first from the config file, then from the array parameter.
function zt_get_raw_directories {
  cat "$ZT_CONFIG_FILE_PATH" 2> /dev/null
  printf '%s\n' "${zt_config[@]}"
}

# @stdin Raw lines from the directories config.
# @stdout Length (integer) of the longest directory path as-written in the config.
function zt_get_longest_path_length {
  local paths_lengths=()
  while IFS='\n$' read -r dir_raw; do
    local directory_path="${dir_raw}"
    if [[ "$directory_path" = *,* ]] directory_path="${${(s:,:)dir_raw}[1]}"
    local path_whitespace_trimmed="${(*)${(*)directory_path##[ ]##}%%[ ]##}"
    paths_lengths+=(${#path_whitespace_trimmed})
  done <<< "$stdin"
  local -i longest_path_length=0
  for length in "${paths_lengths[@]}"; do
    if [[ $longest_path_length -lt $length ]] longest_path_length=$length
  done
  echo $longest_path_length
}

# @stdin Raw lines from the directories config.
# @param $1 When 'true' print level-one sub-directories for dirs marked for expansion.
# @stdout Pretty-printed directories. Mock-up: *~/dev/gc    -- Git cloned repos.
function zt_pretty_print {
  local stdin="$(cat -)"
  local -i longest_path_length=$(zt_get_longest_path_length "$stdin")
  while IFS='\n$' read -r raw_dir; do
    local -a raw_dir_parts=("${(@s:,:)raw_dir}")
    local path_no_whitespace="${(*)${(*)${raw_dir_parts[1]}##[ ]##}%%[ ]##}"
    # Print directory.
    if [[ -z "${raw_dir_parts[2]}" ]]; then
      # Directory does not have a description.
      printf '%s%s\n' $ZT_DIRECTORY_DECORATOR "$path_no_whitespace"
    else
      # Directory has a description.
      local desc_no_whitespace="${(*)${(*)${raw_dir_parts[2]}##[ ]##}%%[ ]##}"
      printf '%s%s\n' \
          $ZT_DIRECTORY_DECORATOR \
          "${(r:$(($longest_path_length + 2)):)path_no_whitespace}-- $desc_no_whitespace"
    fi
    local expand_no_whitespace="${(*)${(*)${raw_dir_parts[3]}##[ ]##}%%[ ]##}"
    if [[ $1 = 'true' ]] && [[ "${expand_no_whitespace}" = 'true' ]]; then
      # Print level-1 sub-directories.
      # Brittle substitution of ~, as it's assumed that file names can't contain a ~.
      find "${(e)path_no_whitespace/[~]/${HOME}}" -maxdepth 1 -type d \
          | sed '1d' \
          | sed "s#${HOME}#~#" \
          | sort \
          | xargs printf ' %s\n'
    fi
  done <<< "$stdin"
}

# @stdin Prettified lines of directories.
# @stdout The whitespace&decorator-trimmed value of the path field.
function zt_get_path_from_pretty {
  while IFS='\n$' read -r dir_pretty; do
    local path_without_description="$dir_pretty"
    if [[ "$path_without_description" = *[-][-]* ]]; then
      path_without_description="${${(s:--:)dir_pretty}[1]}"
    fi
    local path_whitespace_trimmed="${(*)${(*)${path_without_description}##[ ]##}%%[ ]##}"
    echo "${path_whitespace_trimmed##${ZT_DIRECTORY_DECORATOR}}"
  done
}
