# zsh-trampoline -- Jump to the places that matter to you.
# Homepage: <https://github.com/hernancerm/zsh-trampoline>.

# Do not source this script multiple times.
command -v zt_version > /dev/null && return

# CONFIGURATION

## Get the version.
function zt_version {
  echo '0.1.1-dev'
}

ZT_CONFIG_FILE="${HOME}/.config/zsh-trampoline/config.txt"
ZT_CONFIG_SECRET_FILE="${HOME}/.config/zsh-trampoline/config_secret.txt"
ZT_KEY_MAP_START="${ZT_KEY_MAP_START:-^t}"

# FUNCTIONS

## @stdout:int Config source.
##             1: Config stored in the ZT_CONFIG Zsh param.
##             2: Config stored in the config file `~/.config/zsh-trampoline/config.zsh`.
##             0: No config source registered.
function zt_get_config_source {
  if [[ ${+ZT_CONFIG} -eq 1 ]]; then
    echo 1
  elif [[ -f "${ZT_CONFIG_FILE}" ]]; then
    echo 2
  else
    echo 0
  fi
}

## Generate items (files and dirs) as per the config.
## $1:string Item type filter, either 'd' for directory or 'f' for file.
## @stdout:string
function zt_get_items {
  local -a zt_config
  local config_source=$(zt_get_config_source)
  if [[ "${config_source}" -eq 1 ]]; then
    zt_config=(${ZT_CONFIG})
  elif [[ "${config_source}" -eq 2 ]]; then
    local single_line_config="$(cat "${ZT_CONFIG_FILE}")"
    zt_config=(${(f)single_line_config})
    if [[ -f "${ZT_CONFIG_SECRET_FILE}" ]]; then
      local single_line_config_secret="$(cat "${ZT_CONFIG_SECRET_FILE}")"
      local zt_config_secret=(${(f)single_line_config_secret})
      zt_config+=(${zt_config_secret})
    fi
  else
    return
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

# WIDGETS

## Zsh widget.
## List files in fzf and jump to the selected one.
function zt_widget {
  if [[ $(zt_get_config_source) -eq 0 ]]; then
    printf 'No configuration source' 1>&2
    zle accept-line
    return 1
  fi
  local fzf_height='~100%'
  local items="$(zt_get_items)"
  if [[ "${#${(f)items}}" -ge "$(tput lines)" ]]; then
    fzf_height='-1'
  fi
  local fzf_selection="$(echo "${items}" | fzf --height="${fzf_height}" --tiebreak=index)"
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
  bindkey "${ZT_KEY_MAP_START}" zt_widget
}

## ZVM users should use this.
## Setup widget as per zsh-vi-mode requirements.
## <https://github.com/jeffreytse/zsh-vi-mode/tree/master#custom-widgets-and-keybindings>.
function zt_zvm_setup_widget {
  zvm_define_widget zt_widget
  zvm_bindkey viins "${ZT_KEY_MAP_START}" zt_widget
}
