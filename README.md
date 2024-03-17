# zsh-trampoline

## Usage

Press <kbd>ctrl+j</kbd> to bring a list of directories to "jump" (`cd`) to. When the list
is shown, press <kbd>*</kbd> to toggle directory expansion. This is useful when wanting to
remove expanded directories from the filtered directories. See the `{expand}` column in
the [config file](#configuration-file). Type your query, press <kbd>enter</kbd>, and
now you are on a different directory.

## Dependencies

- [fzf](https://github.com/junegunn/fzf) 0.45 or newer.

On macOS, the dependencies can be installed using [Homebrew](https://brew.sh/):

```sh
brew install fzf
```

## Installation

To download and source the plugin, use your favorite plugin manager. For example, use
[Sheldon](https://github.com/rossmacarthur/sheldon):

```toml
# ~/.config/sheldon/plugins.toml

[plugins.poc-zsh-plugin]
github = "HerCerM/zsh-trampoline"
```

The plugin provides two Zsh functions for setup which are meant to be called in the
`.zshrc`. Only one function needs to be called depending on the following criteria:

1. `zt_zvm_setup_widget_jump_to_directory`: When using the plugin
[zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode).

2. `zt_setup_widget_jump_to_directory`: When not using the plugin zsh-vi-mode.

When using either the first or the second function, do the call after the zsh-trampoline
plugin is sourced. For example, for Sheldon that is after `eval "$(sheldon source)"`.
Additionally, when using the first function, do the call inside of `zvm_after_init`, like
this:

```sh
function zvm_after_init {
  # In insert mode, press 'ctrl+j' to cd to a directory.
  zt_zvm_setup_widget_jump_to_directory
}
```

## Configuration

The configuration for zsh-trampoline is provided in two places:

1. A CSV configuration file.
2. Zsh parameters.

Before using zsh-trampoline, it's required to create the CSV configuration file or to set
the Zsh parameter `zt_config`. All other configuration is optional.

### CSV configuration file

The `config.csv` file is where the available directories to jump to are defined.

This CSV config file is searched in the directory `$XDG_CONFIG_HOME/zt`. When the variable
`$XDG_CONFIG_HOME` is not set, the file is searched in `~/.config/zt`. The line format of
the file is as shown below. Conceptually, each line represents a directory that can be
jumped to, and each directory can have metadata associated to it.

```text
{path}, {description}, {expand}
|____|  |_____________________|
 \       \
  \       \__ metadata
   \
    \__ directory
```

<table>
<thead>
<tr><th>Column</th><th>Required</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td><code>{path}</code></td><td><p>Yes</p></td>
<td>
Relative or absolute path to a directory. Parameters (e.g. <code>$HOME</code>) and the caret symbol
(<code>~</code>) are recognized.
</td>
</tr>
<tr>
<td><code>{description}</code></td><td><p>No</p></td>
<td>
Short one-line description of the directory. Must not contain a comma (<code>,</code>).
</td>
</tr>
<tr>
<td><code>{expand}</code></td><td><p>No</p></td>
<td>
Whether to list all level-1 subdirectories. To enable set to <code>true</code>.
</td>
</tr>
</tbody>
</table>

Example of valid contents of a file `config.csv`. Notice that spaces for padding are
allowed (but are not required).

```text
~/dev/gc     , Git cloned repos not mine.   , true
~/dev/gr     , Git my remote-backed repos.  , true
~/dev/spub   , Scripts public.
~/dev/spri   , Scripts private.
~/.dotfiles  , Configuration files.
~/dev/temp
```

### Zsh parameters

<table>
<thead>
<tr>
<th>Zsh parameters</th><th>Allowed values</th>
<th>Default value</th><th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>zt_config</code></td>
<td>Lines as in the CSV config file.</td><td>None.</td>
<td>
Array parameter. Each array element is expected to match the same structure as the lines
in the CSV config file. If this param is set, dirs from this param are listed after the
ones in the config file.
</td>
</tr>
<tr>
<td><code>ZT_KEY_MAP_JUMP_TO_DIRECTORY</code></td>
<td>
<a href="https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/bindkey.md">
<code>bindkey</code> key map</a></td><td><code>^j</code></td>
<td>
Key sequence to press to list directories in fzf. By default, it’s <kbd>ctrl+j</kbd>.
</td>
</tr>
<tr>
<td><code>ZT_KEY_MAP_TOGGLE_EXPAND</code></td>
<td>fzf key (refer to <code>man fzf</code>)</td><td><code>*</code></td>
<td>
Key sequence to press to toggle expanding directories which have a <code>true</code> value
for the column <code>{expand}</code>. This allows seeing only the directories explicitly
  listed in the config file. By default, it’s <kbd>*</kbd>.
</td>
</tr>
</tbody>
</table>

Example of setting a value for `zt_config` (can be placed in the `.zshrc`):

```bash
zt_config=( '~/dev/work,,true' '~/dev/temp' )
```

To get the same behavior from fzf as in the demo GIF, set these default options for fzf:

```bash
export FZF_DEFAULT_OPTS='--layout=reverse --height=~55%'
```

## Similar projects

- <https://github.com/ajeetdsouza/zoxide>
- <https://github.com/wting/autojump>
- <https://github.com/agkozak/zsh-z>
