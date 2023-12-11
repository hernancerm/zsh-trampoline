# Quick start

1. Install the requirements listed in [Requirements](#requirements).
2. Follow the instructions in the section [Installation](#installation).
3. Add your configuration file as described in [Configuration file](#configuration-file).

# Requirements

- [Gawk](https://www.gnu.org/software/gawk/) 4.1 or newer.
- A recent version of [fzf](https://github.com/junegunn/fzf).
- Zsh as your shell (of course).

On macOS, the requirements can be installed using [Homebrew](https://brew.sh/):

```sh
brew install gawk fzf
```

# Installation

To download and source the plugin, use your favorite plugin manager. For example, use
[Sheldon](https://github.com/rossmacarthur/sheldon):

```toml
# ~/.config/sheldon/plugins.toml

[plugins.poc-zsh-plugin]
github = "HerCerM/zsh-trampoline"
```

The plugin provides two Zsh functions for setup which are meant to be called in the
`.zshrc`. Only one function needs to be called depending on the following criteria:

1. `zt_setup_widget_jump_to_directory`: When *not* using the plugin
[zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode).

2. `zt_zvm_setup_widget_jump_to_directory`: When using the plugin zsh-vi-mode.

In case of using the second function, do the call inside of `zvm_after_init`, like this:

```sh
function zvm_after_init {
  # In insert mode, press 'ctrl+j' to cd to a directory.
  zt_zvm_setup_widget_jump_to_directory
}
```

<table>
<tbody>
<tr>
<td>ℹ️</td>
<td>
When using either the first or the second function, do the call after the zsh-trampoline
plugin is sourced. For example, for Sheldon that is after
<code>eval "$(sheldon source)"</code>.
</td>
</tr>
</tbody>
</table>

# Configuration

The configuration for zsh-trampoline is provided in two places:

1. A CSV configuration file.
2. Environment variables.

The CSV file is required to be created by the user. Regarding the env variables, default
values are provided. Only override these if you prefer something different from the
defaults.

## Configuration file

The `config.csv` file is where the available directories to jump to are defined.

This CSV config file is searched in the directory `$XDG_CONFIG_HOME/zt`. When the
environment variable `$XDG_CONFIG_HOME` is not set, it's searched in `~/.config/zt`. The
row format of the file is as shown below. Conceptually, each row represents a directory
that can be jumped to, and each directory can have metadata associated to it.

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
Relative or absolute path to a directory. Environment variables and the caret symbol
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

Example of valid contents of a file `~/.config/zt/config.csv`. Notice that spaces for
padding are allowed, but are not required.

```text
~/dev/gc                      ,Git cloned repos not mine.  ,true
~/dev/temp                    ,Temporary files.
~/.local/share/sheldon/repos
```

In addition to `config.csv`, a second file can be provided following the same format,
`config_local.csv`. When listing the directories to select a jump location, the contents
of the latter file may be appended to the former file.

## Environment variables

<table>
<thead>
<tr>
<th>Environment variable</th><th>Allowed values</th>
<th>Default value</th><th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>ZT_DIRECTORY_DECORATOR</code></td>
<td>Single character</td><td><code>*</code></td>
<td>
Prefix of the <code>{path}</code> for every row in the CSV config files. This eases
selection through fzf by allowing to exclude the expanded directories.
</td>
</tr>
<tr>
<td><code>ZT_LIST_DIRECTORIES_LOCAL</code></td>
<td><code>0</code> or<code>1</code></td><td><code>1</code></td>
<td>
Whether to list directories listed in <code>config_local.csv</code>. By default, all
directories are listed.
</td>
</tr>
<tr>
<td><code>ZT_KEY_MAP_JUMP_TO_DIRECTORY</code></td>
<td>
<a href="https://github.com/rothgar/mastering-zsh/blob/master/docs/helpers/bindkey.md">
<code>bindkey</code> key map</a></td> <td><code>^j</code></td>
<td>
Key sequence to press to list directories in fzf. By default, it’s <kbd>ctrl+j</kbd>.
</td>
</tr>
</tbody>
</table>
