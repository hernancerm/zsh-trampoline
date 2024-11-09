<div align=center>
  <h1>zsh-trampoline</h1>
  <p>Jump to the places that matter to you.</p>
  <a href="https://asciinema.org/a/u8NYrKF0RPmeCtzBAhDxdTvZh" target="_blank">
    <img width=660 src="https://asciinema.org/a/u8NYrKF0RPmeCtzBAhDxdTvZh.svg" />
  </a>
</div>

## What is this?

This is a plugin for Zsh which shares the same purpose as the popular project
[zoxide](https://github.com/ajeetdsouza/zoxide): facilitate `cd`ing to commonly visited
directories. Chiefly different to zoxide, zsh-trampoline is very simple. Instead of using
a ranking algorithm to try to determine the most likely directory you want to `cd` to,
zsh-trampoline simply displays all your configured dirs and files in fzf, always in the
same order.

I've used this for several months and it has worked for me, it might work for you as well.
Please note that since this is a Zsh plugin, it only works if your shell is Zsh. You can
learn this by typing `echo $SHELL`; if the output contains `zsh` somewhere, you are likely
on the right shell.

## Usage

Press <kbd>ctrl+j</kbd> to start fzf with directories and files to "jump" to: `cd` or edit
with `${EDITOR}`. This list is taken from the global parameter `ZT_CONFIG` that you need
to define. See the section [Required configuration](#required-configuration).

When fzf starts, press asterisk (<kbd>*</kbd>) to toggle showing only the dirs and files
explicitly listed in `ZT_CONFIG`. Press <kbd>enter</kbd> and now you are on a different
directory or editing a file.

## Installation

First, install fzf:

- [fzf](https://github.com/junegunn/fzf) >=0.45

This can be done with [Homebrew](https://brew.sh/):

```
brew install fzf
```

Then, install the plugin. This means doing 2 things: Download the code and `source` the
file [trampoline.plugin.zsh](./trampoline.plugin.zsh). You can do that manually via a `git
clone` and then a `source` command in your `~/.zshrc`, or use a plugin manager for Zsh.
Here is an example using [Sheldon](https://github.com/rossmacarthur/sheldon) as the plugin
manager:

```toml
# File: ~/.config/sheldon/plugins.toml

shell = "zsh"

[plugins.zsh-trampoline]
github = "hernancerm/zsh-trampoline"
```

### Required configuration

#### First step: Provide widget configuration by defining `ZT_CONFIG`

I recommend defining the Zsh parameter `ZT_CONFIG` in your `~/.zshrc`. In this parameter
you put your directories and files you want to jump to when pressing <kbd>ctrl+j</kbd>;
they must already exist in your filesystem. Sample definition:

```text
# Sample definition. Place in file: ~/.zshrc
# Put within parentheses the dirs and files you want to jump to.

ZT_CONFIG=(
  ~/dev/gc
  ~/dev/temp:0
  ~/.gitconfig
)
```

Some things to note:

- If your item has whitespace chars, surround it with single quotes.
- Environment variables, defined as `export MY_VAR=~/file/path`, are supported quoted.
  Do not forget to use the `export` keyword. That is, this could be a valid entry in
  `ZT_CONFIG`: `'${MY_VAR}'`. The plugin does the expansion.
- On <kbd>ctrl+j</kbd> specifically what gets listed is:
  - Files. Quoted env vars which point to a file are listed as the env var.
  - Level 1 sub-dirs of the dirs in `ZT_CONFIG`. Quoted env vars which point to a dir are
    treated as dirs.
  - Anything ending in `:0`. In this case the `:0` is stripped. The purpose of this is to
    be able to list the dirs themselves which are in `ZT_CONFIG`, avoiding the sub-dirs
    replacement.
- While on fzf, on <kbd>*</kbd> specifically what gets listed is:
  - Allows to toggle between initial listing and items as-are from `ZT_CONFIG`.

#### Second step: Bind the widget on <kbd>ctrl+j</kbd>

To make <kbd>ctrl+j</kbd> do what it's supposed to, you need to add the line
`zt_setup_widget_jump_to_file` to your `~/.zshrc` **after** sourcing the plugin
zsh-trampoline. For example, when using Sheldon that is after `eval "$(sheldon source)"`;
as a second example, on a manual installation without Sheldon, it would be after `source
path/to/trampoline.plugin.zsh`.

```sh
# Example of widget setup when using Sheldon for the installation.

eval "$(sheldon source)"
# Press 'ctrl+j' to cd to a directory.
zt_setup_widget_jump_to_file
```

<details>
  <summary>
    <b>Use this instead if you want to integrate zsh-trampoline with
    <a href="https://github.com/jeffreytse/zsh-vi-mode">jeffreytse/zsh-vi-mode</a></b>
  </summary>

Do **not** call `zt_setup_widget_jump_to_file` as mentioned above, instead call
`zt_zvm_setup_widget_jump_to_file` inside the function definition of `zvm_after_init`,
like this:

```sh
# Example of widget setup when using Sheldon for the installation.

eval "$(sheldon source)"
function zvm_after_init {
  # In insert mode, press 'ctrl+j' to cd to a directory.
  zt_zvm_setup_widget_jump_to_file
}
```
</details>

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
Key map to list dirs & files in fzf. Default: <kbd>ctrl+j</kbd>
</td>
</tr>
</tbody>
</table>

## Similar projects

- <https://github.com/ajeetdsouza/zoxide>
- <https://github.com/wting/autojump>
- <https://github.com/agkozak/zsh-z>
