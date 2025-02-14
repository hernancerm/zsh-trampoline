<div align=center>
  <h1>zsh-trampoline</h1>
  <p>Jump to the places that matter to you.</p>
  <a href="https://asciinema.org/a/gLdAo5wNcwF1FEC8ZMTZT9krP" target="_blank">
    <img width=660 src="https://asciinema.org/a/gLdAo5wNcwF1FEC8ZMTZT9krP.svg" />
  </a>
</div>

## What is this?

This is a plugin for Zsh which shares the same purpose as the popular project
[zoxide](https://github.com/ajeetdsouza/zoxide): facilitate `cd`ing to commonly visited
directories. Differently from zoxide, zsh-trampoline is very simple. Instead of using a
ranking algorithm to determine the most likely directory you want to `cd` to,
zsh-trampoline simply displays all your configured dirs in fzf, always in the same order.
Also, with zsh-trampoline you can jump to files as well, not just dirs.

## Usage

While on the shell, press <kbd>ctrl+t</kbd> to start fzf with directories and files to
"jump" to: `cd` or edit with `${EDITOR}`. This list is taken from the global parameter
`ZT_CONFIG` that you need to define.

While in fzf, press <kbd>ctrl+t</kbd> to toggle showing only the dirs and files explicitly
listed in `ZT_CONFIG`. Press <kbd>enter</kbd> and now you are on a different directory or
editing a file.

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
    zt_setup_widget_jump_to_file
    # ZSH-TRAMPOLINE - End.
    ```

4. Start a new shell.

### With a plugin manager

If you feel comfortable with shell scripting and plan to install other Zsh plugins, like
[zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode), I recommend you use a shell
plugin manager like [Sheldon](https://github.com/rossmacarthur/sheldon) for the
installation. The plugin manager would be in charge of doing the git clone (step 2) and
sourcing the plugin on startup (line beginning with `source` from the snippet of step 3).

## Parameter ZT_CONFIG

Some things to note:

- If your dir or file has whitespace chars, surround it with single quotes.
- Environment variables, defined as `export MY_VAR=~/file/path`, are supported quoted.
  Do not forget to use the `export` keyword. That is, this could be a valid entry in
  `ZT_CONFIG`: `'${MY_VAR}'`. The plugin does the expansion.
- On <kbd>ctrl+t</kbd> specifically what gets listed is:
  - Files. Quoted env vars which point to a file are listed as the env var.
  - Level 1 sub-dirs of the dirs in `ZT_CONFIG`. Quoted env vars which point to a dir are
    treated as dirs.
  - Anything ending in `:0`. In this case the `:0` is stripped. The purpose of this is to
    be able to list the dirs themselves which are in `ZT_CONFIG`, avoiding the sub-dirs
    replacement.
- While in fzf, on <kbd>ctrl+t</kbd> specifically what gets listed is:
  - Allows to toggle between initial listing and items as-are from `ZT_CONFIG`.

## Integration with other Zsh plugins

- [jeffreytse/zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode) (ZVM).
Binding <kbd>ctrl+t</kbd> is done inside a specific ZVM function, as below. Do not call
`zt_setup_widget_jump_to_file` when integrating with ZVM.

    ```text
    function zvm_after_init {
      zt_zvm_setup_widget_jump_to_file
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
<td><code>ZT_KEY_MAP_JUMP</code></td>
<td>
<a href="https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/bindkey.md">
<code>bindkey</code> key map</a></td><td><code>^t</code></td>
<td>
Key map to list dirs & files in fzf. Default: <kbd>ctrl+t</kbd>.
</td>
</tr>
</tbody>
</table>

## Similar projects

- <https://github.com/ajeetdsouza/zoxide>
- <https://github.com/wting/autojump>
- <https://github.com/agkozak/zsh-z>
