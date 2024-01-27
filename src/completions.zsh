function _zt {
  local zt_function_names="$(zt reflect_get_function_names)"
  # The ${=spec} parameter expansion can be used to create an array from the
  # space-separated elements of a string, as it's done in the line below.
  local zt_function_names_array=(${=zt_function_names})
  compadd "${zt_function_names_array[@]}"
}

compdef _zt zt
