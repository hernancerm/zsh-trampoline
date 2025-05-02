# zsh-trampoline

Zsh plugin leveraging [fzf](https://github.com/junegunn/fzf) to jump to the places that
matter to you.

[![asciicast](https://asciinema.org/a/716276.svg)](https://asciinema.org/a/716276)

## What is this?

This is a Zsh plugin to efficiently `cd` to commonly visited dirs. The plugin displays all
your configured dirs in fzf always in the same order. Think of it like a simple
[zoxide](https://github.com/ajeetdsouza/zoxide) just for Zsh. The plugin can also open
files in `$EDITOR`.

## Usage

While on the shell, press <kbd>ctrl+t</kbd> to start fzf with dirs and files to "jump" to:
`cd` or open with `$EDITOR`. This list is taken from `$ZT_CONFIG` that you need to define.
Press <kbd>enter</kbd> to select.

## Installation

### Without a plugin manager

1. Install [fzf](https://github.com/junegunn/fzf) version >=0.45.
  [Homebrew](https://brew.sh/) command: `brew install fzf`.
2. Clone the zsh-trampoline Git repository by executing the below command:

    ```text
    git clone 'https://github.com/hernancerm/zsh-trampoline.git' \
      "${HOME}/.zsh-trampoline/zsh-trampoline"
    ```

3. Place the below snippet at the end of your file `~/.zshrc`:

    ```text
    # ZSH-TRAMPOLINE - Start - <https://github.com/hernancerm/zsh-trampoline>.
    source "${HOME}/.zsh-trampoline/zsh-trampoline/trampoline.plugin.zsh"
    ZT_CONFIG=(
      # Place each dir and file you want to jump to in a new line.
      ~ # Example, you can remove this line.
    )
    zt_setup_widget
    # ZSH-TRAMPOLINE - End.
    ```

4. Start a new shell.

### With a plugin manager

If you feel comfortable with shell scripting and plan to install other Zsh plugins, like
[zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode), I recommend you use a shell
plugin manager like [Sheldon](https://github.com/rossmacarthur/sheldon) for the
installation. Comparing this approach to the plugin-manager-less approach, the plugin
manager would be in charge of doing the git clone (step 2) and sourcing the plugin on
startup (line beginning with `source` from the snippet of step 3, you still need to define
`ZT_CONFIG` and call `zt_setup_widget`).

## Parameter ZT_CONFIG

Some things to note:

- If your dir or file has whitespace chars, surround it with single quotes.
- Environment variables, defined as `export MY_VAR=~/file/path`, are supported quoted. Do
  not forget the `export` keyword. That is, this could be a valid entry in `ZT_CONFIG`:
  `'${MY_VAR}'`. The plugin does the expansion.
- On <kbd>ctrl+t</kbd> what gets listed is:
  - Files. Quoted env vars which point to a file are listed as the env var.
  - Level 1 sub-dirs of the dirs in `ZT_CONFIG`. Quoted env vars which point to a dir are
    treated as dirs.
  - Anything ending in `:0`. In this case the `:0` is stripped. The purpose of this is to
    be able to list the dirs themselves which are in `ZT_CONFIG`, avoiding the sub-dirs
    replacement.

## Integration with other Zsh plugins

- [jeffreytse/zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode) (ZVM).
Binding <kbd>ctrl+t</kbd> is done inside a specific ZVM function, as below. Do not call
`zt_setup_widget` when integrating with ZVM.

    ```text
    function zvm_after_init {
      zt_zvm_setup_widget
    }
    ```

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
<td><code>ZT_KEY_MAP_START</code></td>
<td>
<a href="https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/bindkey.md">
<code>bindkey</code> key map</a></td><td><code>^t</code></td>
<td>
Key map to list dirs & files in fzf. Default: <kbd>ctrl+t</kbd>.
</td>
</tr>
</tbody>
</table>

## API

(fn) `zt_get_items`:

```text
## Generate items (files and dirs) as per the config.
## $1:string Item type filter, either 'd' for directory or 'f' for file.
## @stdout:string
```

## Similar projects

- <https://github.com/ajeetdsouza/zoxide>
- <https://github.com/wting/autojump>
- <https://github.com/agkozak/zsh-z>
