# Clean start.
if [[ -d ~/demo ]]; then
  printf "The directory ${HOME}/demo will be DELETED. Ok (y/n)? "; read confirm
  if [[ ${confirm} =~ ^[^Yy]$ ]] exit 0
  rm -vrf ~/demo
fi

# Create base items.
mkdir -p ~/demo/work
mkdir -p ~/demo/my-cool-project
mkdir -p ~/demo/.dotfiles
mkdir -p ~/demo/.config
echo '[init]
  defaultBranch = main

[alias]
  s = status -s
  co = checkout
  diffs = diff --staged' > ~/demo/.gitconfig

# Create level-1 sub-dirs.
mkdir ~/demo/work/prices-service
mkdir ~/demo/work/inventory-service
mkdir ~/demo/work/experimental-frontend
mkdir ~/demo/work/plantuml-diagrams
mkdir ~/demo/work/shared-library

# Config.
ZT_CONFIG=(
  ~/demo/work
  ~/demo/my-cool-project:0
  ~/demo/.dotfiles:0
  ~/demo/.gitconfig
)
