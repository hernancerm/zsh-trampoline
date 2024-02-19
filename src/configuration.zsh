function zt_version {
  echo '0.1.0-SNAPSHOT'
}

# Global configuration.
typeset -xL 1 ZT_DIRECTORY_DECORATOR='*'
typeset -i    ZT_LIST_DIRECTORIES_LOCAL=1
typeset       ZT_KEY_MAP_JUMP_TO_DIRECTORY='^j'
typeset       ZT_KEY_MAP_TOGGLE_EXPAND=$ZT_DIRECTORY_DECORATOR
typeset -x    ZT_HOME="$(eval echo ${XDG_CONFIG_HOME:-'~/.config'}/zt | xargs realpath)"

# Make the Gawk library available.
export AWKPATH="$AWKPATH:${0:a:h}"
