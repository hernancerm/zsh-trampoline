function zt_version {
  echo '0.1.0-SNAPSHOT'
}

# Global configuration.
typeset -L 1 ZT_DIRECTORY_DECORATOR='*'
typeset      ZT_KEY_MAP_JUMP_TO_DIRECTORY='^j'
typeset      ZT_KEY_MAP_TOGGLE_EXPAND=$ZT_DIRECTORY_DECORATOR
typeset      ZT_HOME="$(eval echo ${XDG_CONFIG_HOME:-'~/.config'}/zt | xargs realpath)"
typeset      ZT_CONFIG_FILE_PATH=$(eval echo "$ZT_HOME/config.csv")
