# Do not source this script multiple times.
command -v zt_version > /dev/null && return

# CONFIGURATION

## Get the version.
function zt_version {
  echo '0.1.1-dev'
}

ZT_CONFIG_FILEPATH="${HOME}/.zt"
ZT_CONFIG_LOCAL_FILEPATH="${HOME}/.zt.local"
ZT_KEYBIND_START="${ZT_KEYBIND_START:-^t}"

# FUNCTIONS

## Get the list of the configured items, optionally filtering by type.
## @param $1:string (optional) Item type filter, either 'd' for directory or 'f' for file.
## @stdout:string
function zt_get_items {
  if [[ ! -f "${ZT_CONFIG_FILEPATH}" ]]; then
    return
  fi
  local -a zt_config=(${(f)"$(cat "${ZT_CONFIG_FILEPATH}")"})
  if [[ -f "${ZT_CONFIG_LOCAL_FILEPATH}" ]]; then
    zt_config+=(${(f)"$(cat "${ZT_CONFIG_LOCAL_FILEPATH}")"})
  fi
  for raw_file in ${zt_config}; do
    local filepath="${raw_file%%:*}"
    local filepath_expanded="$(eval echo ${filepath})"
    if [[ -f "${filepath_expanded}" ]]; then
      if [[ -z "${1}" ]] || [[ "${1}" = 'f' ]]; then # Filter.
        echo "${filepath}" | sed "s#${HOME}#~#"
      fi
    elif [[ -d "${filepath_expanded}" ]]; then
      if [[ -z "${1}" ]] || [[ "${1}" = 'd' ]]; then # Filter.
        if [[ ${raw_file[(i):0]} -lt ${#raw_file} ]]; then
          echo "${filepath}" | sed "s#${HOME}#~#"
        else
          # Expand level-1 sub dirs.
          find "${filepath_expanded}" -maxdepth 1 -type d \
            | sed 1d | sed "s#${HOME}#~#" | sort
        fi
      fi
    fi
  done
}

# WIDGET

## Zsh widget.
## List files in fzf and jump to the selected one.
function zt_widget {
  if [[ ! -f "${ZT_CONFIG_FILEPATH}" ]]; then
    printf 'ERROR: No config file found for zsh-trampoline, no ~/.zt or ~/.zt.local' 1>&2
    zle accept-line
    return 1
  fi
  local fzf_selection="$(zt_get_items | \
    fzf --height="~$(($(tput lines) - 1))" --tiebreak=index)"
  if [[ -z "${fzf_selection}" ]]; then
    zle reset-prompt
    return
  fi
  # Expand the tilde symbol (~) and environment variables.
  local filepath="$(eval echo ${fzf_selection})"
  if [[ -d "${filepath}" ]]; then
    local cmd='cd'
  fi
  if [[ -f "${filepath}" ]]; then
    local cmd="${EDITOR:-vim}"
  fi
  if [[ ${filepath[(i) ]} -le ${#filepath} ]]; then
    # When the filepath has a whitespace char, surround it with single quotes.
    filepath="'${filepath}'"
  fi
  BUFFER="${cmd} ${filepath}"
  zle reset-prompt
  zle accept-line
}

## Users without ZVM (zsh-vi-mode) should use this.
## Setup widget without integrating with other plugins.
function zt_setup_widget {
  zle -N zt_widget
  bindkey "${ZT_KEYBIND_START}" zt_widget
}

## ZVM users should use this.
## Setup widget as per zsh-vi-mode requirements.
## <https://github.com/jeffreytse/zsh-vi-mode/tree/master#custom-widgets-and-keybindings>.
function zt_zvm_setup_widget {
  zvm_define_widget zt_widget
  zvm_bindkey viins "${ZT_KEYBIND_START}" zt_widget
}
