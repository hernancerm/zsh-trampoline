function zt_version {
  echo '0.1.0-SNAPSHOT'
}

# Select the config home location.
export ZT_CONFIG_HOME="$(eval echo ${XDG_CONFIG_HOME:-'~/.config'}/zt \
    | xargs realpath)"

# Make the Gawk library available.
export AWKPATH="$AWKPATH:${0:a:h}"

# Make the zt script available in PATH.
export PATH="$PATH:${0:a:h}"

# Global configuration.
export ZT_DIRECTORY_DECORATOR='*'
export ZT_LIST_DIRECTORIES_LOCAL=1
export ZT_KEY_MAP_JUMP_TO_DIRECTORY='^j'
export ZT_KEY_MAP_TOGGLE_EXPAND=$ZT_DIRECTORY_DECORATOR
