# zsh-trampoline

> [!WARNING]
> In-progress README.md changes. For accurate documentation refer to the latest release.

Zsh plugin leveraging [fzf](https://github.com/junegunn/fzf) to jump to dirs and files.

## What is this?

This is a Zsh plugin to efficiently `cd` to commonly visited dirs, and also open in
`$EDITOR` commonly visited files. The plugin displays all your configured dirs and files
in fzf always in the same order.

## How do I use this?

Before using zsh-trampoline, you need to create a [configuration
file](#configuration-file). After that, while in a Zsh prompt, press <kbd>ctrl+t</kbd> to
start fzf with dirs and files to "jump" to: `cd` or open with `$EDITOR`. This list is
taken from your config file. Press <kbd>enter</kbd> to jump to your selection.

## Installation

### Without a plugin manager

1. Install [fzf](https://github.com/junegunn/fzf) version >= 0.45.

2. Clone the zsh-trampoline Git repository by executing the below command:

    ```text
    git clone 'https://github.com/hernancerm/zsh-trampoline.git' \
      "${HOME}/.zsh-trampoline/zsh-trampoline"
    ```

3. Place the below snippet at the end of your file `~/.zshrc`:

    ```text
    source "${HOME}/.zsh-trampoline/zsh-trampoline/trampoline.plugin.zsh"
    zt_setup_widget
    ```

4. Start a new shell.

### With a plugin manager

If you feel comfortable with shell scripting and plan to install other Zsh plugins, like
[zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode), I recommend you use a shell
plugin manager like [Sheldon](https://github.com/rossmacarthur/sheldon) for the
installation. Comparing this approach to the plugin-manager-less approach, the plugin
manager would be in charge of doing the git clone (step 2) and sourcing the plugin on
startup (line beginning with `source` from the snippet of step 3), you still need to call
`zt_setup_widget`.

## Configuration file

zsh-trampoline supports two config files:

1. `~/.zt`
2. `~/.zt.local` (used for local config, should not be committed to source control.)

The configs are merged in order, no overrides. I recommend using the first config file for
common dirs/files in your setup, while the second config file for sensitive or
machine-specific dirs/files. Both files share the same syntax.

Example contents of the config file:

```text
~/dev/work
~/dev/temp:0
~/dev/Some Directory With Spaces:0
${HISTFILE}
```

TODO: Support dirs and files with spaces in the config file.

Explanation of the config file's syntax:

- Each line has only one directory or one file.
- Directories are expanded to their level-1 sub-dirs.
- Directories may be suffixed with `:0`. This prevents the level-1 sub-dirs expansion.
- The tilde (`~`) character is supported. It's expanded to the user home directory.
- Environment variables are supported.

## Integration with other Zsh plugins

- [jeffreytse/zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode) (ZVM).

    <kbd>ctrl+t</kbd> is set up inside the ZVM function below. Do not call
    `zt_setup_widget` when integrating with ZVM. Use:

    ```text
    function zvm_after_init {
      zt_zvm_setup_widget
    }
    source "${HOME}/.zsh-trampoline/zsh-trampoline/trampoline.plugin.zsh"
    ```

## Optional configuration

Parameter: `ZT_KEY_MAP_START`:

<table>
<thead>
<tr>
<th>Allowed values</th><th>Default value</th><th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<a href="https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/bindkey.md">
Key binding</a></td>
<td><code>^t</code> (<kbd>ctrl+t</kbd>)</td>
<td>
Key binding to list dirs & files in fzf.
</td>
</tr>
</tbody>
</table>

## Similar projects

- <https://github.com/ajeetdsouza/zoxide>
- <https://github.com/wting/autojump>
- <https://github.com/agkozak/zsh-z>
