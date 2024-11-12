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

## Usage

Press <kbd>ctrl+j</kbd> to start fzf with directories and files to "jump" to: `cd` or edit
with `${EDITOR}`. This list is taken from the global parameter `ZT_CONFIG` that you need
to define. See the section [Required configuration](#required-configuration).

When fzf starts, press asterisk (<kbd>*</kbd>) to toggle showing only the dirs and files
explicitly listed in `ZT_CONFIG`. Press <kbd>enter</kbd> and now you are on a different
directory or editing a file.

## Installation

You can use a Zsh plugin manager like [Sheldon](https://github.com/rossmacarthur/sheldon)
for the installation, alternatively use the quick-start snippet below.

**If you are in macOS, place this in your `~/.zshrc` and start a new shell. For the
snippet to work you must already have installed the Xcode Command Line Tools (install with
`xcode-select --install`) and [Homebrew](https://brew.sh/).**

```bash
# START: ZSH-TRAMPOLINE
# Project homepage: https://github.com/hernancerm/zsh-trampoline
# Install Git, if not already installed.
if [[ -z $(command -v git) ]] brew install git
# Install fzf, if not already installed. Version >=0.45 is required.
# https://github.com/junegunn/fzf
if [[ -z $(command -v fzf) ]] brew install fzf
# Install zsh-trampoline.
git clone 'https://github.com/hernancerm/zsh-trampoline.git' \
  "${HOME}/.zsh-trampoline/zsh-trampoline" 2> /dev/null
source "${zt_git_clone_dir}/trampoline.plugin.zsh"
# zsh-trampoline configuration.
ZT_CONFIG=(
  # Place in a new line the dirs and files you want to jump to.
  ~
)
# Bind ctrl+j to start fzf with the files from ZT_CONFIG.
zt_setup_widget_jump_to_file
# END: ZSH-TRAMPOLINE
```

<details>
  <summary>
    The snippet is too long! I want a shorter snippet.
  </summary>


**To use this snippet you should already have installed git and
[fzf](https://github.com/junegunn/fzf).**

```bash
# ZSH-TRAMPOLINE - https://github.com/hernancerm/zsh-trampoline
git clone 'https://github.com/hernancerm/zsh-trampoline.git' \
  "${HOME}/.zsh-trampoline/zsh-trampoline" 2> /dev/null
source "${zt_git_clone_dir}/trampoline.plugin.zsh"
ZT_CONFIG=(
  # Place in a new line the dirs and files you want to jump to.
  ~
)
zt_setup_widget_jump_to_file
```

</details>

### I'm on Linux, what now?

- Ensure your shell is Zsh: `echo $SHELL` should include `zsh` in its output.
- You may use the shorter snippet above (or the longer one if you use Homebrew).

## Parameter `ZT_CONFIG`

Some things to note:

- If your dir or file has whitespace chars, surround it with single quotes.
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

## Integration with other Zsh plugins

Integrate with [jeffreytse/zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode) (ZVM).
Binding <kbd>ctrl+j</kbd> is done inside a ZVM function, as below. Do **NOT** call
`zt_setup_widget_jump_to_file` when integrating with ZVM.

```bash
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
