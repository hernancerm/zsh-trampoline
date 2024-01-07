@namespace "zt"

# Pretty-print a raw line from the directories config file.
#
# @param raw_dir string Raw line from directories config file.
# @param longest_path_length integer Lenght of longest path in the dirs config file.
# @param expand string A value different from "true" prevents directory expansion.
# @return void
function pretty_print(raw_dir, longest_path_length, expand,
      _raw_dir_array, _path_padded, _description_formatted) {
  split(raw_dir, _raw_dir_array, /,/)
  # Print directory.
  if (trim(_raw_dir_array[2]) == "") {
    printf("%s%s\n", ENVIRON["ZT_DIRECTORY_DECORATOR"], trim(_raw_dir_array[1]))
  } else {
    _path_padded = trim(_raw_dir_array[1]) \
        _repeatSymbol(" ", longest_path_length - length(trim(_raw_dir_array[1]))) \
        _repeatSymbol(" ", 4)
    _description_formatted = "-- " trim(_raw_dir_array[2])
    printf("%s%s%s\n", ENVIRON["ZT_DIRECTORY_DECORATOR"], \
           _path_padded, _description_formatted)
  }
  # Print expanded directories.
  if (expand == "true" && trim(_raw_dir_array[3]) == "true") {
    system("find " trim(_raw_dir_array[1]) " -maxdepth 1 -type d \
        | sed '1d' \
        | xargs realpath \
        | sed 's#" ENVIRON["HOME"] "#~#' \
        | sort \
        | xargs printf ' %s\n'")
  }
}

# @param string string.
# @return string Trimmed string.
function trim(string) {
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
