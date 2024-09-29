# zsh-trampoline

Jump to the places that matter to you.

## Demo

https://github.com/user-attachments/assets/1b1f5534-a705-448e-8be3-7b1d89a3cf18

## Usage

This plugin is simple. Directories and files are always listed in
[fzf](https://github.com/junegunn/fzf) for your choosing and there is no ranking
algorithm. The same files are always listed in the same order.

Press `Ctrl+j` to start fzf with directories and files to "jump" to: `cd` or edit with
`${EDITOR}`. This list is taken from the global parameter `ZT_CONFIG` that you need to
define (see the section [Setup](#setup)).

When fzf starts, press `*` to toggle showing only the dirs and files explicitly listed in
`ZT_CONFIG`. Press `Enter` and now you are on a different directory or editing a file.

## Requirements

- [fzf](https://github.com/junegunn/fzf) >=0.45.
  - Installation with [Homebrew](https://brew.sh/): `brew install fzf`.

## Installation

The installation means doing 2 things: Download the code and `source` the file
[trampoline.plugin.zsh](./trampoline.plugin.zsh). You can do that manually or use a plugin
manager for Zsh. I like to use [Sheldon](https://github.com/rossmacarthur/sheldon) as my
plugin manager:

```toml
# ~/.config/sheldon/plugins.toml

[plugins.poc-zsh-plugin]
github = "hernancerm/zsh-trampoline"
```

### Setup

The setup is easy peasy. You are only required to configure 2 thing:

#### 1. Define the array parameter `ZT_CONFIG`

I recommend defining `ZT_CONFIG` in your `~/.zshrc`. In this parameter you put your
directories and files you want to jump to when pressing `Ctrl+j`. Sample definition:

```text
ZT_CONFIG=(
  ~/dev/gc
  ~/dev/gr
  ~/.dotfiles:0
  ~/dev/temp:0
  ~/.gitconfig
)
```

By default, level-1 sub-directories are listed per each directory in ZT_CONFIG. To disable
this expansion but still list the individual directory, suffix the directory with `:0`.

#### 2. Bind the widget on `Ctrl+j`

To make `Ctrl+j` do what it's supposed to, you need to call **one** of the functions below
in your `~/.zshrc`, depending on the criteria indicated:

1. `zt_zvm_setup_widget_jump_to_file`: When you are using the amazing plugin
   [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode). Do the call inside the
   function `zvm_after_init`, like this:

```sh
function zvm_after_init {
  # In insert mode, press 'ctrl+j' to cd to a directory.
  zt_zvm_setup_widget_jump_to_directory
}
```

2. `zt_setup_widget_jump_to_file`: When you are _not_ using the plugin zsh-vi-mode.

When using either the first or the second function above, do the call **after** the
zsh-trampoline plugin is sourced. For example, for Sheldon that is after `eval "$(sheldon
source)"`.

## Optional configuration

Optional configuration is provided through parameters.

<table>
<thead>
<tr>
<th>Zsh parameters</th><th>Allowed values</th>
<th>Default value</th><th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>ZT_KEY_MAP_JUMP</code></td>
<td>
<a href="https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/bindkey.md">
<code>bindkey</code> key map</a></td><td><code>^j</code></td>
<td>
Key map to list dirs and files in fzf. Default: <code>Ctrl+j</code>.
</td>
</tr>
</tbody>
</table>

## Similar projects

- <https://github.com/ajeetdsouza/zoxide>
- <https://github.com/wting/autojump>
- <https://github.com/agkozak/zsh-z>
