# Development

## Modify the GIF in the README

To have a consistent file structure, prompt, color scheme and input speed, the GIF is
recorded by the tool [Vhs](https://github.com/charmbracelet/vhs) within a Docker
container. The process is to generate the GIF in the container, then retrieve it in the
host machine through a `docker cp` and substitute the existent GIF with this new one. The
same approach is used for retrieving the tape file, which should have been modified in the
container. Here are the steps to follow, all commands assume the current working directory
to be zsh-trampoline's root-level project directory:

1. Build the Docker image.

```bash
docker build ./demo -t ztdemo
```
2. Run the container interactively using Zsh.
```bash
# First time running the container:
docker run --name ztdemo -it ztdemo zsh

# Running the container after it has been stopped (not first time run):
docker container start ztdemo
docker container exec -it ztdemo zsh
```
3. Switch to the `hernan` user.
```bash
su hernan
```
4. Make sure the installed version of zsh-trampoline in the container is what you want.
   [Sheldon](https://github.com/rossmacarthur/sheldon) is used for the installation, which
   means that the plugin version should be hosted at GitHub already to be available in the
   container. To achieve this, push your changes to your branch and point Sheldon to that
   branch and update the plugins with `sheldon lock --update`.
```toml
# /home/hernan/.config/zt/plugins.toml

shell = "zsh"

[plugins.poc-zsh-plugin]
github = "HerCerM/zsh-trampoline"
branch = "my-feature"
```
5. Modify `/home/hernan/demo.tape` as needed. This can be done with a TUI text editor.
   Neovim is installed.

6. Record the GIF with the command `vhs ~/demo.tape`.
```
vhs ~/demo.tape
```
7. Copy the generated GIF (`~/demo.gif`) and updated tape file to the host machine.
```bash
# Copy generated GIF
docker cp ztdemo:/home/hernan/demo.gif ./demo

# Copy modified tape file
docker cp ztdemo:/home/hernan/demo.tape ./demo
```

## Unit testing

Unit testing for the Zsh and Gawk files is done with ZUnit: <https://zunit.xyz/>.
