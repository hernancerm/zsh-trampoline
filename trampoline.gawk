@namespace "zt"

# Pretty-print a raw line from the directories config file.
#
# @param raw_dir string raw line from directories config file.
# @param longest_path_length integer lenght of longest path in the dirs config file.
# @return void
function pretty_print(raw_dir, longest_path_length,
      _raw_dir_array, _path_trimmed, _path_padded, _description_formatted) {
  split(raw_dir, _raw_dir_array, /,/)
  _path_trimmed = _trim(_raw_dir_array[1])
  _path_padded = _path_trimmed \
      _repeatSymbol(" ", longest_path_length - length(_path_trimmed)) \
      _repeatSymbol(" ", 4)
  _description_formatted = "-- " _trim(_raw_dir_array[2])
  # Print directory.
  printf("%s%s%s\n", ENVIRON["ZT_DIRECTORY_DECORATOR"], \
         _path_padded, _description_formatted)
  # Print expanded directories.
  if (get_metadata_value(_raw_dir_array[3], "expand") == "true") {
    system("find " _path_trimmed " -maxdepth 1 -type d \
        | sed '1d' \
        | xargs realpath \
        | sed 's#" ENVIRON["HOME"] "#~#' \
        | xargs printf ' %s\n'")
  }
}

# @param metadata string metadata column from a row in the directories config file.
# @param target_item string the metadate item that holds the requested value.
# @return the value, either boolean or string, of the metadata item target_item.
function get_metadata_value(metadata, target_item,
      _metadata_array, _target_item_extracted, _target_item_value) {
  split(metadata, _metadata_array, /[ ]/)
  for (i in _metadata_array) {
    if (_metadata_array[i] ~ "^"target_item) {
      _target_item_extracted = _metadata_array[i]
      break
    }
  }
  if (_target_item_extracted ~ ":") {
    _target_item_value = get_metadata_value_string(_target_item_extracted)
  } else {
    _target_item_value = get_metadata_value_boolean(_target_item_extracted)
  }
  return _target_item_value
}

# @param metadata_item string the metadate item that holds the requested value.
# @return string
function get_metadata_value_string(metadata_item) {
  if (metadata_item == "") { return metadata_item }
  return awk::gensub(/\w+:/, "", "g", metadata_item)
}

# @param metadata_item string the metadate item that holds the requested value.
# @return string the boolean value as the string "true" or "false".
function get_metadata_value_boolean(metadata_item) {
  return _toTrueFalse(metadata_item != "")
}

# @param string string.
# @return string trimmed string.
function _trim(string) {
  return awk::gensub(/^\s+|\s+$/, "", "g", string);
}

# @param symbol string character to repeat.
# @param times integer amount of times to repeat the symbol.
# @return string
function _repeatSymbol(symbol, times, _output) {
  _output = ""
  while (times > 0) {
    _output = _output symbol
    times--
  }
  return _output
}

# @param boolean boolean.
# @return when provided boolean is 1 then 'true', otherwise 'false'.
function _toTrueFalse(boolean) {
  return boolean ? "true" : "false"
}
