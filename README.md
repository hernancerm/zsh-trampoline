<div align=center>
  <h1>zsh-trampoline</h1>
  <p>Jump to the places that matter to you.</p>
  <a href="https://asciinema.org/a/u8NYrKF0RPmeCtzBAhDxdTvZh" target="_blank">
    <img width=660 src="https://asciinema.org/a/u8NYrKF0RPmeCtzBAhDxdTvZh.svg" />
  </a>
</div>

## What is this?

This is a plugin for Zsh which shares the same purpose as the very popular project
[zoxide](https://github.com/ajeetdsouza/zoxide): facilitate `cd`ing to commonly visited
directories. Chiefly different to zoxide, zsh-trampoline is very simple. Instead of using
a ranking algorithm to try to determine the most likely directory you want to `cd` to,
zsh-trampoline simply displays all your configured dirs and files in fzf, always in the
same order. I've used this for several months and it has worked for me, it might work for
you as well.

The codebase is very small, less than 100 LOC as per the output from
[tokei](https://github.com/XAMPPRocky/tokei) as of Oct 5, 2024:

```
===============================================================================
 Language            Files        Lines         Code     Comments       Blanks
===============================================================================
 Zsh                     5          124           83           25           16
-------------------------------------------------------------------------------
 Markdown                1          129            0          100           29
 |- TOML                 1            4            2            1            1
 (Total)                            133            2          101           30
===============================================================================
 Total                   6          253           83          125           45
===============================================================================
```

## Usage

Press `ctrl+j` to start fzf with directories and files to "jump" to: `cd` or edit with
`${EDITOR}`. This list is taken from the parameter ("parameters" is the Zsh way of
variables) `ZT_CONFIG` that you need to define. See the section [Required
configuration](#required-configuration).

When fzf starts, press `*` to toggle showing only the dirs and files explicitly listed in
`ZT_CONFIG`. Press `enter` and now you are on a different directory or editing a file.

## Installation

First, install the requirements:

- [fzf](https://github.com/junegunn/fzf) >=0.45

This can be done with [Homebrew](https://brew.sh/):

```
brew install fzf
```

Then, install the plugin. This means doing 2 things: Download the code and `source` the
file [trampoline.plugin.zsh](./trampoline.plugin.zsh). You can do that manually via a `git
clone` and then a `source` command in your `~/.zshrc`, or use a plugin manager for Zsh. I
like to use [Sheldon](https://github.com/rossmacarthur/sheldon) as my plugin manager:

```toml
[plugins.zsh-trampoline]
github = "hernancerm/zsh-trampoline"
```

### Required configuration

After the plugin installation, there are 2 **required** setup steps.

#### First step: Define the array parameter `ZT_CONFIG`

I recommend defining `ZT_CONFIG` in your `~/.zshrc`. In this parameter you put your
directories and files you want to jump to when pressing `ctrl+j`. Sample definition:

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

#### Second step: Bind the widget on `ctrl+j`

To make `ctrl+j` do what it's supposed to, you need to call **one** of the functions below
in your file `~/.zshrc`, depending on the criteria indicated:

1. `zt_zvm_setup_widget_jump_to_file`: When you are using the amazing plugin
   [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode). Do the call inside the
   function `zvm_after_init`, like this:

```sh
function zvm_after_init {
  # In insert mode, press 'ctrl+j' to cd to a directory.
  zt_zvm_setup_widget_jump_to_file
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
Key map to list dirs and files in fzf. Default: <code>ctrl+j</code>.
</td>
</tr>
</tbody>
</table>

## Similar projects

- <https://github.com/ajeetdsouza/zoxide>
- <https://github.com/wting/autojump>
- <https://github.com/agkozak/zsh-z>
