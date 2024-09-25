# Usage: `source demo/setup.zsh`. Then `Ctrl+j` to start fzf.

# Clean start.
if [[ -d ~/demo ]]; then
  printf "The directory ${HOME}/demo will be DELETED. Ok (y/n)? "; read confirm
  if [[ ${confirm} =~ ^[^Yy]$ ]] exit 0
  rm -vrf ~/demo
fi

# Create base items.
mkdir -p ~/demo/dev/gc
mkdir -p ~/demo/dev/temp
mkdir -p ~/demo/.dotfiles
echo '[init]
  defaultBranch = main

[core]
  autocrlf = input
  excludesFile = ~/.gitignore

[alias]
  s = status -s
  co = checkout
  diffs = diff --staged' > ~/demo/.gitconfig

# Create level-1 sub-dirs.
mkdir ~/demo/dev/gc/gimp
mkdir ~/demo/dev/gc/neovim
mkdir ~/demo/dev/gc/delta
mkdir ~/demo/dev/gc/fzf
mkdir ~/demo/dev/temp/plantuml_diagrams
mkdir ~/demo/dev/temp/quick-http-server
mkdir ~/demo/.dotfiles/src
mkdir ~/demo/.dotfiles/resources

# Config.
ZT_CONFIG=(
  ~/demo/dev/gc
  ~/demo/dev/temp:0
  ~/demo/.dotfiles:0
  ~/demo/.gitconfig
)
